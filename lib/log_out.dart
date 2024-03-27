import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/login_screen.dart';
class logout extends StatefulWidget {
  const logout({super.key});
  @override
  @override
  State<logout> createState() => _logout();
}
class _logout extends State<logout> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginSignupScreen(),
              ),
            );// 로그아웃 함수 호출
            // 다른 로직 처리
          },
          child: Text('Log Out'),
        ),
      ),
    );
  }
}
