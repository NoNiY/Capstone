import 'package:flutter/material.dart';
import 'main_character.dart'; // MainCharacterScreen으로 이동할 수 있도록 import 추가

class ChangeCharacterScreen extends StatelessWidget {
  const ChangeCharacterScreen({super.key});

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
            'assets/background/background1.jpg',
            fit: BoxFit.fill,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                '캐릭터 변경',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Expanded(
            child: AllCharacterStatus(),
          ),
          const GoToMainCharacterStatus(),
        ],
      ),
    );
  }
}

class AllCharacterStatus extends StatelessWidget {
  const AllCharacterStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainCharacterScreen(characterImage: 'assets/character/character1.png'), // MainCharacterScreen으로 characterImage 전달
                          ),
                        );
                      },
                      child: const CharacterImage(
                        imagePath: 'assets/character/character1.png',
                        height: 350,
                        width: 350,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 150),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainCharacterScreen(characterImage: 'assets/character/character2.png'), // MainCharacterScreen으로 characterImage 전달
                          ),
                        );
                      },
                      child: const CharacterImage(
                        imagePath: 'assets/character/character2.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainCharacterScreen(characterImage: 'assets/character/character3.png'), // MainCharacterScreen으로 characterImage 전달
                          ),
                        );
                      },
                      child: const CharacterImage(
                        imagePath: 'assets/character/character3.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainCharacterScreen(characterImage: 'assets/coming_soon.png'), // MainCharacterScreen으로 characterImage 전달
                          ),
                        );
                      },
                      child: const CharacterImage(
                        imagePath: 'assets/coming_soon.png',
                        height: 230,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CharacterImage extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  const CharacterImage({super.key, 
    required this.imagePath,
    this.height = 80,
    this.width = 80,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Image.asset(
        imagePath,
        height: height,
        width: width,
      ),
    );
  }
}

class GoToMainCharacterStatus extends StatelessWidget {
  const GoToMainCharacterStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 50,
          color: Colors.greenAccent,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
