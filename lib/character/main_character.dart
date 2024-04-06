import 'package:flutter/material.dart';
import 'package:untitled1/character/character_change.dart';
import 'package:untitled1/character/background_change.dart';
import 'package:untitled1/main/home_screen.dart';
import 'package:untitled1/main/main_screen.dart';

class MainCharacterScreen extends StatelessWidget {
  final String? characterImage;
  final String? backgroundImage;

  const MainCharacterScreen({super.key, this.characterImage, this.backgroundImage});

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
          onPressed: () {
            // 왼쪽 아이콘을 눌렀을 때의 동작
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
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
            backgroundImage ?? 'assets/background/background1.jpg',
            fit: BoxFit.fill,
          ),
          Positioned(
            left: -65,
            bottom: 250,
            child: Image.asset(
              characterImage ?? 'assets/character/character1.png',
              height: 350,
              width: 350,
            ),
          ),
          const Positioned(
            left: 55,
            bottom: 270,
            child: CharacterStatus(),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: OtherCharacterStatus(
              characterImage: characterImage,
              backgroundImage: backgroundImage,
            ),
          ),
        ],
      ),
    );
  }
}

class CharacterStatus extends StatelessWidget {
  const CharacterStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class OtherCharacterStatus extends StatelessWidget {
  final String? characterImage;
  final String? backgroundImage;

  const OtherCharacterStatus({super.key, this.characterImage, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeCharacterScreen(),
              ),
            ).then((value) {
              if (value != null) {
                Navigator.pop(context, {
                  'characterImage': value['characterImage'],
                  'backgroundImage': backgroundImage
                });
              }
            });
          },
          child: const Text(
            '캐릭터 변경',
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 130,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeBackgroundScreen(),
              ),
            ).then((value) {
              if (value != null) {
                Navigator.pop(context, {
                  'characterImage': characterImage,
                  'backgroundImage': value['backgroundImage']
                });
              }
            });
          },
          child: const Text(
            '테마 변경',
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 130,
        ),
        const Text(
          '악세사리 변경',
          style: TextStyle(
            fontFamily: "Pretendard",
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 140,
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 50,
            color: Colors.greenAccent,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(
                  characterImage: characterImage,
                  backgroundImage: backgroundImage,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}