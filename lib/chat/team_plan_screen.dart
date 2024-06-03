import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled1/chat/team_plan_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/user_info.dart';
import 'package:untitled1/chat/_teamplan.dart';
import 'package:untitled1/Plan/calendar_screen.dart';

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
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<String> _participants = [];
  final TextEditingController _descriptionController = TextEditingController();
  List<Plan> _plans = [];
  String? _planId;

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
      QuerySnapshot participantsQuerySnapshot = await firestoreInstance
          .collection('plans')
          .where('participants', arrayContains: userEmail)
          .get();
      List<Plan> fetchedPlans = querySnapshot.docs.map((doc) {
        final planData = doc.data() as Map<String, dynamic>;
        planData['id'] = doc.id; // 문서의 ID를 'id' 필드에 할당
        return Plan.fromJson(planData);
      }).toList();
      List<Plan> fetchedPlans1 = participantsQuerySnapshot.docs.map((doc) {
        final planData = doc.data() as Map<String, dynamic>;
        planData['id'] = doc.id; // 문서의 ID를 'id' 필드에 할당
        return Plan.fromJson(planData);
      }).toList();
      fetchedPlans.addAll(fetchedPlans1);
      setState(() {
        _plans = fetchedPlans;
      });
    } catch (e) {
      debugPrint('Firestore에서 데이터 가져오기 중 오류 발생: $e');
      // 예외 처리 코드 추가
    }
  }

  Future<DateTime?> _selectDate(BuildContext context, bool isStartDate) async {
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
          _endDate = pickedDate; // 시작일을 선택하면 종료일도 같은 날로 설정
        } else {
          _endDate = pickedDate;
          _startDate = pickedDate; // 종료일을 선택하면 시작일도 같은 날로 설정
        }
      });
    }

    return pickedDate;
  }

  Future<TimeOfDay?> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
          _endTime = pickedTime.replacing(hour: pickedTime.hour + 1); // 시작 시간을 선택하면 종료 시간은 1시간 뒤로 설정
        } else {
          _endTime = pickedTime;
          _startTime = pickedTime.replacing(hour: pickedTime.hour - 1); // 종료 시간을 선택하면 시작 시간은 1시간 앞으로 설정
        }
      });
    }

    return pickedTime;
  }

  void _addParticipant(StateSetter setState) {
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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('새로운 계획 추가'),
              content: SingleChildScrollView( // SingleChildScrollView 추가
                physics: AlwaysScrollableScrollPhysics(), // 스크롤 항상 활성화
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildDateSelector('시작일', _startDate, true, setState),
                    _buildTimeSelector('시작 시간', _startTime, true, setState),
                    _buildDateSelector('종료일', _endDate, false, setState),
                    _buildTimeSelector('종료 시간', _endTime, false, setState),
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
                      onPressed: () => _addParticipant(setState),
                      child: const Text('참여자 추가'),
                    ),
                  ],
                ),
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
      },
    );
  }

  void _onSave() async {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';

    // Null 체크 및 기본값 설정
    DateTime startDate = _startDate ?? DateTime.now();
    TimeOfDay startTime = _startTime ?? TimeOfDay.now();
    DateTime endDate = _endDate ?? DateTime.now();
    TimeOfDay endTime = _endTime ?? TimeOfDay.now();

    DateTime startDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );

    DateTime endDateTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endTime.hour,
      endTime.minute,
    );

    Plan updatedPlan = Plan(
      userId: userEmail,
      name: _descriptionController.text,
      startDate: startDateTime,
      endDate: endDateTime,
      participants: _participants,
    );

    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentReference documentReference =
          await firestoreInstance.collection('plans').add(updatedPlan.toJson());
      _planId = documentReference.id; // Firestore에서 생성된 id를 가져옴
      updatedPlan = updatedPlan.copyWith(id: _planId); // Plan 객체에 가져온 id를 설정
      await firestoreInstance
          .collection('plans')
          .doc(_planId)
          .collection('chat_room')
          .doc('welcome')
          .set(updatedPlan.toJson());
      setState(() {
        _plans.add(updatedPlan);
        _startDate = null; // 추가 후 초기화
        _startTime = null; // 추가 후 초기화
        _endDate = null; // 추가 후 초기화
        _endTime = null; // 추가 후 초기화
        _planId = null; // 추가 후 초기화
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
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
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
          title: Text(plan.name),
          subtitle: Text(
            '${DateFormat('yyyy-MM-dd HH:mm').format(plan.startDate)} ~ ${DateFormat('yyyy-MM-dd HH:mm').format(plan.endDate)}',
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

  void _navigateToPlanDetails(Plan plan, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanDetailsScreen(plan: plan, index: index),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, bool isStartDate, StateSetter setState) {
    return Row(
      children: <Widget>[
        Text(label),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () async {
            final pickedDate = await _selectDate(context, isStartDate);
            if (pickedDate != null) {
              setState(() {
                if (isStartDate) {
                  _startDate = pickedDate;
                  _endDate = pickedDate; // 시작일을 선택하면 종료일도 같은 날로 설정
                } else {
                  _endDate = pickedDate;
                  _startDate = pickedDate; // 종료일을 선택하면 시작일도 같은 날로 설정
                }
              });
            }
          },
          child: Text(
            date == null ? '날짜 선택' : DateFormat('yyyy-MM-dd').format(date),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(String label, TimeOfDay? time, bool isStartTime, StateSetter setState) {
    return Row(
      children: <Widget>[
        Text(label),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () async {
            final pickedTime = await _selectTime(context, isStartTime);
            if (pickedTime != null) {
              setState(() {
                if (isStartTime) {
                  _startTime = pickedTime;
                  _endTime = pickedTime.replacing(hour: pickedTime.hour + 1); // 시작 시간을 선택하면 종료 시간은 1시간 뒤로 설정
                } else {
                  _endTime = pickedTime;
                  _startTime = pickedTime.replacing(hour: pickedTime.hour - 1); // 종료 시간을 선택하면 시작 시간은 1시간 앞으로 설정
                }
              });
            }
          },
          child: Text(
            time == null ? '시간 선택' : time.format(context),
          ),
        ),
      ],
    );
  }
}
