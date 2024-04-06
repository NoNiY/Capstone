import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/user_info.dart';
import 'package:untitled1/chat/message.dart';
import 'package:untitled1/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }


  @override
  Future<String> _dday() async {
    // 여기에 종료 날짜의 D-day를 계산하는 코드를 작성합니다.
    // 이 메서드는 비동기로 종료 날짜의 D-day를 계산하고 계산된 D-day를 반환합니다.
    // 위의 예시 코드를 참고하여 종료 날짜의 D-day를 계산하고 문자열로 반환합니다.
    final userInfo = UserInfo();
    DateTime userEnd = userInfo.endDate ?? DateTime.now();
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildEndDateDdayText()
            ),
        ],
        ),
        body: Container(
          child: const Column(
            children: [
              Expanded(
                child: Messages(),
              ),
              NewMessage(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildEndDateDdayText() {
    // 여기에 사용자의 종료 날짜에 대한 D-day를 계산하고 텍스트로 반환하는 코드를 작성합니다.
    return FutureBuilder<String>(
      future: _dday(), // _dday() 함수를 호출하여 종료 날짜의 D-day를 계산합니다.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터 로딩 중인 경우 로딩 텍스트를 반환합니다.
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 에러 발생 시 에러 메시지를 반환합니다.
          return Text('Error: ${snapshot.error}');
        } else {
          // 정상적으로 종료 날짜의 D-day가 계산된 경우, 결과를 반환합니다.
          // 이 결과는 FutureBuilder의 future가 완료된 후에 비로소 사용 가능합니다.
          return Text(
            '${snapshot.data}',
            style: const TextStyle(fontSize: 30),
          );
        }
      },
    );
  }
}
