import 'package:cloud_firestore/cloud_firestore.dart';

/// Handles writing inspection report data to Firestore.
/// Uses the report's local uuid as the Firestore document id, so a
/// report's local and cloud identities are always the same value -
/// no separate id-mapping table needed.
class FirestoreReportsService {
  FirestoreReportsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _reportsCollection =>
      _firestore.collection('inspection_reports');

  /// Creates or overwrites the report document in Firestore.
  /// Using set() (not add()) with the uuid as the doc id makes this
  /// operation safely retryable - syncing the same report twice just
  /// overwrites the same document rather than creating duplicates.
  Future<void> pushReport({
    required String uuid,
    required String title,
    required String notes,
    required List<String> imageUrls,
    double? latitude,
    double? longitude,
    required DateTime createdAt,
  }) async {
    await _reportsCollection.doc(uuid).set({
      'uuid': uuid,
      'title': title,
      'notes': notes,
      'imageUrls': imageUrls,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': Timestamp.fromDate(createdAt),
      'syncedAt': Timestamp.now(),
    });
  }
}
