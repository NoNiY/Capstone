import 'package:flutter/material.dart';
import 'package:untitled1/main/home_screen.dart';
import 'package:untitled1/character/main_character.dart';
import 'store_image.dart';

class ChangeCharacterScreen extends StatelessWidget {
  const ChangeCharacterScreen({Key? key});

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
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 40,
            ),
            onPressed: () {},
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
          Expanded(
            child: AllCharacterStatus(),
          ),
          GoToMainCharacterStatus(),
        ],
      ),
    );
  }
}

class AllCharacterStatus extends StatelessWidget {
  const AllCharacterStatus({Key? key});

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
                        StoreImage.characterImage = 'assets/character/character1.png';
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: CharacterImage(
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
                        StoreImage.characterImage = 'assets/character/character2.png';
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: CharacterImage(
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
                        StoreImage.characterImage = 'assets/character/character3.png';
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: CharacterImage(
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Center(child: Text('준비중입니다')),
                              content: Container(
                                width: MediaQuery.of(context).size.width * 0.7, // 팝업 창의 가로 길이를 조정합니다.
                                child: Column(
                                  mainAxisSize: MainAxisSize.min, // 세로 방향 크기를 최소화합니다.
                                  children: [
                                    const SizedBox(height: 20),
                                    const Text('5/11일 출시 예정입니다'),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); // 팝업 창을 닫습니다.
                                      },
                                      child: const Text('확인'),
                                    ),
                                  ],
                                ),
                            ),
                            );
                          },
                        );
                      },
                      child: CharacterImage(
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

  const CharacterImage({
    Key? key,
    required this.imagePath,
    this.height = 80,
    this.width = 80,
    this.left,
    this.right,
    this.top,
    this.bottom,
  }) : super(key: key);

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
  const GoToMainCharacterStatus({Key? key});

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
