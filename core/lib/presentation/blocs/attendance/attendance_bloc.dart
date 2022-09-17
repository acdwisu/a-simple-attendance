import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/common/state-enum.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/attendance-transaction.dart';
import '../../../domain/entities/enum-tipe-absen.dart';
import '../../../domain/usecases/transaction/clear-attendance.dart';
import '../../../domain/usecases/transaction/determine-tipe-absen.dart';
import '../../../domain/usecases/transaction/get-history-attendance.dart';
import '../../../domain/usecases/transaction/save-attendance.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetHistoryAttendance getHistoryAttendance;
  final ClearAttendance clearAttendance;
  final SaveAttendance saveAttendance;
  final DetermineTipeAbsen determineTipeAbsen;

  AttendanceBloc({
    required this.saveAttendance,
    required this.clearAttendance,
    required this.getHistoryAttendance,
    required this.determineTipeAbsen,
  }) : super(AttendanceState.initial()) {
    on<AttendanceRequestHistoryEvent>(_onRequestHistory);
    on<AttendanceClearHistoryEvent>(_onClearHistory);
    on<AttendanceSaveAttendanceEvent>(_onSaveAttendance);
    on<AttendanceDetermineTipeAbsenEvent>(_onDetermineTipeAbsen);
  }

  FutureOr<void> _onRequestHistory(AttendanceRequestHistoryEvent event, Emitter<AttendanceState> emit) async {
    emit(
        state.copyWith(
          historyLoadState: RequestState.Loading,
          message: '',
        )
    );

    final temp = await getHistoryAttendance.execute();

    temp.fold(
      (l) => emit(
        state.copyWith(
          historyLoadState: RequestState.Error,
          message: l.message,
        )
      ), (r) => emit(
        state.copyWith(
          historyLoadState: RequestState.Loaded,
          history: r,
        ),
      )
    );
  }

  FutureOr<void> _onClearHistory(AttendanceClearHistoryEvent event, Emitter<AttendanceState> emit) async {
    emit(
        state.copyWith(
          clearState: RequestState.Loading,
          message: '',
        )
    );

    final temp = await clearAttendance.execute();

    temp.fold(
      (l) => emit(
        state.copyWith(
          clearState: RequestState.Error,
          message: l.message,
        )
      ), (r) => emit(
        state.copyWith(
          clearState: RequestState.Loaded,
          history: List.empty(),
        ),
      )
    );
  }

  FutureOr<void> _onSaveAttendance(AttendanceSaveAttendanceEvent event, Emitter<AttendanceState> emit) async {
    emit(
        state.copyWith(
          saveState: RequestState.Loading,
          message: '',
        )
    );

    final completer = Completer();

    final temp = await saveAttendance.execute(event.data);

    temp.fold(
      (l) {
        emit(
            state.copyWith(
              saveState: RequestState.Error,
              message: l.message,
            )
        );

        completer.complete();
      }, (r) async {
        emit(
          state.copyWith(
            saveState: RequestState.Loaded,
          ),
        );

        final s = await getHistoryAttendance.execute();

        s.fold((t) => null, (u) {
          emit(
            state.copyWith(
              history: u,
              historyLoadState: RequestState.Loaded
            )
          );
        });

        completer.complete();
      }
    );

    await completer.future;
  }

  FutureOr<void> _onDetermineTipeAbsen(AttendanceDetermineTipeAbsenEvent event, Emitter<AttendanceState> emit) async {
    emit(
        state.copyWith(
          tipeAbsenDeterminedState: RequestState.Loading,
          message: '',
        )
    );

    final temp = await determineTipeAbsen.execute(event.tanggal);

    temp.fold(
      (l) => emit(
        state.copyWith(
          tipeAbsenDeterminedState: RequestState.Error,
          message: l.message,
        )
      ), (r) => emit(
        state.copyWith(
          tipeAbsenDeterminedState: RequestState.Loaded,
          tipeAbsenDetermined: r,
        ),
      )
    );
  }
}
