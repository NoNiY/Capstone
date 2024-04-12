import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _points = 10000; // 초기 포인트 값
  int _selectedIndex = 0; // 추가: 현재 선택된 bottom navigation bar의 아이템 인덱스

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildProductsContainer(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFCD3), // 배경색 설정
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // 스크롤이 항상 가능하도록 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '여름바지', 'P', '100',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '청바지', 'P', '200',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '와이셔츠', 'P', '300',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '여름바지', 'P', '100',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '청바지', 'P', '200',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '와이셔츠', 'P', '300',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '여름바지', 'P', '5000',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '청바지', 'P', '200',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '와이셔츠', 'P', '300',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '여름바지', 'P', '5000',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '청바지', 'P', '200',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '와이셔츠', 'P', '300',
                      const Color(0xFFC3D49F), 'assets/images/image_69.png'),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 1.0),
            const SizedBox(height: 100.0), // 추가된 여백
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight - 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green, // 배경색 설정
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 25.0), // SHOP 글씨 위치를 조금 내림
            child: Center(
              child: Text(
                'SHOP',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        // 화면을 꽉 채우는 배경색 추가
        color: const Color(0xFFFFFCD3),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Expanded(
                    child: _buildProductsContainer(context),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0), //p 크기
                              decoration: const BoxDecoration(
                                color: Colors.lightBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                'P',
                                style: TextStyle(
                                    fontSize: 40.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 5.0), // 추가된 부분
                            Text(
                              '$_points',
                              style: const TextStyle(
                                  fontSize: 40.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/back_icon.png', // 뒤로가기 아이콘의 이미지 경로
                            width: 50, // 이미지 크기 조정
                            height: 50,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1.0,
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: '계획',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '팀 계획',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle), // "캐릭터" 아이콘 추가
            label: '캐릭터',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // "설정" 아이콘 추가
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black, // 기본 색상을 검은색으로 설정
        onTap: _onItemTapped,
        elevation: 100, // 절취선 두께 설정
        selectedIconTheme: const IconThemeData(color: Colors.blue, size: 30),
        unselectedIconTheme: const IconThemeData(color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildProduct(BuildContext context, String name, String type,
      String price, Color color, String imageAsset) {
    return GestureDetector(
      onTap: () {
        _showPurchaseDialog(context, name, int.parse(price));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7.0), // 상하 여백을 늘림
        padding: const EdgeInsets.symmetric(vertical: 7.0), // 박스 내부 여백을 늘림
        decoration: BoxDecoration(
          color: const Color(0xFFC3D49F),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100.0, // 이미지 높이 설정
              color: color,
              child: Stack(
                // 이름을 이미지 위에 표시하기 위해 Stack을 사용합니다.
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0), // 이미지를 아래로 내리는 부분
                    child: Center(
                      child: Image.asset(
                        imageAsset,
                        width: 80, // 이미지 크기 조절
                        height: 80,
                        fit: BoxFit.contain, // 이미지가 상자에 맞도록 조정
                      ),
                    ),
                  ),
                  Positioned(
                    top: -5.0,
                    left: 0.0,
                    right: 0.0,
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 2.0, // 굵기 조정
              color: Colors.black,
            ), // 절취선 추가
            Row(
              children: [
                const SizedBox(width: 7.0), // p 오른쪽으로 땡기기
                Container(
                  padding: const EdgeInsets.all(8.0), //p 크기
                  decoration: const BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    price,
                    style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog(
      BuildContext context, String productName, int productPrice) {
    if (_points < productPrice) {
      // 포인트가 부족한 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('포인트 부족'),
            content: const Text('포인트가 부족하여 상품을 구매할 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      // 포인트가 충분한 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('구입 확인'),
            content: Text('$productName을(를) 구입 하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _points -= productPrice; // 제품 가격만큼 포인트 감소
                  });
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: const Text('구입'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: const Text('취소'),
              ),
            ],
          );
        },
      );
    }
  }
}
