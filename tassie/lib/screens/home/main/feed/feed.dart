import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/authenticate/authenticate.dart';
import 'package:tassie/screens/home/main/feed/feedChild.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);
  @override
  FeedState createState() => FeedState();
}

class FeedState extends State<Feed> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  static int page = 1;
  final ScrollController _sc = ScrollController();
  static List posts = [];
  static List noOfComments = [];
  static List noOfLikes = [];
  static List bookmark = [];
  // static List images = [];
  bool isLazyLoading = false;
  static bool isLoading = true;
  bool isEnd = false;
  final dio = Dio();
  final storage = const FlutterSecureStorage();

  void _getMoreData(int index) async {
    // Provider.of<LeftSwipe>(context, listen: false).setSwipe(true);
    if (!isEnd) {
      if (mounted && !isLazyLoading) {
        setState(() {
          isLazyLoading = true;
        });
        // var url = "https://api-tassie.herokuapp.com/feed/lazyfeed/" +
        //     index.toString();
        var url = "https://api-tassie.herokuapp.com/feed/lazyfeed/$index";

        var token = await storage.read(key: "token");
        // print(token);
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
        );
        // List tList = [];
        if (response.data['status'] == true) {
          if (response.data['data']['posts'] != null) {
            if (mounted) {
              setState(() {
                if (index == 1) {
                  isLoading = false;
                }
                isLazyLoading = false;
                posts.addAll(response.data['data']['posts']['results']);
                // posts.addAll(tList);
                if (response.data['data']['posts']['noOfComments'] != null) {
                  noOfComments
                      .addAll(response.data['data']['posts']['noOfComments']);
                }
                if (response.data['data']['posts']['noOfLikes'] != null) {
                  noOfLikes.addAll(response.data['data']['posts']['noOfLikes']);
                }
                if (response.data['data']['posts']['bookmarks'] != null) {
                  bookmark.addAll(response.data['data']['posts']['bookmarks']);
                }
                page++;
              });
            }
            // print(response.data['data']['posts']);
            if (response.data['data']['posts']['results'].length == 0) {
              if (mounted) {
                setState(() {
                  isEnd = true;
                });
              }
            }
          } else {
            if (mounted) {
              setState(() {
                isLoading = false;
                isLazyLoading = false;
              });
            }
          }
        } else {
          await storage.delete(key: "token");
          // await Future.delayed(const Duration(seconds: 1));

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return const Authenticate();
            }),
          );
        }
      }
    }
  }

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
      child: Center(
        child: Opacity(
          opacity: 0.8,
          child: Text('That\'s all for now!'),
        ),
      ),
    );
  }

  Future<void> _refreshPage() async {
    if (mounted) {
      setState(() {
        page = 1;
        posts = [];
        noOfComments = [];
        noOfLikes = [];
        bookmark = [];
        isEnd = false;
        isLoading = true;
        _getMoreData(page);
      });
    }
  }

  @override
  void initState() {
    posts = [];
    noOfComments = [];
    noOfLikes = [];
    bookmark = [];
    page = 1;
    isLoading = true;
    isEnd = false;
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
            body: RefreshIndicator(
              onRefresh: _refreshPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 10,
                    thickness: 0.5,
                  ),
                  if (posts.isNotEmpty) ...[
                    Expanded(
                      // child: ListView.builder(
                      //     itemCount: posts.length,
                      //     itemBuilder: (context, index) {
                      //       return FeedPost(
                      //           index: index, posts: posts, nameList: nameList);
                      //     }),
                      child: ListView.builder(
                        cacheExtent:size.height * 4,
                        itemCount: posts.length + 1,
                        itemBuilder: (context, index) {
                          return index == posts.length
                              ? isEnd
                                  ? _endMessage()
                                  : _buildProgressIndicator()
                              : FeedPost(
                                  // image: images[index],
                                  post: posts[index],
                                  noOfComment: noOfComments[index],
                                  noOfLike: noOfLikes[index],
                                  plusComment: () {
                                    if (mounted) {
                                      setState(() {
                                        noOfComments[index]['count'] += 1;
                                      });
                                    }
                                  },
                                  func: (islike) {
                                    if (mounted) {
                                      setState(() {
                                        if (islike) {
                                          noOfLikes[index]['count'] += 1;
                                        } else {
                                          noOfLikes[index]['count'] -= 1;
                                        }
                                        noOfLikes[index]['isLiked'] =
                                            !noOfLikes[index]['isLiked'];
                                      });
                                    }
                                  },
                                  bookmark: bookmark[index],
                                  funcB: (isBook) {
                                    if (mounted) {
                                      setState(() {
                                        bookmark[index]['isBookmarked'] =
                                            !bookmark[index]['isBookmarked'];
                                      });
                                    }
                                  },
                                  minusComment: () {
                                    if (mounted) {
                                      setState(() {
                                        noOfComments[index]['count'] -= 1;
                                      });
                                    }
                                  },
                                );
                        },
                        controller: _sc,
                      ),
                    ),
                  ] else ...[
                    // isEnd ? _endMessage() : SizedBox(height: 1.0),

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
                                  Theme.of(context).brightness ==
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
                                'Hey! Subscribe other Tassites to get them in feed.',
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
  }
}
