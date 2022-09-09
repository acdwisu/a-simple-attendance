import 'package:core/common/constants.dart';
import 'package:core/data/models/model.dart';
import 'package:core/domain/entities/master-attendance-location.dart';

class ModelMasterAttendanceLocation implements Model<MasterAttendanceLocation> {
  final double lat;
  final double lon;
  final String label;
  final double toleranceRadiusMeter;
  final int id;
  final bool active;

  const ModelMasterAttendanceLocation({
    required this.lat,
    required this.lon,
    required this.label,
    required this.toleranceRadiusMeter,
    required this.id,
    required this.active,
  });

  factory ModelMasterAttendanceLocation.empty() => const ModelMasterAttendanceLocation(
    active: false,
    toleranceRadiusMeter: -1,
    label: '?',
    lon: 0,
    lat: 0,
    id: -1,
  );

  @override
  List<Object?> get props => [
    lat, lon,
  ];

  @override
  MasterAttendanceLocation get toEntity => MasterAttendanceLocation(
    id: id,
    label: label,
    lat: lat,
    lon: lon,
    toleranceRadiusMeter: toleranceRadiusMeter,
    active: active,
  );
}