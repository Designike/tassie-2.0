import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/viewRecRatingChild.dart';
import 'package:tassie/screens/imgLoader.dart';

class ViewRecAllRatings extends StatefulWidget {
  const ViewRecAllRatings(
      {Key? key,
      required this.userUuid,
      required this.recipeUuid,
      required this.dp})
      : super(key: key);
  final String userUuid;
  final String recipeUuid;
  final String? dp;
  @override
  _ViewRecAllRatingsState createState() => _ViewRecAllRatingsState();
}

class _ViewRecAllRatingsState extends State<ViewRecAllRatings> {
  List ratings = [];
  String? uuid;
  final dio = Dio();
  final storage = FlutterSecureStorage();
  AsyncMemoizer memoizer = AsyncMemoizer();
  // AsyncMemoizer memoizer1 = AsyncMemoizer();
  // String? dp;
  final ScrollController _sc = ScrollController();
  final TextEditingController _tc = TextEditingController();
  // static List comments = [];
  bool isLazyLoading = false;
  static bool isLoading = true;
  static int page = 1;
  bool isEnd = false;
  // final dio = Dio();
  // final storage = FlutterSecureStorage();
  // String comm = '';
  // String? uuid;

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

  void _getMoreData(int index) async {
    if (!isEnd) {
      print('1');
      if (!isLazyLoading) {
        print('2');
        setState(() {
          isLazyLoading = true;
        });
        var url = "http://10.0.2.2:3000/recs/lazyrating/" +
            widget.recipeUuid +
            '/' +
            widget.userUuid +
            '/' +
            index.toString();

        var token = await storage.read(key: "token");
        uuid = await storage.read(key: "uuid");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer " + token!
          }),
        );
        List tList = [];
        print(response);
        if (response.data['data']['ratings']['results'] != null) {
          for (int i = 0;
              i < response.data['data']['ratings']['results']['ratings'].length;
              i++) {
            tList
                .add(response.data['data']['ratings']['results']['ratings'][i]);
          }

          // print(dp);
          setState(() {
            if (index == 1) {
              isLoading = false;
            }
            isLazyLoading = false;
            ratings.addAll(tList);
            page++;
          });
          if (response.data['data']['ratings']['results']['ratings'].length ==
              0) {
            setState(() {
              isEnd = true;
            });
          }
        }
        // print(comments);
      }
    }
  }

  @override
  void initState() {
    page = 1;
    ratings = [];
    _getMoreData(page);
    super.initState();
    // load();
    memoizer = AsyncMemoizer();
    // memoizer1 = AsyncMemoizer();

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ratings"),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? kLight
            : kDark[900],
      ),
      // backgroundColor: Color(0xFFEDF0F6),
      body: CustomScrollView(
        controller: _sc,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return index == ratings.length
                    ? isEnd
                        ? null
                        : _buildProgressIndicator()
                    : CreateRating(
                        rating: ratings[index],
                        index: index,
                        userUuid: widget.userUuid,
                        recipeUuid: widget.recipeUuid,
                        removeRating: (ind) {
                          setState(() {
                            ratings.remove(ind);
                          });
                        },
                        uuid: uuid,
                      );
              },
              childCount: ratings.length,
            ),
          )
        ],
      ),
      // bottomNavigationBar: Transform.translate(
      //   offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      //   child: Container(
      //     height: 100.0,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(30.0),
      //         topRight: Radius.circular(30.0),
      //       ),
      //       color: Theme.of(context).brightness == Brightness.dark
      //           ? kDark[900]
      //           : kLight,
      //     ),
      //     child: Padding(
      //       padding: EdgeInsets.all(12.0),
      //       child: TextField(
      //         onChanged: (val) {
      //           comm = val;
      //         },
      //         controller: _tc,
      //         decoration: InputDecoration(
      //           border: InputBorder.none,
      //           enabledBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(30.0),
      //             borderSide: BorderSide(color: Colors.grey),
      //           ),
      //           focusedBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(30.0),
      //             borderSide: BorderSide(color: Colors.grey),
      //           ),
      //           contentPadding: EdgeInsets.all(20.0),
      //           hintText: 'Add a comment',
      //           prefixIcon: Container(
      //             margin: EdgeInsets.all(4.0),
      //             width: 48.0,
      //             height: 48.0,
      //             decoration: BoxDecoration(
      //               shape: BoxShape.circle,
      //             ),
      //             child: CircleAvatar(
      //               child: ClipOval(
      //                   // child: Image(
      //                   //   height: 48.0,
      //                   //   width: 48.0,
      //                   //   image: NetworkImage('https://picsum.photos/200'),
      //                   //   fit: BoxFit.cover,
      //                   // ),
      //                   child: FutureBuilder(
      //                       future: loadImg(widget.dp, memoizer),
      //                       // future: loadImg('assets/Banana.png'),
      //                       builder:
      //                           (BuildContext context, AsyncSnapshot text) {
      //                         if (text.connectionState ==
      //                             ConnectionState.waiting) {
      //                           return Image.asset("assets/images/broken.png",
      //                               fit: BoxFit.cover,
      //                               height: 48.0,
      //                               width: 48.0);
      //                         } else {
      //                           return Image(
      //                             height: 48.0,
      //                             width: 48.0,
      //                             image: NetworkImage(text.data.toString()),
      //                             fit: BoxFit.cover,
      //                           );
      //                         }
      //                       })),
      //             ),
      //           ),
      //           suffixIcon: Container(
      //             margin: EdgeInsets.only(right: 4.0),
      //             width: 70.0,
      //             child: IconButton(
      //               // shape: RoundedRectangleBorder(
      //               //   borderRadius: BorderRadius.circular(30.0),
      //               // ),
      //               // color: Color(0xFF23B66F),
      //               onPressed: () async {
      //                 var token = await storage.read(key: "token");
      //                 Response response = await dio.post(
      //                     "http://10.0.2.2:3000/recs/addComment",
      //                     options: Options(headers: {
      //                       HttpHeaders.contentTypeHeader: "application/json",
      //                       HttpHeaders.authorizationHeader: "Bearer " + token!
      //                     }),
      //                     data: {
      //                       'comment': comm,
      //                       'recipeUuid': widget.recipeUuid
      //                     });
      //                 if (response.data['status'] == true) {
      //                   // widget.plusComment();
      //                   Navigator.pushReplacement(
      //                       context,
      //                       MaterialPageRoute(
      //                           builder: (BuildContext context) =>
      //                               super.widget));
      //                 }
      //               },
      //               icon: Icon(
      //                 Icons.send,
      //                 size: 25.0,
      //                 // color: Colors.white,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
