import 'package:flutter/material.dart';
import 'package:untitled1/main/home_screen.dart';
import 'store_image.dart';
import 'background_change.dart';
import 'character_change.dart';

class MainCharacterScreen extends StatelessWidget {
  const MainCharacterScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            StoreImage.backgroundImage,
            fit: BoxFit.fill,
          ),
          Positioned(
            left: -65,
            bottom: 200,
            child: Image.asset(
              StoreImage.characterImage,
              height: 350,
              width: 350,
            ),
          ),
          const Positioned(
            left: 55,
            bottom: 200,
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
  const CharacterStatus({Key? key});

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
  const OtherCharacterStatus({Key? key});

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
            );
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
          height: 100,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeBackgroundScreen(),
              ),
            );
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
          height: 100,
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
          height: 100,
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
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
