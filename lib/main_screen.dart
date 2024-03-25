import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled1/planner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    }catch(e){
      print(e);
    }
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
                  // 바탕화면 사진과 캐릭터 디자인
                  Container(
                    width: 390,
                    height: 590,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/123.jpg'),
                        fit: BoxFit.fill, // 이미지가 부모 컨테이너에 꽉 차도록 설정
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: Image.asset('assets/images/111.png'),
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
                                    value: 0.6, // 경험치의 비율을 나타내는 값 (0 ~ 1)
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
        // 하단바
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
                  // 아이콘 버튼을 눌렀을 때의 동작
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
                  // 아이콘 버튼을 눌렀을 때의 동작
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

class Textstyle {
}
