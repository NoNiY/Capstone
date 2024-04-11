import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/chat/team_plan_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/user_info.dart';
import 'package:untitled1/chat/_teamplan.dart';

class TeamPlanScreen extends StatelessWidget {
  const TeamPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: TeamPlanListScreen(),
    );
  }
}

class TeamPlanListScreen extends StatefulWidget {
  const TeamPlanListScreen({super.key});

  @override
  State<TeamPlanListScreen> createState() => _TeamPlanListScreenState();
}

class _TeamPlanListScreenState extends State<TeamPlanListScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _participants = [];
  final TextEditingController _descriptionController = TextEditingController();
  List<Plan> _plans = [];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }
  Future<void> _fetchPlans() async {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';

    try {
      final firestoreInstance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestoreInstance
          .collection('plans')
          .where('userId', isEqualTo: userEmail)
          .get();

      List<Plan> fetchedPlans = querySnapshot.docs.map((doc) {
        final planData = doc.data() as Map<String, dynamic>;
        planData['id'] = doc.id; // 문서의 ID를 'id' 필드에 할당
        return Plan.fromJson(planData);
      }).toList();

      setState(() {
        _plans = fetchedPlans;
      });
    } catch (e) {
      debugPrint('Firestore에서 데이터 가져오기 중 오류 발생: $e');
      // 예외 처리 코드 추가
    }
  }
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
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

  void _addPlan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('새로운 계획 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildDateSelector('시작일', _startDate, true),
              _buildDateSelector('종료일', _endDate, false),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: '계획 내용'),
              ),
              const SizedBox(height: 16),
              const Text('참여자'),
              Wrap(
                children: _participants.map((participant) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Chip(
                      label: Text(participant),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addParticipant,
                child: const Text('참여자 추가'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: _onSave,
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

  void _onSave() async {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';

    // Null 체크 및 기본값 설정
    DateTime startDate = _startDate ?? DateTime.now();
    DateTime endDate = _endDate ?? DateTime.now();

    Plan updatedPlan = Plan(
      userId: userEmail,
      name: _descriptionController.text,
      startDate: startDate,
      endDate: endDate,
      participants: _participants,
    );

    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentReference documentReference = await firestoreInstance.collection('plans').add(updatedPlan.toJson());
      String planId = documentReference.id; // Firestore에서 생성된 id를 가져옴
      updatedPlan = updatedPlan.copyWith(id: planId); // Plan 객체에 가져온 id를 설정
      await firestoreInstance.collection('plans').doc(planId).set(updatedPlan.toJson());
      setState(() {
        _plans.add(updatedPlan);
        _startDate = null; // 추가 후 초기화
        _endDate = null; // 추가 후 초기화
        _participants = []; // 추가 후 초기화
        _descriptionController.clear(); // 추가 후 초기화
      });
      // 데이터 추가가 성공적으로 이루어졌으므로 다이얼로그를 닫습니다.
      if (mounted) {
      Navigator.of(context).pop();
      }
    } catch (e) {
      // Firestore 데이터 추가 과정에서 예외가 발생한 경우
      debugPrint('Firestore에 데이터 추가 중 오류 발생: $e');
      // 예외 처리 코드 추가 (예를 들어, 사용자에게 오류 메시지를 보여줄 수 있음)
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 계획 목록'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16),
          Expanded(
            child: _buildPlanList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlan,
        tooltip: '새로운 계획 추가',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlanList() {
    return ListView.builder(
      itemCount: _plans.length,
      itemBuilder: (context, index) {
        final plan = _plans[index];
        return ListTile(
          title: Text(plan.name), // 변경: 'description' -> 'name'
          subtitle: Text(
            '${DateFormat('yyyy-MM-dd').format(plan.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(plan.endDate)}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deletePlan(context, index);
            },
          ),
          onTap: () => _navigateToPlanDetails(plan, index),
        );
      },
    );
  }

  void _deletePlan(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('계획 삭제'),
          content: const Text('이 계획을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _deleteSelectedPlan(index);
                Navigator.pop(context);
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

  Future<void> _deleteSelectedPlan(int index) async {
  final plan = _plans[index];

  if (plan.id.isEmpty) {
    debugPrint('Plan ID가 비어있어 삭제할 수 없습니다.');
    return;
  }

  try {
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection('plans').doc(plan.id).delete();

    setState(() {
      _plans.removeAt(index);
    });
  } catch (e) {
    debugPrint('Firestore에서 데이터 삭제 중 오류 발생: $e');
    // 예외 처리 코드 추가
  }
}

  void _ddeletePlan(int index) {
    setState(() {
      _plans.removeAt(index);
    });
  }

  void _navigateToPlanDetails(Plan plan, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PlanDetailsScreen(plan: plan, index: index),
    ),
  );
}

  Widget _buildDateSelector(String label, DateTime? date, bool isStartDate) {
    return Row(
      children: <Widget>[
        Text(label),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => _selectDate(context, isStartDate),
          child: Text(
            date == null
                ? '날짜 선택'
                : DateFormat('yyyy-MM-dd').format(date),
          ),
        ),
      ],
    );
  }
}