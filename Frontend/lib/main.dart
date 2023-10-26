import 'package:flutter/material.dart';
import 'package:ho_pla/views/schedule.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoPla Demo',
      theme: ThemeData.dark(),
      home: ScheduleWidget(),
    );
  }
}
