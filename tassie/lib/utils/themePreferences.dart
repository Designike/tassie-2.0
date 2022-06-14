import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  // SharedPreferences prefs;
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  var storage = const FlutterSecureStorage();
  Future<void> setThemeMode(ThemeMode themeMode) async {
    Get.changeThemeMode(themeMode);
    _themeMode = themeMode;
    update();
    // prefs = await s.getInstance();
    await storage.write(
        key: 'theme', value: themeMode.toString().split('.')[1]);
    // print('Theme mode set to $themeMode');
  }

  getThemeModeFromPreferences() async {
    ThemeMode themeMode;
    String themeText = "dark";
    // prefs = await SharedPreferences.getInstance();
    try {
      var theme = await storage.read(key: 'theme');
      // print(theme);
      themeText = theme!;
    } catch (e) {
      await storage.write(key: 'theme', value: "dark");
    }

    try {
      themeMode =
          ThemeMode.values.firstWhere((e) => describeEnum(e) == themeText);
    } catch (e) {
      themeMode = ThemeMode.system;
    }
    setThemeMode(themeMode);
  }
}
