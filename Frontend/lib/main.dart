import 'package:flutter/material.dart';
import 'package:ho_pla/views/profile.dart';
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
    return MaterialApp(
      title: 'HoPla Demo',
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      home: ProfileWidget(),
    );
  }
}
