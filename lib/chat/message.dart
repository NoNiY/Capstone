import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/chat/chat_bubble.dart';
import 'package:untitled1/user_info.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = UserInfo();
    String userEmail = userInfo.userEmail ?? '';
    String userName = userEmail.split('@')[0];
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chatting')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
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