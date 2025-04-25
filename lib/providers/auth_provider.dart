import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  Future<bool> login(String email, String password) async {
    // TODO: Implement actual login logic
    _isAuthenticated = true;
    _userId = "user123";
    _userEmail = email;
    _userName = "Sarah"; // Hardcoded for now
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    _userName = null;
    notifyListeners();
  }

  Future<bool> register(String email, String password, String name) async {
    // TODO: Implement actual registration logic
    _isAuthenticated = true;
    _userId = "user123";
    _userEmail = email;
    _userName = name;
    notifyListeners();
    return true;
  }
}
