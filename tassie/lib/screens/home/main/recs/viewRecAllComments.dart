import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/recs/viewRecCommentChild.dart';
import 'package:tassie/utils/imgLoader.dart';

class ViewRecAllComments extends StatefulWidget {
  const ViewRecAllComments(
      {Key? key,
      required this.userUuid,
      required this.recipeUuid,
      required this.dp})
      : super(key: key);
  final String userUuid;
  final String recipeUuid;
  final String? dp;
  @override
  ViewRecAllCommentsState createState() => ViewRecAllCommentsState();
}

class ViewRecAllCommentsState extends State<ViewRecAllComments> {
  List comments = [];
  List commentStoredFutures = [];
  String? uuid;
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;
  Animation<double>? animation;
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
  String comm = '';
  // String? uuid;

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

  void _getMoreData(int index) async {
    if (!isEnd) {
      if (!isLazyLoading) {
        if (mounted) {
          setState(() {
            isLazyLoading = true;
          });
        }
        var url =
            'https://api-tassie.herokuapp.com/recs/lazyreccomment/${widget.recipeUuid}/${widget.userUuid}/$index';

        var token = await storage.read(key: "token");
        uuid = await storage.read(key: "uuid");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
        );
        List tList = [];
        if (response.data['data']['comments']['results'] != null) {
          for (int i = 0;
              i <
                  response
                      .data['data']['comments']['results']['comments'].length;
              i++) {
            tList.add(
                response.data['data']['comments']['results']['comments'][i]);
          }

          // print(dp);
          if (mounted) {
            setState(() {
              if (index == 1) {
                isLoading = false;
              }
              isLazyLoading = false;
              comments.addAll(tList);
              for (int i = 0; i < tList.length; i++) {
                AsyncMemoizer memoizer4 = AsyncMemoizer();
                Future storedFuture =
                    loadImg(tList[i]['profilePic'], memoizer4);
                commentStoredFutures.add(storedFuture);
              }
              page++;
            });
          }
          if (response.data['data']['comments']['results']['comments'].length ==
              0) {
            if (mounted) {
              setState(() {
                isEnd = true;
              });
            }
          }
        }
        // print(comments);
      }
    }
  }

  // void removeItem(int index) {
  //   final removedItem = comments[index];
  //   comments.removeAt(index);
  //   _commentsListKey.currentState!.removeItem(
  //       index,
  //       (context, animation) => CreateComment(
  //           recost: removedItem,
  //           index: index,
  //           userUuid: widget.userUuid,
  //           recipeUuid: widget.recipeUuid,
  //           removeComment: (ind) {},
  //           uuid: uuid,
  //           isPost: false));
  // }

  @override
  void initState() {
    page = 1;
    comments = [];
    _getMoreData(page);
    super.initState();
    // load();
    memoizer = AsyncMemoizer();
    storedFuture = loadImg(widget.dp, memoizer);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
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
                return index == comments.length
                    ? isEnd
                        ? null
                        : _buildProgressIndicator()
                    : CreateComment(
                        recost: comments[index],
                        index: index,
                        userUuid: widget.userUuid,
                        recipeUuid: widget.recipeUuid,
                        storedFuture: commentStoredFutures[index],
                        removeComment: (ind) {
                          if (mounted) {
                            setState(() {
                              comments.removeAt(ind);
                            });
                          }
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             super.widget));
                        },
                        uuid: uuid,
                        isPost: false,
                      );
              },
              childCount: comments.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: Theme.of(context).brightness == Brightness.dark
                ? kDark[900]
                : kLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) {
                comm = val;
              },
              controller: _tc,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.all(20.0),
                hintText: 'Add a comment',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(4.0),
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                        // child: Image(
                        //   height: 48.0,
                        //   width: 48.0,
                        //   image: NetworkImage('https://picsum.photos/200'),
                        //   fit: BoxFit.cover,
                        // ),
                        child: FutureBuilder(
                            future: storedFuture,
                            // future: loadImg('assets/Banana.png'),
                            builder:
                                (BuildContext context, AsyncSnapshot text) {
                              if ((text.connectionState ==
                                      ConnectionState.waiting) ||
                                  text.hasError) {
                                return Image.asset("assets/images/broken.png",
                                    fit: BoxFit.cover,
                                    height: 48.0,
                                    width: 48.0);
                              } else {
                                if (!text.hasData) {
                                  return const SizedBox(
                                      height: 48.0,
                                      width: 48.0,
                                      child: Center(
                                        child: Icon(
                                          Icons.refresh,
                                          // size: 50.0,
                                          color: kDark,
                                        ),
                                      ));
                                }
                                return Image(
                                  height: 48.0,
                                  width: 48.0,
                                  image: NetworkImage(text.data.toString()),
                                  fit: BoxFit.cover,
                                );
                              }
                            })),
                  ),
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 4.0),
                  width: 70.0,
                  child: IconButton(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(30.0),
                    // ),
                    // color: Color(0xFF23B66F),
                    onPressed: () async {
                      var token = await storage.read(key: "token");
                      Response response = await dio.post(
                          "https://api-tassie.herokuapp.com/recs/addComment",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer ${token!}"
                          }),
                          data: {
                            'comment': comm,
                            'recipeUuid': widget.recipeUuid
                          });
                      if (response.data['status'] == true) {
                        // widget.plusComment();
                        // await Future.delayed(const Duration(seconds: 1));

                        if (!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    super.widget));
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 25.0,
                      // color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
