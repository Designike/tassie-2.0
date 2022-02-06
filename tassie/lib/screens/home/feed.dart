// ignore_for_file: prefer_const_constructors,avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/feedPost.dart';
import 'package:tassie/screens/home/profile.dart';
import 'package:tassie/screens/wrapper.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // List<Map> posts = [
  //   {"name": "Soham", "time": "30 mins", "image": "https://picsum.photos/200"},
  //   {"name": "Soham", "time": "30 mins", "image": "https://picsum.photos/200"},
  //   {"name": "Soham", "time": "30 mins", "image": "https://picsum.photos/200"}
  // ];
  static int page = 1;
  final ScrollController _sc = ScrollController();
  static List posts = [];
  static List noOfComments = [];
  static List noOfLikes = [];
  static List bookmark = [];
  bool isLazyLoading = false;
  static bool isLoading = true;
  bool isEnd = false;
  final dio = Dio();
  final storage = FlutterSecureStorage();
  // Future<void> load() async {
  //   var token = await storage.read(key: "token");
  //   // try {http://10.0.2.2:3000/feed/
  //   Response response = await dio.post("http://10.0.2.2:3000/feed/",
  //       options: Options(headers: {
  //         HttpHeaders.contentTypeHeader: "application/json",
  //         HttpHeaders.authorizationHeader: "Bearer " + token!
  //       }),
  //       data: {});

  //   // to fix error
  //   if (response.data['data'] != null) {
  //     print(response.data['data']['post']);

  //     posts = response.data['data']['post'][0];
  //   } else {
  //     posts = [];
  //   }
  //   if (response.data['data']['nameList'] != null) {
  //     nameList = response.data['data']['nameList'];
  //   } else {
  //     nameList = [];
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // } on DioError catch (e) {
  //   if (e.response!.statusCode == 401 &&
  //       e.response!.statusMessage == "Unauthorized") {
  //     await storage.delete(key: "token");
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) {
  //         return Wrapper();
  //       }),
  //     );
  //   } else {
  //     print(e);
  //   }
  // } catch (e) {
  //   print(e);
  // }
  // }

  void _getMoreData(int index) async {
    if (!isEnd) {
      if (!isLazyLoading) {
        print('calling...');
        setState(() {
          isLazyLoading = true;
        });
        // var url = "http://10.0.2.2:3000/feed/lazyfeed/" +
        //     index.toString();
        var url = "http://10.0.2.2:3000/feed/lazyfeed/" + index.toString();

        var token = await storage.read(key: "token");
        // print(token);
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer " + token!
          }),
        );
        // List tList = [];
        if (response.data['data']['posts'] != null) {
          //   for (int i = 0;
          //       i < response.data['data']['posts']['results'].length;
          //       i++) {
          //     tList.add(response.data['data']['posts']['results'][i]);
          //   }
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
              print(noOfLikes);
            }
            if (response.data['data']['posts']['bookmarks'] != null) {
              bookmark.addAll(response.data['data']['posts']['bookmarks']);
              print(noOfLikes);
            }
            page++;
          });
          // print(response.data['data']['posts']);
          if (response.data['data']['posts']['results'].length == 0) {
            setState(() {
              isEnd = true;
            });
          }
        } else {
          setState(() {
            isLoading = false;
            isLazyLoading = false;
          });
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
          child: CircularProgressIndicator(
            color: kPrimaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _endMessage() {
    print(isEnd);
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

  Future<void> _refreshPage() async {
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

  @override
  void initState() {
  posts = [];
  noOfComments = [];
  noOfLikes = [];
  bookmark = [];
  page=1;
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
        ? Scaffold(
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
                      MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? Brightness.dark
                          : Brightness.light),
              title: Text(
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
                  Divider(
                    height: 10,
                    thickness: 0.5,
                  ),
                  if (posts.length > 0) ...[
                    Expanded(
                      // child: ListView.builder(
                      //     itemCount: posts.length,
                      //     itemBuilder: (context, index) {
                      //       return FeedPost(
                      //           index: index, posts: posts, nameList: nameList);
                      //     }),
                      child: ListView.builder(
                        itemCount: posts.length + 1,
                        itemBuilder: (context, index) {
                          return index == posts.length
                              ? isEnd
                                  ? _endMessage()
                                  : _buildProgressIndicator()
                              : FeedPost(
                                  post: posts[index],
                                  noOfComment: noOfComments[index],
                                  noOfLike: noOfLikes[index],
                                  plusComment: () {
                                    setState(() {
                                      noOfComments[index]['count'] += 1;
                                    });
                                  },
                                  func: (islike) {
                                    setState(() {
                                      if (islike) {
                                        noOfLikes[index]['count'] += 1;
                                      } else {
                                        noOfLikes[index]['count'] -= 1;
                                      }
                                      noOfLikes[index]['isLiked'] =
                                          !noOfLikes[index]['isLiked'];
                                    });
                                  },
                                  bookmark: bookmark[index],
                                  funcB: (isBook) {
                                    setState(() {
                                      bookmark[index]['isBookmarked'] =
                                          !bookmark[index]['isBookmarked'];
                                    });
                                  },minusComment: () {
                                    setState(() {
                                      noOfComments[index]['count'] -= 1;
                                    });
                                  },
                                );
                        },
                        controller: _sc,
                      ),
                    ),
                  ] else ...[
                    // isEnd ? _endMessage() : SizedBox(height: 1.0),

                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.25,
                            ),
                            Image(
                              image: MediaQuery.of(context)
                                          .platformBrightness ==
                                      Brightness.dark
                                  ? AssetImage('assets/images/no_feed_dark.png')
                                  : AssetImage(
                                      'assets/images/no_feed_light.png'),
                              width: size.width * 0.75,
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            SizedBox(
                              width: size.width * 0.75,
                              child: Text(
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
