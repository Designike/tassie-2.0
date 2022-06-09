// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/utils/leftSwipe.dart';
import 'package:tassie/screens/home/navigator/outerTabNavigator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // String _currentPage = "Page1";
  // List<String> pageKeys = ["Page1", "Page2", "Page3"];

  Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
  };
  // int _selectedIndex = 0;

  int _selectedIndex = 0;
  // static bool isLoading = true;
  final dio = Dio();
  final storage = FlutterSecureStorage();
  final LocalStorage lstorage = LocalStorage('tassie');
  int currentPage = 0;
  // bool leftSwipeOn = true;
  // bool isFetching = true;

  // Future<void> getIng() async {
  //   print(lstorage.getItem('ingreds'));
  //   // print((await storage.read(key: 'date')) == null);
  //   if ((await storage.read(key: 'date')) == null) {
  //     await storage.write(
  //         key: 'date',
  //         value: (DateTime.now().add(Duration(hours: 48)).toString()));
  //   }
  //   String? date = await storage.read(key: 'date');

  //   // print(date);
  //   // print(DateTime.now());
  //   lstorage.ready.then((value) async {
  //     // print(json.decode(lstorage.getItem('ingreds')).runtimeType);
  //     if ((lstorage.getItem('ingreds') == null) ||
  //         DateTime.parse(date!).isBefore(DateTime.now())) {
  //       print('thai che');
  //       var url = "https://api-tassie.herokuapp.com/recs/getIng/";
  //       var token = await storage.read(key: "token");
  //       Response response = await dio.get(
  //         url,
  //         options: Options(headers: {
  //           HttpHeaders.contentTypeHeader: "application/json",
  //           HttpHeaders.authorizationHeader: "Bearer " + token!
  //         }),
  //       );
  //       // await storage.delete(key: 'ingreds');
  //       // await storage.write(
  //       //     key: 'ingreds', value: response.data['data'].toString());
  //       // var ingreds = await storage.read(key: 'ingreds');
  //       // // print(ingreds);
  //       lstorage.setItem('ingreds', json.encode(response.data['data']));

  //       await storage.write(
  //           key: 'date',
  //           value: DateTime.now().add(Duration(hours: 48)).toString());
  //       // setState(() {
  //       //   isFetching = false;
  //       // });

  //     }
  //     // print('1');
  //     // print(lstorage.getItem('ingreds'));
  //   });
  // }

  // void _navigateBottomBar(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  PageController _pageController = PageController();
  List<Widget> _screens = [];

  // double _angle = 0;
  Widget _buildOffstageNavigator(int index) {
    return TabNavigator2(
        navigatorKey: _navigatorKeys[index]!,
        tabItem: index,
        rightSwipe: () {
          print('yup2');
          setState(() {
            _selectedIndex = 0;
            _pageController.jumpToPage(0);
          });
        });
  }

  void _selectTab(int index) {
    print('thai che');
    if (index == _selectedIndex) {
      _navigatorKeys[index]!.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(index);
      });
    }
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
    return
        // (isFetching == true)
        //     ? Scaffold(
        //         // backgroundColor: Colors.white,
        //         body: Center(
        //           child: SpinKitThreeBounce(
        //             color: kPrimaryColor,
        //             size: 50.0,
        //           ),
        //         ),
        //       )
        //     :
        WillPopScope(
      onWillPop: () async =>
          !await _navigatorKeys[_selectedIndex]!.currentState!.maybePop(),
      child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          // floatingActionButtonLocation:
          // FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: SpeedDial(
          //   elevation: 0,
          //   spacing: 15.0,
          //   foregroundColor: kDark[900],
          //   backgroundColor: kPrimaryColor,
          //   icon: Icons.add_rounded,
          //   activeIcon: Icons.close_rounded,
          //   // onOpen: () => animatedController.reverse(),
          //   // onClose: () => animatedController.forward(),
          //   children: [
          //     SpeedDialChild(
          //         child: Icon(Icons.post_add_rounded),
          //         label: 'New Post',
          //         onTap: () => {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(builder: (context) {
          //                   return AddPost();
          //                 }),
          //               )
          //             }),
          //     SpeedDialChild(
          //         child: Icon(Icons.fastfood_rounded),
          //         label: 'New Recipe',
          //         onTap: () async {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) {
          //               return Scaffold(
          //                 // backgroundColor: Colors.white,
          //                 body: Center(
          //                   child: AnimatedTextKit(
          //                     pause: Duration(milliseconds: 100),
          //                     animatedTexts: [
          //                       FadeAnimatedText('Finding Trivets'),
          //                       FadeAnimatedText('Settling grubs'),
          //                       FadeAnimatedText('Hoarding stuff'),
          //                     ],
          //                   ),
          //                 ),
          //               );
          //             }),
          //           );
          //           var url = "https://api-tassie.herokuapp.com/recs/createRecipe/";

          //           var token = await storage.read(key: "token");
          //           Response response = await dio.get(
          //             url,
          //             options: Options(headers: {
          //               HttpHeaders.contentTypeHeader: "application/json",
          //               HttpHeaders.authorizationHeader: "Bearer " + token!
          //             }),
          //           );
          //           await Future.delayed(Duration(seconds: 1));
          //           print(response);
          //           if (response.data['status'] == true) {
          //             print(response);
          //             Navigator.pushReplacement(
          //               context,
          //               MaterialPageRoute(builder: (context) {
          //                 return AddRecipe(
          //                   uuid: response.data['data']['recUuid'],
          //                   // folder: response.data['data']['folder'],
          //                 );
          //               }),
          //             );
          //           } else {
          //             print(response.data);
          //             showSnack(
          //                 context, 'Unable to create recipe', () {}, 'OK', 3);
          //             Navigator.pushReplacement(
          //               context,
          //               MaterialPageRoute(builder: (context) {
          //                 return Home();
          //               }),
          //             );
          //           }
          //         }),
          //   ],
          // ),
          // bottomNavigationBar: BottomNavigationBar(
          //   type: BottomNavigationBarType.fixed,

          //   currentIndex: _selectedIndex,
          //   // onTap: _navigateBottomBar,
          //   onTap: (selectedPageIndex) {
          //   setState(() {
          //     _selectedIndex = selectedPageIndex;
          //     _pageController.jumpToPage(selectedPageIndex);
          //   });
          // },
          //   // ignore: prefer_const_literals_to_create_immutables
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.feed),
          //       label: 'Feed',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.restaurant),
          //       label: 'Recs',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.add_circle),
          //       label: 'New',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.search),
          //       label: 'Explore',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.person_rounded),
          //       label: 'Profile',
          //     ),
          //   ],
          // ),
          // bottomNavigationBar: BottomAppBar(
          //   shape: CircularNotchedRectangle(),
          //   color: Theme.of(context).brightness == Brightness.dark
          //       ? kDark[900]
          //       : kLight,
          //   // color: kLight,
          //   notchMargin: 6.0,
          //   child: Container(
          //     height: 65.0,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         MaterialButton(
          //           onPressed: () {
          //             _selectTab(0);
          //             // setState(() {
          //             //   _selectedIndex = 0;
          //             //   _pageController.jumpToPage(0);
          //             // });

          //             // ignore: prefer_const_literals_to_create_immutables
          //           },
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(Icons.feed,
          //                   color: _selectedIndex == 0 ? kPrimaryColor : kDark),
          //               Text(
          //                 'Feed',
          //                 style: TextStyle(
          //                     color: _selectedIndex == 0
          //                         ? Theme.of(context).brightness ==
          //                                 Brightness.light
          //                             ? kDark[900]
          //                             : kLight
          //                         : kDark),
          //               ),
          //             ],
          //           ),
          //         ),
          //         MaterialButton(
          //           onPressed: () {
          //             _selectTab(1);
          //             // setState(() {
          //             //   _selectedIndex = 1;
          //             //   _pageController.jumpToPage(1);
          //             // });
          //             // ignore: prefer_const_literals_to_create_immutables
          //           },
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(Icons.restaurant,
          //                   color: _selectedIndex == 1 ? kPrimaryColor : kDark),
          //               Text(
          //                 'Recs',
          //                 style: TextStyle(
          //                     color: _selectedIndex == 1
          //                         ? Theme.of(context).brightness ==
          //                                 Brightness.light
          //                             ? kDark[900]
          //                             : kLight
          //                         : kDark),
          //               ),
          //             ],
          //           ),
          //         ),
          //         SizedBox(
          //           width: 40.0,
          //         ),
          //         MaterialButton(
          //           onPressed: () {
          //             _selectTab(2);
          //             // setState(() {
          //             //   _selectedIndex = 2;
          //             //   _pageController.jumpToPage(2);
          //             // });
          //             // ignore: prefer_const_literals_to_create_immutables
          //           },
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(Icons.search,
          //                   color: _selectedIndex == 2 ? kPrimaryColor : kDark),
          //               Text(
          //                 'Explore',
          //                 style: TextStyle(
          //                     color: _selectedIndex == 2
          //                         ? Theme.of(context).brightness ==
          //                                 Brightness.light
          //                             ? kDark[900]
          //                             : kLight
          //                         : kDark),
          //               ),
          //             ],
          //           ),
          //         ),
          //         MaterialButton(
          //           onPressed: () {
          //             // setState(() {
          //             //   _selectedIndex = 3;
          //             //   _pageController.jumpToPage(3);
          //             // });
          //             _selectTab(3);
          //             // ignore: prefer_const_literals_to_create_immutables
          //           },
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(Icons.person_rounded,
          //                   color: _selectedIndex == 3 ? kPrimaryColor : kDark),
          //               Text(
          //                 'Profile',
          //                 style: TextStyle(
          //                     color: _selectedIndex == 3
          //                         ? Theme.of(context).brightness ==
          //                                 Brightness.light
          //                             ? kDark[900]
          //                             : kLight
          //                         : kDark),
          //               ),
          //             ],
          //           ),
          //         ),
          //         // IconButton(
          //         //   icon: Icon(Icons.feed),
          //         //   color: Colors.black,
          //         //   onPressed: () {},
          //         // ),
          //         // IconButton(
          //         //   icon: Icon(Icons.search),
          //         //   color: Colors.black,
          //         //   onPressed: () {},
          //         // ),
          //         // SizedBox(
          //         //   width: 40,
          //         // ),
          //         // IconButton(
          //         //   icon: Icon(Icons.add_shopping_cart),
          //         //   color: Colors.black,
          //         //   onPressed: () {},
          //         // ),
          //         // IconButton(
          //         //   icon: Icon(Icons.account_box),
          //         //   color: Colors.black,
          //         //   onPressed: () {},
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),

          // body: IndexedStack(
          //   children: _screens,
          //   index: _selectedIndex,
          // ),
          body: PageView(
            physics: Provider.of<LeftSwipe>(context).isSwipe
                ? AlwaysScrollableScrollPhysics()
                : NeverScrollableScrollPhysics(),
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: _screens,
            reverse: true,
          )),
    );
  }
}
