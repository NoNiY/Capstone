import 'package:flutter/material.dart';
import 'package:untitled1/character/character_change.dart';
import 'package:untitled1/character/background_change.dart';

class MainCharacterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: Icon(
            Icons.person_add_alt,
            size: 40,
          ),
          onPressed: () {
            // 왼쪽 아이콘을 눌렀을 때의 동작
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              size: 40,
            ),
            onPressed: () {
              // 오른쪽 아이콘을 눌렀을 때의 동작
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background/background1.jpg',
            fit: BoxFit.fill,
          ),
          Positioned(
            left: -65,
            bottom: 250,
            child: Image.asset(
              'assets/character/character1.png',
              height: 350,
              width: 350,
            ),
          ),
          Positioned(
            left: 55,
            bottom: 270,
            child: CharacterStatus(),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: OtherCharacterStatus(),
          ),
        ],
      ),
    );
  }
}

class CharacterStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class OtherCharacterStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeCharacterScreen(), // 변경할 화면으로 이동
              ),
            );
          },
          child: Text(
            '캐릭터 변경',
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 130,
        ),
        GestureDetector(
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeBackgroundScreen(), // 변경할 화면으로 이동
              ),
            );
          },
          child: Text(
            '테마 변경',
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 130,
        ),
        Text(
          '악세사리 변경',
          style: TextStyle(
            fontFamily: "Pretendard",
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 140,
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 50,
            color: Colors.greenAccent,
          ), onPressed: () {
          Navigator.pop(context); // main.screen으로 이동
        },
        ),
      ],
    );
  }
}
