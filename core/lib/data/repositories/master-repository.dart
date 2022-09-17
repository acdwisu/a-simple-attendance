import 'dart:developer';

import 'package:core/common/failure.dart';
import 'package:core/data/datasources/master-local-datasource.dart';
import 'package:core/data/models/master-attendance-location.dart';
import 'package:core/domain/entities/master-attendance-location.dart';
import 'package:core/domain/repositories/master-repository.dart';
import 'package:dartz/dartz.dart';

class MasterRepositoyImpl extends MasterRepository {
  final MasterLocalDatasource masterLocalDatasource;

  MasterRepositoyImpl({
    required this.masterLocalDatasource,
  });

  @override
  Future<Either<Failure, String>> deletePinnedLocation(int id) async {
    try {
      final result = await masterLocalDatasource.deletePinnedLocation(id);

      if(result) {
        return const Right('oke');
      }

      return Left(CacheFailure(
          message: 'failed'
      ));
    } catch(e, trace) {
      log('error', error: e, stackTrace: trace);

      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Iterable<MasterAttendanceLocation>>> getPinnedLocation() async {
    try {
      final result = await masterLocalDatasource.getPinnedLocation();

      if(result != null && result.isNotEmpty) {
        return Right(result.map((e) => e.toEntity));
      }

      return Left(CacheFailure(
        message: 'No Data'
      ));
    } catch(e, trace) {
      log('error', error: e, stackTrace: trace);

      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> savePinnedLocation(MasterAttendanceLocation data) async {
    try {
      final result = await masterLocalDatasource.savePinnedLocation(ModelMasterAttendanceLocation(
        active: data.active,
        toleranceRadiusMeter: data.toleranceRadiusMeter,
        label: data.label,
        id: data.id,
        lon: data.lon,
        lat: data.lat,
      ));

      if(result) {
        return const Right('oke');
      }

      return Left(CacheFailure(
        message: 'failed'
      ));
    } catch(e, trace) {
      log('error', error: e, stackTrace: trace);

      return Left(CommonFailure(e.toString()));
    }
  }
}