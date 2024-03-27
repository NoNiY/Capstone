import 'package:flutter/material.dart';
import 'main_screen.dart';

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Calendar App',
      home: MainScreen(),
    );
  }
}