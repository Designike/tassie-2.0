import 'package:flutter/material.dart';
import 'package:tassie/screens/home/explore.dart';
import 'package:tassie/screens/home/feed.dart';
import 'package:tassie/screens/home/home_stack.dart';
import 'package:tassie/screens/home/map.dart';
import 'package:tassie/screens/home/profile.dart';
import 'package:tassie/screens/home/recipes.dart';

import 'home_home.dart';

// class TabNavigatorRoutes {
//   static const String root = '/';
//   static const String detail = '/detail';
// }

class TabNavigator2 extends StatelessWidget {
  const TabNavigator2({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final int tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == 0) {
      child = HomeHome();
    } else {
      child = TassieMap();
    }
    print(child);
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
    // return Container(child: child);
  }
}
