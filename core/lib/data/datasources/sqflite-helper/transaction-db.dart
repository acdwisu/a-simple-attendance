import 'package:core/common/utils.dart';
import 'package:core/domain/entities/enum-tipe-absen.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../models/attendance-transaction.dart';
import '../../models/master-attendance-location.dart';

class TransactionSqfliteHelper {
  static TransactionSqfliteHelper? _databaseHelper;

  TransactionSqfliteHelper._instance() {
    _databaseHelper = this;
  }

  factory TransactionSqfliteHelper() => _databaseHelper ?? TransactionSqfliteHelper._instance();

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
  final _columnAtTanggal = 'g';
  final _columnAtMediaPath = 'h';
  final _columnAtIdMasterAttendanceLoc = 'i';
  final _columnAtTipeAbsen = 'j';
  final _columnAtJam = 'k';

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
          $_columnAtTanggal TEXT,
          $_columnAtJam TEXT,
          $_columnAtIdMasterAttendanceLoc INTEGER,
          $_columnAtMediaPath TEXT
        );
      '''),
    ]);
  }

  Future<Iterable<Map<TipeAbsen, ModelAttendanceTransaction?>>?> retrieveAttendanceHistory(
      Iterable<ModelMasterAttendanceLocation> rawMaster,
      ) async {
    final db = await __database;

    final history = await db!.query(
      _tblAttendanceTransaction,
    );

    if(history.isEmpty) {
      return null;
    }

    final master = {
      for(final e in rawMaster)
        e.id : e
    };

    if(history.isNotEmpty) {
      final temp = {
        for(final e in history)
          "${e[_columnAtTanggal]}-${e[_columnAtTipeAbsen]}": _fromJsonAt(e, master)
      };

      return temp.keys.map((e) => e.split('-').first).toSet().map((e) => {
        TipeAbsen.Masuk: temp["$e-${TipeAbsen.Masuk.index}"],
        TipeAbsen.Pulang: temp["$e-${TipeAbsen.Pulang.index}"],
      });
    }

    return null;
  }

  Future<bool> clearAttendanceHistory() async {
    final db = await __database;

    final result = await db!.delete(
      _tblAttendanceTransaction,
    );

    return result>0;
  }

  Future<bool> isHasAbsen(DateTime tanggal, TipeAbsen tipeAbsen) async {
    final db = await __database;

    final local = await db!.query(
        _tblAttendanceTransaction,
        where: "$_columnAtTipeAbsen = ? AND $_columnAtTanggal = ?",
        whereArgs: [
          tipeAbsen.index,
          _tanggalFormatter(tanggal),
        ]
    );

    return local.isNotEmpty;
  }

  Future<bool> saveNewAttendance(ModelAttendanceTransaction model) async {
    final db = (await __database)!;

    if(await isHasAbsen(model.tanggal, model.tipeAbsen,)) {
      return false;
    }

    final int result = await db.insert(
      _tblAttendanceTransaction,
      _toJsonAt(model),
    );

    return result>0;
  }

  //region at convert
  ModelAttendanceTransaction _fromJsonAt(
    Map json,
    Map<int, ModelMasterAttendanceLocation> master,
  ) => ModelAttendanceTransaction(
    id: json[_columnAtId],
    lat: json[_columnAtLat],
    lon: json[_columnAtLon],
    mediaPath: json[_columnAtMediaPath],
    description: json[_columnAtDescription],
    tanggal: DateTime.parse(json[_columnAtTanggal]),
    distToAttendanceLocation: json[_columnAtDistanceToAttendanceLoc],
    attendanceLocation: master[json[_columnAtIdMasterAttendanceLoc]]
        ?? ModelMasterAttendanceLocation.empty(),
    //bughole
    tipeAbsen: TipeAbsen.values[json[_columnAtTipeAbsen]],
    jam: parseTimeOfDay(json[_columnAtJam]),
  );

  Map<String, dynamic> _toJsonAt(ModelAttendanceTransaction model) => {
    _columnAtId: model.id,
    _columnAtLat: model.lat,
    _columnAtLon: model.lon,
    _columnAtMediaPath: model.mediaPath,
    _columnAtDistanceToAttendanceLoc: model.distToAttendanceLocation,
    _columnAtIdMasterAttendanceLoc: model.attendanceLocation.id,
    _columnAtDescription: model.description,
    _columnAtTanggal: _tanggalFormatter(model.tanggal),
    _columnAtJam: timeOfDayToString(model.jam),
    _columnAtTipeAbsen: model.tipeAbsen.index,
  };
  //endregion

  String _tanggalFormatter(DateTime dateTime)
    => "${dateTime.year}${dateTime.month}${dateTime.day}";
}