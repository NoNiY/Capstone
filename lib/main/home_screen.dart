import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Plan/calendar_screen.dart';
import 'package:untitled1/character/main_character.dart';
import 'package:untitled1/chat/TeamPlan_Screen.dart';
import 'package:untitled1/main/log_out.dart';
import 'package:untitled1/main/main_screen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;

  final List<Widget> _pages = [CalendarScreen(plans: [],),TeamPlanScreen(), MainScreen(), MainCharacterScreen(), LogoutScreen()];
  //아래 위젯 화면 종류
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.person_add_alt, size: 40),
          onPressed: () {

            // 왼쪽 아이콘을 눌렀을 때의 동작
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart, size: 40),
            onPressed: () {
              // 오른쪽 아이콘을 눌렀을 때의 동작
            },
          ),
        ],
      ),
      // 하단바
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.description,
              size: 40,),
            label: '계획',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, size: 40),
            label: '팀계획',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 40),
            label: '마이룸',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 40),
            label: '설정',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Color.fromARGB(255, 197, 142, 233),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );

  }
}