import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/chat/TeamPlanDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/user_info.dart';
import 'package:untitled1/chat/_teamplan.dart';

class TeamPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '팀 계획',
      home: TeamPlanListScreen(),
    );
  }
}

class TeamPlanListScreen extends StatefulWidget {
  @override
  _TeamPlanListScreenState createState() => _TeamPlanListScreenState();
}

class _TeamPlanListScreenState extends State<TeamPlanListScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _participants = [];
  TextEditingController _descriptionController = TextEditingController();
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
        return Plan.fromJson(doc.data() as Map<String, dynamic>);
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
        final TextEditingController _controller = TextEditingController();
        return AlertDialog(
          title: Text('참여자 추가'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: '이름'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _participants.add(_controller.text);
                  _controller.clear(); // 입력 필드 비우기
                });
                Navigator.of(context).pop();
              },
              child: Text('추가'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
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
          title: Text('새로운 계획 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildDateSelector('시작일', _startDate, true),
              _buildDateSelector('종료일', _endDate, false),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: '계획 내용'),
              ),
              SizedBox(height: 16),
              Text('참여자'),
              Wrap(
                children: _participants.map((participant) {
                  return Padding(
                    padding: EdgeInsets.all(4),
                    child: Chip(
                      label: Text(participant),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addParticipant,
                child: Text('참여자 추가'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: _onSave,
              child: Text('추가'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
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
      id: '',
    );

    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentReference documentReference = await firestoreInstance.collection('plans').add(updatedPlan.toJson());
      String planId = documentReference.id; // Firestore에서 생성된 id를 가져옴
      updatedPlan = updatedPlan.copyWith(id: planId); // Plan 객체에 가져온 id를 설정
      setState(() {
        _plans.add(updatedPlan);
        _startDate = null;
        _endDate = null;
        _participants = [];
        _descriptionController.clear();
      });
      // 데이터 추가가 성공적으로 이루어졌으므로 다이얼로그를 닫습니다.
      Navigator.of(context).pop();
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
        title: Text('팀 계획 목록'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 16),
          Expanded(
            child: _buildPlanList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlan,
        tooltip: '새로운 계획 추가',
        child: Icon(Icons.add),
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
            '${DateFormat('yyyy-MM-dd').format(plan.startDate!)} ~ ${DateFormat('yyyy-MM-dd').format(plan.endDate!)}',
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
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
          title: Text('계획 삭제'),
          content: Text('이 계획을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _deleteSelectedPlan(index);
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSelectedPlan(int index) async {
    final plan = _plans[index];

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

  void _navigateToPlanDetails(Plan plan, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanDetailsScreen(plan: plan.toJson(), index: index),
      ),
    );

    if (result != null && result['delete'] == true) {
      setState(() {
        _plans.removeAt(result['index']);
      });
    }
  }

  Widget _buildDateSelector(String label, DateTime? date, bool isStartDate) {
    return Row(
      children: <Widget>[
        Text(label),
        SizedBox(width: 16),
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
