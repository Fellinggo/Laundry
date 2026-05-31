import 'package:flutter/material.dart';

class AuthProvider
    with
        ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;

  void login(
    String username,
  ) {
    _isLoggedIn = true;
    _userName = username;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = null;
    notifyListeners();
  }
}
