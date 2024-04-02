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
                  'assets/images/shop_logo.png',
                  height: AppBar().preferredSize.height,
                  fit: BoxFit.contain,
                ),
                const Positioned(
                  bottom: 4,
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: const Color(0xFFFFFCD3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 1.0),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('shop').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final products = snapshot.data!.docs;

                  return Column(
                    children: [
                      for (int i = 0; i < products.length; i += 3)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int j = i; j < i + 3 && j < products.length; j++)
                              _buildProduct(
                                context,
                                products[j]['name'],
                                products[j]['type'],
                                products[j]['price'].toString(),
                                Color(products[j]['color']),
                                products[j]['imageUrl'],
                              ),
                          ],
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 200.0),
              Padding(
                padding: const EdgeInsets.only(left: 1.0, bottom: 1.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            '$_points',
                            style: const TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/back_icon.png',
                          width: 110,
                          height: 110,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProduct(BuildContext context, String name, String type,
      String price, Color color, String imageUrl) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          _showPurchaseDialog(context, name, int.parse(price));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          decoration: const BoxDecoration(
            color: Color(0xffc3d49f),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 100.0,
                    color: color,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: FutureBuilder<String>(
                          future: _getImageUrl(imageUrl),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Image.network(
                                  snapshot.data!,
                                  width: 90,
                                  height: 90,
                                );
                              } else {
                                return const Icon(Icons.error);
                              }
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -2.0,
                    left: 20.0,
                    right: 20.0,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 5.0,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<String> _getImageUrl(String gsUrl) async {
  final reference = FirebaseStorage.instance.refFromURL(gsUrl);
  await reference.getMetadata();
  final url = await reference.getDownloadURL();
  return url;
}

  void _showPurchaseDialog(BuildContext context, String productName, int productPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('구입 확인'),
          content: Text('$productName을(를) 구입 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _points -= productPrice;
                });
                Navigator.of(context).pop();
              },
              child: const Text('구입'),
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {});
    });
  }
}