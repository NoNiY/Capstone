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
  String? _planName; // Nullable로 변경

  @override
  void initState() {
    super.initState();
    _fetchPlanDetails();
  }
  Future<void> _fetchPlanDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('plans')
          .doc(widget.planId) // 받은 계획 ID를 사용하여 해당 계획의 데이터 가져오기
          .get();

      setState(() {
        _planName = doc['name']; // 계획 이름 가져오기
      });
    } catch (e) {
      debugPrint('Firestore에서 데이터 가져오는 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 4,
          backgroundColor: Colors.blueGrey,
          title: _planName != null ? Center(child: Text(_planName!)) : CircularProgressIndicator(),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
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
}