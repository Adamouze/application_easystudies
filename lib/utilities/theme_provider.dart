import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // These are the default theme settings
  bool _isDarkTheme = false;
  ThemeMode _themeMode = ThemeMode.system;

  bool get isDarkTheme => _isDarkTheme;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: deprecated_member_use
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? (WidgetsBinding.instance.window.platformBrightness == Brightness.dark);
    if (_isDarkTheme) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }


  toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    if (_isDarkTheme) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkTheme);
    notifyListeners();
  }
}
