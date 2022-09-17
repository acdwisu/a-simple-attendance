import 'package:an_attendance/injection.dart';
import 'package:attendance/presentation/pages/history/main.dart';
import 'package:core/common/shared.dart';
import 'package:core/common/utils.dart';
import 'package:core/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:core/presentation/blocs/master/master_attendance_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void runner(bool prod) async {
  production = prod;
  
  WidgetsFlutterBinding.ensureInitialized();

  initInjection();

  runApp(
    production? const MyApp() : DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<MasterAttendanceBloc>(),
        ),
        BlocProvider(
          create: (context) => locator<AttendanceBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: !production,
        useInheritedMediaQuery: true,
        locale: production? null : DevicePreview.locale(context),
        builder: production? null : DevicePreview.appBuilder,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const AttendanceHistoryPage(),
        navigatorKey: Shared.navigatorKey,
      ),
    );
  }
}