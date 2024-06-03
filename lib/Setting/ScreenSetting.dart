import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode(); // 이전 설정 불러오기
  }

  _loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  _saveDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('다크 모드 설정'),
      ),
      body: Center(
        child: Switch(
          value: isDarkMode,
          onChanged: (value) {
            setState(() {
              isDarkMode = value;
              _saveDarkMode(value); // 사용자 설정 저장
              // MaterialApp의 theme 속성을 통해 앱의 전체적인 테마 변경
              MaterialApp(
                theme: value ? ThemeData.dark() : ThemeData.light(),
                home: Scaffold(
                  appBar: AppBar(
                    title: Text('메인 화면'),
                  ),
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('뒤로 가기'),
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
