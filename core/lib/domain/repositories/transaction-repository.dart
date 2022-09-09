import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/attendance-transaction.dart';

abstract class TransactionRepository {
  Stream<Either<Failure, Iterable<AttendanceTransaction>>> getHistoryAttendance();
  Future<Either<Failure, String>> saveAttendance(AttendanceTransaction data);
  Future<Either<Failure, String>> clear();
}