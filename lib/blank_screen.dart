import 'package:flutter/material.dart';

class BlankScreen extends StatelessWidget {
  const BlankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blank Screen'),
      ),
      body: const Center(
        child: Text('This is a blank screen.'),
      ),
    );
  }
}