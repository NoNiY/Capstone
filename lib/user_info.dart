import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
export 'package:untitled1/user_info.dart';

class UserInfo with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  UserInfo() {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  String? get userEmail => _user?.email;
}