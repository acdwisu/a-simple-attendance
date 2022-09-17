import 'package:core/domain/entities/attendance-transaction.dart';
import 'package:core/presentation/widgets/map-picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class DialogDetailHistory extends StatelessWidget {
  final AttendanceTransaction data;

  DialogDetailHistory({
    Key? key,
    required this.data,
  }) : super(key: key);

  final dateFormatter = DateFormat('dd MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      child: Column(
        children: [
          Text(
            dateFormatter.format(data.tanggal),
            style: textTheme.headline2,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "${data.tipeAbsen.name} at ${data.attendanceLocation.label} "
                "(${data.jam})"
          ),
          const SizedBox(
            height: 20,
          ),
          MapPicker(
            initialValue: LatLng(
              data.lat, data.lon
            ),
          )
        ],
      ),
    );
  }
}
