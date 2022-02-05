// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/bookmarksPage.dart';
import 'package:tassie/screens/home/editProfile.dart';
import 'package:tassie/screens/home/profilePostTab.dart';
import 'package:tassie/screens/home/settings.dart';
import 'package:tassie/screens/home/showMoreText.dart';
import 'package:tassie/screens/home/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../wrapper.dart';
import 'profileRecipeTab.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var dio = Dio();
  final storage = FlutterSecureStorage();

  void _launchURL(url) async {
    try {
      if (!await launch(url)) {
        showSnack(context, 'Could not launch $url', () {}, 'OK', 4);
      }
    } catch (e) {
      showSnack(context, 'Unable to open url', () {}, 'OK', 4);
    }
  }

  Future<void> _refreshPage() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('tassie'),
    //     actions: [
    //       IconButton(
    //         icon: Icon(Icons.logout),
    //         onPressed: () async {
    //           var token = await storage.read(key: "token");
    //           print('1');
    //           Response response = await dio.get(
    //             "http://10.0.2.2:3000/user/logout/",
    //             options: Options(headers: {
    //               HttpHeaders.contentTypeHeader: "application/json",
    //               HttpHeaders.authorizationHeader: "Bearer " + token!
    //             }),
    //           );
    //           print('1.1');
    //           await storage.delete(key: "token");
    //           print('1.1.1');
    //           Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(builder: (context) {
    //               return Wrapper();
    //             }),
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );
    return DefaultTabController(
      length: 2,
      child: RefreshIndicator(
        onRefresh: _refreshPage,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'parthnamdev',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.bookmark_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BookmarksPage();
                    }),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return SettingsPage();
                    }),
                  );
                },
              ),
            ],
          ),
          body: NestedScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            headerSliverBuilder: (context, isScrollable) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      Center(
                        child: Stack(
                          children: [
                            ClipOval(
                              child: Material(
                                child: Ink.image(
                                  height: 128,
                                  width: 128,
                                  image:
                                      NetworkImage('https://picsum.photos/200'),
                                  fit: BoxFit.cover,
                                  child: InkWell(
                                    onTap: () {},
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: ClipOval(
                                child: Container(
                                  padding: EdgeInsets.all(4.0),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: ClipOval(
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      color: kPrimaryColor,
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.15, vertical: 30.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '237',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text('Posts'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '237',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text('Recipes'),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              height: 50.0,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text('3930',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text('Subscribers'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('40',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text('Subscribed'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Name and bio
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'koko',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: ShowMoreText(
                                  text:
                                      'I create yummy recipe henlo hi nike noice'),
                            ),
                            SizedBox(height: 10.0),
                            // Text(
                            //   'm.youtube.com/mitchkoko/',
                            //   style: TextStyle(color: Colors.blue),
                            //   overflow: TextOverflow.ellipsis,
                            //   maxLines: 1,
                            // ),
                            RichText(
                              text: TextSpan(
                                text:
                                    'https://www.youtube.com/channel/UCMKbJiTDOyBcTQZjDtRMdWA',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchURL(
                                        'https://www.youtube.com/channel/UCMKbJiTDOyBcTQZjDtRMdWA');
                                  },
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(child: Text('Edit Profile')),
                                  decoration: BoxDecoration(
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? kDark[900]
                                          : kLight,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // stories
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
                      //   child: Container(
                      //     height: 110,
                      //     child: ListView(
                      //       scrollDirection: Axis.horizontal,
                      //       children: [
                      //         BubbleStories(text: 'story 1'),
                      //         BubbleStories(text: 'story 2'),
                      //         BubbleStories(text: 'story 3'),
                      //         BubbleStories(text: 'story 4'),
                      //         BubbleStories(text: 'story 5'),
                      //         BubbleStories(text: 'story 6'),
                      //         BubbleStories(text: 'story 7'),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      TabBar(
                        indicatorColor: kPrimaryColor,
                        tabs: [
                          Tab(icon: Icon(Icons.photo_rounded)),
                          Tab(
                            icon: Icon(Icons.fastfood_rounded),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.0,
                      )
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                PostTab(),
                RecipeTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
