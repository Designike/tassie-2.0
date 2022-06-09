// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class ThemePreferences {
//   // static const PREF_KEY = 'system';

//   setTheme(String system, String light) async {
//     // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     // sharedPreferences.setBool(PREF_KEY, value);
//     print(system);
//     print(light);
//     FlutterSecureStorage storage = FlutterSecureStorage();
//     storage.write(key: "system", value: system);
//     storage.write(key: "light", value: light);
//   }

//   getTheme() async {
//     // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     // return sharedPreferences.getBool(PREF_KEY) ?? false;
//     FlutterSecureStorage storage = FlutterSecureStorage();
//     Map val = {};
//     val['system'] = await storage.read(key: "system");
//     val['light'] = await storage.read(key: "light");
//     return val;
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  // SharedPreferences prefs;
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  var storage = FlutterSecureStorage();
  Future<void> setThemeMode(ThemeMode themeMode) async {
    Get.changeThemeMode(themeMode);
    _themeMode = themeMode;
    update();
    // prefs = await s.getInstance();
    await storage.write(key:'theme',value: themeMode.toString().split('.')[1]);
  }

  getThemeModeFromPreferences() async {
    ThemeMode themeMode;
    String themeText = "dark";
    // prefs = await SharedPreferences.getInstance();
    try {
      var theme = await storage.read(key:'theme');
      themeText = theme!;
    } catch (e) {
      await storage.write(key:'theme',value:"dark");
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