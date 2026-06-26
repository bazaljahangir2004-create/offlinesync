import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'inspection_report.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [InspectionReports])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

/// Opens (or creates) the SQLite file in the app's documents directory.
/// This runs natively on-device, fully offline - no network needed.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'offlinesync.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
