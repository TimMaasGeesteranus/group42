import 'package:flutter/material.dart';

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
        fillColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected) ? red : grey)),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(red),
        foregroundColor: MaterialStateProperty.all(
            white), // Set the text color to white for text buttons
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
    ));
