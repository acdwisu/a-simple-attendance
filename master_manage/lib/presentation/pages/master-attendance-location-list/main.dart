import 'package:core/common/state-enum.dart';
import 'package:core/presentation/blocs/master/master_attendance_bloc.dart';
import 'package:core/presentation/widgets/default-appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_manage/presentation/pages/master-attendance-location-list/dialogs/form-attendance-location.dart';

import 'widgets/tile-pinned-location.dart';

class MasterAttendanceLocationListPage extends StatefulWidget {
  const MasterAttendanceLocationListPage({Key? key}) : super(key: key);

  @override
  _MasterAttendanceLocationListPageState createState() =>
      _MasterAttendanceLocationListPageState();
}

class _MasterAttendanceLocationListPageState
    extends State<MasterAttendanceLocationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppbar(
        title: 'Pinned Attendance Locations',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MasterAttendanceBloc, MasterAttendanceState>(
          builder: (context, state) {
            if(state.locationLoadState==RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if(state.locationLoadState==RequestState.Error) {
              return Center(
                child: Text(
                  state.message,
                ),
              );
            }

            if(state.locations==null || state.locations!.isEmpty) {
              return const Center(
                child: Text(
                  'No Data'
                ),
              );
            }

            return ListView(
              children: state.locations!.map((e) => TilePinnedLocation(
                location: e,
              )).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(
          Icons.add_circle_outline
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const FormAttendanceLocation();
              }
          );
        },
      ),
    );
  }
}
