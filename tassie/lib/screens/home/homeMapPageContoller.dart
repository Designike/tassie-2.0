import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/utils/leftSwipe.dart';
import 'package:tassie/screens/home/navigator/outerTabNavigator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // String _currentPage = "Page1";
  // List<String> pageKeys = ["Page1", "Page2", "Page3"];

  final Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
  };
  // int _selectedIndex = 0;

  int _selectedIndex = 0;
  // static bool isLoading = true;
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final LocalStorage lstorage = LocalStorage('tassie');
  int currentPage = 0;

  PageController _pageController = PageController();
  List<Widget> _screens = [];

  // double _angle = 0;
  Widget _buildOffstageNavigator(int index) {
    return TabNavigator2(
        navigatorKey: _navigatorKeys[index]!,
        tabItem: index,
        rightSwipe: () {
          if (mounted) {
            setState(() {
              _selectedIndex = 0;
              _pageController.jumpToPage(0);
            });
          }
        });
  }

  @override
  void initState() {
    super.initState();
    // getIng();

    //  AnimationController animatedController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    //  animatedController.addListener(() {
    //   setState(() {
    //     _angle = animatedController.value * 45 / 360 * pi * 2;
    //   });
    _selectedIndex = 0;
    // _screens = [
    //   Feed(),
    //   Recipes(),
    //   // Add(),
    //   Explore(),
    //   Profile(uuid: "user"),
    // ];
    _screens = [
      _buildOffstageNavigator(0),
      // if(leftSwipeOn) ... [
      _buildOffstageNavigator(1),
      // ]
      // _buildOffstageNavigator(2),
      // _buildOffstageNavigator(3),
    ];

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await _navigatorKeys[_selectedIndex]!.currentState!.maybePop(),
      child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: OfflineBuilder(
            connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected ? PageView(
            physics: Provider.of<LeftSwipe>(context).isSwipe
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            reverse: true,
            children: _screens,
          ): Stack(children: [
            Positioned(
                height: 100.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                  child: Center(
                    child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
                  ),
                ),
              ),
              Center(
                child: new Text(
                  'You are not connected to Internet.',
                ),
              ),
          ],);
        },
            child: Container(),
          )),
    );
  }
}
