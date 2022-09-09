import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void runner(bool production) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    production? MyApp() : DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}