import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/main/login_screen.dart';
import 'package:untitled1/Setting/setting_home.dart';

class LoginSetting extends StatelessWidget {
  const LoginSetting({super.key});

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if(context.mounted){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
      );
    }
  }

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('로그인 설정'),

    ),
    body: ListView(
        children: <Widget>[
        ListTile(
          title: Text('로그아웃'),
          onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()),
          );
        },
  ),
/*
        ListTile(
          title: Text('비밀번호 번경'),
          onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginSignupScreen()),
        );
      },
        ),
        ListTile(
          title: Text('아이디 삭제'),
          onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginSignupScreen()),
          );
        },
        ),
*/
  ],
    ),
  );
}
}