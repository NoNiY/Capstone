import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/chat/chat_bubble.dart';
import 'package:untitled1/user_info.dart';

class Messages extends StatelessWidget {
  final String planId; // planId를 받도록 수정

  const Messages({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('plans')
          .doc(planId) // 수정된 부분
          .collection('chat_room')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            return ChatBubbles(
                chatDocs[index]['text'],
                chatDocs[index]['userID'].toString() == userEmail,
                chatDocs[index]['userName']
            );
          },
        );
      },
    );
  }
}