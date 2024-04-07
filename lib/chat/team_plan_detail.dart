import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/chat/team_plan_screen.dart';
import 'package:untitled1/chat/_teamplan.dart';
import 'package:untitled1/chat/chat_room.dart';

class PlanDetailsScreen extends StatelessWidget {
  final Plan plan;
  final int index;

  const PlanDetailsScreen({super.key, required this.plan, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계획 상세 정보'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '계획 내용: ${plan.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              '시작일: ${DateFormat('yyyy-MM-dd').format(plan.startDate)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '종료일: ${DateFormat('yyyy-MM-dd').format(plan.endDate)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '참여자: ${plan.participants.join(', ')}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _deletePlan(context);
              },
              child: const Text('채팅방'),
            ),
          ],
        ),
      ),
    );
  }

  void _deletePlan(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('채팅방'),
          content: const Text('채팅방으로 이동하겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return const ChatScreen();
                    }
                ));
              },
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}

