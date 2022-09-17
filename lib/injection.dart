import 'package:core/data/datasources/master-local-datasource.dart';
import 'package:core/data/datasources/master-sqflite.dart';
import 'package:core/data/datasources/sqflite-helper/master-db.dart';
import 'package:core/data/datasources/sqflite-helper/transaction-db.dart';
import 'package:core/data/datasources/transaction-local-datasource.dart';
import 'package:core/data/datasources/transaction-sqflite.dart';
import 'package:core/data/repositories/master-repository.dart';
import 'package:core/data/repositories/transaction-repository.dart';
import 'package:core/domain/repositories/master-repository.dart';
import 'package:core/domain/repositories/transaction-repository.dart';
import 'package:core/domain/usecases/master/delete-master-attendance-location.dart';
import 'package:core/domain/usecases/master/get-master-attendance-locations.dart';
import 'package:core/domain/usecases/master/save-master-attendance-location.dart';
import 'package:core/domain/usecases/transaction/clear-attendance.dart';
import 'package:core/domain/usecases/transaction/get-history-attendance.dart';
import 'package:core/domain/usecases/transaction/save-attendance.dart';
import 'package:core/domain/usecases/transaction/determine-tipe-absen.dart';
import 'package:core/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:core/presentation/blocs/master/master_attendance_bloc.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void initInjection() {
  locator.allowReassignment = true;

  //<editor-fold desc="Blocs">
  locator.registerFactory(() => MasterAttendanceBloc(
    deleteMasterAttendanceLocation: locator(),
    getMasterAttendanceLocations: locator(),
    saveMasterAttendanceLocation: locator(),
  ));

  locator.registerFactory(() => AttendanceBloc(
    clearAttendance: locator(),
    getHistoryAttendance: locator(),
    saveAttendance: locator(),
    determineTipeAbsen: locator(),
  ));
  //</editor-fold>


  //<editor-fold desc="Usecases">
  locator.registerLazySingleton(() => DeleteMasterAttendanceLocation(
    masterRepository: locator()
  ));

  locator.registerLazySingleton(() => GetMasterAttendanceLocation(
    masterRepository: locator()
  ));

  locator.registerLazySingleton(() => SaveMasterAttendanceLocation(
    masterRepository: locator()
  ));

  locator.registerLazySingleton(() => ClearAttendance(
    transactionRepository: locator()
  ));

  locator.registerLazySingleton(() => GetHistoryAttendance(
    transactionRepository: locator()
  ));

  locator.registerLazySingleton(() => SaveAttendance(
    transactionRepository: locator()
  ));

  locator.registerLazySingleton(() => DetermineTipeAbsen(
    transactionRepository: locator()
  ));
  //</editor-fold>


  //<editor-fold desc="Repositories">
  locator.registerLazySingleton<MasterRepository>(() => MasterRepositoyImpl(
    masterLocalDatasource: locator(),
  ));

  locator.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(
    transactionLocalDatasource: locator(),
  ));
  //</editor-fold>


  //<editor-fold desc="Datasources">
  locator.registerLazySingleton<MasterLocalDatasource>(() => MasterSqfliteDatasource(
    masterDbHelper: locator()
  ));

  locator.registerLazySingleton<TransactionLocalDatasource>(() => TransactionSqflite(
    transactionDbHelper: locator(),
    masterDbHelper: locator(),
  ));
  //</editor-fold>


  locator.registerLazySingleton(() => MasterSqfliteHelper());
  locator.registerLazySingleton(() => TransactionSqfliteHelper());
}