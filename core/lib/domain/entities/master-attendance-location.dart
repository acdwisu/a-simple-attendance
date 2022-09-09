import 'package:equatable/equatable.dart';

class MasterAttendanceLocation extends Equatable {
  final double lat;
  final double lon;
  final String label;
  final double toleranceRadiusMeter;
  final int id;
  final bool active;

  const MasterAttendanceLocation({
    required this.lat,
    required this.lon,
    required this.label,
    required this.toleranceRadiusMeter,
    required this.id,
    required this.active,
  });

  @override
  List<Object?> get props => [
    lat, lon,
  ];
}