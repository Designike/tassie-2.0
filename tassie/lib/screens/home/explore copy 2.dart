// import 'dart:io';

// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:lottie/lottie.dart';
// import 'package:tassie/constants.dart';
// import 'package:tassie/screens/home/explorePost.dart';
// import 'package:tassie/screens/home/exploreRec.dart';
// import 'package:tassie/screens/home/exploreSearchHashtagTab.dart';
// import 'package:tassie/screens/home/exploreSearchRecipeTab.dart';
// import 'package:tassie/screens/home/exploreSearchUserTab.dart';
// import 'package:tassie/screens/home/recPost.dart';

// class Explore extends StatefulWidget {
//   const Explore({Key? key}) : super(key: key);

//   @override
//   _ExploreState createState() => _ExploreState();
// }

// class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

//   final ScrollController _sc = ScrollController();
//   static int page = 1;
//   static List recosts = [];
//   bool isLazyLoading = false;
//   static bool isLoading = true;
//   bool isEnd = false;
//   final dio = Dio();
//   final storage = FlutterSecureStorage();

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

//   Widget _endMessage() {
//     print(isEnd);
//     return Padding(
//       padding: const EdgeInsets.all(kDefaultPadding),
//       child: Center(
//         child: Opacity(
//           opacity: 0.8,
//           child: Text('That\'s all for now!'),
//         ),
//       ),
//     );
//   }

//   void _getMoreData(int index) async {
//     if (!isEnd) {
//       if (!isLazyLoading) {
//         print('calling...');
//         setState(() {
//           isLazyLoading = true;
//         });
//         var url = "https://api-tassie.herokuapp.com/recs/lazyrecs/" + index.toString();
//         var token = await storage.read(key: "token");
//         Response response = await dio.get(
//           url,
//           options: Options(headers: {
//             HttpHeaders.contentTypeHeader: "application/json",
//             HttpHeaders.authorizationHeader: "Bearer " + token!
//           }),
//         );
//         // print(response);
//         List tList = [];
//         if (response.data['data']['recs'] != null) {
//           for (int i = 0;
//               i < response.data['data']['recs']['results'].length;
//               i++) {
//             tList.add(response.data['data']['recs']['results'][i]);
//           }
//           setState(() {
//             if (index == 1) {
//               isLoading = false;
//             }
//             isLazyLoading = false;
//             recosts.addAll(tList);
//             // print(recs[0]['name']);
//             page++;
//           });
//           if (response.data['data']['recs']['results'].length == 0) {
//             setState(() {
//               isEnd = true;
//             });
//           }
//         } else {
//           setState(() {
//             isLoading = false;
//             isLazyLoading = false;
//           });
//         }
//       }
//     }
//   }

//   Future<void> _refreshPage() async {
//     setState(() {
//       page = 1;
//       recosts = [];
//       isEnd = false;
//       isLoading = true;
//       _getMoreData(page);
//     });
//   }

//   // static int page = 1;
//   // List recosts = ['one', 'two', 'three', 'four', 'five', 'one', 'two', 'three', 'four', 'five'];
//   // List<Map> recosts1 = [
//   //   {
//   //     "username": "abhay",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   //   {
//   //     "name": "Paneer Tikka",
//   //     "username": "Sommy21",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   //   {
//   //     "name": "Dhokla",
//   //     "username": "parthnamdev",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   //   {
//   //     "name": "Khamman",
//   //     "username": "rishabh",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   //   {
//   //     "username": "aryak",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   //   {
//   //     "username": "hemanth",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   //   {
//   //     "name": "Paneer Tikka",
//   //     "username": "Sommy21",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   //   {
//   //     "name": "Dhokla",
//   //     "username": "parthnamdev",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   //   {
//   //     "name": "Khamman",
//   //     "username": "rishabh",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   //   {
//   //     "username": "shivam",
//   //     "url": "https://picsum.photos/200",
//   //     "profilePic": "https://picsum.photos/200"
//   //   },
//   // ];
//   // Future<void> _refreshPage() async {
//   //   getRecosts();
//   //   setState(() {});
//   // }

//   Future<void> getRecosts() async {
//     var url = "https://api-tassie.herokuapp.com/search/lazyExplore/" + page.toString();

