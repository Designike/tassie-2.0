// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/add.dart';
import 'package:tassie/screens/home/explore.dart';
import 'package:tassie/screens/home/feed.dart';
import 'package:tassie/screens/home/profile.dart';
import 'package:tassie/screens/home/recipes.dart';
import 'package:tassie/screens/wrapper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  PageController _pageController = PageController();
  List<Widget> _screens = []; 
 
  // double _angle = 0;

  @override
  void initState() {
    super.initState();
    //  AnimationController animatedController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    //  animatedController.addListener(() {
    //   setState(() {
    //     _angle = animatedController.value * 45 / 360 * pi * 2;
    //   });
    _selectedIndex = 0;
    _screens = [
    Feed(),
    Recipes(),
    // Add(),
    Explore(),
    Profile(),
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
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        elevation: 0,
        spacing: 15.0,
        foregroundColor: kDark[900],
        backgroundColor: kPrimaryColor,
        icon: Icons.add_rounded,
        activeIcon: Icons.close_rounded,
        // onOpen: () => animatedController.reverse(),
        // onClose: () => animatedController.forward(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.post_add_rounded),
            label: 'New Post',

          ),
          SpeedDialChild(
            child: Icon(Icons.fastfood_rounded),
            label: 'New Recipe',

          ),

        ],
      ),
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
      bottomNavigationBar: BottomAppBar(
        
          shape: CircularNotchedRectangle(),
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? kDark[900]
              : kLight,
          notchMargin: 6.0,
          child: Container(
            height: 65.0,            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () {
                    setState(() {
          _selectedIndex = 0;
          _pageController.jumpToPage(0);
        });
            
        // ignore: prefer_const_literals_to_create_immutables
        },
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
        children: [
            Icon(Icons.feed, color: _selectedIndex == 0 ? kPrimaryColor : kDark), Text('Feed', style: TextStyle(color: _selectedIndex == 0 ? MediaQuery.of(context).platformBrightness == Brightness.light ? kDark[900] : kLight : kDark),),
        ],
        ),
        ),
        MaterialButton(
                  onPressed: () {
            setState(() {
          _selectedIndex = 1;
          _pageController.jumpToPage(1);
        });
        // ignore: prefer_const_literals_to_create_immutables
        },child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
            Icon(Icons.restaurant, color: _selectedIndex == 1 ? kPrimaryColor : kDark), Text('Recs', style: TextStyle(color: _selectedIndex == 1 ? MediaQuery.of(context).platformBrightness == Brightness.light ? kDark[900] : kLight : kDark),),
        ],),),
        SizedBox(width: 40.0,),
        MaterialButton(
                  onPressed: () {
           setState(() {
          _selectedIndex = 2;
          _pageController.jumpToPage(2);
        });
        // ignore: prefer_const_literals_to_create_immutables
        },child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
            Icon(Icons.search, color: _selectedIndex == 2 ? kPrimaryColor : kDark), Text('Explore', style: TextStyle(color: _selectedIndex == 2 ? MediaQuery.of(context).platformBrightness == Brightness.light ? kDark[900] : kLight : kDark),),
        ],),),
        MaterialButton(
                  onPressed: () {
            setState(() {
          _selectedIndex = 3;
          _pageController.jumpToPage(3);
        });
        // ignore: prefer_const_literals_to_create_immutables
        },child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
            Icon(Icons.person_rounded, color: _selectedIndex == 3 ? kPrimaryColor : kDark), Text('Profile', style: TextStyle(color: _selectedIndex == 3 ? MediaQuery.of(context).platformBrightness == Brightness.light ? kDark[900] : kLight : kDark),),
        ],),),
                // IconButton(
                //   icon: Icon(Icons.feed),
                //   color: Colors.black,
                //   onPressed: () {},
                // ),
                // IconButton(
                //   icon: Icon(Icons.search),
                //   color: Colors.black,
                //   onPressed: () {},
                // ),
                // SizedBox(
                //   width: 40,
                // ),
                // IconButton(
                //   icon: Icon(Icons.add_shopping_cart),
                //   color: Colors.black,
                //   onPressed: () {},
                // ),
                // IconButton(
                //   icon: Icon(Icons.account_box),
                //   color: Colors.black,
                //   onPressed: () {},
                // ),
              ],
            ),
          ),),
      // body: IndexedStack(
      //   children: _screens,
      //   index: _selectedIndex,
      // ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _screens,
      )
    );
  }
}
