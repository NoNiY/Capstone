import 'package:flutter/material.dart';
import 'package:untitled1/blank_screen.dart';
import 'package:untitled1/main/main_screen.dart';
import 'package:untitled1/Plan/plan_list_screen.dart';
import 'package:untitled1/Plan/plan_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled1/Plan/_plan.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/user_info.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime? focusedDay;
  final DateTime? selectedDay;
  final List<Plan> plans;

  const CalendarScreen(
      {super.key, this.focusedDay, this.selectedDay, required this.plans});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Plan> _plans = [];
  Plan? _selectedPlan;
  Timer? _debounce;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay ?? DateTime.now();
    _selectedDay = widget.selectedDay;
    _plans = widget.plans;
    _retrievePlans();
  }

  @override
  void dispose() {
    _persistPlans();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _showPlanScreen(Plan? plan, {DateTime? initialDate}) {
    showDialog(
      context: context,
      builder: (context) {
        return PlanScreen(
          plan: plan,
          onPlanUpdated: (updatedPlan) {
            setState(() {
              if (plan != null) {
                _plans.removeWhere((p) => p.id == updatedPlan.id);
              }
              _plans.add(updatedPlan);
            });
            _persistPlansDebounced();
          },
          initialDate: initialDate ?? DateTime.now(),
        );
      },
    );
  }

Future<void> _deletePlan() async {
  if (_selectedPlan != null) {
    String planId = _selectedPlan!.id;
    setState(() {
      _plans.removeWhere((plan) => plan.id == planId);
      _selectedPlan = null;
    });

    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';

    try {
      await FirebaseFirestore.instance
          .collection(userEmail)
          .doc(planId)
          .delete();
    } catch (error) {
      debugPrint('Error deleting plan: $error');
      // 에러 처리를 추가할 수 있습니다.
    }
  }
}

  void _persistPlansDebounced() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      _persistPlans();
    });
  }

  Future<void> _persistPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonPlans = _plans.map((plan) => jsonEncode(plan.toJson())).toList();
    await prefs.setStringList('plans', jsonPlans);
  }

  Future<void> _retrievePlans() async {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection(userEmail).get();

      final plans = querySnapshot.docs.map((doc) => Plan.fromJson(doc.data())).toList();

      setState(() {
        _plans = plans;
      });
    } catch (error) {
      debugPrint('Error retrieving plans: $error');
      // 에러 처리를 추가할 수 있습니다.
    }
  }


  List<Plan> _getPlansForDate(DateTime date) {
    return _plans
        .where((plan) =>
            date.isAfter(plan.startDate.subtract(const Duration(days: 1))) &&
            date.isBefore(plan.endDate.add(const Duration(days: 1))))
        .toList();
  }

  String _getDayOfWeek(DateTime date) {
    const List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    return weekdays[date.weekday - 1];
  }

  Color _getPlanColor(String planType) {
    switch (planType) {
      case 'Type 1':
        return Colors.red;
      case 'Type 2':
        return Colors.blue;
      case 'Type 3':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTableCalendar(),
          if (_selectedDay != null) _buildEventList(),
          const SizedBox(height: 16),
          _buildActionButtons(),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: _buildBottomAppBar(),
      appBar: _buildAppBar(),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: _onDaySelected,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: true,
        titleTextStyle: const TextStyle(fontSize: 20),
        titleTextFormatter: (date, locale) {
          final formattedDate = DateFormat.yMMMM(locale).format(date);
          return '$formattedDate\n';
        },
        leftChevronIcon: const Icon(Icons.chevron_left),
        rightChevronIcon: const Icon(Icons.chevron_right),
        headerMargin: const EdgeInsets.only(bottom: 8),
        headerPadding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, date) {
          final formattedDate = DateFormat.yMMMM().format(date);
          return GestureDetector(
            onTap: _showMonthPicker,
            child: Text(
              formattedDate,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        markerBuilder: (context, date, events) {
          final plansOnDate = _getPlansForDate(date)
              .where((plan) =>
                  plan.startDate.isAtSameMomentAs(plan.endDate) &&
                  date.isAtSameMomentAs(plan.startDate))
              .toList();

          if (plansOnDate.isEmpty) return null;

          return Positioned(
            bottom: 2,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: plansOnDate.map((plan) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  height: 4.0,
                  width: 4.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getPlanColor(plan.type),
                  ),
                );
              }).toList(),
            ),
          );
        },
        defaultBuilder: (context, date, events) {
          final plansOnDate = _getPlansForDate(date)
              .where((plan) => !plan.startDate.isAtSameMomentAs(plan.endDate))
              .toList();

          if (plansOnDate.isNotEmpty) {
            final shortestPlan = plansOnDate.reduce((a, b) =>
                a.endDate.difference(a.startDate) <
                        b.endDate.difference(b.startDate)
                    ? a
                    : b);

            final backgroundColor = _getPlanColor(shortestPlan.type);

            return Container(
              margin: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          return null;
        },
        selectedBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
        dowBuilder: (context, day) {
          return Center(
            child: Text(
              _getDayOfWeek(day),
              style: const TextStyle(color: Colors.black),
            ),
          );
        },
      ),
      availableGestures: AvailableGestures.horizontalSwipe,
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
    );
  }

  Widget _buildEventList() {
    final plansOnSelectedDay = _getPlansForDate(_selectedDay!);
    return Expanded(
      child: ListView.builder(
        itemCount: plansOnSelectedDay.length,
        itemBuilder: (context, index) {
          final plan = plansOnSelectedDay[index];
          final isLongTermPlan = plan.startDate != plan.endDate;
          return GestureDetector(
            onDoubleTap: () {
              setState(() {
                _focusedDay = plan.startDate;
                _selectedDay = plan.startDate;
              });
            },
            onLongPress: () {
              _showPlanScreen(plan, initialDate: plan.startDate);
            },
            onTap: () {
              setState(() {
                _selectedPlan = _selectedPlan == plan ? null : plan;
              });
            },
            child: Container(
              color: _selectedPlan == plan ? Colors.grey[300] : null,
              child: ListTile(
                title: Text(plan.name),
                subtitle: Text(
                  isLongTermPlan
                      ? '${plan.startDate.toIso8601String().split('T').first} - ${plan.endDate.toIso8601String().split('T').first}\n${plan.details.split('\n').first}'
                      : '${plan.startDate.toIso8601String().split('T').first}/${plan.startTime.format(context)}\n${plan.details.split('\n').first}',
                ),
                trailing: _selectedPlan == plan
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showPlanScreen(plan,
                                  initialDate: plan.startDate);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: const Text(
                                        'Are you sure you want to delete this plan?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('No'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Yes'),
                                        onPressed: () {
                                          _deletePlan();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            _showPlanScreen(null, initialDate: _selectedDay ?? _focusedDay);
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Plan'),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlanListScreen(
                  plans: _plans,
                  initialDate: _selectedDay ?? _focusedDay,
                ),
              ),
            );
            if (result != null) {
                setState(() {
                  _plans = List<Plan>.from(result);
                });
                _persistPlans();
              }
          },
          icon: const Icon(Icons.list),
          label: const Text('Plan List'),
        ),
      ],
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlankScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlankScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.face),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlankScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlankScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.people),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BlankScreen()),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BlankScreen()),
            );
          },
        ),
      ],
    );
  }

  void _showMonthPicker() {
    final currentYear = DateTime.now().year;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedYear = currentYear;
        int? selectedMonth;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Month and Year'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() {
                            selectedYear--;
                          });
                        },
                      ),
                      Text(
                        selectedYear.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setState(() {
                            selectedYear++;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(12, (index) {
                        final month = index + 1;
                        final monthName = DateFormat('MMM')
                            .format(DateTime(selectedYear, month));
                        final isSelected = selectedMonth == month;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedMonth = month;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                monthName,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    if (selectedMonth != null) {
                      final selectedMonthDateTime =
                          DateTime(selectedYear, selectedMonth!);
                      setState(() {
                        _focusedDay = selectedMonthDateTime;
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {
        // Update the _focusedDay when the dialog is dismissed
        _focusedDay = _focusedDay;
      });
    });
  }

  Widget? _buildFloatingActionButton() {
    if (_selectedDay != null) {
      return FloatingActionButton(
        onPressed: () {
          _showPlanScreen(null, initialDate: _selectedDay!);
        },
        child: const Icon(Icons.add),
      );
    }
    return null;
  }
}