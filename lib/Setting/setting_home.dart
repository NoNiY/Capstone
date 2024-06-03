import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Setting/LoginSetting.dart';
import 'package:untitled1/Setting/ScreenSetting.dart';
import 'package:untitled1/Setting/feedback_screen.dart';
import 'package:untitled1/main/login_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('로그인 설정'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginSetting()),
              );
            },
          ),
          ListTile(
            title: Text('화면설정'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            title: Text('문의하기'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

