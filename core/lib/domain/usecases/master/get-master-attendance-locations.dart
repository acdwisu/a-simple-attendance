import 'package:core/common/failure.dart';
import 'package:core/domain/entities/master-attendance-location.dart';
import 'package:core/domain/repositories/master-repository.dart';
import 'package:dartz/dartz.dart';

class GetMasterAttendanceLocation {
  final MasterRepository masterRepository;

  GetMasterAttendanceLocation({
    required this.masterRepository,
  });

  Future<Either<Failure, Iterable<MasterAttendanceLocation>>> execute() {
    return masterRepository.getPinnedLocation();
  }
}