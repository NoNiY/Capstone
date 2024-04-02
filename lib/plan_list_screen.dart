import 'package:flutter/material.dart';
import 'package:untitled1/calendar_screen.dart';
import 'package:untitled1/plan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '_plan.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/user_info.dart';

class PlanListScreen extends StatefulWidget {
  final List<Plan> plans;
  final DateTime? initialDate;

  const PlanListScreen({
    super.key,
    required this.plans,
    this.initialDate,
  });

  @override
  State<PlanListScreen> createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen> {
  late List<Plan> _plans;
  Plan? _selectedPlan;
  String _searchQuery = '';
  String? _selectedPlanId;

  @override
  void initState() {
    super.initState();
    _plans = List<Plan>.from(widget.plans);
    _retrievePlans();
  }

  Future<void> _persistPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonPlans =
        widget.plans.map((plan) => jsonEncode(plan.toJson())).toList();
    await prefs.setStringList('plans', jsonPlans);
  }

  Future<void> _retrievePlans() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonPlans = prefs.getStringList('plans') ?? [];

    final plans = jsonPlans
        .map((jsonPlan) => Plan.fromJson(jsonDecode(jsonPlan)))
        .toList();

    setState(() {
      widget.plans.clear();
      widget.plans.addAll(plans);
    });
  }

  void _showPlanScreen(BuildContext context, Plan? plan) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanScreen(
          plan: plan,
          onPlanUpdated: (updatedPlan) {
            setState(() {
              if (plan != null) {
                _plans.removeWhere((p) => p.id == updatedPlan.id);
              }
              _plans.add(updatedPlan);
            });
            _persistPlans();
          },
          initialDate: plan?.startDate ?? widget.initialDate ?? DateTime.now(),
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _plans = List<Plan>.from(result);
      });
    }
  }

  Future<void> deletePlanFromFirestore(String userEmail, String planId) async {
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

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Plan plan) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this plan?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() {
        _plans.removeWhere((p) => p.id == plan.id);
        _selectedPlan = null;
      });

      final userInfo = UserInfo();
      String userEmail = userInfo.userEmail ?? '';

      await deletePlanFromFirestore(userEmail, plan.id);
    }
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    if (_selectedPlan != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => _showPlanScreen(context, _selectedPlan),
            heroTag: null,
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () =>
                _showDeleteConfirmationDialog(context, _selectedPlan!),
            backgroundColor: Colors.red,
            heroTag: null,
            child: const Icon(Icons.delete),
          ),
        ],
      );
    } else {
      return FloatingActionButton(
        onPressed: () => _showPlanScreen(context, null),
        backgroundColor: Colors.green,
        heroTag: null,
        child: const Icon(Icons.add),
      );
    }
  }

  Future<List<Plan>> _searchPlansOnFirestore(String query) async {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';

    final querySnapshot = await FirebaseFirestore.instance
        .collection(userEmail)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '$query\uf8ff')
        .get();

    return querySnapshot.docs.map((doc) => Plan.fromJson(doc.data())).toList();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Plan List'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context, _plans),
      ),
    ),
    body: Column(
      children: [
        _buildSearchField(),
        Expanded(
          child: FutureBuilder<List<Plan>>(
            future: _searchPlansOnFirestore(_searchQuery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final filteredPlans = snapshot.data ?? [];
              return filteredPlans.isNotEmpty
                  ? _buildPlanList(filteredPlans)
                  : _buildNoPlansFound();
            },
          ),
        ),
      ],
    ),
    floatingActionButton: _buildFloatingActionButton(context),
  );
}

Widget _buildSearchField() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Search',
        prefixIcon: Icon(Icons.search),
      ),
    ),
  );
}

Widget _buildPlanList(List<Plan> plans) {
  return ListView.builder(
    itemCount: plans.length,
    itemBuilder: (context, index) {
      final plan = plans[index];
      final isLongTermPlan = plan.startDate != plan.endDate;
      return GestureDetector(
        onDoubleTap: () => _navigateToCalendarScreen(plan),
        onLongPress: () => _showPlanScreen(context, plan),
        onTap: () => _toggleSelectedPlan(plan),
        child: Container(
          color: _selectedPlanId == plan.id ? Colors.grey[300] : null,
          child: ListTile(
            title: Text(plan.name),
            subtitle: Text(
              isLongTermPlan
                  ? '${plan.startDate.toIso8601String().split('T').first} - ${plan.endDate.toIso8601String().split('T').first}\n${plan.details.split('\n').first}'
                  : '${plan.startDate.toIso8601String().split('T').first}/${plan.startTime.format(context)}\n${plan.details.split('\n').first}',
            ),
            trailing: plan.type == 'Type 2' || plan.type == 'Type 3'
                ? _buildPlanActions(context, plan)
                : null,
          ),
        ),
      );
    },
  );
}

Widget _buildNoPlansFound() {
  return Center(
    child: Text(
      'No plans found for "$_searchQuery"',
      style: const TextStyle(fontSize: 16),
    ),
  );
}

Future<void> _showCompletionDialog(BuildContext context, Plan plan) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You have successfully completed the plan.'),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _plans.removeWhere((p) => p.id == plan.id);
                _selectedPlan = null;
              });

              final userInfo = UserInfo();
              String userEmail = userInfo.userEmail ?? '';

              await deletePlanFromFirestore(userEmail, plan.id);

              _persistPlans();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<void> _showIncompleteDialog(BuildContext context, Plan plan) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Don\'t Give Up!'),
        content: const Text('Keep pushing forward. You can do it!'),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _plans.removeWhere((p) => p.id == plan.id);
                _selectedPlan = null;
              });

              final userInfo = UserInfo();
              String userEmail = userInfo.userEmail ?? '';

              await deletePlanFromFirestore(userEmail, plan.id);

              _persistPlans();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Widget _buildPlanActions(BuildContext context, Plan plan) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.check),
        onPressed: () => _showCompletionDialog(context, plan),
      ),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _showIncompleteDialog(context, plan),
      ),
    ],
  );
}

void _navigateToCalendarScreen(Plan plan) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => CalendarScreen(
        focusedDay: plan.startDate,
        selectedDay: plan.startDate,
        plans: _plans,
      ),
    ),
  );
}

void _toggleSelectedPlan(Plan plan) {
  setState(() {
    _selectedPlanId = _selectedPlanId == plan.id ? null : plan.id;
  });
}
}