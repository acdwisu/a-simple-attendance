import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

late bool production;

final BehaviorSubject<Position> positionStream = BehaviorSubject();

String timeOfDayToString(TimeOfDay time) =>
    "${time.hour}:${time.minute}";

TimeOfDay parseTimeOfDay(String value) {
  final splitted = value.split(':');

  return TimeOfDay(
    hour: int.parse(splitted[0]),
    minute: int.parse(splitted[1]),
  );
}

String format2DigitNumber(int? number) {
  if(number == null) {
    return '00';
  }

  if(number <= 9) {
    return "0$number";
  }

  return number.toString();
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<bool> confirmDialog(BuildContext context, String message) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Konfirmasi',
        ),
        content: Text(
          message,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.red
            ),
            child: const Text(
              'Tidak',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue
            ),
            child: const Text(
              'Ya',
            ),
          ),
        ],
      );
    }
  ) ?? false;
}