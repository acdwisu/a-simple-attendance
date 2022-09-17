import 'package:attendance/presentation/pages/tapping/main.dart';
import 'package:core/common/state-enum.dart';
import 'package:core/common/utils.dart';
import 'package:core/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:core/presentation/blocs/master/master_attendance_bloc.dart';
import 'package:core/presentation/widgets/default-appbar.dart';
import 'package:core/presentation/widgets/map-picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:master_manage/presentation/pages/master-attendance-location-list/main.dart';
import 'package:collection/collection.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({Key? key}) : super(key: key);

  @override
  _AttendanceHistoryPageState createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  int? idExpanded;

  @override
  void initState() {
    super.initState();

    determinePosition().then((value) {
      positionStream.addStream(Geolocator.getPositionStream());
    });

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return Scaffold(
      appBar: DefaultAppbar(
        title: 'An Attendance',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const MasterAttendanceLocationListPage();
              })).then((value) => _fetchData());
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(
          CupertinoIcons.camera_viewfinder,
        ),
        onPressed: () async {
          final currentPosition = await determinePosition();

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TappingPage(
              currentPosition: currentPosition,
            );
          })).then((value) => _fetchData());
        },
      ),
      body: Column(
        children: [
          Text(
            'History',
            style: textTheme.headline4,
          ),
          Expanded(
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if(state.historyLoadState==RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if(state.historyLoadState==RequestState.Error) {
                  return Center(
                    child: Text(
                      state.message,
                    ),
                  );
                }

                if(state.history==null || state.history!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Data'
                    ),
                  );
                }

                final dateFormat = DateFormat('dd MMMM yyyy');

                return SingleChildScrollView(
                  child: Column(
                    children: state.history!.mapIndexed((index, e) => ExpansionTile(
                      leading: Text(
                        (index+1).toString()
                      ),
                      title: Text(
                        dateFormat.format(e.values.firstWhere((element) => element!=null)!.tanggal)
                      ),
                      children: e.keys.map((f) {
                        final value = e[f];

                        return ListTile(
                          title: Text(f.name, style: const TextStyle(
                              color: Colors.black
                          )),
                          subtitle: value==null? const Text('null') : Text(
                              "${value.attendanceLocation.label} "
                                  "(${format2DigitNumber(value.jam.hour)}:${format2DigitNumber(value.jam.minute)})"
                          ),
                          trailing: value==null? null : const Icon(
                            Icons.info
                          ),
                          onTap: value==null? null : () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text(
                                              dateFormat.format(value.tanggal)
                                          ),
                                          subtitle: Text(
                                              "${f.name} at ${value.attendanceLocation.label} "
                                                  "(${format2DigitNumber(value.jam.hour)}:${format2DigitNumber(value.jam.minute)})"
                                          ),
                                        ),
                                        MapPicker(
                                          initialValue: LatLng(value.lat, value.lon),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            );
                          },
                        );
                      }).toList(),
                    )).toList(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _fetchData() {
    Future.microtask(() {
      context.read<MasterAttendanceBloc>()
          .add(MasterAttendanceRequestDataEvent());

      context.read<AttendanceBloc>()
        ..add(AttendanceRequestHistoryEvent())
        ..add(AttendanceDetermineTipeAbsenEvent(tanggal: DateTime.now()));
    });
  }
}
