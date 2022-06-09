import 'package:flutter/material.dart';
import 'package:tassie/screens/home/main/explore/explore.dart';
import 'package:tassie/screens/home/main/feed/feed.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/screens/home/main/recs/recipes.dart';

// class TabNavigatorRoutes {
//   static const String root = '/';
//   static const String detail = '/detail';
// }

class TabNavigator extends StatelessWidget {
  const TabNavigator({required this.navigatorKey, required this.tabItem, Key? key}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;
  final int tabItem;
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == 0) {
      child = const Feed();
    } else if (tabItem == 1) {
      child = const Recipes();
    } else if (tabItem == 2) {
      child = const Explore();
    } else {
      child = const Profile(uuid: "user");
    }
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
    // return Container(child: child);
  }
}
