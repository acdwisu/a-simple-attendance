import 'package:core/domain/entities/master-attendance-location.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';

abstract class MasterRepository {
  Future<Either<Failure, Iterable<MasterAttendanceLocation>>> getPinnedLocation();
  Future<Either<Failure, String>> savePinnedLocation(MasterAttendanceLocation data);
  Future<Either<Failure, String>> deletePinnedLocation(int id);
}