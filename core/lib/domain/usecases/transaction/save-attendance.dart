import 'package:core/domain/repositories/transaction-repository.dart';
import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../entities/attendance-transaction.dart';

class SaveAttendance {
  final TransactionRepository transactionRepository;

  SaveAttendance({required this.transactionRepository});

  Future<Either<Failure, String>> execute(AttendanceTransaction data) {
    return transactionRepository.saveAttendance(data);
  }
}