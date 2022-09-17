import 'package:core/common/failure.dart';
import 'package:core/domain/entities/master-attendance-location.dart';
import 'package:core/domain/repositories/master-repository.dart';
import 'package:dartz/dartz.dart';

class SaveMasterAttendanceLocation {
  final MasterRepository masterRepository;

  SaveMasterAttendanceLocation({
    required this.masterRepository,
  });

  Future<Either<Failure, String>> execute(MasterAttendanceLocation data) {
    return masterRepository.savePinnedLocation(data);
  }
}