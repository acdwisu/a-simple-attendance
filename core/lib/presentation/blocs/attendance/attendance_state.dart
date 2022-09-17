part of 'attendance_bloc.dart';

@immutable
class AttendanceState {
  final Iterable<Map<TipeAbsen, AttendanceTransaction?>>? history;
  final TipeAbsen tipeAbsenDetermined;
  final RequestState historyLoadState;
  final RequestState saveState;
  final RequestState clearState;
  final RequestState tipeAbsenDeterminedState;
  final String message;

  const AttendanceState({
    required this.history,
    required this.historyLoadState,
    required this.saveState,
    required this.clearState,
    required this.message,
    required this.tipeAbsenDetermined,
    required this.tipeAbsenDeterminedState,
  });

  AttendanceState copyWith({
    Iterable<Map<TipeAbsen, AttendanceTransaction?>>? history,
    TipeAbsen? tipeAbsenDetermined,
    RequestState? historyLoadState,
    RequestState? saveState,
    RequestState? clearState,
    RequestState? tipeAbsenDeterminedState,
    String? message,
  }) => AttendanceState(
      history: history ?? this.history,
      historyLoadState: historyLoadState ?? this.historyLoadState,
      saveState: saveState ?? this.saveState,
      clearState: clearState ?? this.clearState,
      message: message ?? this.message,
      tipeAbsenDetermined: tipeAbsenDetermined ?? this.tipeAbsenDetermined,
      tipeAbsenDeterminedState: tipeAbsenDeterminedState ?? this.tipeAbsenDeterminedState
  );

  factory AttendanceState.initial() => const AttendanceState(
      history: null,
      historyLoadState: RequestState.Empty,
      saveState: RequestState.Empty,
      clearState: RequestState.Empty,
      message: '',
      tipeAbsenDetermined: TipeAbsen.Unknown,
      tipeAbsenDeterminedState: RequestState.Empty,
  );
}