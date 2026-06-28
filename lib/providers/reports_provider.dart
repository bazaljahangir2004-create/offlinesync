import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/app_database.dart';
import 'database_provider.dart';

/// Streams the full list of reports, newest first.
/// The UI watches this and rebuilds automatically whenever the
/// underlying SQLite table changes - no manual refresh needed.
final reportsStreamProvider = StreamProvider<List<InspectionReport>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.inspectionReports)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

/// Handles creating and updating reports. This is the single place
/// that knows how to turn raw form input into a saved local record.
class ReportsRepository {
  ReportsRepository(this._db);
  final AppDatabase _db;

  static const _uuidGen = Uuid();

  /// Creates a new draft report locally. Returns the generated uuid,
  /// which is the same id that'll later be used as the Firestore doc id.
  Future<String> createReport({
    required String title,
    required String notes,
    required List<String> localImagePaths,
    double? latitude,
    double? longitude,
  }) async {
    final uuid = _uuidGen.v4();

    await _db.into(_db.inspectionReports).insert(
          InspectionReportsCompanion.insert(
            uuid: uuid,
            title: title,
            notes: Value(notes),
            localImagePaths: Value(jsonEncode(localImagePaths)),
            latitude: Value(latitude),
            longitude: Value(longitude),
          ),
        );

    return uuid;
  }

  /// Updates a report's editable content (title, notes, photos,
  /// location) and resets it to 'draft' so it gets re-synced with
  /// the new data - editing an already-synced report means the old
  /// cloud copy is now stale until the next sync run.
  Future<void> updateReportContent({
    required String uuid,
    required String title,
    required String notes,
    required List<String> localImagePaths,
    double? latitude,
    double? longitude,
  }) async {
    await (_db.update(_db.inspectionReports)..where((t) => t.uuid.equals(uuid)))
        .write(
      InspectionReportsCompanion(
        title: Value(title),
        notes: Value(notes),
        localImagePaths: Value(jsonEncode(localImagePaths)),
        latitude: Value(latitude),
        longitude: Value(longitude),
        syncStatus: const Value('draft'),
        lastSyncError: const Value(null),
      ),
    );
  }

  /// Updates sync-related fields after an upload attempt.
  Future<void> updateSyncStatus({
    required String uuid,
    required String status,
    List<String>? uploadedImageUrls,
    DateTime? syncedAt,
    String? lastSyncError,
  }) async {
    final companion = InspectionReportsCompanion(
      syncStatus: Value(status),
      uploadedImageUrls: uploadedImageUrls != null
          ? Value(jsonEncode(uploadedImageUrls))
          : const Value.absent(),
      syncedAt: syncedAt != null ? Value(syncedAt) : const Value.absent(),
      lastSyncError: Value(lastSyncError),
    );

    await (_db.update(_db.inspectionReports)..where((t) => t.uuid.equals(uuid)))
        .write(companion);
  }

  /// Fetches every report that still needs to be synced
  /// (anything not already marked 'synced').
  Future<List<InspectionReport>> getUnsyncedReports() {
    return (_db.select(_db.inspectionReports)
          ..where((t) => t.syncStatus.equals('synced').not()))
        .get();
  }

  /// Small helpers so the rest of the app never has to think about
  /// the JSON-encoding detail directly.
  static List<String> decodeImagePaths(String raw) {
    if (raw.isEmpty) return [];
    return (jsonDecode(raw) as List).cast<String>();
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReportsRepository(db);
});
