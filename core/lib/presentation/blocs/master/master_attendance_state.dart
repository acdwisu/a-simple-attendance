part of 'master_attendance_bloc.dart';

@immutable
class MasterAttendanceState {
  final Iterable<MasterAttendanceLocation>? locations;
  final RequestState locationLoadState;
  final RequestState deleteLocationState;
  final RequestState saveLocationState;
  final String message;

  const MasterAttendanceState({
    required this.locations,
    required this.locationLoadState,
    required this.deleteLocationState,
    required this.saveLocationState,
    required this.message,
  });

  MasterAttendanceState copyWith({
    Iterable<MasterAttendanceLocation>? locations,
    RequestState? locationLoadState,
    RequestState? deleteLocationState,
    RequestState? saveLocationState,
    String? message,
  }) => MasterAttendanceState(
    locations: locations ?? this.locations,
    locationLoadState: locationLoadState ?? this.locationLoadState,
    deleteLocationState: deleteLocationState ?? this.deleteLocationState,
    saveLocationState: saveLocationState ?? this.saveLocationState,
    message: message ?? this.message,
  );

  factory MasterAttendanceState.initial() => const MasterAttendanceState(
    locations: null,
    locationLoadState: RequestState.Empty,
    deleteLocationState: RequestState.Empty,
    saveLocationState: RequestState.Empty,
    message: '',
  );
}
