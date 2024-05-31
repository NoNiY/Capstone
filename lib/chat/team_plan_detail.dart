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
  List<Plan> _plans = [];
  @override
  void initState() {
    super.initState();
    _participants = List.from(widget.plan.participants);
    _fetchPlans();
  }
  Future<void> _fetchPlans() async {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';

    try {
      final firestoreInstance = FirebaseFirestore.instance;

      // 현재 계획이 아닌 모든 계획에 대한 참여자를 가져오기 위해 별도의 쿼리 필요
      QuerySnapshot allPlansSnapshot = await firestoreInstance
          .collection('plans')
          .where('participants', arrayContains: userEmail)
          .get();

      // 중복된 참여자를 제거하고 _participants에 저장
      List<String> participants = [];
      allPlansSnapshot.docs.forEach((doc) {
        List<String> docParticipants = ((doc.data() as Map<String, dynamic>?)?['participants'] as List<dynamic>?)?.map((participant) => participant.toString())?.toList() ?? [];
        participants.addAll(docParticipants.whereType<String>().where((participant) => participant != userEmail));
      });

      setState(() {
        _participants = participants.toSet().toList(); // 중복 제거를 위해 Set 활용
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
              onPressed: () {
                _addParticipant();
              },
              child: const Text('참여자 추가'),
            ),
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
                setState(() {
                  _participants.add(controller.text);
                  controller.clear(); // 입력 필드 비우기
                });
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ChatScreen(planId: widget.plan.id);
                }));
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