//     var token = await storage.read(key: "token");
//     Response response = await dio.get(
//       url,
//       options: Options(headers: {
//         HttpHeaders.contentTypeHeader: "application/json",
//         HttpHeaders.authorizationHeader: "Bearer " + token!
//       }),
//     );
//     print(response);
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     // return Container(
//     // child: FloatingActionButton(onPressed: () async {
//     //   var token = await storage.read(key: "token");
//     //   // print(formData.files[0]);
//     //   Response response = await dio.post(
//     //       // 'https://api-tassie.herokuapp.com/drive/upload',
//     //       'https://api-tassie.herokuapp.com/search/guess/',
//     //       options: Options(headers: {
//     //         HttpHeaders.contentTypeHeader: "application/json",
//     //         HttpHeaders.authorizationHeader: "Bearer " + token!
//     //       }),
//     //       data: {
//     //         'start': 0,
//     //         'veg': true,
//     //         'flavour': 'Spicy',
//     //         'course': 'Main course',
//     //         'maxTime': 30,
//     //         'ingredients': ['sev', 'Maida', 'sugar']
//     //       });
//     //   print(response);
//     // }),
//     // );
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           systemOverlayStyle: SystemUiOverlayStyle(
//               statusBarColor: Theme.of(context).scaffoldBackgroundColor,
//               statusBarIconBrightness:
//                   MediaQuery.of(context).platformBrightness == Brightness.light
//                       ? Brightness.dark
//                       : Brightness.light),
//           toolbarHeight: kToolbarHeight * 1.2,
//           title: GestureDetector(
//             onTap: () {
//               showSearch(context: context, delegate: SearchBar());
//             },
//             child: Container(
//               // child: Row(
//               //   children: [
//               //     Text('Search ', style: TextStyle(color: kDark)),
//               //     AnimatedTextKit(
//               //       pause: Duration(milliseconds: 3000),
//               //       repeatForever: false,
//               //       animatedTexts: [
//               //         FadeAnimatedText('recipes!',
//               //             textStyle: TextStyle(color: kDark)),
//               //         FadeAnimatedText('tassites!',
//               //             textStyle: TextStyle(color: kDark)),
//               //         FadeAnimatedText('posts!',
//               //             textStyle: TextStyle(color: kDark)),
//               //       ],
//               //     ),
//               //   ],
//               // ),
//               child: const Text('Search', style: TextStyle(color: kDark)),
//               decoration: BoxDecoration(
//                 color:
//                     MediaQuery.of(context).platformBrightness == Brightness.dark
//                         ? kDark[900]
//                         : kLight,
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               width: size.width * 0.8,
//               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 showSearch(context: context, delegate: SearchBar());
//               },
//               icon: const Icon(Icons.search_rounded),
//             ),
//           ]),
//       body: RefreshIndicator(
//         onRefresh: _refreshPage,
//         child: CustomScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           // controller: _sc,
//           slivers: [
//             SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   Center(
//                     child: Container(
//                       // padding: EdgeInsets.all(5.0),
//                       margin:
//                           EdgeInsets.only(top: 50.0, bottom: kDefaultPadding),
//                       width: size.width * 0.5,
//                       child: Lottie.asset('assets/images/cooker.json',
//                           fit: BoxFit.cover),
//                       decoration: BoxDecoration(
//                           color: MediaQuery.of(context).platformBrightness ==
//                                   Brightness.dark
//                               ? kDark[900]
//                               : kLight,
//                           borderRadius: BorderRadius.circular(size.width)),
//                     ),
//                   ),
//                   Text('Tap to suggest recipe!',
//                       style: TextStyle(fontSize: 16.0)),
//                 ],
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 7.0),
//                 child: MasonryGridView.count(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     crossAxisCount: 2,
//                     // mainAxisSpacing: 10,
//                     // crossAxisSpacing: 10,
//                     itemCount: recosts.length,
//                     itemBuilder: (context, index) {
//                       return recosts_toggle[index] == '1'
//                           // ? Container(
//                           //     height: 100.0,
//                           //     color: Colors.red,
//                           //   )
//                           // : Container(height: 150.0, color: Colors.green);
//                           ? Container(
//                               child: ExploreRec(recs: recosts[index]),
//                               margin: EdgeInsets.all(7.0),
//                             )
//                           // : ExplorePost(post: post, noOfComment: noOfComment, noOfLike: noOfLike, func: func, plusComment: plusComment, bookmark: bookmark, funcB: funcB, minusComment: minusComment);
//                           : Container(
//                               child: ExplorePost(post: recosts[index]),
//                               margin: EdgeInsets.all(7.0),
//                             );
//                     }),
//               ),
//             ),
//           ],
//           // ),
//         ),
//       ),
//     );
//   }
// }

// class SearchBar extends SearchDelegate<String> {
//   final suggestions = ['paneer', 'sandwich', 'pani puri'];
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear_rounded),
//         onPressed: () {
//           query = "";
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
//               recipes: [],
//             ),
//             ExploreSearchUserTab(
//               users: [],
//             ),
//             ExploreSearchHashtagTab(
//               hashtags: [],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
