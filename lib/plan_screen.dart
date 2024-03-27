import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '_plan.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/user_info.dart';

class PlanScreen extends StatefulWidget {
  final Plan? plan;
  final Function(Plan) onPlanUpdated;
  final DateTime initialDate;

  const PlanScreen({
    super.key,
    this.plan,
    required this.onPlanUpdated,
    required this.initialDate,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late TextEditingController _planNameController;
  late TextEditingController _planDetailsController;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _planType;

  @override
  void initState() {
    super.initState();
    if (widget.plan != null) {
      _planNameController = TextEditingController(text: widget.plan!.name);
      _planDetailsController =
          TextEditingController(text: widget.plan!.details);
      _startDate = widget.plan!.startDate;
      _endDate = widget.plan!.endDate;
      _startTime = widget.plan!.startTime;
      _endTime = widget.plan!.endTime;
      _planType = widget.plan!.type;
    } else {
      _planNameController = TextEditingController();
      _planDetailsController = TextEditingController();
      _startDate = widget.initialDate;
      _endDate = widget.initialDate;
      _startTime = TimeOfDay.now();
      _endTime =
          TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
      _planType = 'Type 1';
    }
  }
  @override
  void dispose() {
    _planNameController.dispose();
    _planDetailsController.dispose();
    super.dispose();
  }

  void _onSave() async{
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';
    Plan updatedPlan = Plan(
      id: userEmail,
      name: _planNameController.text,
      startDate: _startDate,
      endDate: _endDate,
      startTime: _startTime,
      endTime: _endTime,
      type: _planType,
      details: _planDetailsController.text,
    );
    try {
      // Firestore 인스턴스 가져오기
      final firestoreInstance = FirebaseFirestore.instance;
      // 'plans' 컬렉션에 데이터 추가
      await firestoreInstance.collection(updatedPlan.id).doc(updatedPlan.name).set(updatedPlan.toJson());

      // 데이터 추가 후, 다음 작업 수행
      widget.onPlanUpdated(updatedPlan);

    } catch (e) {
      // 오류 처리
      print('Firestore에 데이터 추가 중 오류 발생: $e');
      // 오류 메시지를 사용자에게 보여줄 수 있음
    }
    Navigator.of(context).pop();
  }

  void _showCupertinoTimePicker(BuildContext context, bool isStartTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      fontSize: 22, // 폰트 크기 조정
                      color: CupertinoColors.black, // 필요한 경우 폰트 색상 조정
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      isStartTime ? _startTime.hour : _endTime.hour,
                      isStartTime ? _startTime.minute : _endTime.minute),
                  onDateTimeChanged: (DateTime newDateTime) {
                    TimeOfDay selectedTime = TimeOfDay(
                        hour: newDateTime.hour, minute: newDateTime.minute);
                    if (isStartTime) {
                      setState(() {
                        _startTime = selectedTime;
                        // EndTime이 StartTime보다 빠를 경우, EndTime을 StartTime으로 조정
                        if (_endTime.hour < _startTime.hour ||
                            (_endTime.hour == _startTime.hour &&
                                _endTime.minute < _startTime.minute)) {
                          _endTime = _startTime;
                        }
                      });
                    } else {
                      setState(() {
                        // 선택한 EndTime이 StartTime보다 이른 경우에만 조정
                        if (selectedTime.hour > _startTime.hour ||
                            (selectedTime.hour == _startTime.hour &&
                                selectedTime.minute >= _startTime.minute)) {
                          _endTime = selectedTime;
                        } else {
                          // 선택한 EndTime이 StartTime보다 이르면, EndTime을 StartTime으로 설정
                          _endTime = _startTime;
                        }
                      });
                    }
                  },
                  use24hFormat: false,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan != null ? 'Correct Plan' : 'Add Plan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _planNameController,
              decoration: const InputDecoration(
                labelText: 'Plan Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _planDetailsController,
              decoration: const InputDecoration(
                labelText: 'Plan Details',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text(
                  '${_startDate.year}/${_startDate.month}/${_startDate.day}'),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                );
                if (picked != null && picked != _startDate) {
                  setState(() {
                    _startDate = picked;
                    if (_startDate.isAfter(_endDate)) {
                      _endDate = _startDate;
                    }
                  });
                }
              },
            ),
            ListTile(
              title: const Text('End Date'),
              subtitle:
                  Text('${_endDate.year}/${_endDate.month}/${_endDate.day}'),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: _startDate,
                  lastDate: DateTime(2030),
                );
                if (picked != null && picked != _endDate) {
                  setState(() {
                    _endDate = picked;
                  });
                }
              },
            ),
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(_startTime.format(context)),
              onTap: () => _showCupertinoTimePicker(
                  context, true), // Start Time 설정을 위해 수정
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text(_endTime.format(context)),
              onTap: () => _showCupertinoTimePicker(
                  context, false), // End Time 설정을 위해 수정
            ),
            DropdownButtonFormField<String>(
              value: _planType,
              onChanged: (String? newValue) {
                setState(() {
                  _planType = newValue!;
                });
              },
              items: <String>['Type 1', 'Type 2', 'Type 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Plan Type',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSave,
        child: const Icon(Icons.save),
      ),
    );
  }
}
