import 'package:flutter/material.dart';
import 'package:untitled1/Plan/calendar_screen.dart';
import 'package:untitled1/Setting/setting_home.dart';
import 'package:untitled1/chat/team_plan_screen.dart';
import 'package:untitled1/main/log_out.dart';
import 'package:untitled1/main/main_screen.dart';
import 'package:untitled1/shop_screen.dart';
import 'package:untitled1/character/main_character.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;

  final List<Widget> _pages = const [
    CalendarScreen(plans: []),
    TeamPlanScreen(),
    MainScreen(),
    MainCharacterScreen(),
    SettingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(
            Icons.person_add_alt,
            size: 40,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 40,
            ),
            onPressed: () {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description,
              size: 40,
            ),
            label: '계획',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group,
              size: 40,
            ),
            label: '팀계획',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 40,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 40,
            ),
            label: '마이룸',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 40,
            ),
            label: '설정',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 197, 142, 233),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
