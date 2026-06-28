import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_database.dart';
import '../services/cloudinary_service.dart';
import '../services/firestore_service.dart';
import 'connectivity_provider.dart';
import 'reports_provider.dart';
import 'settings_provider.dart';

// --- Cloudinary config ---
// Replace these two values with your own cloud name and unsigned
// upload preset name from the Cloudinary dashboard.
const _cloudinaryCloudName = 'YOUR_CLOUD_NAME';
const _cloudinaryUploadPreset = 'YOUR_UPLOAD_PRESET';

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
    required this.ref,
  });

  final CloudinaryService cloudinary;
  final FirestoreReportsService firestore;
  final ReportsRepository repository;
  final Ref ref;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Future<void> syncOneReport(InspectionReport report) async {
    debugPrint('[SYNC] syncOneReport start: ${report.uuid}');
    await repository.updateSyncStatus(
      uuid: report.uuid,
      status: 'syncing',
    );

    try {
      final localPaths =
          ReportsRepository.decodeImagePaths(report.localImagePaths);
      debugPrint('[SYNC] uploading ${localPaths.length} images');

      final uploadedUrls = await cloudinary.uploadImages(localPaths);
      debugPrint('[SYNC] cloudinary upload succeeded: $uploadedUrls');

      await firestore.pushReport(
        uuid: report.uuid,
        title: report.title,
        notes: report.notes,
        imageUrls: uploadedUrls,
        latitude: report.latitude,
        longitude: report.longitude,
        createdAt: report.createdAt,
      );
      debugPrint('[SYNC] firestore push succeeded');

      await repository.updateSyncStatus(
        uuid: report.uuid,
        status: 'synced',
        uploadedImageUrls: uploadedUrls,
        syncedAt: DateTime.now(),
      );
      debugPrint('[SYNC] marked synced: ${report.uuid}');
    } catch (e, stack) {
      debugPrint('[SYNC] FAILED for ${report.uuid}: $e');
      debugPrint('[SYNC] stacktrace: $stack');
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
  /// Respects the "Wi-Fi only" setting - if enabled and the current
  /// connection isn't Wi-Fi, this is a no-op rather than burning the
  /// user's mobile data.
  Future<void> syncAllPending() async {
    debugPrint('[SYNC] syncAllPending called, isSyncing=$_isSyncing');
    if (_isSyncing) return;

    final wifiOnly = ref.read(wifiOnlySyncProvider).value ?? false;
    final connectionKind = ref.read(connectionKindProvider).value;

    if (wifiOnly && connectionKind != ConnectionKind.wifi) {
      debugPrint(
        '[SYNC] skipped - wifi-only is on and current connection is $connectionKind',
      );
      return;
    }

    _isSyncing = true;

    try {
      final pending = await repository.getUnsyncedReports();
      debugPrint('[SYNC] found ${pending.length} unsynced reports');
      for (final report in pending) {
        debugPrint(
            '[SYNC] syncing report uuid=${report.uuid} title=${report.title}');
        await syncOneReport(report);
      }
    } catch (e) {
      debugPrint('[SYNC] syncAllPending threw: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Estimates the total local file size (in bytes) of all photos
  /// belonging to not-yet-synced reports. Used to show the user a
  /// human-readable "X MB pending" figure before they sync.
  Future<int> estimatePendingBytes() async {
    final pending = await repository.getUnsyncedReports();
    int total = 0;
    for (final report in pending) {
      final paths = ReportsRepository.decodeImagePaths(report.localImagePaths);
      for (final path in paths) {
        try {
          final file = File(path);
          if (await file.exists()) {
            total += await file.length();
          }
        } catch (_) {
          // Skip files that can't be read - shouldn't block the estimate.
        }
      }
    }
    return total;
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    cloudinary: ref.watch(cloudinaryServiceProvider),
    firestore: ref.watch(firestoreReportsServiceProvider),
    repository: ref.watch(reportsRepositoryProvider),
    ref: ref,
  );
});

/// Watches connectivity and automatically triggers a sync the moment
/// the device comes back online (or switches onto Wi-Fi, if the
/// wifi-only setting is on). syncAllPending() itself checks the
/// wifi-only preference, so this listener can fire freely on any
/// connection change and let that check decide whether to proceed.
final autoSyncListenerProvider = Provider<void>((ref) {
  ref.listen(connectionKindProvider, (previous, next) {
    final wasOffline =
        previous?.value == ConnectionKind.none || previous?.value == null;
    final isNowConnected =
        next.value != null && next.value != ConnectionKind.none;

    if (wasOffline && isNowConnected) {
      ref.read(syncServiceProvider).syncAllPending();
    }

    // Also catch the mobile -> wifi transition specifically, since
    // that's the moment a wifi-only sync becomes possible even
    // though the device was already "online" via mobile data.
    final justGotWifi = previous?.value != ConnectionKind.wifi &&
        next.value == ConnectionKind.wifi;
    if (justGotWifi) {
      ref.read(syncServiceProvider).syncAllPending();
    }
  });
});
