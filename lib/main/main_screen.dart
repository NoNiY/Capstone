import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/shop_screen.dart';
import 'package:untitled1/Plan/calendar_screen.dart';
import 'package:untitled1/Plan/_plan.dart';
import 'package:untitled1/main/log_out.dart';
import 'package:untitled1/chat/chat_room.dart';
import 'package:untitled1/character/main_character.dart';
import '../character/store_image.dart';

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
    _currentCharacterImage = widget.characterImage ?? StoreImage.characterImage;
    _currentBackgroundImage = widget.backgroundImage ?? StoreImage.backgroundImage;
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
                        style: TextStyle(fontSize: 40, color: Colors.black),
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
      ),
    );
  }
}
