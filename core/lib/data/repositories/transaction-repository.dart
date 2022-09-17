import 'dart:developer';

import 'package:core/common/failure.dart';
import 'package:core/data/datasources/transaction-local-datasource.dart';
import 'package:core/data/models/attendance-transaction.dart';
import 'package:core/data/models/master-attendance-location.dart';
import 'package:core/domain/entities/attendance-transaction.dart';
import 'package:core/domain/repositories/transaction-repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/enum-tipe-absen.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  final TransactionLocalDatasource transactionLocalDatasource;

  TransactionRepositoryImpl({
    required this.transactionLocalDatasource,
  });

  @override
  Future<Either<Failure, String>> clearAttendanceHistory() async {
    try {
      final result = await transactionLocalDatasource.clearDataAbsen();

      if(result) {
        return const Right('oke');
      }

      return Left(CacheFailure(
        message: 'clear failed'
      ));
    } catch(e, trace) {
      log('error', error: e, stackTrace: trace);

      return Left(CommonFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Iterable<Map<TipeAbsen, AttendanceTransaction?>>?>> getHistoryAttendance() async {
    try {
      final result = await transactionLocalDatasource.getHistoryAttendance();

      if(result != null && result.isNotEmpty) {
        return Right(result.map((e) => e.map((key, value) => MapEntry(key, value?.toEntity))));
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
  Future<Either<Failure, String>> saveAttendance(AttendanceTransaction data) async {
    try {
      if(data.distToAttendanceLocation > data.attendanceLocation.toleranceRadiusMeter) {
        return Left(
          CommonFailure(
            'Terlalu jauh dari pinned location terdekat'
          )
        );
      }

      final hasAbsen = await transactionLocalDatasource.isHasAbsen(
        data.tanggal, data.tipeAbsen);

      if(hasAbsen) {
        return Left(
          CommonFailure('Sudah Absen ${data.tipeAbsen.name} hari ini')
        );
      }

      final result = await transactionLocalDatasource.saveAbsen(
        ModelAttendanceTransaction(
          jam: data.jam,
          tipeAbsen: data.tipeAbsen,
          id: data.id,
          lat: data.lat,
          lon: data.lon,
          distToAttendanceLocation: data.distToAttendanceLocation,
          description: data.description,
          mediaPath: data.mediaPath,
          tanggal: data.tanggal,
          attendanceLocation: ModelMasterAttendanceLocation(
            lon: data.attendanceLocation.lon,
            lat: data.attendanceLocation.lat,
            id: data.attendanceLocation.id,
            label: data.attendanceLocation.label,
            toleranceRadiusMeter: data.attendanceLocation.toleranceRadiusMeter,
            active: data.attendanceLocation.active,
          )
        )
      );

      if(result) {
        return const Right('oke');
      }

      return Left(CacheFailure(
        message: 'failed'
      ));
    } catch (e, trace) {
      log('error', error: e, stackTrace: trace);

      return Left(CommonFailure(
        e.toString()
      ));
    }
  }

  @override
  Future<Either<Failure, TipeAbsen>> determineTipeAbsen(DateTime tanggal) async {
    try {
      final result = await transactionLocalDatasource.determineTipeAbsen(tanggal);

      return Right(result);

    } catch(e, trace) {
      log('error', error: e, stackTrace: trace);

      return Left(CommonFailure(e.toString()));
    }
  }

}