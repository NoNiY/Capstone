import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2; // 초기 홈 페이지 선택
  int _points = 10000; // 초기 포인트 값

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildProductsContainer(BuildContext context) {
    return Container(
      color: Color(0xFFFFFCD3), // 배경색 설정
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(), // 스크롤이 항상 가능하도록 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '여름바지', 'P', '100', Color(0xFFFC3D49F), 'assets/image 69.png'),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '청바지', 'P', '200', Color(0xFFFC3D49F), 'assets/image 103.png'),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '와이셔츠', 'P', '300', Color(0xFFFC3D49F), 'assets/image 106.png'),
                ),
                SizedBox(width: 16.0),
              ],
            ),
            SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '여름바지', 'P', '100', Color(0xFFFC3D49F), 'assets/image 69.png'),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '청바지', 'P', '200', Color(0xFFFC3D49F), 'assets/image 103.png'),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '와이셔츠', 'P', '300', Color(0xFFFC3D49F), 'assets/image 106.png'),
                ),
                SizedBox(width: 16.0),
              ],
            ),
            SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '여름바지', 'P', '5000', Color(0xFFFC3D49F), 'assets/image 69.png'),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '청바지', 'P', '200', Color(0xFFFC3D49F), 'assets/image 103.png'),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '와이셔츠', 'P', '300', Color(0xFFFC3D49F), 'assets/image 106.png'),
                ),
                SizedBox(width: 16.0),
              ],
            ),
            SizedBox(height: 1.0),
            SizedBox(height: 100.0), // 추가된 여백
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/shop_logo.png', // 내가 올려준 이미지의 경로
                  height: AppBar().preferredSize.height, // 상단바 높이와 동일하게 설정,
                  fit: BoxFit.contain, // 이미지가 화면에 맞도록 조정
                ),
                Positioned(
                  bottom: 4, // 텍스트의 위치 조정
                  child: Text(
                    'SHOP',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
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
                  padding: EdgeInsets.all(0.0),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0), //p 크기
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              'P',
                              style: TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 5.0), // 추가된 부분
                          Text(
                            '$_points',
                            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/back_icon.png', // 뒤로가기 아이콘의 이미지 경로
                          width: 110, // 이미지 크기 조정
                          height: 110,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1.0,
                  thickness: 2.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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
        selectedIconTheme: IconThemeData(color: Colors.blue, size: 30),
        unselectedIconTheme: IconThemeData(color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildProduct(BuildContext context, String name, String type, String price, Color color, String imageAsset) {
    return GestureDetector(
      onTap: () {
        _showPurchaseDialog(context, name, int.parse(price));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.0), // 상하 여백을 늘림
        padding: EdgeInsets.symmetric(vertical: 6.0), // 박스 내부 여백을 늘림
        decoration: BoxDecoration(
          color: Color(0xFFFC3D49F),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100.0, // 이미지 높이 설정
              color: color,
              child: Stack( // 이름을 이미지 위에 표시하기 위해 Stack을 사용합니다.
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0), // 이미지를 아래로 내리는 부분
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
                      style: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 2.0, // 굵기 조정
              color: Colors.black,
            ), // 절취선 추가
            Row(
              children: [
                SizedBox(width: 7.0), // p 오른쪽으로 땡기기
                Container(
                  padding: EdgeInsets.all(8.0), //p 크기
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    type,
                    style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    price,
                    style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, String productName, int productPrice) {
    if (_points < productPrice) { // 포인트가 부족한 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('포인트 부족'),
            content: Text('포인트가 부족하여 상품을 구매할 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } else { // 포인트가 충분한 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('구입 확인'),
            content: Text('$productName을(를) 구입 하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _points -= productPrice; // 제품 가격만큼 포인트 감소
                  });
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('구입'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('취소'),
              ),
            ],
          );
        },
      );
    }
  }
}
