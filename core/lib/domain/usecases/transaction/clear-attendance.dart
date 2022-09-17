import 'package:core/domain/repositories/transaction-repository.dart';
import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';

class ClearAttendance {
  final TransactionRepository transactionRepository;

  ClearAttendance({required this.transactionRepository});

  Future<Either<Failure, String>> execute() {
    return transactionRepository.clearAttendanceHistory();
  }
}