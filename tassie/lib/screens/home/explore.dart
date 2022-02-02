import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/explorePost.dart';
import 'package:tassie/screens/home/exploreRec.dart';
import 'package:tassie/screens/home/recPost.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  var dio = Dio();
  var storage = FlutterSecureStorage();
  List recosts_toggle = ['2', '1', '1', '1', '2', '2', '1', '1', '1', '2'];

  // List recosts = ['one', 'two', 'three', 'four', 'five', 'one', 'two', 'three', 'four', 'five'];
  List<Map> recosts = [
    {
      "username": "abhay",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "name": "Paneer Tikka",
      "username": "Sommy21",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "name": "Dhokla",
      "username": "parthnamdev",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "name": "Khamman",
      "username": "rishabh",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "username": "aryak",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "username": "hemanth",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "name": "Paneer Tikka",
      "username": "Sommy21",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "name": "Dhokla",
      "username": "parthnamdev",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "name": "Khamman",
      "username": "rishabh",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "username": "shivam",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
  ];
  Future<void> _refreshPage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // return Container(
    // child: FloatingActionButton(onPressed: () async {
    //   var token = await storage.read(key: "token");
    //   // print(formData.files[0]);
    //   Response response = await dio.post(
    //       // 'http://10.0.2.2:3000/drive/upload',
    //       'http://10.0.2.2:3000/search/guess/',
    //       options: Options(headers: {
    //         HttpHeaders.contentTypeHeader: "application/json",
    //         HttpHeaders.authorizationHeader: "Bearer " + token!
    //       }),
    //       data: {
    //         'start': 0,
    //         'veg': true,
    //         'flavour': 'Spicy',
    //         'course': 'Main course',
    //         'maxTime': 30,
    //         'ingredients': ['sev', 'Maida', 'sugar']
    //       });
    //   print(response);
    // }),
    // );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                  statusBarIconBrightness:
                      MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? Brightness.dark
                          : Brightness.light),
          toolbarHeight: kToolbarHeight * 1.2,
          title: GestureDetector(
            onTap: () {
              showSearch(context: context, delegate: SearchBar());
            },
            child: Container(
              // child: Row(
              //   children: [
              //     Text('Search ', style: TextStyle(color: kDark)),
              //     AnimatedTextKit(
              //       pause: Duration(milliseconds: 3000),
              //       repeatForever: false,
              //       animatedTexts: [
              //         FadeAnimatedText('recipes!',
              //             textStyle: TextStyle(color: kDark)),
              //         FadeAnimatedText('tassites!',
              //             textStyle: TextStyle(color: kDark)),
              //         FadeAnimatedText('posts!',
              //             textStyle: TextStyle(color: kDark)),
              //       ],
              //     ),
              //   ],
              // ),
              child: const Text('Search', style: TextStyle(color: kDark)),
              decoration: BoxDecoration(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? kDark[900]
                        : kLight,
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: size.width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchBar());
              },
              icon: const Icon(Icons.search_rounded),
            ),
          ]),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          // controller: _sc,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      // padding: EdgeInsets.all(5.0),
                      margin:
                          EdgeInsets.only(top: 50.0, bottom: kDefaultPadding),
                      width: size.width * 0.5,
                      child: Lottie.asset('assets/images/cooker.json',
                          fit: BoxFit.cover),
                      decoration: BoxDecoration(
                          color: MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? kDark[900]
                        : kLight,
                          borderRadius: BorderRadius.circular(size.width)),
                    ),
                  ),
                  Text('Tap to suggest recipe!',
                      style: TextStyle(fontSize: 16.0)),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 7.0),
                child: MasonryGridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    // mainAxisSpacing: 10,
                    // crossAxisSpacing: 10,
                    itemCount: recosts.length,
                    itemBuilder: (context, index) {
                      return recosts_toggle[index] == '1'
                          // ? Container(
                          //     height: 100.0,
                          //     color: Colors.red,
                          //   )
                          // : Container(height: 150.0, color: Colors.green);
                          ? Container(
                              child: ExploreRec(recs: recosts[index]),
                              margin: EdgeInsets.all(7.0),
                            )
                          // : ExplorePost(post: post, noOfComment: noOfComment, noOfLike: noOfLike, func: func, plusComment: plusComment, bookmark: bookmark, funcB: funcB, minusComment: minusComment);
                          : Container(
                              child: ExplorePost(post: recosts[index]),
                              margin: EdgeInsets.all(7.0),
                            );
                    }),
              ),
            ),
          ],
          // ),
        ),
      ),
    );
  }
}

class SearchBar extends SearchDelegate<String> {
  final suggestions = ['paneer', 'sandwich', 'pani puri'];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = suggestions;
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionsList[index]),
          subtitle: Text(
            suggestionsList[index],
            style: TextStyle(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? kLight
                        : kDark[900]),
          ),
          leading: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50.0,
                width: 50.0,
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      itemCount: suggestionsList.length,
    );
  }
}
