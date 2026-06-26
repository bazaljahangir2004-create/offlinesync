import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_database.dart';
import '../services/cloudinary_service.dart';
import '../services/firestore_service.dart';
import 'connectivity_provider.dart';
import 'reports_provider.dart';

// --- Cloudinary config ---
// Replace these two values with your own cloud name and unsigned
// upload preset name from the Cloudinary dashboard.
const _cloudinaryCloudName = 'dkezo8cso';
const _cloudinaryUploadPreset = 'offlinesync_unsigned';

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService(
    cloudName: _cloudinaryCloudName,
    uploadPreset: _cloudinaryUploadPreset,
  );
});

final firestoreReportsServiceProvider =
    Provider<FirestoreReportsService>((ref) {
  return FirestoreReportsService();
});

/// Coordinates the full sync flow for a single report:
/// upload its local photos to Cloudinary, then write the report
/// (with the resulting URLs) to Firestore, then mark it synced
/// locally. Any failure along the way marks the report 'failed'
/// with an error message, rather than leaving it stuck mid-sync.
class SyncService {
  SyncService({
    required this.cloudinary,
    required this.firestore,
    required this.repository,
  });

  final CloudinaryService cloudinary;
  final FirestoreReportsService firestore;
  final ReportsRepository repository;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Future<void> syncOneReport(InspectionReport report) async {
    await repository.updateSyncStatus(
      uuid: report.uuid,
      status: 'syncing',
    );

    try {
      final localPaths =
          ReportsRepository.decodeImagePaths(report.localImagePaths);

      final uploadedUrls = await cloudinary.uploadImages(localPaths);

      await firestore.pushReport(
        uuid: report.uuid,
        title: report.title,
        notes: report.notes,
        imageUrls: uploadedUrls,
        latitude: report.latitude,
        longitude: report.longitude,
        createdAt: report.createdAt,
      );

      await repository.updateSyncStatus(
        uuid: report.uuid,
        status: 'synced',
        uploadedImageUrls: uploadedUrls,
        syncedAt: DateTime.now(),
      );
    } catch (e) {
      await repository.updateSyncStatus(
        uuid: report.uuid,
        status: 'failed',
        lastSyncError: e.toString(),
      );
    }
  }

  /// Syncs every report that isn't already marked 'synced'.
  /// Runs sequentially and guards against overlapping runs (e.g. a
  /// manual sync button tap while an automatic sync is in progress).
  Future<void> syncAllPending() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final pending = await repository.getUnsyncedReports();
      for (final report in pending) {
        await syncOneReport(report);
      }
    } finally {
      _isSyncing = false;
    }
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    cloudinary: ref.watch(cloudinaryServiceProvider),
    firestore: ref.watch(firestoreReportsServiceProvider),
    repository: ref.watch(reportsRepositoryProvider),
  );
});

/// Watches connectivity and automatically triggers a sync the moment
/// the device comes back online. This provider has no UI - it's a
/// background listener wired up once near the app root (see main.dart).
final autoSyncListenerProvider = Provider<void>((ref) {
  ref.listen(isOnlineProvider, (previous, next) {
    final wasOffline = previous?.value == false;
    final isNowOnline = next.value == true;

    if (wasOffline && isNowOnline) {
      ref.read(syncServiceProvider).syncAllPending();
    }
  });
});
