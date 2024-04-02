import 'package:flutter/material.dart';
import '../main_screen.dart';

class ChangeCharacterScreen extends StatelessWidget {
  //static String selectedImage = '';

  //final String selectedImage;
  //ChangeCharacterScreen({required this.selectedImage});

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
            top: MediaQuery.of(context).size.height * 0.05,
            left: 0,
            right: 0,
            child: Center(
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
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(characterImage: 'assets/character/character1.png'),
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
                    SizedBox(height: 150),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(characterImage: 'assets/character/character2.png'),
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
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(characterImage: 'assets/character/character3.png'),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(characterImage: 'assets/coming_soon.png'),
                          ),
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
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: IconButton(
        icon: Icon(
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