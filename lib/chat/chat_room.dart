import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/user_info.dart';
import 'package:untitled1/chat/message.dart';
import 'package:untitled1/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  final String planId; // planId를 받도록 수정

  const ChatScreen({super.key, required this.planId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<String> _dday() async {
    final userInfo = UserInfo();
    DateTime userEnd = userInfo.endDate;
    DateTime currentDate = DateTime.now();
    int dDayToEnd = userEnd.difference(currentDate).inDays;
    return dDayToEnd >= 0 ? 'D-$dDayToEnd' : 'D+${-dDayToEnd}';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 4,
          backgroundColor: Colors.blueGrey,
          title: const Text("work"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildEndDateDdayText(),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Messages(planId: widget.planId), // Messages에 planId 전달
            ),
            NewMessage(planId: widget.planId), // NewMessage에 planId 전달
          ],
        ),
      ),
    );
  }

  Widget _buildEndDateDdayText() {
    return FutureBuilder<String>(
      future: _dday(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text(
            '${snapshot.data}',
            style: const TextStyle(fontSize: 30),
          );
        }
      },
    );
  }
}