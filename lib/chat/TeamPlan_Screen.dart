import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/chat/TeamPlanDetail.dart';

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
  List<Map<String, dynamic>> _plans = [];
  final int index=0;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime
          .now()
          .year + 1),
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
                onPressed: () => _addParticipant(),
                child: Text('참여자 추가'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _plans.add({
                    'startDate': _startDate,
                    'endDate': _endDate,
                    'description': _descriptionController.text,
                    'participants': _participants.toList(),
                  });
                  _startDate = null;
                  _endDate = null;
                  _descriptionController.clear();
                  _participants.clear();
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


  Widget _buildDateSelector(String label, DateTime? date, bool isStartDate) {
    return Row(
      children: <Widget>[
        Text(label),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => _selectDate(context, isStartDate),
          child: Text(
              date == null ? '날짜 선택' : DateFormat('yyyy-MM-dd').format(date)),
        ),
      ],
    );
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
        onPressed: () => _addPlan(),
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
          title: Text(plan['description']),
          subtitle: Text(
              '${DateFormat('yyyy-MM-dd').format(
                  plan['startDate']!)} ~ ${DateFormat('yyyy-MM-dd').format(
                  plan['endDate']!)}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deletePlan(context,index); // 여기서 index를 전달
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
                _ddeletePlan(index); // 인덱스 전달
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

  void _ddeletePlan(int index) {
    setState(() {
      _plans.removeAt(index);
    });
  }

  void _navigateToPlanDetails(Map<String, dynamic> plan, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanDetailsScreen(plan: plan, index: index),
      ),
    );

    if (result != null && result['delete'] == true) {
      setState(() {
        _plans.removeAt(result['index']);
      });
    }
  }
}
