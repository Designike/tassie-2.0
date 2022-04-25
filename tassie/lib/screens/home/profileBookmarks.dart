// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';

class ProfileBookmarks extends StatefulWidget {
  const ProfileBookmarks({Key? key}) : super(key: key);

  @override
  _ProfileBookmarksState createState() => _ProfileBookmarksState();
}

class _ProfileBookmarksState extends State<ProfileBookmarks> {
  var dio = Dio();
  final storage = FlutterSecureStorage();
  List posts = [];
  List recs = [];
  static int page = 1;
  bool isLazyLoadingR = false;
  bool isLazyLoadingP = false;
  bool isEndR = false;
  bool isEndP = false;
  bool isLoading = true;

  Future<void> _refreshPage() async {
    setState(() {
      // page = 1;
      page = 1;
      recs = [];
      posts = [];
      isLazyLoadingR = false;
      isLazyLoadingP = false;
      isEndR = false;
      isEndP = false;
      isLoading = true;
      getBookmarks();

      // recosts_toggle = [];
      // isEnd = false;
      // isLoading = true;
      // _getRecosts(page);
    });
  }

  Future<void> getBookmarks() async {
    var url = "https://api-tassie-alt.herokuapp.com/profile/lazyBookmark/" +
        page.toString();
    var token = await storage.read(key: "token");
    Response response = await dio.get(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer " + token!
      }),
    );
    if (response.data['data'] != null) {
      setState(() {
        if (page == 1) {
          isLoading = false;
        }
        isLazyLoadingR = false;
        isLazyLoadingP = false;
        // posts.addAll(tList);
        // print(recs);
        if (response.data['data']['recs'] != null) {
          recs.addAll(response.data['data']['recs']);
          // print(noOfLikes);
        }
        if (response.data['data']['posts'] != null) {
          posts.addAll(response.data['data']['posts']);
          // print(noOfLikes);
        }
        isLoading = false;
        page++;
      });
      // print(response.data['data']['posts']);
      if (response.data['data']['recs'] == null) {
        setState(() {
          isEndR = true;
        });
      }
      if (response.data['data']['posts'] == null) {
        setState(() {
          isEndP = true;
        });
      }

      // print(recs);
    } else {
      setState(() {
        isLoading = false;
        isLazyLoadingR = false;
        isLazyLoadingP = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: 1,
          child: CircularProgressIndicator(
            color: kPrimaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _endMessage() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: 0.8,
          child: Text('That\'s all for now!'),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    page = 1;
    recs = [];
    posts = [];
    isLazyLoadingR = false;
    isLazyLoadingP = false;
    isEndR = false;
    isEndP = false;
    isLoading = true;
    getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          physics: AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, isScrollable) {
            return [
              SliverAppBar(
                elevation: 0,
                // forceElevated: isScrollable,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? kLight
                    : kDark[900],
                title: Text('Your bookmarks'),
                // actions: [
                //   IconButton(
                //     icon: Icon(Icons.clear_rounded),
                //     onPressed: () {
                //       // clear query
                //     },
                //   ),

                // ],
                bottom: TabBar(
                  indicatorColor: kPrimaryColor,
                  unselectedLabelColor: kDark,
                  labelColor: Theme.of(context).brightness == Brightness.dark
                      ? kLight
                      : kDark[900],
                  tabs: [
                    Tab(icon: Icon(Icons.photo_rounded)),
                    Tab(
                      icon: Icon(Icons.fastfood_rounded),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: isLoading
              ? _buildProgressIndicator()
              : TabBarView(
                  children: [
                    RefreshIndicator(
                      onRefresh: _refreshPage,
                      child: ListView(
                        children: [
                          posts.length > 0
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  // controller: _sc,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                    // childAspectRatio: (size.width / 2) /
                                    //     ((size.width / 2) + (size.width / 10) + 100.0),
                                  ),
                                  itemBuilder: (context, index) {
                                    return index == posts.length
                                        ? isEndP
                                            ? _endMessage()
                                            : _buildProgressIndicator()
                                        // : FeedPost(index: index, posts: posts);
                                        : Image.network(posts[index]['url']);
                                    // return Container(
                                    //   color: Colors.red,
                                    // );
                                  },
                                  itemCount: posts.length,
                                )
                              : Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(size.width * 0.15),
                                    child: Text(
                                      'No posts saved',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: _refreshPage,
                      child: ListView(
                        children: [
                          recs.length > 0
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  // controller: _sc,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                    // childAspectRatio: (size.width / 2) /
                                    //     ((size.width / 2) + (size.width / 10) + 100.0),
                                  ),
                                  itemBuilder: (context, index) {
                                    return index == recs.length
                                        ? isEndR
                                            ? _endMessage()
                                            : _buildProgressIndicator()
                                        // : FeedPost(index: index, posts: posts);
                                        : Image.network(recs[index]['url']);
                                    // return Container(
                                    //   color: Colors.red,
                                    // );
                                  },
                                  itemCount: recs.length,
                                )
                              : Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(size.width * 0.15),
                                    child: Text(
                                      'No recipes saved',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
