part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent {}

class AttendanceRequestHistoryEvent extends AttendanceEvent {}

class AttendanceClearHistoryEvent extends AttendanceEvent {}

class AttendanceSaveAttendanceEvent extends AttendanceEvent {
  final AttendanceTransaction data;

  AttendanceSaveAttendanceEvent({required this.data});
}

class AttendanceDetermineTipeAbsenEvent extends AttendanceEvent {
  final DateTime tanggal;

  AttendanceDetermineTipeAbsenEvent({required this.tanggal});
}