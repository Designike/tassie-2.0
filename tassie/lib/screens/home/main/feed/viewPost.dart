import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:tassie/utils/leftSwipe.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/screens/home/main/recs/viewRecCommentChild.dart';
import 'package:tassie/utils/imgLoader.dart';

import '../../../../constants.dart';

class ViewComments extends StatefulWidget {
  final Map post;
  final Map noOfComment;
  final Map noOfLike;
  final Map bookmark;
  final void Function(bool) func;
  final void Function(bool) funcB;
  final void Function() plusComment;
  final void Function() minusComment;
  final String? dp;
  const ViewComments(
      {required this.post,
      required this.noOfComment,
      required this.noOfLike,
      required this.func,
      required this.plusComment,
      required this.funcB,
      required this.bookmark,
      required this.minusComment,
      required this.dp,
      Key? key})
      : super(key: key);

  @override
  ViewCommentsState createState() => ViewCommentsState();
}

class ViewCommentsState extends State<ViewComments> {
  final ScrollController _sc = ScrollController();
  final TextEditingController _tc = TextEditingController();
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizer1 = AsyncMemoizer();
  AsyncMemoizer memoizer2 = AsyncMemoizer();
  late Future storedFuture;
  late Future storedFuture1;
  late Future storedFuture2;
  String? dp;
  static List comments = [];
  static List commentStoredFutures = [];
  bool isLazyLoading = false;
  static bool isLoading = true;
  static int page = 1;
  bool isEnd = false;
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  String comment = '';
  String? uuid;

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

