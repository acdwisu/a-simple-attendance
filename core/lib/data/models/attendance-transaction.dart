import 'package:core/domain/entities/attendance-transaction.dart';

import 'master-attendance-location.dart';
import 'model.dart';

class ModelAttendanceTransaction implements Model<AttendanceTransaction> {
  final ModelMasterAttendanceLocation attendanceLocation;
  final double lat;
  final double lon;
  final DateTime timeStamp;
  final String description;
  final String mediaPath;
  final double distToAttendanceLocation;
  final int id;

  const ModelAttendanceTransaction({
    required this.attendanceLocation,
    required this.lat,
    required this.lon,
    required this.timeStamp,
    required this.description,
    required this.mediaPath,
    required this.distToAttendanceLocation,
    required this.id,
  });

  @override
  List<Object?> get props => [
    id,
  ];

  @override
  AttendanceTransaction get toEntity => AttendanceTransaction(
    id: id,
    lon: lon,
    lat: lat,
    timeStamp: timeStamp,
    description: description,
    distToAttendanceLocation: distToAttendanceLocation,
    mediaPath: mediaPath,
    attendanceLocation: attendanceLocation.toEntity,
  );
}