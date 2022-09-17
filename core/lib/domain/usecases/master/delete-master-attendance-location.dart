import 'package:core/common/failure.dart';
import 'package:core/domain/repositories/master-repository.dart';
import 'package:dartz/dartz.dart';

class DeleteMasterAttendanceLocation {
  final MasterRepository masterRepository;

  DeleteMasterAttendanceLocation({
    required this.masterRepository,
  });

  Future<Either<Failure, String>> execute(int id) {
    return masterRepository.deletePinnedLocation(id);
  }
}