import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/screens/home/main/recs/recChild.dart';

import '../../../../constants.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);
  @override
  RecipesState createState() => RecipesState();
}

class RecipesState extends State<Recipes> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // recs to be fetched from api
  // List recs = [];
  // List<Map> recs = [
  //   {"name": "Paneer Tikka", "user": "Sommy21", "url": "https://picsum.photos/200", "profilePic": "https://picsum.photos/200"},
  //   {"name": "Dhokla", "user": "parthnamdev", "url": "https://picsum.photos/200", "profilePic": "https://picsum.photos/200"},
  //   {"name": "Khamman", "user": "rishabh", "url": "https://picsum.photos/200", "profilePic": "https://picsum.photos/200"}
  // ];
  final ScrollController _sc = ScrollController();
  static int page = 1;
  static List recs = [];
  static List recipeData = [];
  bool isLazyLoading = false;
  static bool isLoading = true;
  bool isEnd = false;
  final dio = Dio();
  final storage = const FlutterSecureStorage();

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: isLazyLoading ? 0.8 : 00,
          child: const CircularProgressIndicator(
            color: kPrimaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _endMessage() {
    return const Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      // ignore: unnecessary_const
      child: const Center(
        child: Opacity(
          opacity: 0.8,
          child: Text('That\'s all for now!'),
        ),
      ),
    );
  }

  void _getMoreData(int index) async {
    if (!isEnd) {
      if (!isLazyLoading) {
        if (mounted) {
          setState(() {
            isLazyLoading = true;
          });
        }
        var url = 'https://api-tassie.herokuapp.com/recs/lazyrecs/$index';
        var token = await storage.read(key: "token");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
        );
        // print(response);
        // print(response.data);
        if (response.data['data'] != null) {
          if (mounted) {
            setState(() {
              if (index == 1) {
                isLoading = false;
              }
              isLazyLoading = false;
              recs.addAll(response.data['data']['results']);
              // posts.addAll(tList);
              // print(recs);
              if (response.data['data']['recipeData'] != null) {
                recipeData.addAll(response.data['data']['recipeData']);
                // print(noOfLikes);

              }
              page++;
            });
          }
          // print(response.data['data']['posts']);
          if (response.data['data']['results'].length == 0) {
            if (mounted) {
              setState(() {
                isEnd = true;
              });
            }
          }
          // print(recs);
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
              isLazyLoading = false;
            });
          }
        }
      }
    }
  }

  Future<void> _refreshPage() async {
    if (mounted) {
      setState(() {
        page = 1;
        recs = [];
        recipeData = [];
        isEnd = false;
        isLoading = true;
        _getMoreData(page);
      });
    }
  }

  @override
  void initState() {
    page = 1;
    recs = [];
    recipeData = [];
    isEnd = false;
    isLoading = true;
    _getMoreData(page);
    super.initState();
    // load();

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return (isLoading == true)
        ? const Scaffold(
            // backgroundColor: Colors.white,
            body: Center(
              child: SpinKitThreeBounce(
                color: kPrimaryColor,
                size: 50.0,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: kToolbarHeight * 1.1,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                  statusBarIconBrightness:
                      Theme.of(context).brightness == Brightness.light
                          ? Brightness.dark
                          : Brightness.light),
              title: const Text(
                'Yumminess ahead !',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'LobsterTwo',
                  fontSize: 30.0,
                ),
              ),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: _refreshPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 10,
                    thickness: 0.5,
                  ),
                  if (recs.isNotEmpty) ...[
                    Expanded(
                      child: GridView.builder(
                        controller: _sc,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (size.width / 2) /
                              ((size.width / 2) + (size.width / 10) + 100.0),
                        ),
                        itemBuilder: (context, index) {
                          return index == recs.length
                              ? isEnd
                                  ? _endMessage()
                                  : _buildProgressIndicator()
                              // : FeedPost(index: index, posts: posts);
                              : RecPost(
                                  recs: recs[index],
                                  recipeData: recipeData[index],
                                  funcB: (isBook) {
                                    if (mounted) {
                                      setState(() {
                                        recipeData[index]['isBookmarked'] =
                                            !recipeData[index]['isBookmarked'];
                                      });
                                    }
                                  },
                                );
                          // return Container(
                          //   color: Colors.red,
                          // );
                        },
                        itemCount: recs.length,
                      ),
                    ),
                  ] else ...[
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.25,
                            ),
                            Image(
                              image:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? const AssetImage(
                                          'assets/images/no_feed_dark.png')
                                      : const AssetImage(
                                          'assets/images/no_feed_light.png'),
                              width: size.width * 0.75,
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            SizedBox(
                              width: size.width * 0.75,
                              child: const Text(
                                'Subscribe to see others\' recs.',
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
  }
}
