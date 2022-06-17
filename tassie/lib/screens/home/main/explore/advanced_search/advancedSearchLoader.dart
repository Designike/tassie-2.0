import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/explore/advanced_search/advancedSearch.dart';
import 'package:tassie/screens/home/main/explore/explorePost.dart';
import 'package:tassie/screens/home/main/explore/exploreRec.dart';
import 'package:tassie/screens/home/main/explore/search/searchBar.dart';
import 'package:tassie/screens/home/main/explore/search/viewHashtag.dart';

class AdvancedSearchLoader extends StatefulWidget {
  const AdvancedSearchLoader({Key? key, required this.size}) : super(key: key);
  final Size size;

  @override
  AdvancedSearchLoaderState createState() => AdvancedSearchLoaderState();
}

class AdvancedSearchLoaderState extends State<AdvancedSearchLoader> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  double width = 0;
  double marg = 0;
  double marg2 = 0;
  double rad = 0;

  Future<void> animate() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      marg2 = widget.size.width * 0.55;
      width = 0;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      width = widget.size.height * 2;
      marg = widget.size.height;
      marg2 = 0;
      rad = 0;
    });
    await Future.delayed(Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: false).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return AdvancedSearch();
      }),
    );
  }

  @override
  void initState() {
    width = widget.size.width * 0.4;
    marg = 0;
    rad = widget.size.width;
    super.initState();
    animate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Hero(
              tag: "cooker",
              child: AnimatedContainer(
                // padding: EdgeInsets.all(5.0),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.fastOutSlowIn,
                width: width,
                height: width,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? kDark[900]
                        : kLight,
                    borderRadius: BorderRadius.circular(rad)),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 1100),
              curve: Curves.bounceOut,
              margin: EdgeInsets.only(top: marg, bottom: marg2),
              child: Lottie.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/cooker_dark.json'
                    : 'assets/images/cooker_light.json',
                width: size.width * 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
