import 'package:flutter/foundation.dart';

class AuthState with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void setAuthenticationStatus(bool status) {
    _isAuthenticated = status;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

}
