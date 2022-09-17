import 'package:core/common/state-enum.dart';
import 'package:core/common/utils.dart';
import 'package:core/domain/entities/attendance-transaction.dart';
import 'package:core/domain/entities/enum-tipe-absen.dart';
import 'package:core/domain/entities/master-attendance-location.dart';
import 'package:core/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:core/presentation/blocs/master/master_attendance_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class TappingPage extends StatefulWidget {
  final Position currentPosition;

  const TappingPage({Key? key, required this.currentPosition}) : super(key: key);

  @override
  State<TappingPage> createState() => _TappingPageState();
}

class _TappingPageState extends State<TappingPage> {
  MasterAttendanceLocation? _nearestPinnedLocation;

  @override
  void initState() {
    super.initState();

    context.read<AttendanceBloc>()
      .add(AttendanceDetermineTipeAbsenEvent(tanggal: DateTime.now()));

    context.read<MasterAttendanceBloc>()
      .add(MasterAttendanceRequestDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(widget.currentPosition.latitude,
                widget.currentPosition.longitude),
            zoom: 17
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null,
            ),
            BlocBuilder<MasterAttendanceBloc, MasterAttendanceState>(
              builder: (context, state) {
                if(state.locationLoadState!=RequestState.Loaded || state.locations==null || state.locations!.isEmpty) {
                  return Container();
                }

                return Positioned(
                  left: 10,
                  top: 10,
                  child: Card(
                    child: StreamBuilder<Position>(
                      stream: positionStream,
                      builder: (context, snapshot) {
                        if(snapshot.data==null) {
                          return Container();
                        }

                        _nearestPinnedLocation = state.locations!.first;

                        for (var value in state.locations!.skip(1)) {
                          if(Geolocator.distanceBetween(
                            _nearestPinnedLocation!.lat, _nearestPinnedLocation!.lon,
                            snapshot.data!.latitude, snapshot.data!.longitude,
                          ) > Geolocator.distanceBetween(
                            value.lat, value.lon,
                            snapshot.data!.latitude, snapshot.data!.longitude,
                          )) {
                            _nearestPinnedLocation = value;
                          }
                        }

                        return Text(
                          "Nearest Pinned Loc:\n"
                              "${_nearestPinnedLocation!.label} ${Geolocator.distanceBetween(
                            _nearestPinnedLocation!.lat, _nearestPinnedLocation!.lon,
                            snapshot.data!.latitude, snapshot.data!.longitude,
                          )} m"
                        );
                      }
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if(state.tipeAbsenDeterminedState!=RequestState.Loaded) {
                  return Container();
                }

                return Stack(
                  children: [
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Card(
                        child: Text(
                          state.tipeAbsenDetermined.name
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 40
                        ),
                        child: ElevatedButton(
                          onPressed: state.saveState==RequestState.Loading? null : () {
                            final currentPosition = positionStream.value;
                            final currentTime = DateTime.now();

                            if(_nearestPinnedLocation!=null) {
                              context.read<AttendanceBloc>().add(
                                  AttendanceSaveAttendanceEvent(
                                      data: AttendanceTransaction(
                                        id: -1,
                                        lat: currentPosition.latitude,
                                        lon: currentPosition.longitude,
                                        attendanceLocation: _nearestPinnedLocation!,
                                        tanggal: currentTime,
                                        mediaPath: '',
                                        description: '',
                                        distToAttendanceLocation: Geolocator.distanceBetween(
                                          _nearestPinnedLocation!.lat, _nearestPinnedLocation!.lon,
                                          currentPosition.latitude, currentPosition.longitude,
                                        ),
                                        tipeAbsen: state.tipeAbsenDetermined,
                                        jam: TimeOfDay.fromDateTime(currentTime),
                                      )
                                  )
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Master Pinned Location belum terdefinisi'),
                                  );
                                }
                              );
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_circle_outline
                              ),
                              if(state.saveState==RequestState.Loading)
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
            BlocListener<AttendanceBloc, AttendanceState>(
              child: Container(),
              listenWhen: (a, b) => a.saveState!=b.saveState,
              listener: (context, state) {
                if(state.saveState==RequestState.Loaded) {
                  showDialog(context: context, builder: (context) => const AlertDialog(
                    title: Text('Done'),
                    content: Text('Absen berhasil disimpan'),
                  )).then((value) => Navigator.of(context).pop(true));
                } else if(state.saveState==RequestState.Error) {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: const Text('Failed'),
                    content: Text('Absen gagal disimpan (${state.message})'),
                  ));
                }
              },
            )
          ],
          children: [
            TileLayerWidget(
              options: TileLayerOptions(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
            ),
            LocationMarkerLayerWidget(),
            BlocBuilder<MasterAttendanceBloc, MasterAttendanceState>(
              builder: (context, state) {
                if(state.locationLoadState!=RequestState.Loaded || state.locations==null || state.locations!.isEmpty) {
                  return Container();
                }

                return CircleLayerWidget(
                  options: CircleLayerOptions(
                    circles: state.locations!.map((e) => CircleMarker(
                      point: LatLng(e.lat, e.lon),
                      radius: e.toleranceRadiusMeter,
                      useRadiusInMeter: true,
                      color: Colors.lightBlueAccent.withOpacity(0.5),
                    )).toList(),
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
