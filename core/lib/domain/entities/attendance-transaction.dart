import 'package:core/domain/entities/master-map.dart';
import 'package:equatable/equatable.dart';

class AttendanceTransaction extends Equatable {
  final MasterAttendanceLocation attendanceLocation;
  final double lat;
  final double lon;
  final DateTime timeStamp;
  final String description;
  final String mediaPath;
  final double distToAttendanceLocation;
  final int id;

  const AttendanceTransaction({
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
}