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
import 'package:tassie/screens/home/advancedSearch.dart';
import 'package:tassie/screens/home/explorePost.dart';
import 'package:tassie/screens/home/exploreRec.dart';
import 'package:tassie/screens/home/exploreSearchHashtagTab.dart';
import 'package:tassie/screens/home/exploreSearchRecipeTab.dart';
import 'package:tassie/screens/home/exploreSearchUserTab.dart';
import 'package:tassie/screens/home/recPost.dart';
import 'package:tassie/screens/home/searchBar.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _sc = ScrollController();
  static int page = 1;
  static List recosts = [];
  static List recostsData = [];
  static List recosts_toggle = [];
  int previousLength = 0;
  bool isLazyLoading = false;
  bool isLoading = true;
  bool isEnd = false;
  final dio = Dio();
  final storage = FlutterSecureStorage();

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

  // List recosts_toggle = ['2', '1', '1', '1', '2', '2', '1', '1', '1', '2'];

  // List recosts = ['one', 'two', 'three', 'four', 'five', 'one', 'two', 'three', 'four', 'five'];
  // List<Map> recosts = [
  //   {
  //     "username": "abhay",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "name": "Paneer Tikka",
  //     "username": "Sommy21",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "name": "Dhokla",
  //     "username": "parthnamdev",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "name": "Khamman",
  //     "username": "rishabh",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "username": "aryak",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "username": "hemanth",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "name": "Paneer Tikka",
  //     "username": "Sommy21",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "name": "Dhokla",
  //     "username": "parthnamdev",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "name": "Khamman",
  //     "username": "rishabh",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "username": "shivam",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  // ];

  void _getRecosts(int index) async {
    if (!isEnd) {
      if (!isLazyLoading) {
        print('calling...');
        setState(() {
          isLazyLoading = true;
        });
        var url = "http://10.0.2.2:3000/search/lazyExplore/" + index.toString()+'/'+previousLength.toString();
        var token = await storage.read(key: "token");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer " + token!
          }),
        );
        // print(response);
        // print(response.data);
        if (response.data['data'] != null) {
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
              recosts_toggle.addAll(response.data['data']['indices']);
              // print(noOfLikes);

            }
            previousLength = (response.data['data']['results']).length;
            page++;
          });
          // print(response.data['data']['posts']);
          if (response.data['data']['results'].length == 0) {
            setState(() {
              isEnd = true;
            });
          }
          // print(recs);
        } else {
          setState(() {
            isLoading = false;
            isLazyLoading = false;
          });
        }
      }
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      page = 1;
      recosts = [];
      recostsData = [];
      recosts_toggle = [];
      isEnd = false;
      isLoading = true;
      _getRecosts(page);
    });
  }

  @override
  void initState() {
    page = 1;
    recosts = [];
    recosts_toggle = [];
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
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ))
        : Scaffold(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SearchBar();
                      }),
                    );
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
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? kDark[900]
                          : kLight,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: size.width * 0.8,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SearchBar();
                        }),
                      );
                    },
                    icon: const Icon(Icons.search_rounded),
                  ),
                ]),
            body: RefreshIndicator(
              onRefresh: _refreshPage,
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _sc,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return AdvancedSearch();
                                }),
                              );
                            },
                            child: Container(
                              // padding: EdgeInsets.all(5.0),
                              margin: EdgeInsets.only(
                                  top: 50.0, bottom: kDefaultPadding),
                              width: size.width * 0.5,
                              child: Lottie.asset('assets/images/cooker.json',
                                  fit: BoxFit.cover),
                              decoration: BoxDecoration(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? kDark[900]
                                      : kLight,
                                  borderRadius:
                                      BorderRadius.circular(size.width)),
                            ),
                          ),
                        ),
                        Text('Tap to suggest recipe!',
                            style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 50.0, horizontal: 7.0),
                      child: MasonryGridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          // mainAxisSpacing: 10,
                          // crossAxisSpacing: 10,
                          itemCount: recosts.length,
                          itemBuilder: (context, index) {
                            return recosts[recosts_toggle[index]]['isPost'] ==
                                    false
                                // ? Container(
                                //     height: 100.0,
                                //     color: Colors.red,
                                //   )
                                // : Container(height: 150.0, color: Colors.green);
                                ? Container(
                                    child: ExploreRec(
                                      recs: recosts[recosts_toggle[index]],
                                      recostData:
                                          recostsData[recosts_toggle[index]],
                                      funcB: (isBook) {
                                        setState(() {
                                          recostsData[recosts_toggle[index]]
                                              ['isBookmarked'] = !recostsData[
                                                  recosts_toggle[index]]
                                              ['isBookmarked'];
                                        });
                                      },
                                    ),
                                    margin: EdgeInsets.all(7.0),
                                  )
                                // : ExplorePost(post: post, noOfComment: noOfComment, noOfLike: noOfLike, func: func, plusComment: plusComment, bookmark: bookmark, funcB: funcB, minusComment: minusComment);
                                : Container(
                                    child: ExplorePost(
                                        post: recosts[recosts_toggle[index]]),
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

// class searchBar extends SearchDelegate<String> {
//   final suggestions = ['paneer', 'sandwich', 'pani puri'];

//   static int page = 1;
//   static List recipes = [];
//   static List users = [];
//   static List tags = [];
//   bool isLazyLoading = false;
//   static bool isLoading = true;
//   bool isEnd = false;
//   final dio = Dio();
//   final storage = FlutterSecureStorage();

//   void _getRecosts(int index) async {
//     if (!isEnd) {
//       if (!isLazyLoading) {
//         print('calling...');
//         // showSuggestions(context);
//         isLazyLoading = true;
//         print(query);
//         var url = "http://10.0.2.2:3000/search/lazySearch/" +
//             index.toString() +
//             '/' +
//             query;
//         var token = await storage.read(key: "token");
//         Response response = await dio.get(
//           url,
//           options: Options(headers: {
//             HttpHeaders.contentTypeHeader: "application/json",
//             HttpHeaders.authorizationHeader: "Bearer " + token!
//           }),
//         );
//         print(response);
//         // print(response.data);
//         if (response.data['data'] != null) {
//           // setState(() {
//           if (index == 1) {
//             isLoading = false;
//           }
//           isLazyLoading = false;
//           // posts.addAll(tList);
//           // print(recs);
//           if (response.data['data']['recs'] != null) {
//             recipes.addAll(response.data['data']['recs']);
//             // print(noOfLikes);
//           }
//           if (response.data['data']['tags'] != null) {
//             tags.addAll(response.data['data']['tags']);
//             // print(noOfLikes);
//           }
//           if (response.data['data']['users'] != null) {
//             users.addAll(response.data['data']['users']);
//             // print(noOfLikes);
//           }
//           page++;
//           // });
//           // print(response.data['data']['posts']);
//           // if (response.data['data'].length == 0) {
//           //   // setState(() {
//           //   isEnd = true;
//           //   // });
//           // }
//           // print(recs);
//         } else {
//           // showSuggestions(() {
//           isLoading = false;
//           isLazyLoading = false;
//           // });
//         }
//       }
//     }
//   }

//   Widget _buildProgressIndicator() {
//     return Padding(
//       padding: const EdgeInsets.all(kDefaultPadding),
//       child: Center(
//         child: Opacity(
//           opacity: isLazyLoading ? 0.8 : 00,
//           child: CircularProgressIndicator(
//             color: kPrimaryColor,
//             strokeWidth: 2.0,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear_rounded),
//         onPressed: () {
//           query = "";
//         },
//       ),
//       IconButton(
//         icon: const Icon(Icons.search_rounded),
//         onPressed: () async {
//           page = 1;
//           _getRecosts(page);
//           // showSuggestions(context);
//         },
//       )
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () {
//         close(context, '');
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionsList = suggestions;

//     return DefaultTabController(
//       length: 3,
//       child: NestedScrollView(
//         physics: AlwaysScrollableScrollPhysics(),
//         headerSliverBuilder: (context, isScrollable) {
//           return [
//             SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   TabBar(
//                     indicatorColor: kPrimaryColor,
//                     tabs: [
//                       Tab(
//                         icon: Icon(Icons.account_circle),
//                       ),
//                       Tab(
//                         icon: Icon(Icons.fastfood_rounded),
//                       ),
//                       Tab(
//                         icon: Icon(Icons.tag_rounded),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 2.0,
//                   )
//                 ],
//               ),
//             ),
//           ];
//         },
//         body: TabBarView(
//           children: [
//             ExploreSearchRecipeTab(
//               recipes: recipes,
//             ),
//             ExploreSearchUserTab(
//               users: users,
//             ),
//             ExploreSearchHashtagTab(
//               hashtags: tags,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
