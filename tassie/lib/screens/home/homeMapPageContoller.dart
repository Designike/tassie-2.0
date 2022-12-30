import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/utils/leftSwipe.dart';
import 'package:tassie/screens/home/navigator/outerTabNavigator.dart';
import 'package:tassie/utils/leftSwipe.dart';

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

  // BannerAd? banner;

  // void createBannerAd() {
  //   banner = BannerAd(
  //     adUnitId: "ca-app-pub-6882682815888845/9486743320",
  //     size: AdSize.banner,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       // Called when an ad is successfully received.
  //       onAdLoaded: (Ad ad) => print('${ad.runtimeType} loaded.'),
  //       // Called when an ad request failed.
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         print('${ad.runtimeType} failed to load: $error');
  //       },
  //       // Called when an ad opens an overlay that covers the screen.
  //       onAdOpened: (Ad ad) => print('${ad.runtimeType} opened.'),
  //       // Called when an ad removes an overlay that covers the screen.
  //       onAdClosed: (Ad ad) {
  //         print('${ad.runtimeType} closed');
  //         ad.dispose();
  //         createBannerAd();
  //         print('${ad.runtimeType} reloaded');
  //       },
  //       // Called when an ad is in the process of leaving the application.
  //       // onApplicationExit: (Ad ad) => print('Left application.'),
  //     ),
  //   )..load();
  // }

  // double _angle = 0;
  Widget _buildOffstageNavigator(int index) {
    return TabNavigator2(
        navigatorKey: _navigatorKeys[index]!,
        tabItem: index,
        rightSwipe: () {
          if (mounted) {
            Provider.of<LeftSwipe>(context, listen: false).setSwipe(true);
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
    _selectedIndex = 0;
    _screens = [
      _buildOffstageNavigator(0),
      _buildOffstageNavigator(1),
    ];

    _pageController = PageController(initialPage: _selectedIndex);
    // createBannerAd();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              return connected
                  ? WillPopScope(
                      onWillPop: () async {
                        final value = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            actionsPadding: const EdgeInsets.all(20.0),
                            title: const Text('Are you sure?'),
                            content: const Text('Do you want to exit the app'),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text("No"),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          ),
                        );
                        if (value != null) {
                          return Future.value(value);
                        } else {
                          return Future.value(false);
                        }
                      },
                      child: PageView(
                        physics: Provider.of<LeftSwipe>(context).isSwipe
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        children: _screens,
                      ),
                    )
                  : Scaffold(
                      appBar: AppBar(
                        toolbarHeight: kToolbarHeight * 1.1,
                        backgroundColor: Colors.transparent,
                        systemOverlayStyle: SystemUiOverlayStyle(
                            statusBarColor:
                                connected ? Colors.green : Colors.red,
                            statusBarIconBrightness:
                                Theme.of(context).brightness == Brightness.light
                                    ? Brightness.dark
                                    : Brightness.light),
                        title: const Text(
                          'Tassie',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'LobsterTwo',
                            fontSize: 40.0,
                          ),
                        ),
                        centerTitle: true,
                      ),
                      // resizeToAvoidBottomInset: false,
                      body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              height: 10,
                              thickness: 0.5,
                            ),
                            SingleChildScrollView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.25,
                                    ),
                                    const Icon(
                                      Icons.wifi_off_rounded,
                                      size: 80.0,
                                      color: kDark,
                                    ),
                                    const SizedBox(
                                      height: 30.0,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.75,
                                      child: const Text(
                                        'Oops! Seems like you are not connected to internet.',
                                        style: TextStyle(fontSize: 18.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      width: 100.0,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: connected
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      child: Center(
                                          child: Text(connected
                                              ? "Online"
                                              : "Offline")),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    );
            },
            child: Container(),
          )),
    );
  }
}
