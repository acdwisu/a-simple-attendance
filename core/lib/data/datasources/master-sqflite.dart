import 'package:core/data/datasources/master-local-datasource.dart';
import 'package:core/data/datasources/sqflite-helper/master-db.dart';
import 'package:core/data/models/master-attendance-location.dart';

class MasterSqfliteDatasource extends MasterLocalDatasource {
  final MasterSqfliteHelper masterDbHelper;

  MasterSqfliteDatasource({
    required this.masterDbHelper,
  });

  @override
  Future<bool> deletePinnedLocation(int idPinnedLocation) {
    return masterDbHelper.deleteMasterAttendanceLocation(idPinnedLocation);
  }

  @override
  Future<Iterable<ModelMasterAttendanceLocation>?> getPinnedLocation() {
    return masterDbHelper.retrieveMasterAttendanceLocations();
  }

  @override
  Future<bool> savePinnedLocation(ModelMasterAttendanceLocation model) {
    return masterDbHelper.saveMasterAttendanceLocation(model);
  }

}