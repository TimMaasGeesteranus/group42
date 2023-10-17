import 'package:flutter/material.dart';
import 'package:ho_pla/views/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'HoPla Demo',
      home: WelcomeWidget(),
    );
  }
}
