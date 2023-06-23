import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userType;

  bool get isAuthenticated => _isAuthenticated;
  String? get userType => _userType;

  AuthState() {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userType = prefs.getString('userType');
    print('Loaded userType: $_userType');
    notifyListeners();
  }


  void setAuthenticationStatus(bool status, String userType) async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = status;
    _userType = userType;
    prefs.setBool('isAuthenticated', status);
    prefs.setString('userType', userType);
    print('Set userType: $userType');
    notifyListeners();
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = false;
    _userType = 'home';
    prefs.setBool('isAuthenticated', false);
    prefs.setString('userType', 'home');
    notifyListeners();
  }
}
