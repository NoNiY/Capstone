import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/main/login_screen.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if(context.mounted){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => signOut(context),
          child: const Text('Log Out'),
        ),
      ),
    );
  }
}