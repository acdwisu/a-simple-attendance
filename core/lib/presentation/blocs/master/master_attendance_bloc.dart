import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/common/state-enum.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/master-attendance-location.dart';
import '../../../domain/usecases/master/delete-master-attendance-location.dart';
import '../../../domain/usecases/master/get-master-attendance-locations.dart';
import '../../../domain/usecases/master/save-master-attendance-location.dart';

part 'master_attendance_event.dart';
part 'master_attendance_state.dart';

class MasterAttendanceBloc extends Bloc<MasterAttendanceEvent, MasterAttendanceState> {
  final DeleteMasterAttendanceLocation deleteMasterAttendanceLocation;
  final GetMasterAttendanceLocation getMasterAttendanceLocations;
  final SaveMasterAttendanceLocation saveMasterAttendanceLocation;

  MasterAttendanceBloc({
    required this.saveMasterAttendanceLocation,
    required this.getMasterAttendanceLocations,
    required this.deleteMasterAttendanceLocation,
  }) : super(MasterAttendanceState.initial()) {
    on<MasterAttendanceRequestDataEvent>(_onRequestData);
    on<MasterAttendanceDeleteLocationEvent>(_onDeleteLocation);
    on<MasterAttendanceSaveLocationEvent>(_onSaveLocation);
  }

  FutureOr<void> _onRequestData(MasterAttendanceRequestDataEvent event, Emitter<MasterAttendanceState> emit) async {
    emit(
        state.copyWith(
          locationLoadState: RequestState.Loading,
          message: '',
        )
    );

    final temp = await getMasterAttendanceLocations.execute();

    temp.fold(
      (l) => emit(
        state.copyWith(
          locationLoadState: RequestState.Error,
          message: l.message,
        )
      ), (r) => emit(
        state.copyWith(
          locationLoadState: RequestState.Loaded,
          locations: r,
        ),
      )
    );
  }

  FutureOr<void> _onDeleteLocation(MasterAttendanceDeleteLocationEvent event, Emitter<MasterAttendanceState> emit) async {
    emit(
        state.copyWith(
          deleteLocationState: RequestState.Loading,
          message: '',
        )
    );

    final temp = await deleteMasterAttendanceLocation.execute(event.id);

    temp.fold(
      (l) => emit(
        state.copyWith(
          deleteLocationState: RequestState.Error,
          message: l.message,
        )
      ), (r) => emit(
        state.copyWith(
          deleteLocationState: RequestState.Loaded,
          locations: state.locations?.where((element) => element.id!=event.id),
        ),
      )
    );
  }

  FutureOr<void> _onSaveLocation(MasterAttendanceSaveLocationEvent event, Emitter<MasterAttendanceState> emit) async {
    emit(
        state.copyWith(
          saveLocationState: RequestState.Loading,
          message: '',
        )
    );

    final temp = await saveMasterAttendanceLocation.execute(event.location);

    final completer = Completer();

    temp.fold(
      (l) => emit(
        state.copyWith(
          saveLocationState: RequestState.Error,
          message: l.message,
        )
      ), (r) async {
        final temp2 = await getMasterAttendanceLocations.execute();

        temp2.fold((l) => emit(
          state.copyWith(
            locations: event.location.id<1? (
              [
                ...state.locations!,
                event.location
              ]
            ) : state.locations!,
            saveLocationState: RequestState.Loaded,
            locationLoadState: RequestState.Loaded,
          )
        ), (r2) => emit(
          state.copyWith(
            saveLocationState: RequestState.Loaded,
            locationLoadState: RequestState.Loaded,
            locations: r2,
          ),
        ));

        completer.complete();
      }
    );

    await completer.future;
  }
}
