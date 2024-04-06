import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/shop_screen.dart';
import 'package:untitled1/Plan/calendar_screen.dart';
import 'package:untitled1/Plan/_plan.dart';
import 'package:untitled1/main/log_out.dart';
import 'package:untitled1/chat/chat_room.dart';
import 'package:untitled1/character/main_character.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.characterImage, this.backgroundImage});

  final String? characterImage;
  final String? backgroundImage;


  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  late String _currentCharacterImage;
  late String _currentBackgroundImage;
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _currentCharacterImage = widget.characterImage ?? 'assets/character/character1.png';
    _currentBackgroundImage = widget.backgroundImage ?? 'assets/background/background1.jpg';
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        debugPrint(loggedUser!.email);
      }
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  Future<List<Plan>> getPlansFromFirestore() async {
    final userEmail = loggedUser?.email;
    if (userEmail != null) {
      final querySnapshot =
          await FirebaseFirestore.instance.collection(userEmail).get();
      return querySnapshot.docs.map((doc) => Plan.fromJson(doc.data())).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        /*appBar: AppBar(
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
                if (context.mounted){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShopScreen()
                    )
                  );
                }
              },
            ),
          ],
        ),
        */
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
                      fit: BoxFit.fill, // 이미지가 부모 컨테이너에 꽉 차도록 설정
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Image.asset(_currentCharacterImage),
                      ),
                      const Text(
                        '10',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: 0.6, // 경험치의 비율을 나타내는 값 (0 ~ 1)
                                  backgroundColor: Colors.grey[500],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
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
              /*
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.description,
                  size: 40,
                ),
                onPressed: () async {
                  final plans = await getPlansFromFirestore();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarScreen(plans: plans),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.group, size: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                  // 아이콘 버튼을 눌렀을 때의 동작
                },
              ),
              IconButton(
                icon: const Icon(Icons.home, size: 40),
                onPressed: () {
                  // 아이콘 버튼을 눌렀을 때의 동작
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, size: 40),
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
                  // 아이콘 버튼을 눌렀을 때의 동작
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, size: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogoutScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
    */
      ),
    );
  }
}