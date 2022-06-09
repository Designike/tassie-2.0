import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tassie/utils/leftSwipe.dart';
import 'package:tassie/screens/wrapper.dart';
import 'package:tassie/theme.dart';
import 'package:tassie/utils/themePreferences.dart';
import 'package:provider/provider.dart';

void main() {
  ThemeController thc = ThemeController();
  thc.getThemeModeFromPreferences();
  runApp(
      ChangeNotifierProvider(create: (_) => LeftSwipe(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tassie',
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.dark,
      home: const Wrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
