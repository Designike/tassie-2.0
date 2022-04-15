// import 'package:flutter/material.dart';
// import 'package:tassie/themePreferences.dart';
// // import 'package:fluttertheme/theme_preferences.dart';

// class ThemeModel with ChangeNotifier {
//   Map _isDark = {"system": "false", "light": "false"};
//   ThemePreferences _preferences = ThemePreferences();
//   Map get isDark => _isDark;

//   ThemeModel() {
//     _isDark = {"system": "false", "light": "false"};
//     _preferences = ThemePreferences();
//     getPreferences();
//   }
//   set isDark(Map theme) {
//     print('toppaaa');
//     _isDark = {"system": theme['system'], "light": theme['light']};
//     _preferences.setTheme(theme['system'], theme['light']);
//     notifyListeners();
//   }

//   getPreferences() async {
//     _isDark = await _preferences.getTheme();
//     notifyListeners();
//   }
// }
