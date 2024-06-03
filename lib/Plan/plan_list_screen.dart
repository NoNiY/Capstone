import 'package:flutter/material.dart';
import 'package:untitled1/Plan/_plan.dart';
import 'package:untitled1/Plan/calendar_screen.dart';
import 'package:untitled1/Plan/plan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final String _searchQuery = '';
  List<Plan> _filteredPlans = [];

  @override
  void initState() {
    super.initState();
    _plans = List<Plan>.from(widget.plans);
    _filteredPlans = List<Plan>.from(_plans);
    _retrievePlansFromFirestore();
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

  Future<void> updateUserStats(String userId, int pointsToAdd, int expToAdd) async {
  try {
    // Firestore의 users 컬렉션 참조
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    // Firestore 트랜잭션을 사용하여 points와 exp 동시에 업데이트
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDoc);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      int currentPoints = snapshot['points'] ?? 0;
      int currentExp = snapshot['exp'] ?? 0;

      transaction.update(userDoc, {
        'points': currentPoints + pointsToAdd,
        'exp': currentExp + expToAdd,
      });
    });

    print("User stats updated successfully!");
  } catch (e) {
    print("Failed to update user stats: $e");
  }
}

Future<String?> getUserIdByEmail(String email) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  } catch (e) {
    print("Failed to get user ID by email: $e");
    return null;
  }
}


  Future<void> _retrievePlansFromFirestore() async {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';

    final querySnapshot =
        await FirebaseFirestore.instance.collection(userEmail).get();

    setState(() {
      _plans =
          querySnapshot.docs.map((doc) => Plan.fromJson(doc.data())).toList();
      _filteredPlans = List<Plan>.from(_plans);
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
          },
          initialDate: plan?.startDate ?? widget.initialDate ?? DateTime.now(),
        ),
      ),
    );
    if (result != null) {
      await _retrievePlansFromFirestore();
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
      await _retrievePlansFromFirestore();
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

  Future<void> _filterPlans(String query) async {
    final filteredPlans = await _searchPlansOnFirestore(query);
    setState(() {
      _filteredPlans = filteredPlans;
    });
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
            child: _filteredPlans.isNotEmpty
                ? _buildPlanList(_filteredPlans)
                : _buildNoPlansFound(),
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
        onChanged: (value) async {
          await _filterPlans(value);
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
            color: _selectedPlan == plan ? Colors.grey[300] : null,
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
              await _retrievePlansFromFirestore();

              // 이메일을 통해 사용자 고유 ID를 가져와 포인트와 경험치 업데이트
              String? userId = await getUserIdByEmail(userEmail);
              if (userId != null) {
                await updateUserStats(userId, 500, 100);
              } else {
                print("User ID not found for email: $userEmail");
              }

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
                await _retrievePlansFromFirestore();
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
      _selectedPlan = _selectedPlan == plan ? null : plan;
    });
  }
}
