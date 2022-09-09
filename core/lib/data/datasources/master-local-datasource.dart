import 'package:core/data/models/master-attendance-location.dart';

abstract class MasterLocalDatasource {
  Future<Iterable<ModelMasterAttendanceLocation>?> getPinnedLocation();
  Future<bool> savePinnedLocation(ModelMasterAttendanceLocation model);
  Future<bool> deletePinnedLocation(int idPinnedLocation);
}