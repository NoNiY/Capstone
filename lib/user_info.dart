import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
export 'package:untitled1/user_info.dart';

class UserInfo with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final DateTime _startDate = DateTime.now();
  final DateTime _endDate = DateTime.now();

  UserInfo() {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  String? get userEmail => _user?.email;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

}