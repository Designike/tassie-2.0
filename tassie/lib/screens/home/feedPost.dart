// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/viewComments.dart';
import 'package:tassie/screens/imgLoader.dart';

class FeedPost extends StatefulWidget {
  const FeedPost(
      {required this.post,
      required this.noOfComment,
      required this.noOfLike,
      required this.func,
      required this.plusComment,
      required this.bookmark,
      required this.funcB,
      // required this.image,
      required this.minusComment});
  final Map post;
  final Map noOfComment;
  final Map noOfLike;
  final Map bookmark;
  // final Uint8List image;
  final void Function(bool) func;
  final void Function(bool) funcB;
  final void Function() plusComment;
  final void Function() minusComment;
  @override
  _FeedPostState createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  // final Map post;
  String? dp;
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizer1 = AsyncMemoizer();
  late Future storedFuture;
  late Future storedFuture1;
  final dio = Dio();
  final storage = FlutterSecureStorage();
  // String _image = "";
  // bool isImage = false;

  Future<void> getdp() async {
    dp = await storage.read(key: "profilePic");
  }

  @override
  void initState() {
    // TODO: implement initState
    getdp();
    memoizer = AsyncMemoizer();
    memoizer1 = AsyncMemoizer();
    storedFuture = loadImg(widget.post['postID'], memoizer);
    storedFuture1 = loadImg(widget.post['profilePic'], memoizer1);
    super.initState();
    // loadImg(widget.post['postID'],memoizer).then((result) {
    //   // print('hello');
    //   // print(result);
    //   setState(() {
    //     _image = result;
    //     isImage = true;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Future<Uint8List> load = loadImg(widget.post['postID']);
    print(widget.bookmark);
    Map post = widget.post;
    bool isBookmarked = widget.bookmark['isBookmarked'];
    bool liked = widget.noOfLike['isLiked'];
    int likeNumber = widget.noOfLike['count'];
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: double.infinity,
        // height: 560.0,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? kDark[900]
              : kLight,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        child: ClipOval(
                          //     child: Image(
                          //       height: 50.0,
                          //       width: 50.0,
                          //       image: NetworkImage(post['url']),
                          //       fit: BoxFit.cover,
                          //     ),
                          child: FutureBuilder(
                              future: storedFuture1,
                              builder:
                                  (BuildContext context, AsyncSnapshot text) {
                                if (text.connectionState ==
                                    ConnectionState.waiting) {
                                  return Image(
                                    height: 50.0,
                                    width: 50.0,
                                    image:
                                        AssetImage("assets/images/broken.png"),
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  // return Image(
                                  //   image: NetworkImage(text.data.toString()),
                                  //   fit: BoxFit.cover,
                                  // );
                                  return Image(
                                    height: 50.0,
                                    width: 50.0,
                                    image: NetworkImage(text.data.toString()),
                                    fit: BoxFit.cover,
                                  );
                                }
                              }),
                        ),
                      ),
                    ),
                    title: Text(
                      post['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      post['createdAt'],
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kLight
                              : kDark[900]),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.more_horiz),
                      // color: Colors.black,
                      onPressed: () => print('More'),
                    ),
                  ),
                  InkWell(
                    onDoubleTap: () async {
                      if (!liked) {
                        var token = await storage.read(key: "token");
                        dio.post(
                            "https://api-tassie-alt.herokuapp.com/feed/like",
                            options: Options(headers: {
                              HttpHeaders.contentTypeHeader: "application/json",
                              HttpHeaders.authorizationHeader:
                                  "Bearer " + token!
                            }),
                            data: {'uuid': post['uuid']});
                        widget.func(true);
                      }
                    },
                    // child: Container(
                    //   margin: EdgeInsets.all(10.0),
                    //   width: double.infinity,
                    //   height: size.width - 40.0,
                    //   // height: 400.0,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(25.0),
                    //     image: DecorationImage(
                    //       // image: NetworkImage(post['url']),
                    //       image: Image.network(_image).image,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                    child: FutureBuilder(
                        future: storedFuture,
                        builder: (BuildContext context, AsyncSnapshot text) {
                          if (text.connectionState == ConnectionState.waiting) {
                            return Container(
                              margin: EdgeInsets.all(10.0),
                              width: double.infinity,
                              height: size.width - 40.0,
                              // height: 400.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/broken.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            // return Image(
                            //   image: NetworkImage(text.data.toString()),
                            //   fit: BoxFit.cover,
                            // );
                            return Container(
                              margin: EdgeInsets.all(10.0),
                              width: double.infinity,
                              height: size.width - 40.0,
                              // height: 400.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                image: DecorationImage(
                                  image: NetworkImage(text.data.toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: (!liked)
                                      ? Icon(Icons.favorite_border)
                                      : Icon(
                                          Icons.favorite,
                                          color: kPrimaryColor,
                                        ),
                                  iconSize: 30.0,
                                  onPressed: () async {
                                    if (liked) {
                                      // print(post);

                                      var token =
                                          await storage.read(key: "token");
                                      dio.post(
                                          "https://api-tassie-alt.herokuapp.com/feed/unlike",
                                          options: Options(headers: {
                                            HttpHeaders.contentTypeHeader:
                                                "application/json",
                                            HttpHeaders.authorizationHeader:
                                                "Bearer " + token!
                                          }),
                                          data: {'uuid': post['uuid']});
                                      widget.func(false);
                                    } else {
                                      // print(post);

                                      var token =
                                          await storage.read(key: "token");
                                      dio.post(
                                          "https://api-tassie-alt.herokuapp.com/feed/like",
                                          options: Options(headers: {
                                            HttpHeaders.contentTypeHeader:
                                                "application/json",
                                            HttpHeaders.authorizationHeader:
                                                "Bearer " + token!
                                          }),
                                          data: {'uuid': post['uuid']});
                                      widget.func(true);
                                    }
                                    print(likeNumber.toString());
                                  },
                                ),
                                Text(
                                  likeNumber.toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20.0),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.chat),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (_) => ViewComments(
                                          post: post,
                                          noOfComment: widget.noOfComment,
                                          noOfLike: widget.noOfLike,
                                          func: widget.func,
                                          plusComment: widget.plusComment,
                                          funcB: widget.funcB,
                                          bookmark: widget.bookmark,
                                          minusComment: widget.minusComment,
                                          dp: dp,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  widget.noOfComment['count'].toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: (isBookmarked)
                              ? Icon(Icons.bookmark)
                              : Icon(Icons.bookmark_border),
                          iconSize: 30.0,
                          onPressed: () async {
                            if (!isBookmarked) {
                              var token = await storage.read(key: "token");
                              Response response = await dio.post(
                                  "https://api-tassie-alt.herokuapp.com/feed/bookmark",
                                  options: Options(headers: {
                                    HttpHeaders.contentTypeHeader:
                                        "application/json",
                                    HttpHeaders.authorizationHeader:
                                        "Bearer " + token!
                                  }),
                                  data: {'uuid': post['uuid']});
                              widget.funcB(true);
                            } else {
                              var token = await storage.read(key: "token");
                              Response response = await dio.post(
                                  "https://api-tassie-alt.herokuapp.com/feed/removeBookmark",
                                  options: Options(headers: {
                                    HttpHeaders.contentTypeHeader:
                                        "application/json",
                                    HttpHeaders.authorizationHeader:
                                        "Bearer " + token!
                                  }),
                                  data: {'uuid': post['uuid']});
                              widget.funcB(false);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text(
                  //   posts[index]['description'],
                  //   overflow: TextOverflow.ellipsis,
                  //   textAlign: TextAlign.start,
                  // ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                          builder: (_) => ViewComments(
                            post: post,
                            noOfComment: widget.noOfComment,
                            noOfLike: widget.noOfLike,
                            func: widget.func,
                            plusComment: widget.plusComment,
                            funcB: widget.funcB,
                            bookmark: widget.bookmark,
                            minusComment: widget.minusComment,
                            dp: dp,
                          ),
                        ));
                      },
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: post['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? kDark[900]
                                    : kLight,
                              ),
                            ),
                            TextSpan(text: " "),
                            TextSpan(
                              text: post['description'],
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? kDark[900]
                                    : kLight,
                              ),
                            )
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
