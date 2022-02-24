import 'package:flutter/material.dart';
import 'package:tassie/screens/home/explore.dart';
import 'package:tassie/screens/home/feed.dart';
import 'package:tassie/screens/home/profile.dart';
import 'package:tassie/screens/home/recipes.dart';

// class TabNavigatorRoutes {
//   static const String root = '/';
//   static const String detail = '/detail';
// }

class TabNavigator extends StatelessWidget {
  const TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final int tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == 0) {
      child = Feed();
    } else if (tabItem == 1) {
      child = Recipes();
    } else if (tabItem == 2) {
      child = Explore();
    } else {
      child = Profile(uuid: "user");
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
