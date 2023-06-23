import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userType;

  bool get isAuthenticated => _isAuthenticated;
  String? get userType => _userType;

  AuthState() {
    loadAuthenticationStatus();
  }

  void loadAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userType = prefs.getString('userType');
    notifyListeners();
  }

  void setAuthenticationStatus(bool status, String userType) async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = status;
    prefs.setBool('isAuthenticated', status);
    _userType = userType;
    prefs.setString('userType', userType);
    notifyListeners();
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = false;
    prefs.setBool('isAuthenticated', false);
    _userType = null;
    prefs.remove('userType');
    notifyListeners();
  }
}
