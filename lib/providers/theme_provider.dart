import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  late bool _isDark;
  bool get isDark => _isDark;

  ThemeProvider() {
    _isDark = false;
    getPreferences();
  }
//Switching the themes
  set isDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

  getPreferences() async {
    notifyListeners();
  }
}
