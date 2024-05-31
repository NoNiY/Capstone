import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/chat/_teamplan.dart';
import 'package:untitled1/chat/chat_room.dart';
import 'package:untitled1/user_info.dart';

class PlanDetailsScreen extends StatefulWidget {
  final Plan plan;
  final int index;

  const PlanDetailsScreen({super.key, required this.plan, required this.index});

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  List<String> _participants = [];

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
  }

  Future<void> _fetchParticipants() async {
    final userInfo = UserInfo();
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('plans')
          .doc(widget.plan.id)
          .get();
      List<String> participants = List.from(doc['participants']);

      // 본인 이메일 제거
      participants.removeWhere((participant) => participant == userInfo.userEmail);

      setState(() {
        _participants = participants.toSet().toList();
      });
    } catch (e) {
      debugPrint('Firestore에서 데이터 가져오기 중 오류 발생: $e');
      // 예외 처리 코드 추가
    }
  }

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
              '계획 내용: ${widget.plan.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              '시작일: ${DateFormat('yyyy-MM-dd').format(widget.plan.startDate)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '종료일: ${DateFormat('yyyy-MM-dd').format(widget.plan.endDate)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '참여자: ${_participants.join(', ')}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addParticipant,
              child: const Text('참여자 추가'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToChat(context),
              child: const Text('채팅방'),
            ),
          ],
        ),
      ),
    );
  }

  void _addParticipant() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('참여자 추가'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: '이름'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _participants.add(controller.text);
                  });
                  FirebaseFirestore.instance
                      .collection('plans')
                      .doc(widget.plan.id)
                      .update({
                    'participants': FieldValue.arrayUnion([controller.text])
                  });
                  controller.clear();
                }
                Navigator.of(context).pop();
              },
              child: const Text('추가'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ChatScreen(planId: widget.plan.id);
        },
      ),
    );
  }
}