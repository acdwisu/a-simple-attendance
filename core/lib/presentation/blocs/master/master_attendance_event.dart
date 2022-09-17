part of 'master_attendance_bloc.dart';

@immutable
abstract class MasterAttendanceEvent {}

class MasterAttendanceRequestDataEvent extends MasterAttendanceEvent {}

class MasterAttendanceDeleteLocationEvent extends MasterAttendanceEvent {
  final int id;

  MasterAttendanceDeleteLocationEvent({required this.id});
}

class MasterAttendanceSaveLocationEvent extends MasterAttendanceEvent {
  final MasterAttendanceLocation location;

  MasterAttendanceSaveLocationEvent({required this.location});
}