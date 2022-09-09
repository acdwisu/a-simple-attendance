import 'package:core/domain/entities/attendance-transaction.dart';
import 'package:core/domain/entities/enum-tipe-absen.dart';
import 'package:flutter/material.dart';

import 'master-attendance-location.dart';
import 'model.dart';

class ModelAttendanceTransaction implements Model<AttendanceTransaction> {
  final ModelMasterAttendanceLocation attendanceLocation;
  final double lat;
  final double lon;
  final DateTime tanggal;
  final TimeOfDay jam;
  final String description;
  final String mediaPath;
  final double distToAttendanceLocation;
  final int id;
  final TipeAbsen tipeAbsen;

  const ModelAttendanceTransaction({
    required this.attendanceLocation,
    required this.lat,
    required this.lon,
    required this.tanggal,
    required this.description,
    required this.mediaPath,
    required this.distToAttendanceLocation,
    required this.id,
    required this.tipeAbsen,
    required this.jam,
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
    tanggal: tanggal,
    jam: jam,
    description: description,
    distToAttendanceLocation: distToAttendanceLocation,
    mediaPath: mediaPath,
    attendanceLocation: attendanceLocation.toEntity,
    tipeAbsen: tipeAbsen
  );
}