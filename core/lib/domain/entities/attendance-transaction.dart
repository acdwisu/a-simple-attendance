import 'package:core/domain/entities/enum-tipe-absen.dart';
import 'package:core/domain/entities/master-attendance-location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AttendanceTransaction extends Equatable {
  final MasterAttendanceLocation attendanceLocation;
  final double lat;
  final double lon;
  final String description;
  final String mediaPath;
  final double distToAttendanceLocation;
  final int id;
  final TipeAbsen tipeAbsen;
  final DateTime tanggal;
  final TimeOfDay jam;

  const AttendanceTransaction({
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
}