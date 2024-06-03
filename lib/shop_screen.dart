import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _points = 0;
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _loadUserPoints();
    }
  }

  Future<void> _loadUserPoints() async {
    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _points = userDoc['points'];
        });
      }
    } catch (e) {
      print('Error loading user points: $e');
    }
  }

  Future<void> _updateUserPoints(int newPoints) async {
    try {
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .update({'points': newPoints});
      setState(() {
        _points = newPoints;
      });
    } catch (e) {
      print('Error updating user points: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight - 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 25.0),
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
                              padding: const EdgeInsets.all(8.0),
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
                            const SizedBox(width: 5.0),
                            Text(
                              '$_points',
                              style: const TextStyle(
                                  fontSize: 40.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/back_icon.png',
                            width: 50,
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
    );
  }

  Widget _buildProductsContainer(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFCD3),
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '밀짚모자', 'P', '100', const Color(0xFFC3D49F), 'assets/images/image_101.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '캡모자', 'P', '200', const Color(0xFFC3D49F), 'assets/images/image_102.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '마술모자', 'P', '300', const Color(0xFFC3D49F), 'assets/images/image_104.png'),
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
                  child: _buildProduct(context, '반팔티', 'P', '100', const Color(0xFFC3D49F), 'assets/images/image_105.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '나시', 'P', '200', const Color(0xFFC3D49F), 'assets/images/image_107.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '와이셔츠', 'P', '300', const Color(0xFFC3D49F), 'assets/images/image_106.png'),
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
                  child: _buildProduct(context, '여름반바지', 'P', '100', const Color(0xFFC3D49F), 'assets/images/image_109.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '청바지', 'P', '200', const Color(0xFFC3D49F), 'assets/images/image_108.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '정장바지', 'P', '300', const Color(0xFFC3D49F), 'assets/images/image_110.png'),
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
                  child: _buildProduct(context, '귀걸이', 'P', '100', const Color(0xFFC3D49F), 'assets/images/image_111.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '반지', 'P', '200', const Color(0xFFC3D49F), 'assets/images/image_112.png'),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProduct(context, '팔찌', 'P', '300', const Color(0xFFC3D49F), 'assets/images/image_114.png'),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 1.0),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }

  Widget _buildProduct(BuildContext context, String name, String type, String price, Color color, String imageAsset) {
    return GestureDetector(
      onTap: () {
        _showPurchaseDialog(context, name, int.parse(price));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        decoration: BoxDecoration(
          color: const Color(0xFFC3D49F),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100.0,
              color: color,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Image.asset(
                        imageAsset,
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
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
              thickness: 2.0,
              color: Colors.black,
            ),
            Row(
              children: [
                const SizedBox(width: 7.0),
                Container(
                  padding: const EdgeInsets.all(8.0),
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

  void _showPurchaseDialog(BuildContext context, String productName, int productPrice) {
    if (_points < productPrice) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('포인트 부족'),
            content: const Text('포인트가 부족하여 상품을 구매할 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('구입 확인'),
            content: Text('$productName을(를) 구입 하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () {
                  _updateUserPoints(_points - productPrice);
                  Navigator.of(context).pop();
                },
                child: const Text('구입'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
