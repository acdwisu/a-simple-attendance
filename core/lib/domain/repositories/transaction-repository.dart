import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/attendance-transaction.dart';
import '../entities/enum-tipe-absen.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Iterable<Map<TipeAbsen, AttendanceTransaction?>>?>> getHistoryAttendance();
  Future<Either<Failure, String>> saveAttendance(AttendanceTransaction data);
  Future<Either<Failure, String>> clearAttendanceHistory();
  Future<Either<Failure, TipeAbsen>> determineTipeAbsen(DateTime tanggal);
}