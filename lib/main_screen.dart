import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './planner.dart';
import './character/main_character.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, this.characterImage, this.backgroundImage}) : super(key: key);

  final String? characterImage;
  final String? backgroundImage;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 이미지 상태를 유지하기 위한 변수 선언
  late String _currentCharacterImage;
  late String _currentBackgroundImage;

  @override
  void initState() {
    super.initState();
    // widget에서 전달된 이미지 받기
    _currentCharacterImage = widget.characterImage ?? 'assets/character/character1.png';
    _currentBackgroundImage = widget.backgroundImage ?? 'assets/background/background1.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 4,
          backgroundColor: Colors.blueGrey,
          leading: IconButton(
            icon: Icon(
                Icons.person_add_alt,
                size: 40),
            onPressed: () {
              // 왼쪽 아이콘을 눌렀을 때의 동작
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                  Icons.shopping_cart,
                  size: 40),
              onPressed: () {
                // 오른쪽 아이콘을 눌렀을 때의 동작
              },
            ),
          ],
        ),
        body: Expanded(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 390,
                  height: 590,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_currentBackgroundImage),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Image.asset(_currentCharacterImage),
                      ),
                      Text(
                        '10',
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: 0.6,
                                  backgroundColor: Colors.grey[500],
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                    Icons.description,
                    size: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlannerScreen();
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                    Icons.group,
                    size: 40),
                onPressed: () {
                  // 아이콘 버튼을 눌렀을 때의 동작
                },
              ),
              IconButton(
                icon: Icon(
                    Icons.home,
                    size: 40),
                onPressed: () {
                  // 아이콘 버튼을 눌렀을 때의 동작
                },
              ),
              IconButton(
                icon: Icon(
                    Icons.person_outline,
                    size: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        // main_screen에서 main_character로 이동할 때 이미지 전달
                        return MainCharacterScreen(
                          characterImage: _currentCharacterImage,
                          backgroundImage: _currentBackgroundImage,
                        );
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                    Icons.settings,
                    size: 40),
                onPressed: () {
                  // 아이콘 버튼을 눌렀을 때의 동작
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
