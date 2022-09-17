import '../../domain/entities/enum-tipe-absen.dart';
import '../models/attendance-transaction.dart';

abstract class TransactionLocalDatasource {
  Future<Iterable<Map<TipeAbsen, ModelAttendanceTransaction?>>?> getHistoryAttendance();
  Future<bool> isHasAbsen(DateTime tanggal, TipeAbsen tipeAbsen);
  Future<bool> saveAbsen(ModelAttendanceTransaction model);
  Future<bool> clearDataAbsen();
  Future<TipeAbsen> determineTipeAbsen(DateTime tanggal);
}