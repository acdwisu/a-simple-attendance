import 'package:flutter/material.dart';

class DefaultAppbar extends AppBar {
  DefaultAppbar({
    Key? key,
    required String title,
    List<Widget>? actions,
  }) : super(
    key: key,
    iconTheme: const IconThemeData(
      color: Colors.black, //change your color here
    ),
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: const TextStyle(color: Colors.black),
    ),
    elevation: 0.0,
    automaticallyImplyLeading: false,
    actions: actions,
  );
}
