// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InspectionReportsTable extends InspectionReports with TableInfo<$InspectionReportsTable, InspectionReport>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$InspectionReportsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
@override
late final GeneratedColumn<String> uuid = GeneratedColumn<String>('uuid', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
static const VerificationMeta _titleMeta = const VerificationMeta('title');
@override
late final GeneratedColumn<String> title = GeneratedColumn<String>('title', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _notesMeta = const VerificationMeta('notes');
@override
late final GeneratedColumn<String> notes = GeneratedColumn<String>('notes', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
static const VerificationMeta _localImagePathsMeta = const VerificationMeta('localImagePaths');
@override
late final GeneratedColumn<String> localImagePaths = GeneratedColumn<String>('local_image_paths', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('[]'));
static const VerificationMeta _uploadedImageUrlsMeta = const VerificationMeta('uploadedImageUrls');
@override
late final GeneratedColumn<String> uploadedImageUrls = GeneratedColumn<String>('uploaded_image_urls', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('[]'));
static const VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
@override
late final GeneratedColumn<double> latitude = GeneratedColumn<double>('latitude', aliasedName, true, type: DriftSqlType.double, requiredDuringInsert: false);
static const VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
@override
late final GeneratedColumn<double> longitude = GeneratedColumn<double>('longitude', aliasedName, true, type: DriftSqlType.double, requiredDuringInsert: false);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>('sync_status', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('draft'));
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: currentDateAndTime);
static const VerificationMeta _syncedAtMeta = const VerificationMeta('syncedAt');
@override
late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>('synced_at', aliasedName, true, type: DriftSqlType.dateTime, requiredDuringInsert: false);
static const VerificationMeta _lastSyncErrorMeta = const VerificationMeta('lastSyncError');
@override
late final GeneratedColumn<String> lastSyncError = GeneratedColumn<String>('last_sync_error', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
@override
List<GeneratedColumn> get $columns => [id, uuid, title, notes, localImagePaths, uploadedImageUrls, latitude, longitude, syncStatus, createdAt, syncedAt, lastSyncError];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'inspection_reports';
@override
VerificationContext validateIntegrity(Insertable<InspectionReport> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('uuid')) {
context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));} else if (isInserting) {
context.missing(_uuidMeta);
}
if (data.containsKey('title')) {
context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));} else if (isInserting) {
context.missing(_titleMeta);
}
if (data.containsKey('notes')) {
context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));}if (data.containsKey('local_image_paths')) {
context.handle(_localImagePathsMeta, localImagePaths.isAcceptableOrUnknown(data['local_image_paths']!, _localImagePathsMeta));}if (data.containsKey('uploaded_image_urls')) {
context.handle(_uploadedImageUrlsMeta, uploadedImageUrls.isAcceptableOrUnknown(data['uploaded_image_urls']!, _uploadedImageUrlsMeta));}if (data.containsKey('latitude')) {
context.handle(_latitudeMeta, latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));}if (data.containsKey('longitude')) {
context.handle(_longitudeMeta, longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));}if (data.containsKey('sync_status')) {
context.handle(_syncStatusMeta, syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta));}if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));}if (data.containsKey('synced_at')) {
context.handle(_syncedAtMeta, syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));}if (data.containsKey('last_sync_error')) {
context.handle(_lastSyncErrorMeta, lastSyncError.isAcceptableOrUnknown(data['last_sync_error']!, _lastSyncErrorMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override InspectionReport map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return InspectionReport(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!, title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!, notes: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}notes'])!, localImagePaths: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}local_image_paths'])!, uploadedImageUrls: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uploaded_image_urls'])!, latitude: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}latitude']), longitude: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}longitude']), syncStatus: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, syncedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']), lastSyncError: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}last_sync_error']), );
}
@override
$InspectionReportsTable createAlias(String alias) {
return $InspectionReportsTable(attachedDatabase, alias);}}class InspectionReport extends DataClass implements Insertable<InspectionReport> 
{
final int id;
final String uuid;
final String title;
final String notes;
final String localImagePaths;
final String uploadedImageUrls;
final double? latitude;
final double? longitude;
final String syncStatus;
final DateTime createdAt;
final DateTime? syncedAt;
final String? lastSyncError;
const InspectionReport({required this.id, required this.uuid, required this.title, required this.notes, required this.localImagePaths, required this.uploadedImageUrls, this.latitude, this.longitude, required this.syncStatus, required this.createdAt, this.syncedAt, this.lastSyncError});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
map['uuid'] = Variable<String>(uuid);
map['title'] = Variable<String>(title);
map['notes'] = Variable<String>(notes);
map['local_image_paths'] = Variable<String>(localImagePaths);
map['uploaded_image_urls'] = Variable<String>(uploadedImageUrls);
if (!nullToAbsent || latitude != null){map['latitude'] = Variable<double>(latitude);
}if (!nullToAbsent || longitude != null){map['longitude'] = Variable<double>(longitude);
}map['sync_status'] = Variable<String>(syncStatus);
map['created_at'] = Variable<DateTime>(createdAt);
if (!nullToAbsent || syncedAt != null){map['synced_at'] = Variable<DateTime>(syncedAt);
}if (!nullToAbsent || lastSyncError != null){map['last_sync_error'] = Variable<String>(lastSyncError);
}return map; 
}
InspectionReportsCompanion toCompanion(bool nullToAbsent) {
return InspectionReportsCompanion(id: Value(id),uuid: Value(uuid),title: Value(title),notes: Value(notes),localImagePaths: Value(localImagePaths),uploadedImageUrls: Value(uploadedImageUrls),latitude: latitude == null && nullToAbsent ? const Value.absent() : Value(latitude),longitude: longitude == null && nullToAbsent ? const Value.absent() : Value(longitude),syncStatus: Value(syncStatus),createdAt: Value(createdAt),syncedAt: syncedAt == null && nullToAbsent ? const Value.absent() : Value(syncedAt),lastSyncError: lastSyncError == null && nullToAbsent ? const Value.absent() : Value(lastSyncError),);
}
factory InspectionReport.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return InspectionReport(id: serializer.fromJson<int>(json['id']),uuid: serializer.fromJson<String>(json['uuid']),title: serializer.fromJson<String>(json['title']),notes: serializer.fromJson<String>(json['notes']),localImagePaths: serializer.fromJson<String>(json['localImagePaths']),uploadedImageUrls: serializer.fromJson<String>(json['uploadedImageUrls']),latitude: serializer.fromJson<double?>(json['latitude']),longitude: serializer.fromJson<double?>(json['longitude']),syncStatus: serializer.fromJson<String>(json['syncStatus']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),lastSyncError: serializer.fromJson<String?>(json['lastSyncError']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'uuid': serializer.toJson<String>(uuid),'title': serializer.toJson<String>(title),'notes': serializer.toJson<String>(notes),'localImagePaths': serializer.toJson<String>(localImagePaths),'uploadedImageUrls': serializer.toJson<String>(uploadedImageUrls),'latitude': serializer.toJson<double?>(latitude),'longitude': serializer.toJson<double?>(longitude),'syncStatus': serializer.toJson<String>(syncStatus),'createdAt': serializer.toJson<DateTime>(createdAt),'syncedAt': serializer.toJson<DateTime?>(syncedAt),'lastSyncError': serializer.toJson<String?>(lastSyncError),};}InspectionReport copyWith({int? id,String? uuid,String? title,String? notes,String? localImagePaths,String? uploadedImageUrls,Value<double?> latitude = const Value.absent(),Value<double?> longitude = const Value.absent(),String? syncStatus,DateTime? createdAt,Value<DateTime?> syncedAt = const Value.absent(),Value<String?> lastSyncError = const Value.absent()}) => InspectionReport(id: id ?? this.id,uuid: uuid ?? this.uuid,title: title ?? this.title,notes: notes ?? this.notes,localImagePaths: localImagePaths ?? this.localImagePaths,uploadedImageUrls: uploadedImageUrls ?? this.uploadedImageUrls,latitude: latitude.present ? latitude.value : this.latitude,longitude: longitude.present ? longitude.value : this.longitude,syncStatus: syncStatus ?? this.syncStatus,createdAt: createdAt ?? this.createdAt,syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,lastSyncError: lastSyncError.present ? lastSyncError.value : this.lastSyncError,);InspectionReport copyWithCompanion(InspectionReportsCompanion data) {
return InspectionReport(
id: data.id.present ? data.id.value : this.id,uuid: data.uuid.present ? data.uuid.value : this.uuid,title: data.title.present ? data.title.value : this.title,notes: data.notes.present ? data.notes.value : this.notes,localImagePaths: data.localImagePaths.present ? data.localImagePaths.value : this.localImagePaths,uploadedImageUrls: data.uploadedImageUrls.present ? data.uploadedImageUrls.value : this.uploadedImageUrls,latitude: data.latitude.present ? data.latitude.value : this.latitude,longitude: data.longitude.present ? data.longitude.value : this.longitude,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,lastSyncError: data.lastSyncError.present ? data.lastSyncError.value : this.lastSyncError,);
}
@override
String toString() {return (StringBuffer('InspectionReport(')..write('id: $id, ')..write('uuid: $uuid, ')..write('title: $title, ')..write('notes: $notes, ')..write('localImagePaths: $localImagePaths, ')..write('uploadedImageUrls: $uploadedImageUrls, ')..write('latitude: $latitude, ')..write('longitude: $longitude, ')..write('syncStatus: $syncStatus, ')..write('createdAt: $createdAt, ')..write('syncedAt: $syncedAt, ')..write('lastSyncError: $lastSyncError')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, uuid, title, notes, localImagePaths, uploadedImageUrls, latitude, longitude, syncStatus, createdAt, syncedAt, lastSyncError);@override
bool operator ==(Object other) => identical(this, other) || (other is InspectionReport && other.id == this.id && other.uuid == this.uuid && other.title == this.title && other.notes == this.notes && other.localImagePaths == this.localImagePaths && other.uploadedImageUrls == this.uploadedImageUrls && other.latitude == this.latitude && other.longitude == this.longitude && other.syncStatus == this.syncStatus && other.createdAt == this.createdAt && other.syncedAt == this.syncedAt && other.lastSyncError == this.lastSyncError);
}class InspectionReportsCompanion extends UpdateCompanion<InspectionReport> {
final Value<int> id;
final Value<String> uuid;
final Value<String> title;
final Value<String> notes;
final Value<String> localImagePaths;
final Value<String> uploadedImageUrls;
final Value<double?> latitude;
final Value<double?> longitude;
final Value<String> syncStatus;
final Value<DateTime> createdAt;
final Value<DateTime?> syncedAt;
final Value<String?> lastSyncError;
const InspectionReportsCompanion({this.id = const Value.absent(),this.uuid = const Value.absent(),this.title = const Value.absent(),this.notes = const Value.absent(),this.localImagePaths = const Value.absent(),this.uploadedImageUrls = const Value.absent(),this.latitude = const Value.absent(),this.longitude = const Value.absent(),this.syncStatus = const Value.absent(),this.createdAt = const Value.absent(),this.syncedAt = const Value.absent(),this.lastSyncError = const Value.absent(),});
InspectionReportsCompanion.insert({this.id = const Value.absent(),required String uuid,required String title,this.notes = const Value.absent(),this.localImagePaths = const Value.absent(),this.uploadedImageUrls = const Value.absent(),this.latitude = const Value.absent(),this.longitude = const Value.absent(),this.syncStatus = const Value.absent(),this.createdAt = const Value.absent(),this.syncedAt = const Value.absent(),this.lastSyncError = const Value.absent(),}): uuid = Value(uuid), title = Value(title);
static Insertable<InspectionReport> custom({Expression<int>? id, 
Expression<String>? uuid, 
Expression<String>? title, 
Expression<String>? notes, 
Expression<String>? localImagePaths, 
Expression<String>? uploadedImageUrls, 
Expression<double>? latitude, 
Expression<double>? longitude, 
Expression<String>? syncStatus, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? syncedAt, 
Expression<String>? lastSyncError, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (uuid != null)'uuid': uuid,if (title != null)'title': title,if (notes != null)'notes': notes,if (localImagePaths != null)'local_image_paths': localImagePaths,if (uploadedImageUrls != null)'uploaded_image_urls': uploadedImageUrls,if (latitude != null)'latitude': latitude,if (longitude != null)'longitude': longitude,if (syncStatus != null)'sync_status': syncStatus,if (createdAt != null)'created_at': createdAt,if (syncedAt != null)'synced_at': syncedAt,if (lastSyncError != null)'last_sync_error': lastSyncError,});
}InspectionReportsCompanion copyWith({Value<int>? id, Value<String>? uuid, Value<String>? title, Value<String>? notes, Value<String>? localImagePaths, Value<String>? uploadedImageUrls, Value<double?>? latitude, Value<double?>? longitude, Value<String>? syncStatus, Value<DateTime>? createdAt, Value<DateTime?>? syncedAt, Value<String?>? lastSyncError}) {
return InspectionReportsCompanion(id: id ?? this.id,uuid: uuid ?? this.uuid,title: title ?? this.title,notes: notes ?? this.notes,localImagePaths: localImagePaths ?? this.localImagePaths,uploadedImageUrls: uploadedImageUrls ?? this.uploadedImageUrls,latitude: latitude ?? this.latitude,longitude: longitude ?? this.longitude,syncStatus: syncStatus ?? this.syncStatus,createdAt: createdAt ?? this.createdAt,syncedAt: syncedAt ?? this.syncedAt,lastSyncError: lastSyncError ?? this.lastSyncError,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (uuid.present) {
map['uuid'] = Variable<String>(uuid.value);}
if (title.present) {
map['title'] = Variable<String>(title.value);}
if (notes.present) {
map['notes'] = Variable<String>(notes.value);}
if (localImagePaths.present) {
map['local_image_paths'] = Variable<String>(localImagePaths.value);}
if (uploadedImageUrls.present) {
map['uploaded_image_urls'] = Variable<String>(uploadedImageUrls.value);}
if (latitude.present) {
map['latitude'] = Variable<double>(latitude.value);}
if (longitude.present) {
map['longitude'] = Variable<double>(longitude.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<String>(syncStatus.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (syncedAt.present) {
map['synced_at'] = Variable<DateTime>(syncedAt.value);}
if (lastSyncError.present) {
map['last_sync_error'] = Variable<String>(lastSyncError.value);}
return map; 
}
@override
String toString() {return (StringBuffer('InspectionReportsCompanion(')..write('id: $id, ')..write('uuid: $uuid, ')..write('title: $title, ')..write('notes: $notes, ')..write('localImagePaths: $localImagePaths, ')..write('uploadedImageUrls: $uploadedImageUrls, ')..write('latitude: $latitude, ')..write('longitude: $longitude, ')..write('syncStatus: $syncStatus, ')..write('createdAt: $createdAt, ')..write('syncedAt: $syncedAt, ')..write('lastSyncError: $lastSyncError')..write(')')).toString();}
}
abstract class _$AppDatabase extends GeneratedDatabase{
_$AppDatabase(QueryExecutor e): super(e);
$AppDatabaseManager get managers => $AppDatabaseManager(this);
late final $InspectionReportsTable inspectionReports = $InspectionReportsTable(this);
@override
Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
@override
List<DatabaseSchemaEntity> get allSchemaEntities => [inspectionReports];
}
typedef $$InspectionReportsTableCreateCompanionBuilder = InspectionReportsCompanion Function({Value<int> id,required String uuid,required String title,Value<String> notes,Value<String> localImagePaths,Value<String> uploadedImageUrls,Value<double?> latitude,Value<double?> longitude,Value<String> syncStatus,Value<DateTime> createdAt,Value<DateTime?> syncedAt,Value<String?> lastSyncError,});
typedef $$InspectionReportsTableUpdateCompanionBuilder = InspectionReportsCompanion Function({Value<int> id,Value<String> uuid,Value<String> title,Value<String> notes,Value<String> localImagePaths,Value<String> uploadedImageUrls,Value<double?> latitude,Value<double?> longitude,Value<String> syncStatus,Value<DateTime> createdAt,Value<DateTime?> syncedAt,Value<String?> lastSyncError,});
class $$InspectionReportsTableFilterComposer extends Composer<
        _$AppDatabase,
        $InspectionReportsTable> {
        $$InspectionReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get title => $composableBuilder(
      column: $table.title,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get localImagePaths => $composableBuilder(
      column: $table.localImagePaths,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get uploadedImageUrls => $composableBuilder(
      column: $table.uploadedImageUrls,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get lastSyncError => $composableBuilder(
      column: $table.lastSyncError,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$InspectionReportsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $InspectionReportsTable> {
        $$InspectionReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get localImagePaths => $composableBuilder(
      column: $table.localImagePaths,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get uploadedImageUrls => $composableBuilder(
      column: $table.uploadedImageUrls,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get lastSyncError => $composableBuilder(
      column: $table.lastSyncError,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$InspectionReportsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $InspectionReportsTable> {
        $$InspectionReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get uuid => $composableBuilder(
      column: $table.uuid,
      builder: (column) => column);
      
GeneratedColumn<String> get title => $composableBuilder(
      column: $table.title,
      builder: (column) => column);
      
GeneratedColumn<String> get notes => $composableBuilder(
      column: $table.notes,
      builder: (column) => column);
      
GeneratedColumn<String> get localImagePaths => $composableBuilder(
      column: $table.localImagePaths,
      builder: (column) => column);
      
GeneratedColumn<String> get uploadedImageUrls => $composableBuilder(
      column: $table.uploadedImageUrls,
      builder: (column) => column);
      
GeneratedColumn<double> get latitude => $composableBuilder(
      column: $table.latitude,
      builder: (column) => column);
      
GeneratedColumn<double> get longitude => $composableBuilder(
      column: $table.longitude,
      builder: (column) => column);
      
GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt,
      builder: (column) => column);
      
GeneratedColumn<String> get lastSyncError => $composableBuilder(
      column: $table.lastSyncError,
      builder: (column) => column);
      
        }
      class $$InspectionReportsTableTableManager extends RootTableManager    <_$AppDatabase,
    $InspectionReportsTable,
    InspectionReport,
    $$InspectionReportsTableFilterComposer,
    $$InspectionReportsTableOrderingComposer,
    $$InspectionReportsTableAnnotationComposer,
    $$InspectionReportsTableCreateCompanionBuilder,
    $$InspectionReportsTableUpdateCompanionBuilder,
    (InspectionReport,BaseReferences<_$AppDatabase,$InspectionReportsTable,InspectionReport>),
    InspectionReport,
    PrefetchHooks Function()
    > {
    $$InspectionReportsTableTableManager(_$AppDatabase db, $InspectionReportsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$InspectionReportsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$InspectionReportsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$InspectionReportsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<String> uuid = const Value.absent(),Value<String> title = const Value.absent(),Value<String> notes = const Value.absent(),Value<String> localImagePaths = const Value.absent(),Value<String> uploadedImageUrls = const Value.absent(),Value<double?> latitude = const Value.absent(),Value<double?> longitude = const Value.absent(),Value<String> syncStatus = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime?> syncedAt = const Value.absent(),Value<String?> lastSyncError = const Value.absent(),})=> InspectionReportsCompanion(id: id,uuid: uuid,title: title,notes: notes,localImagePaths: localImagePaths,uploadedImageUrls: uploadedImageUrls,latitude: latitude,longitude: longitude,syncStatus: syncStatus,createdAt: createdAt,syncedAt: syncedAt,lastSyncError: lastSyncError,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),required String uuid,required String title,Value<String> notes = const Value.absent(),Value<String> localImagePaths = const Value.absent(),Value<String> uploadedImageUrls = const Value.absent(),Value<double?> latitude = const Value.absent(),Value<double?> longitude = const Value.absent(),Value<String> syncStatus = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime?> syncedAt = const Value.absent(),Value<String?> lastSyncError = const Value.absent(),})=> InspectionReportsCompanion.insert(id: id,uuid: uuid,title: title,notes: notes,localImagePaths: localImagePaths,uploadedImageUrls: uploadedImageUrls,latitude: latitude,longitude: longitude,syncStatus: syncStatus,createdAt: createdAt,syncedAt: syncedAt,lastSyncError: lastSyncError,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$InspectionReportsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $InspectionReportsTable,
    InspectionReport,
    $$InspectionReportsTableFilterComposer,
    $$InspectionReportsTableOrderingComposer,
    $$InspectionReportsTableAnnotationComposer,
    $$InspectionReportsTableCreateCompanionBuilder,
    $$InspectionReportsTableUpdateCompanionBuilder,
    (InspectionReport,BaseReferences<_$AppDatabase,$InspectionReportsTable,InspectionReport>),
    InspectionReport,
    PrefetchHooks Function()
    >;class $AppDatabaseManager {
final _$AppDatabase _db;
$AppDatabaseManager(this._db);
$$InspectionReportsTableTableManager get inspectionReports => $$InspectionReportsTableTableManager(_db, _db.inspectionReports);
}
