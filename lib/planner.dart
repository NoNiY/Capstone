import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({Key? key}) : super(key: key);

  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('planner'),
        ),
        body: (
        Text("planner")
        ),
      )
    );
  }
}