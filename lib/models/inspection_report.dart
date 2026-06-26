import 'package:drift/drift.dart';

class InspectionReports extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uuid => text().unique()();

  TextColumn get title => text()();

  TextColumn get notes => text().withDefault(const Constant(''))();

  TextColumn get localImagePaths => text().withDefault(const Constant('[]'))();

  TextColumn get uploadedImageUrls =>
      text().withDefault(const Constant('[]'))();

  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  TextColumn get syncStatus => text().withDefault(const Constant('draft'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  TextColumn get lastSyncError => text().nullable()();
}
