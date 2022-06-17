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
import 'package:tassie/utils/snackbar.dart';

class ViewHashtag extends StatefulWidget {
  const ViewHashtag({Key? key, required this.tag}) : super(key: key);
  final String tag;
  @override
  ViewHashtagState createState() => ViewHashtagState();
}

class ViewHashtagState extends State<ViewHashtag>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _sc = ScrollController();
  static int page = 1;
  static List recosts = [];
  static List recostsData = [];
  static List recostsToggle = [];
  int previousLength = 0;
  bool isLazyLoading = false;
  bool isLoading = true;
  bool isEnd = false;
  final dio = Dio();
  final storage = const FlutterSecureStorage();

  void _getRecosts(int index) async {
    if (!isEnd) {
      if (!isLazyLoading) {
        if (mounted) {
          setState(() {
            isLazyLoading = true;
          });
        }
        var url =
            "https://api-tassie.herokuapp.com/search/lazyHashtag/${index.toString()}/${previousLength.toString()}/${widget.tag}";
        var token = await storage.read(key: "token");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
        );
        print(response);
        if (response.data['data'] != null) {
          if (response.data['data']['status'] == true) {
          if (mounted) {
            setState(() {
              if (index == 1) {
                isLoading = false;
              }
              isLazyLoading = false;
              recosts.addAll(response.data['data']['results']);
              // posts.addAll(tList);
              // print(recs);
              if (response.data['data']['data'] != null) {
                recostsData.addAll(response.data['data']['data']);
                // print(recostsData);
              }
              if (response.data['data']['indices'] != null) {
                recostsToggle.addAll(response.data['data']['indices']);
                // print(noOfLikes);

              }
              previousLength = (response.data['data']['results']).length;
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
          showSnack(context, response.data['message'] , (){}, 'OK', 3);
          if (mounted) {
            setState(() {
              isLoading = false;
              isLazyLoading = false;
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
      }
    }
  }

  Future<void> _refreshPage() async {
    if (mounted) {
      setState(() {
        page = 1;
        recosts = [];
        recostsData = [];
        recostsToggle = [];
        isEnd = false;
        isLoading = true;
        _getRecosts(page);
      });
    }
  }

  @override
  void initState() {
    page = 1;
    recosts = [];
    recostsToggle = [];
    recostsData = [];
    isEnd = false;
    isLoading = true;
    _getRecosts(page);
    super.initState();
    // load();

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getRecosts(page);
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? kLight
                  : kDark[900],
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                statusBarIconBrightness:
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light,
              ),
              toolbarHeight: kToolbarHeight * 1.2,
              title: const Text(
                'What\'s on trend!',
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
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _sc,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // const SizedBox(height: 50.0),
                        Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: Center(
                              child: Text(
                            '#${widget.tag}',
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? kLight
                                    : kDark[900],
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          )),
                        ),
                        // Text('Tap to suggest recipe!',
                        //     style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 50.0, horizontal: 7.0),
                      child: MasonryGridView.count(
                          cacheExtent: size.height * 2.5,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          // mainAxisSpacing: 10,
                          // crossAxisSpacing: 10,
                          itemCount: recosts.length,
                          itemBuilder: (context, index) {
                            return recosts[recostsToggle[index]]['isPost'] ==
                                    false
                                // ? Container(
                                //     height: 100.0,
                                //     color: Colors.red,
                                //   )
                                // : Container(height: 150.0, color: Colors.green);
                                ? Container(
                                    margin: const EdgeInsets.all(7.0),
                                    child: ExploreRec(
                                      recs: recosts[recostsToggle[index]],
                                      recostData:
                                          recostsData[recostsToggle[index]],
                                      funcB: (isBook) {
                                        if (mounted) {
                                          setState(() {
                                            recostsData[recostsToggle[index]]
                                                ['isBookmarked'] = !recostsData[
                                                    recostsToggle[index]]
                                                ['isBookmarked'];
                                          });
                                        }
                                      },
                                    ),
                                  )
                                // : ExplorePost(post: post, noOfComment: noOfComment, noOfLike: noOfLike, func: func, plusComment: plusComment, bookmark: bookmark, funcB: funcB, minusComment: minusComment);
                                : Container(
                                    margin: const EdgeInsets.all(7.0),
                                    child: ExplorePost(
                                      post: recosts[recostsToggle[index]],
                                      // recostData:
                                      //   recostsData[recosts_toggle[index]],
                                      noOfLike:
                                          recostsData[recostsToggle[index]]
                                              ['likes'],
                                      noOfComment:
                                          recostsData[recostsToggle[index]]
                                              ['comments'],
                                      isLiked: recostsData[recostsToggle[index]]
                                          ['isLiked'],
                                      funcB: (isBook) {
                                        if (mounted) {
                                          setState(() {
                                            recostsData[recostsToggle[index]]
                                                ['isBookmarked'] = !recostsData[
                                                    recostsToggle[index]]
                                                ['isBookmarked'];
                                          });
                                        }
                                      },
                                      plusComment: () {
                                        if (mounted) {
                                          setState(() {
                                            recostsData[recostsToggle[index]]
                                                ['comments'] += 1;
                                          });
                                        }
                                      },
                                      func: (islike) {
                                        if (mounted) {
                                          setState(() {
                                            if (islike) {
                                              recostsData[recostsToggle[index]]
                                                  ['likes'] += 1;
                                            } else {
                                              recostsData[recostsToggle[index]]
                                                  ['likes'] -= 1;
                                            }
                                            recostsData[recostsToggle[index]]
                                                ['isLiked'] = !recostsData[
                                                    recostsToggle[index]]
                                                ['isLiked'];
                                          });
                                        }
                                      },
                                      bookmark:
                                          recostsData[recostsToggle[index]]
                                              ['isBookmarked'],
                                      // funcB: (isBook) {
                                      //   setState(() {
                                      //     recostsData[recosts_toggle[index]]['isBookmarked'] =
                                      //         !recostsData[recosts_toggle[index]]['isBookmarked'];
                                      //   });
                                      // },
                                      minusComment: () {
                                        if (mounted) {
                                          setState(() {
                                            recostsData[recostsToggle[index]]
                                                ['comments'] -= 1;
                                          });
                                        }
                                      },
                                    ),
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
