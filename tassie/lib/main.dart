import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tassie/utils/leftSwipe.dart';
import 'package:tassie/screens/wrapper.dart';
import 'package:tassie/theme.dart';
import 'package:tassie/utils/themePreferences.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp(ChangeNotifierProvider(
  //   create: (_) => ThemeModel(),
  //   child: Consumer(
  //   builder: (context, ThemeModel themeNotifier,child),
  //   child: MyApp(),
  //   // ),
  // ));
  // Get.lazyPut(() => ThemeController());
  ThemeController thc = ThemeController();
  thc.getThemeModeFromPreferences();
  runApp(ChangeNotifierProvider(
    create: (_) => LeftSwipe(),
    child: const MyApp()));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //     create: (_) => ThemeModel(),
    //     child: Consumer(
    //         builder: (context, ThemeModel themeNotifier, child) =>
    //             themeNotifier.isDark['system'] == "true"
    //                 ? MaterialApp(
    //                     home: Wrapper(),
    //                     theme: lightThemeData(context),
    //                     darkTheme: darkThemeData(context),
    //                     debugShowCheckedModeBanner: false,
    //                   )
    //                 : MaterialApp(
    //                     home: Wrapper(),
    //                     theme: themeNotifier.isDark['light'] == "true"
    //                         ? lightThemeData(context)
    //                         : darkThemeData(context),
    //                     debugShowCheckedModeBanner: false,
    //                   )));
    return GetMaterialApp(
      title: 'Tassie',
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.dark,
      home: const Wrapper(),
      debugShowCheckedModeBanner: false,
    );

    // ),
    // );
    // return MaterialApp(
    //   home: Wrapper(),
    //   theme: theme lightThemeData(context),
    //   darkTheme: darkThemeData(context),
    //   debugShowCheckedModeBanner: false,
    // );
  }
}
