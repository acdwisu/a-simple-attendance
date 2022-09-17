import 'package:core/common/failure.dart';
import 'package:core/domain/entities/enum-tipe-absen.dart';
import 'package:core/domain/repositories/transaction-repository.dart';
import 'package:dartz/dartz.dart';

class DetermineTipeAbsen {
  final TransactionRepository transactionRepository;

  DetermineTipeAbsen({required this.transactionRepository});

  Future<Either<Failure, TipeAbsen>> execute(DateTime tanggal) {
    return transactionRepository.determineTipeAbsen(tanggal);
  }
}