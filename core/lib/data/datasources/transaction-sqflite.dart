import 'package:core/data/datasources/sqflite-helper/transaction-db.dart';
import 'package:core/data/datasources/transaction-local-datasource.dart';
import 'package:core/data/models/attendance-transaction.dart';
import 'package:core/domain/entities/enum-tipe-absen.dart';

import 'sqflite-helper/master-db.dart';

class TransactionSqflite extends TransactionLocalDatasource {
  final TransactionSqfliteHelper transactionDbHelper;
  final MasterSqfliteHelper masterDbHelper;

  TransactionSqflite({
    required this.transactionDbHelper,
    required this.masterDbHelper,
  });

  @override
  Future<bool> clearDataAbsen() {
    return transactionDbHelper.clearAttendanceHistory();
  }

  @override
  Future<Iterable<Map<TipeAbsen, ModelAttendanceTransaction?>>?> getHistoryAttendance() async {
    final master = await masterDbHelper.retrieveMasterAttendanceLocations();

    return transactionDbHelper.retrieveAttendanceHistory(master ?? []);
  }

  @override
  Future<bool> isHasAbsen(DateTime tanggal, TipeAbsen tipeAbsen) {
    return transactionDbHelper.isHasAbsen(tanggal, tipeAbsen);
  }

  @override
  Future<bool> saveAbsen(ModelAttendanceTransaction model) {
    return transactionDbHelper.saveNewAttendance(model);
  }

  @override
  Future<TipeAbsen> determineTipeAbsen(DateTime tanggal) {
    return transactionDbHelper.determineTipeAbsen(tanggal);
  }

}