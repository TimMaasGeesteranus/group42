import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:ho_pla/views/devices_overview.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required for using plugins before runApp

  final preferences = await SharedPreferences.getInstance();
  final bool darkMode = preferences.getBool('darkmode') ?? false;

  runApp(MyApp(darkMode: darkMode));
}

class MyApp extends StatelessWidget {
  final bool darkMode;

  const MyApp({super.key, required this.darkMode});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
        initTheme: darkMode ? ThemeData.dark() : ThemeData.light(),
        builder: (context, myTheme) {
          return MaterialApp(
            title: 'HoPla Demo',
            theme: myTheme,
            home: DevicesOverviewWidget(),
          );
        });
  }
}
