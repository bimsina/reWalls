import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

void onThemeChanged(int value, ThemeNotifier themeNotifier) async {
  themeNotifier.setTheme(themes[value]);
  var prefs = await SharedPreferences.getInstance();
  prefs.setInt('theme', value);
}
