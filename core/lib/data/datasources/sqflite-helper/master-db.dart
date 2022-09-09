import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../models/master-attendance-location.dart';

class MasterSqfliteHelper {
  static MasterSqfliteHelper? _databaseHelper;

  MasterSqfliteHelper._instance() {
    _databaseHelper = this;
  }

  factory MasterSqfliteHelper() => _databaseHelper ?? MasterSqfliteHelper._instance();

  static Database? _database;

  Future<Database?> get __database async {
    _database ??= await _initDb();

    return _database;
  }
  
  //mal
  final _tblMasterAttendanceLocation = 'ab';

  final _columnMalId = 'a';
  final _columnMalLat = 'c';
  final _columnMalLon = 'd';
  final _columnMalLabel = 'e';
  final _columnMalToleranceRadiusMeter = 'f';
  final _columnMalActive = 'g';
  
  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/bssdt-mdb.opiu';

    var db = await openDatabase(
        databasePath,
        version: 1,
        onCreate: _onCreate,
        password: '08r93efjkmif8hksjdkssnkdi3u9djk'
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await Future.wait([
      db.execute('''
        CREATE TABLE  $_tblMasterAttendanceLocation (
          $_columnMalId INTEGER PRIMARY KEY,
          $_columnMalLat REAL,
          $_columnMalLon REAL,
          $_columnMalLabel TEXT,
          $_columnMalToleranceRadiusMeter INTEGER,
          $_columnMalActive INTEGER
        );
      '''),
    ]);
  }

  Future<Iterable<ModelMasterAttendanceLocation>?> retrieveMasterAttendanceLocations() async {
    final db = await __database;

    final results = await db!.query(
      _tblMasterAttendanceLocation,
    );

    return results.isNotEmpty?
      results.map((e) => _fromJsonMal(e)) : null;
  }

  Future<ModelMasterAttendanceLocation?> retrieveMasterAttendanceLocation(int id) async {
    final db = await __database;

    final results = await db!.query(
      _tblMasterAttendanceLocation,
      where: "$_columnMalId = $id"
    );

    return results.isNotEmpty?
      _fromJsonMal(results.first) : null;
  }

  Future<bool> deleteMasterAttendanceLocation(int id) async {
    final db = await __database;

    final result = await db!.delete(
      _tblMasterAttendanceLocation,
      where: "$_columnMalId = ?",
      whereArgs: [
        id,
      ]
    );

    return result>0;
  }

  Future<bool> saveMasterAttendanceLocation(ModelMasterAttendanceLocation model) async {
    final db = (await __database)!;

    late final int result;

    if(model.id == -1 || model.id == 0) {
      result = await db.insert(
        _tblMasterAttendanceLocation,
        _toJsonMal(model),
      );
    } else {
      result = await db.update(
        _tblMasterAttendanceLocation,
        _toJsonMal(model),
        where: "$_columnMalId = ${model.id}",
      );
    }

    return result>0;
  }

  //region mal convert
  ModelMasterAttendanceLocation _fromJsonMal(Map json) => ModelMasterAttendanceLocation(
    id: json[_columnMalId],
    lat: json[_columnMalLat],
    lon: json[_columnMalLon],
    label: json[_columnMalLabel],
    toleranceRadiusMeter: json[_columnMalToleranceRadiusMeter],
    active: json[_columnMalActive]==1,
  );

  Map<String, dynamic> _toJsonMal(ModelMasterAttendanceLocation model) => {
    _columnMalId: model.id,
    _columnMalLat: model.lat,
    _columnMalLon: model.lon,
    _columnMalLabel: model.label,
    _columnMalToleranceRadiusMeter: model.toleranceRadiusMeter,
    _columnMalActive: model.active? 1 : 0,
  };
//endregion
}