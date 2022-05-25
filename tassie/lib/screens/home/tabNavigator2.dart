import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/constants.dart';
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

class TabNavigator2 extends StatefulWidget {
  TabNavigator2({
    required this.navigatorKey,
    required this.tabItem,
    required this.rightSwipe,
  });
  final GlobalKey<NavigatorState> navigatorKey;
  final int tabItem;
  final void Function() rightSwipe;

  @override
  State<TabNavigator2> createState() => _TabNavigator2State();
}

class _TabNavigator2State extends State<TabNavigator2> {
  String? dp;
  bool isLoading = true;
  var storage = FlutterSecureStorage();

  Future<void> getdp() async {
    dp = await storage.read(key: "profilePic");
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getdp();
  }

  @override
  Widget build(BuildContext context) {
    // Widget child;
    // if (widget.tabItem == 0) {
    //   child = HomeHome();
    // } else {
    //   child = TassieMap(dp: dp!);
    // }
    // print(child);
    return isLoading
        ? Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 50.0,
            ),
          )
        : Navigator(
            key: widget.navigatorKey,
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                  builder: (context) => widget.tabItem == 0
                      ? HomeHome()
                      : TassieMap(dp: dp!, rightSwipe: widget.rightSwipe));
            },
          );
    // return Container(child: child);
  }
}
