import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../models/attendance-transaction.dart';
import '../../models/master-attendance-location.dart';
import 'master-db.dart';

class TransactionDbHelper {
  static TransactionDbHelper? _databaseHelper;
  
  late final MasterDbHelper masterDbHelper;

  TransactionDbHelper._instance() {
    _databaseHelper = this;
    
    masterDbHelper = MasterDbHelper();
  }

  factory TransactionDbHelper() => _databaseHelper ?? TransactionDbHelper._instance();

  static Database? _database;

  Future<Database?> get __database async {
    _database ??= await _initDb();

    return _database;
  }

  //at
  final _tblAttendanceTransaction = 'ab';

  final _columnAtId = 'a';
  final _columnAtLat = 'c';
  final _columnAtLon = 'd';
  final _columnAtDescription = 'e';
  final _columnAtDistanceToAttendanceLoc = 'f';
  final _columnAtTimestamp = 'g';
  final _columnAtMediaPath = 'h';
  final _columnAtIdMasterAttendanceLoc = 'i';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/bssdt-tdb.iuer';

    var db = await openDatabase(
        databasePath,
        version: 1,
        onCreate: _onCreate,
        password: '87ebnhsbdsd83u2983ndmsdsk'
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await Future.wait([
      db.execute('''
        CREATE TABLE  $_tblAttendanceTransaction (
          $_columnAtId INTEGER PRIMARY KEY,
          $_columnAtLat REAL,
          $_columnAtLon REAL,
          $_columnAtDescription TEXT,
          $_columnAtDistanceToAttendanceLoc INTEGER,
          $_columnAtTimestamp INTEGER,
          $_columnAtIdMasterAttendanceLoc INTEGER,
          $_columnAtMediaPath TEXT
        );
      '''),
    ]);
  }

  Future<Iterable<ModelAttendanceTransaction>?> retrieveAttendanceHistory() async {
    final db = await __database;

    final results = await db!.query(
      _tblAttendanceTransaction,
    );

    final rawMaster = await masterDbHelper.retrieveMasterAttendanceLocations() ?? [];

    final master = {
      for(final e in rawMaster)
        e.id : e
    };

    return results.isNotEmpty?
      results.map((e) => _fromJsonAt(e, master)) : null;
  }

  Future<bool> clearAttendanceHistory() async {
    final db = await __database;

    final result = await db!.delete(
      _tblAttendanceTransaction,
    );

    return result>0;
  }

  Future<bool> saveNewAttendance(ModelAttendanceTransaction model) async {
    final db = (await __database)!;

    final int result = await db.insert(
      _tblAttendanceTransaction,
      _toJsonAt(model),
    );

    return result>0;
  }

  //region at convert
  ModelAttendanceTransaction _fromJsonAt(Map json, Map<int, ModelMasterAttendanceLocation> master) => ModelAttendanceTransaction(
    id: json[_columnAtId],
    lat: json[_columnAtLat],
    lon: json[_columnAtLon],
    mediaPath: json[_columnAtMediaPath],
    description: json[_columnAtDescription],
    timeStamp: DateTime.fromMillisecondsSinceEpoch(json[_columnAtTimestamp]),
    distToAttendanceLocation: json[_columnAtDistanceToAttendanceLoc],
    attendanceLocation: master[json[_columnAtIdMasterAttendanceLoc]]
        ?? ModelMasterAttendanceLocation.empty(),
  );

  Map<String, dynamic> _toJsonAt(ModelAttendanceTransaction model) => {
    _columnAtId: model.id,
    _columnAtLat: model.lat,
    _columnAtLon: model.lon,
    _columnAtMediaPath: model.mediaPath,
    _columnAtDistanceToAttendanceLoc: model.distToAttendanceLocation,
    _columnAtIdMasterAttendanceLoc: model.attendanceLocation.id,
    _columnAtDescription: model.description,
    _columnAtTimestamp: model.timeStamp.millisecondsSinceEpoch,
  };
//endregion
}