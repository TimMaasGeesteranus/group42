import 'package:animated_theme_switcher/animated_theme_switcher.dart';
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
    return ThemeProvider(
        initTheme: darkMode ? customDarkTheme : ThemeData.light(),
        builder: (context, myTheme) {
          return MaterialApp(
            title: 'HoPla Demo',
            theme: myTheme,
            home: ProfileWidget(),
          );
        });
  }
}

Color red = const Color(0xFFFF3636);
Color orange = const Color(0xFFF79256);
Color black = const Color(0xFF1E2023);
Color blue = const Color(0xFF75F5EE);
Color green = const Color(0xFF5DE877);
Color grey = const Color(0xFF59575A);
Color darkGrey = const Color(0xFF272D33);
Color white = const Color(0xFFFFFFFF);

final customDarkTheme = ThemeData.dark().copyWith(
  primaryColor: red,
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.selected) ? red : grey)
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(red),
      foregroundColor: MaterialStateProperty.all(white), // Set the text color to white for text buttons
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: red),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionHandleColor: red,
    cursorColor: white,
  )
);
