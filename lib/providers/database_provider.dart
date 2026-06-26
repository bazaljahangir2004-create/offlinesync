import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_database.dart';

/// Single shared instance of the database for the whole app.
/// Riverpod keeps this alive for the app's lifetime.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
