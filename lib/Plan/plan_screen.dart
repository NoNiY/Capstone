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
  final point = 0;

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

  void _onSave() async {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';
    String planId =
        widget.plan?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    Plan updatedPlan = Plan(
      id: planId,
      name: _planNameController.text,
      startDate: _startDate,
      endDate: _endDate,
      startTime: _startTime,
      endTime: _endTime,
      type: _planType,
      details: _planDetailsController.text,
    );
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      if (widget.plan != null) {
        await firestoreInstance
            .collection(userEmail)
            .doc(planId)
            .update(updatedPlan.toJson());
      } else {
        await firestoreInstance
            .collection(userEmail)
            .doc(planId)
            .set(updatedPlan.toJson());
      }
      widget.onPlanUpdated(updatedPlan);
    } catch (e) {
      debugPrint('Firestore에 데이터 추가 중 오류 발생: $e');
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
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
            _buildTextField(_planNameController, 'Plan Name'),
            const SizedBox(height: 16.0),
            _buildTextField(_planDetailsController, 'Plan Details',
                maxLines: 3),
            const SizedBox(height: 16.0),
            _buildDatePicker('Start Date', _startDate, true),
            _buildDatePicker('End Date', _endDate, false),
            _buildTimePicker('Start Time', _startTime, true),
            _buildTimePicker('End Time', _endTime, false),
            _buildDropdownButton(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSave,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      maxLines: maxLines,
    );
  }

  Widget _buildDatePicker(String title, DateTime date, bool isStartDate) {
    return ListTile(
      title: Text(title),
      subtitle: Text('${date.year}/${date.month}/${date.day}'),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: isStartDate ? DateTime(2023) : _startDate,
          lastDate: DateTime(2030),
        );
        if (picked != null && picked != date) {
          setState(() {
            if (isStartDate) {
              _startDate = picked;
              if (_startDate.isAfter(_endDate)) {
                _endDate = _startDate;
              }
            } else {
              _endDate = picked;
            }
          });
        }
      },
    );
  }

  Widget _buildTimePicker(String title, TimeOfDay time, bool isStartTime) {
    return ListTile(
      title: Text(title),
      subtitle: Text(time.format(context)),
      onTap: () => _showCupertinoTimePicker(context, isStartTime),
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButtonFormField<String>(
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
    );
  }
}
