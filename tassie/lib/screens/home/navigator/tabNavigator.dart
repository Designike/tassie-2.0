import 'package:flutter/material.dart';
import 'package:tassie/screens/home/main/explore/explore.dart';
import 'package:tassie/screens/home/main/feed/feed.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/screens/home/main/recs/recipes.dart';

// class TabNavigatorRoutes {
//   static const String root = '/';
//   static const String detail = '/detail';
// }

class TabNavigator extends StatefulWidget {
  const TabNavigator({required this.navigatorKey, required this.tabItem, Key? key}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;
  final int tabItem;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  HeroController heroController = HeroController();

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.tabItem == 0) {
      child = const Feed();
    } else if (widget.tabItem == 1) {
      child = const Recipes();
    } else if (widget.tabItem == 2) {
      child = const Explore();
    } else {
      child = const Profile(uuid: "user");
    }
    return Navigator(
      key: widget.navigatorKey,
      observers: [heroController],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
    // return Container(child: child);
  }
}
