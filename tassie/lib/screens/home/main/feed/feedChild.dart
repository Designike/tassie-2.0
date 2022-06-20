import 'dart:io';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/utils/leftSwipe.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/screens/home/main/feed/viewPost.dart';
import 'package:tassie/utils/imgLoader.dart';

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
      required this.minusComment,
      Key? key})
      : super(key: key);
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
  FeedPostState createState() => FeedPostState();
}

class FeedPostState extends State<FeedPost> {
  // final Map post;
  String? dp;
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizer1 = AsyncMemoizer();
  late Future storedFuture;
  late Future storedFuture1;
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  // String _image = "";
  // bool isImage = false;

  Future<void> getdp() async {
    dp = await storage.read(key: "profilePic");
  }

  @override
  void initState() {
    // print(widget.post['createdAt']);
    getdp();
    memoizer = AsyncMemoizer();
    memoizer1 = AsyncMemoizer();
    storedFuture = loadImg(widget.post['postID'], memoizer);
    storedFuture1 = loadImg(widget.post['profilePic'], memoizer1);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Future<Uint8List> load = loadImg(widget.post['postID']);
    Map post = widget.post;
    bool isBookmarked = widget.bookmark['isBookmarked'];
    bool liked = widget.noOfLike['isLiked'];
    int likeNumber = widget.noOfLike['count'];
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: double.infinity,
        // height: 560.0,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? kDark[900]
              : kLight,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.transparent
                  : Color(0xFFE4E4E4)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        child: ClipOval(
                          //     child: Image(
                          //       height: 50.0,
                          //       width: 50.0,
                          //       image: CachedNetworkImageProvider(post['url']),
                          //       fit: BoxFit.cover,
                          //     ),
                          child: FutureBuilder(
                              future: storedFuture1,
                              builder:
                                  (BuildContext context, AsyncSnapshot text) {
                                if ((text.connectionState ==
                                        ConnectionState.waiting ||
                                    text.hasError)) {
                                  return const Image(
                                    height: 50.0,
                                    width: 50.0,
                                    image:
                                        AssetImage("assets/images/broken.png"),
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  // return Image(
                                  //   image: CachedNetworkImageProvider(text.data.toString()),
                                  //   fit: BoxFit.cover,
                                  // );
                                  if (!text.hasData) {
                                    return const SizedBox(
                                        height: 50.0,
                                        width: 50.0,
                                        child: Center(
                                          child: Icon(
                                            Icons.refresh,
                                            // size: 50.0,
                                            color: kDark,
                                          ),
                                        ));
                                  }
                                  return Image(
                                    height: 50.0,
                                    width: 50.0,
                                    image: CachedNetworkImageProvider(
                                        text.data.toString()),
                                    fit: BoxFit.cover,
                                  );
                                }
                              }),
                        ),
                      ),
                    ),
                    // title: Text(
                    //   post['username'],
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    title: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: [
                          TextSpan(
                            text: post['username'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? kDark[900]
                                  : kLight,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Profile(
                                    uuid: post['userUuid'],
                                  ),
                                ));
                              },
                          ),
                        ])),
                    subtitle: Text(
                      "${DateTime.parse(post['createdAt']).hour}:${DateTime.parse(post['createdAt']).minute} ${months[DateTime.parse(post['createdAt']).month]} ${DateTime.parse(post['createdAt']).day}",
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kLight
                              : kDark[900]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_horiz),
                      // color: Colors.black,
                      onPressed: () => {},
                    ),
                  ),
                  InkWell(
                    onDoubleTap: () async {
                      if (!liked) {
                        var token = await storage.read(key: "token");
                        dio.post("https://api-tassie.herokuapp.com/feed/like",
                            options: Options(headers: {
                              HttpHeaders.contentTypeHeader: "application/json",
                              HttpHeaders.authorizationHeader:
                                  "Bearer ${token!}"
                            }),
                            data: {'uuid': post['uuid']});
                        widget.func(true);
                      }
                    },
                    child: Hero(
                      tag: post['uuid'],
                      child: FutureBuilder(
                          future: storedFuture,
                          builder: (BuildContext context, AsyncSnapshot text) {
                            if ((text.connectionState ==
                                    ConnectionState.waiting) ||
                                text.hasError) {
                              return Container(
                                margin: const EdgeInsets.all(10.0),
                                width: double.infinity,
                                height: size.width - 40.0,
                                // height: 400.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/broken.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } else {
                              if (!text.hasData) {
                                return Container(
                                    margin: const EdgeInsets.all(10.0),
                                    width: double.infinity,
                                    height: size.width - 40.0,
                                    child: const Center(
                                      child: Icon(
                                        Icons.refresh,
                                        size: 50.0,
                                        color: kDark,
                                      ),
                                    ));
                              }
                              return Container(
                                margin: const EdgeInsets.all(10.0),
                                width: double.infinity,
                                height: size.width - 40.0,
                                // height: 400.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        text.data.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: (!liked)
                                      ? const Icon(Icons.favorite_border)
                                      : const Icon(
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
                                          "https://api-tassie.herokuapp.com/feed/unlike",
                                          options: Options(headers: {
                                            HttpHeaders.contentTypeHeader:
                                                "application/json",
                                            HttpHeaders.authorizationHeader:
                                                "Bearer ${token!}"
                                          }),
                                          data: {'uuid': post['uuid']});
                                      widget.func(false);
                                    } else {
                                      // print(post);

                                      var token =
                                          await storage.read(key: "token");
                                      dio.post(
                                          "https://api-tassie.herokuapp.com/feed/like",
                                          options: Options(headers: {
                                            HttpHeaders.contentTypeHeader:
                                                "application/json",
                                            HttpHeaders.authorizationHeader:
                                                "Bearer ${token!}"
                                          }),
                                          data: {'uuid': post['uuid']});
                                      widget.func(true);
                                    }
                                  },
                                ),
                                Text(
                                  likeNumber.toString(),
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20.0),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.chat),
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
                                    Provider.of<LeftSwipe>(context,
                                            listen: false)
                                        .setSwipe(false);
                                  },
                                ),
                                Text(
                                  widget.noOfComment['count'].toString(),
                                  style: const TextStyle(
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
                              ? const Icon(Icons.bookmark)
                              : const Icon(Icons.bookmark_border),
                          iconSize: 30.0,
                          onPressed: () async {
                            if (!isBookmarked) {
                              var token = await storage.read(key: "token");
                              await dio.post(
                                  "https://api-tassie.herokuapp.com/feed/bookmark",
                                  options: Options(headers: {
                                    HttpHeaders.contentTypeHeader:
                                        "application/json",
                                    HttpHeaders.authorizationHeader:
                                        "Bearer ${token!}"
                                  }),
                                  data: {'uuid': post['uuid']});
                              widget.funcB(true);
                            } else {
                              var token = await storage.read(key: "token");
                              await dio.post(
                                  "https://api-tassie.herokuapp.com/feed/removeBookmark",
                                  options: Options(headers: {
                                    HttpHeaders.contentTypeHeader:
                                        "application/json",
                                    HttpHeaders.authorizationHeader:
                                        "Bearer ${token!}"
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
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                    builder: (_) => Profile(
                                      uuid: post['userUuid'],
                                    ),
                                  ));
                                },
                            ),
                            const TextSpan(text: " "),
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
