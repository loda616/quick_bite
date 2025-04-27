import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _userName;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get errorMessage => _errorMessage;

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      _clearError();
      // TODO: Implement actual login logic
      _isAuthenticated = true;
      _userId = "user123";
      _userEmail = email;
      _userName = AppLocalizations.of(context)!.defaultUserName;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = AppLocalizations.of(context)!.loginFailed;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      _clearError();
      _isAuthenticated = false;
      _userId = null;
      _userEmail = null;
      _userName = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = AppLocalizations.of(context)!.networkError;
      notifyListeners();
    }
  }

  Future<bool> register(
      String email, String password, String name, BuildContext context) async {
    try {
      _clearError();
      // TODO: Implement actual registration logic
      _isAuthenticated = true;
      _userId = "user123";
      _userEmail = email;
      _userName = name;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = AppLocalizations.of(context)!.registrationFailed;
      notifyListeners();
      return false;
    }
  }
}
