import 'package:core/domain/entities/master-attendance-location.dart';
import 'package:core/common/utils.dart';
import 'package:core/presentation/blocs/master/master_attendance_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_manage/presentation/pages/master-attendance-location-list/dialogs/form-attendance-location.dart';

class TilePinnedLocation extends StatefulWidget {
  final MasterAttendanceLocation location;

  const TilePinnedLocation({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  State<TilePinnedLocation> createState() => _TilePinnedLocationState();
}

class _TilePinnedLocationState extends State<TilePinnedLocation> {
  late MasterAttendanceLocation _location = widget.location;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${_location.label} (${_location.active? 'Active' : 'Inactive'})",
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Max Radius: ${_location.toleranceRadiusMeter.toStringAsFixed(2)} m"
          ),
          Text(
            "Coordinate: ${_location.lat.toStringAsFixed(3)}, ${_location.lon.toStringAsFixed(3)}"
          ),
        ],
      ),
      trailing: Column(
        children: [
          Expanded(
            child: IconButton(
              icon: const Icon(
                Icons.edit,
              ),
              onPressed: () {
                showDialog<MasterAttendanceLocation>(
                  context: context,
                  builder: (context) {
                    return FormAttendanceLocation(
                      attendanceLocation: _location,
                    );
                  }
                ).then((value) {
                  if(value != null && mounted) {
                    setState(() {
                      _location = value;
                    });
                  }
                });
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(
                Icons.delete
              ),
              onPressed: () {
                confirmDialog(context, 'Data akan dihapus, Anda yakin?').then((value) {
                  if(value) {
                    context.read<MasterAttendanceBloc>().add(
                        MasterAttendanceDeleteLocationEvent(id: _location.id)
                    );
                  }
                });
              },
            ),
          )
        ],
      ),
      onTap: () {

      },
    );
  }
}
