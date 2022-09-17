import 'package:core/common/constants.dart';
import 'package:core/common/state-enum.dart';
import 'package:core/common/utils.dart';
import 'package:core/domain/entities/master-attendance-location.dart';
import 'package:core/presentation/blocs/master/master_attendance_bloc.dart';
import 'package:core/presentation/widgets/map-picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

class FormAttendanceLocation extends StatefulWidget {
  final MasterAttendanceLocation? attendanceLocation;
  final bool edit;

  const FormAttendanceLocation({
    Key? key,
    this.attendanceLocation,
    this.edit = true,
  }) : super(key: key);

  @override
  State<FormAttendanceLocation> createState() => _FormAttendanceLocationState();
}

class _FormAttendanceLocationState extends State<FormAttendanceLocation> {
  late final FormGroup _formGroup;

  final _keyCoord = '1';
  final _keyMaxTolerance = '2';
  final _keyLabel = '3';

  final _streamRadius = BehaviorSubject<double>();

  @override
  void initState() {
    super.initState();

    _formGroup = FormGroup({
      _keyCoord: FormControl<LatLng>(
        disabled: true,
        value: widget.attendanceLocation != null ? LatLng(
          widget.attendanceLocation!.lat,
          widget.attendanceLocation!.lon,
        ) : null,
        validators: [
          Validators.required
        ],
      ),
      _keyLabel: FormControl<String>(
        value: widget.attendanceLocation?.label,
        validators: [
          Validators.required
        ],
      ),
      _keyMaxTolerance: FormControl<double>(
        value: widget.attendanceLocation?.toleranceRadiusMeter ??
            defaultMaxToleranceRadius,
        validators: [
          Validators.required
        ],
      ),
    }, disabled: !widget.edit);

    _streamRadius.add(_formGroup.control(_keyMaxTolerance).value);

    _streamRadius.addStream(_formGroup.control(_keyMaxTolerance).valueChanges.cast<double>());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ReactiveForm(
        formGroup: _formGroup,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReactiveFormField<LatLng, LatLng>(
                formControlName: _keyCoord,
                builder: (state) {
                  return FutureBuilder<Position>(
                      future: determinePosition(),
                      builder: (context, snapshot) {
                        return MapPicker(
                          onPicked: (value) {
                            _formGroup.patchValue({
                              _keyCoord: value
                            });
                          },
                          initialValue: state.control.value,
                          radiusStream: _streamRadius,
                        );
                      }
                  );
                },
                valueAccessor: DefaultValueAccessor(),
              ),
              ReactiveTextField(
                formControlName: _keyLabel,
                decoration: const InputDecoration(
                  labelText: 'Label'
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReactiveSlider(
                    formControlName: _keyMaxTolerance,
                    labelBuilder: (value) {
                      return "Max Tolerance Radius: ${value.toStringAsFixed(2)} m";
                    },
                    min: 0,
                    max: 150,
                    divisions: 450,
                  ),
                  Expanded(
                    child: ReactiveValueListenableBuilder(
                      formControlName: _keyMaxTolerance,
                      builder: (context, field, child) {
                        return Text(
                          "${(field.value as double).toStringAsFixed(2)} m"
                        );
                      },
                    ),
                  )
                ],
              ),
              if(widget.edit)
                BlocConsumer<MasterAttendanceBloc, MasterAttendanceState>(
                  builder: (context, state) {
                    return ReactiveFormConsumer(
                      builder: (context, form, child) {
                        final valid = form.valid && state.saveLocationState!=RequestState.Loading;

                        return TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: valid ? Colors.green : Colors
                                .grey,
                            primary: Colors.white,
                          ),
                          onPressed: valid ? () {
                            final coord = form.control(_keyCoord).value as LatLng;

                            context.read<MasterAttendanceBloc>().add(
                                MasterAttendanceSaveLocationEvent(
                                    location: MasterAttendanceLocation(
                                      lat: coord.latitude,
                                      lon: coord.longitude,
                                      id: widget.attendanceLocation?.id ?? -1,
                                      active: true,
                                      toleranceRadiusMeter: _formGroup.value[_keyMaxTolerance]! as double,
                                      label: _formGroup.value[_keyLabel] as String,
                                    )
                                )
                            );
                          } : null,
                          child: Text(
                            widget.attendanceLocation == null ?
                            'Simpan' : 'Edit',
                          ),
                        );
                      },
                    );
                  },
                  listenWhen: (a, b) => a.saveLocationState!=b.saveLocationState,
                  listener: (context, state) {
                    if(state.saveLocationState==RequestState.Loaded) {
                      showDialog(context: context, builder: (context) => const AlertDialog(
                        title: Text('Done'),
                        content: Text('Lokasi berhasil disimpan'),
                      )).then((value) => Navigator.of(context).pop(state.locations!.last));
                    } else if(state.saveLocationState==RequestState.Error) {
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: const Text('Failed'),
                        content: Text('Lokasi gagal disimpan (${state.message})'),
                      ));
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
