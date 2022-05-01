import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseUserProvider extends ChangeNotifier {
  User user;

  String get firebaseUid => user.uid;

  void set(User user) {
    this.user = user;
    notifyListeners();
  }

  void reset() {
    user = null;
    notifyListeners();
  }
}