  void _getMoreData(int index) async {
    if (!isEnd) {
      if (!isLazyLoading) {
        if (mounted) {
          setState(() {
            isLazyLoading = true;
          });
        }
        var url =
            "https://api-tassie.herokuapp.com/feed/lazycomment/${widget.post['uuid']}/${widget.post['userUuid']}/${index.toString()}";
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
          if (mounted) {
            setState(() {
              if (index == 1) {
                isLoading = false;
              }
              isLazyLoading = false;
              comments.addAll(tList);
              for (int i = 0; i < tList.length; i++) {
                AsyncMemoizer memoizer4 = AsyncMemoizer();
                // print(tList[i]['profilePic']);
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
      }
    }
  }

  @override
  void initState() {
    page = 1;
    comments = [];
    _getMoreData(page);
    super.initState();
    // print(widget.post);
    // load();
    memoizer = AsyncMemoizer();
    memoizer1 = AsyncMemoizer();
    memoizer2 = AsyncMemoizer();
    storedFuture = loadImg(widget.post['postID'], memoizer);
    storedFuture1 = loadImg(widget.post['profilePic'], memoizer1);
    storedFuture2 = loadImg(widget.dp, memoizer2);
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
    bool liked = widget.noOfLike['isLiked'];
    int noOfComments = comments.length;
    Size size = MediaQuery.of(context).size;
    bool isBookmarked = widget.bookmark['isBookmarked'];
    return Scaffold(
      // backgroundColor: Color(0xFFEDF0F6),
      body: CustomScrollView(
        controller: _sc,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40.0),
                  width: double.infinity,
                  // height: 600.0,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  iconSize: 30.0,
                                  // color: Colors.black,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Provider.of<LeftSwipe>(context,
                                            listen: false)
                                        .setSwipe(true);
                                  },
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: ListTile(
                                    leading: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        child: ClipOval(
                                          // child: Image(
                                          //   height: 50.0,
                                          //   width: 50.0,
                                          //   image: CachedNetworkImageProvider(
                                          //       widget.post['url']),
                                          //   fit: BoxFit.cover,
                                          // ),
                                          child: FutureBuilder(
                                              future: storedFuture1,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot text) {
                                                if ((text.connectionState ==
                                                        ConnectionState
                                                            .waiting) ||
                                                    text.hasError) {
                                                  return const Image(
                                                    height: 50.0,
                                                    width: 50.0,
                                                    image: AssetImage(
                                                        "assets/images/broken.png"),
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
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            text.data
                                                                .toString()),
                                                    fit: BoxFit.cover,
                                                  );
                                                }
                                              }),
                                        ),
                                      ),
                                    ),
                                    // title: Text(
                                    //   widget.post['username'],
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    title: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: widget.post['username'],
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? kDark[900]
                                                  : kLight,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (_) => Profile(
                                                    uuid:
                                                        widget.post['userUuid'],
                                                  ),
                                                ));
                                              },
                                          ),
                                        ])),
                                    subtitle: Text(
                                      "${DateTime.parse(widget.post['createdAt']).hour}:${DateTime.parse(widget.post['createdAt']).minute} ${months[DateTime.parse(widget.post['createdAt']).month]} ${DateTime.parse(widget.post['createdAt']).day}",
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? kLight
                                              : kDark[900]),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.more_horiz),
                                      // color: Colors.black,
                                      onPressed: () => {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onDoubleTap: () async {
                                if (!liked) {
                                  var token = await storage.read(key: "token");
                                  dio.post(
                                      "https://api-tassie.herokuapp.com/feed/like",
                                      options: Options(headers: {
                                        HttpHeaders.contentTypeHeader:
                                            "application/json",
                                        HttpHeaders.authorizationHeader:
                                            "Bearer ${token!}"
                                      }),
                                      data: {'uuid': widget.post['uuid']});
                                  widget.func(true);
                                  if (mounted) {
                                    setState(() {});
                                  }
                                }
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              // child: Container(
                              //   margin: EdgeInsets.all(10.0),
                              //   width: double.infinity,
                              //   height: 400.0,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(25.0),
                              //     image: DecorationImage(
                              //       image:
                              //           CachedNetworkImageProvider(widget.post['profilePic']),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),
                              child: Hero(
                                tag: widget.post['uuid'],
                                child: FutureBuilder(
                                    future: storedFuture,
                                    builder: (BuildContext context,
                                        AsyncSnapshot text) {
                                      if ((text.connectionState ==
                                              ConnectionState.waiting) ||
                                          text.hasError) {
                                        return Container(
                                          margin: const EdgeInsets.all(10.0),
                                          width: double.infinity,
                                          height: size.width - 40.0,
                                          // height: 400.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                'assets/images/broken.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else {
                                        // return Image(
                                        //   image: CachedNetworkImageProvider(text.data.toString()),
                                        //   fit: BoxFit.cover,
                                        // );
                                        if (!text.hasData) {
                                          return Container(
                                              margin:
                                                  const EdgeInsets.all(10.0),
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
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(MaterialPageRoute(
                                                    builder: (context) => PhotoView(
                                                        imageProvider:
                                                            CachedNetworkImageProvider(text
                                                                .data
                                                                .toString()))));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10.0),
                                            width: double.infinity,
                                            height: size.width - 40.0,
                                            // height: 400.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        text.data.toString()),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: (!liked)
                                                ? const Icon(
                                                    Icons.favorite_border)
                                                : const Icon(
                                                    Icons.favorite,
                                                    color: kPrimaryColor,
                                                  ),
                                            iconSize: 30.0,
                                            onPressed: () async {
                                              if (liked) {
                                                // print(post);

                                                var token = await storage.read(
                                                    key: "token");
                                                dio.post(
                                                    "https://api-tassie.herokuapp.com/feed/unlike",
                                                    options: Options(headers: {
                                                      HttpHeaders
                                                              .contentTypeHeader:
                                                          "application/json",
                                                      HttpHeaders
                                                              .authorizationHeader:
                                                          "Bearer ${token!}"
                                                    }),
                                                    data: {
                                                      'uuid':
                                                          widget.post['uuid']
                                                    });
                                                widget.func(false);
                                              } else {
                                                // print(post);

                                                var token = await storage.read(
                                                    key: "token");
                                                dio.post(
                                                    "https://api-tassie.herokuapp.com/feed/like",
                                                    options: Options(headers: {
                                                      HttpHeaders
                                                              .contentTypeHeader:
                                                          "application/json",
                                                      HttpHeaders
                                                              .authorizationHeader:
                                                          "Bearer ${token!}"
                                                    }),
                                                    data: {
                                                      'uuid':
                                                          widget.post['uuid']
                                                    });
                                                widget.func(true);
                                              }
                                              if (mounted) {
                                                setState(() {});
                                              }
                                              // print(likeNumber.toString());
                                            },
                                          ),
                                          Text(
                                            widget.noOfLike['count'].toString(),
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
                                            onPressed: () {},
                                          ),
                                          Text(
                                            widget.noOfComment['count']
                                                .toString(),
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
                                        var token =
                                            await storage.read(key: "token");
                                        await dio.post(
                                            "https://api-tassie.herokuapp.com/feed/bookmark",
                                            options: Options(headers: {
                                              HttpHeaders.contentTypeHeader:
                                                  "application/json",
                                              HttpHeaders.authorizationHeader:
                                                  "Bearer ${token!}"
                                            }),
                                            data: {
                                              'uuid': widget.post['uuid']
                                            });
                                        widget.funcB(true);
                                      } else {
                                        var token =
                                            await storage.read(key: "token");
                                        await dio.post(
                                            "https://api-tassie.herokuapp.com/feed/removeBookmark",
                                            options: Options(headers: {
                                              HttpHeaders.contentTypeHeader:
                                                  "application/json",
                                              HttpHeaders.authorizationHeader:
                                                  "Bearer ${token!}"
                                            }),
                                            data: {
                                              'uuid': widget.post['uuid']
                                            });
                                        widget.funcB(false);
                                      }
                                      if (mounted) {
                                        setState(() {});
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
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: RichText(
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.post['username'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? kDark[900]
                                            : kLight,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (_) => Profile(
                                              uuid: widget.post['userUuid'],
                                            ),
                                          ));
                                        },
                                    ),
                                    const TextSpan(text: " "),
                                    TextSpan(
                                      text: widget.post['description'],
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return index == comments.length
                    ? isEnd
                        ? _endMessage()
                        : _buildProgressIndicator()
                    : CreateComment(
                        recost: comments[index],
                        index: index,
                        userUuid: widget.post['userUuid'],
                        recipeUuid: widget.post['uuid'],
                        storedFuture: commentStoredFutures[index],
                        removeComment: (ind) {
                          if (mounted) {
                            setState(() {
                              comments.remove(ind);
                            });
                          }
                        },
                        uuid: uuid,
                        isPost: true,
                      );
              },
              childCount: noOfComments,
            ),
          )
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
                comment = val;
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
                      child: FutureBuilder(
                          future: storedFuture2,
                          builder: (BuildContext context, AsyncSnapshot text) {
                            if ((text.connectionState ==
                                    ConnectionState.waiting) ||
                                text.hasError) {
                              return const Image(
                                height: 48.0,
                                width: 48.0,
                                image: AssetImage("assets/images/broken.png"),
                                fit: BoxFit.cover,
                              );
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
                                image: CachedNetworkImageProvider(
                                    text.data.toString()),
                                fit: BoxFit.cover,
                              );
                            }
                          }),
                    ),
                  ),
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 4.0),
                  width: 70.0,
                  child: IconButton(
                    onPressed: () async {
                      var token = await storage.read(key: "token");
                      Response response = await dio.post(
                          "https://api-tassie.herokuapp.com/feed/addComment",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer ${token!}"
                          }),
                          data: {
                            'comment': comment,
                            'postUuid': widget.post['uuid']
                          });
                      if (response.data['status'] == true) {
                        widget.plusComment();
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
