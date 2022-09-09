import 'package:flutter/material.dart';

late bool production;

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