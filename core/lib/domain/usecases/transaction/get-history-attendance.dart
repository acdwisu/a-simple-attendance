import 'package:core/domain/repositories/transaction-repository.dart';
import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../entities/attendance-transaction.dart';
import '../../entities/enum-tipe-absen.dart';

class GetHistoryAttendance {
  final TransactionRepository transactionRepository;

  GetHistoryAttendance({required this.transactionRepository});

  Future<Either<Failure, Iterable<Map<TipeAbsen, AttendanceTransaction?>>?>> execute() {
    return transactionRepository.getHistoryAttendance();
  }
}