import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userType;
  String? _identifier;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get userType => _userType;
  String? get identifier => _identifier;
  String? get token => _token;

  AuthState() {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userType = prefs.getString('userType');
    _identifier = prefs.getString('identifier');
    _token = prefs.getString('token');
    if (_isAuthenticated && _token != null) {  // Only check the token validity if the user is authenticated
      checkTokenValidity();
    }
    notifyListeners();
  }


  void setAuthenticationStatus(bool status, String userType, String identifier, String token) async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = status;
    _userType = userType;
    _identifier = identifier;
    _token = token;
    prefs.setBool('isAuthenticated', status);
    prefs.setString('userType', userType);
    prefs.setString('identifier', identifier);
    prefs.setString('token', token);
    notifyListeners();
  }

  Future<void> checkTokenValidity() async {
    // Make the API request to check the token validity
    final response = await http.get(Uri.parse('https://app.easystudies.fr/api/login.php?_token=$_token&_login=$_identifier&_pwd='));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['_valid'] != true) {
        logout(); // log out if the token is not valid
      }
    }
    else {
      throw Exception('Failed to load data from API');
    }
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
