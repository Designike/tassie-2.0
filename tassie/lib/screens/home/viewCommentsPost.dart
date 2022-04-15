// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/screens/home/viewRecCommentChild.dart';
import 'package:tassie/screens/imgLoader.dart';

import '../../constants.dart';

class ViewCommentsPost extends StatefulWidget {
  final Map post;
  // final Map noOfComment;
  // final Map noOfLike;
  // final Map bookmark;
  // final void Function(bool) func;
  // final void Function(bool) funcB;
  // final void Function() plusComment;
  // final void Function() minusComment;
  // final String? dp;
  ViewCommentsPost({required this.post});

  @override
  _ViewCommentsPostState createState() => _ViewCommentsPostState();
}

class _ViewCommentsPostState extends State<ViewCommentsPost> {
  final ScrollController _sc = ScrollController();
  final TextEditingController _tc = TextEditingController();
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizer1 = AsyncMemoizer();
  AsyncMemoizer memoizer2 = AsyncMemoizer();
  String? dp;
  static List comments = [];
  bool isLazyLoading = false;
  static bool isLoading = true;
  static int page = 1;
  bool isEnd = false;
  final dio = Dio();
  final storage = FlutterSecureStorage();
  String comment = '';
  String? uuid;

  void func(bool islike) {
    setState(() {
      if (islike) {
        noOfLikes['count'] += 1;
      } else {
        noOfLikes['count'] -= 1;
      }
      noOfLikes[index]['isLiked'] = !noOfLikes[index]['isLiked'];
    });
  }

  void funcB(bool isBook) {
    setState(() {
      bookmark[index]['isBookmarked'] = !bookmark[index]['isBookmarked'];
    });
  }

  void plusComment() {
    setState(() {
      noOfComment[index]['count'] += 1;
    });
  }

  void minusComment() {
    setState(() {
      noOfComment[index]['count'] -= 1;
    });
  }

  void getStats() async {
    var url =
            "http://10.0.2.2:3000/profile/getStats/";
        var token = await storage.read(key: "token");
        Response response = await dio.post(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer " + token!
          }),
          data: {
            "postUuid": widget.post["uuid"],
          },
        );
        if(response.length != 0)
        {
          setState(() {
            noOfComment = response.data.beta[0]['comments'];
            noOfLikes = response.data.beta[0]['likes'];
            bookmark = response.data.beta[0]['bookmark'];
          });
        }
      
  }

  // List<Map> comments = [
  //   {
  //     "image": "https://picsum.photos/200",
  //     "name": "soham",
  //     "text": "Fuck off!"
  //   },
  //   {
  //     "image": "https://picsum.photos/200",
  //     "name": "soham",
  //     "text": "Fuck off!"
  //   },
  //   {
  //     "image": "https://picsum.photos/200",
  //     "name": "soham",
  //     "text": "Fuck off!"
  //   },
  //   {
  //     "image": "https://picsum.photos/200",
  //     "name": "soham",
  //     "text": "Fuck off!"
  //   },
  //   {"image": "https://picsum.photos/200", "name": "soham", "text": "Fuck off!"}
  // ];

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

  Widget _createComment(int index) {
    Map post = widget.post;
    // print(post);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50.0,
                width: 50.0,
                image: NetworkImage(post['profilePic']),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          comments[index]['username'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          comments[index]['comment'],
          style: TextStyle(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? kLight
                : kDark[900],
          ),
        ),
        trailing: (widget.post['userUuid'] == uuid ||
                comments[index]['uuid'].split('_comment_')[0] == uuid)
            ? IconButton(
                icon: Icon(
                  Icons.delete_rounded,
                ),
                color: Colors.grey,
                onPressed: () async {
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(
                      "https://api-tassie.herokuapp.com/feed/removeComment",
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      data: {
                        'postUuid': widget.post['uuid'],
                        'commentUuid': comments[index]['uuid'],
                      });
                  setState(() {
                    comments.remove(index);
                  });
                  widget.minusComment();
                },
              )
            : null,
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

  void _getMoreData(int index) async {
    if (!isEnd) {
      print('1');
      if (!isLazyLoading) {
        print('2');
        setState(() {
          isLazyLoading = true;
        });
        var url = "https://api-tassie.herokuapp.com/feed/lazycomment/" +
            widget.post['uuid'] +
            '/' +
            widget.post['userUuid'] +
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
        if (response.data['data']['comments']['results'] != null) {
          for (int i = 0;
              i <
                  response
                      .data['data']['comments']['results']['comments'].length;
              i++) {
            tList.add(
                response.data['data']['comments']['results']['comments'][i]);
          }

          setState(() {
            if (index == 1) {
              isLoading = false;
            }
            isLazyLoading = false;
            comments.addAll(tList);
            page++;
          });
          if (response.data['data']['comments']['results']['comments'].length ==
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
    comments = [];
    _getMoreData(page);
    super.initState();
    // load();
    memoizer = AsyncMemoizer();
    memoizer1 = AsyncMemoizer();
    memoizer2 = AsyncMemoizer();
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
    int no_of_comments = comments.length;
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
                  padding: EdgeInsets.only(top: 40.0),
                  width: double.infinity,
                  // height: 600.0,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  iconSize: 30.0,
                                  // color: Colors.black,
                                  onPressed: () {
                                    print('henlo');
                                    Navigator.pop(context);
                                  },
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: ListTile(
                                    leading: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        child: ClipOval(
                                          // child: Image(
                                          //   height: 50.0,
                                          //   width: 50.0,
                                          //   image: NetworkImage(
                                          //       widget.post['url']),
                                          //   fit: BoxFit.cover,
                                          // ),
                                          child: FutureBuilder(
                                              future: loadImg(
                                                  widget.post['profilePic'],
                                                  memoizer1),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot text) {
                                                if (text.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Image(
                                                    height: 50.0,
                                                    width: 50.0,
                                                    image: AssetImage(
                                                        "assets/images/broken.png"),
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
                                                    image: NetworkImage(
                                                        text.data.toString()),
                                                    fit: BoxFit.cover,
                                                  );
                                                }
                                              }),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      widget.post['username'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      widget.post['createdAt'],
                                      style: TextStyle(
                                          color: MediaQuery.of(context)
                                                      .platformBrightness ==
                                                  Brightness.dark
                                              ? kLight
                                              : kDark[900]),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.more_horiz),
                                      // color: Colors.black,
                                      onPressed: () => print('More'),
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
                                            "Bearer " + token!
                                      }),
                                      data: {'uuid': widget.post['uuid']});
                                  widget.func(true);
                                  setState(() {});
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
                              //           NetworkImage(widget.post['profilePic']),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),
                              child: FutureBuilder(
                                  future:
                                      loadImg(widget.post['postID'], memoizer),
                                  builder: (BuildContext context,
                                      AsyncSnapshot text) {
                                    if (text.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        margin: EdgeInsets.all(10.0),
                                        width: double.infinity,
                                        height: size.width - 40.0,
                                        // height: 400.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
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
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                text.data.toString()),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
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
                                                          "Bearer " + token!
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
                                                          "Bearer " + token!
                                                    }),
                                                    data: {
                                                      'uuid':
                                                          widget.post['uuid']
                                                    });
                                                widget.func(true);
                                              }
                                              setState(() {});
                                              // print(likeNumber.toString());
                                            },
                                          ),
                                          Text(
                                            widget.noOfLike['count'].toString(),
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
                                              print('Chat');
                                            },
                                          ),
                                          Text(
                                            widget.noOfComment['count']
                                                .toString(),
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
                                        var token =
                                            await storage.read(key: "token");
                                        Response response = await dio.post(
                                            "https://api-tassie.herokuapp.com/feed/bookmark",
                                            options: Options(headers: {
                                              HttpHeaders.contentTypeHeader:
                                                  "application/json",
                                              HttpHeaders.authorizationHeader:
                                                  "Bearer " + token!
                                            }),
                                            data: {
                                              'uuid': widget.post['uuid']
                                            });
                                        widget.funcB(true);
                                      } else {
                                        var token =
                                            await storage.read(key: "token");
                                        Response response = await dio.post(
                                            "https://api-tassie.herokuapp.com/feed/removeBookmark",
                                            options: Options(headers: {
                                              HttpHeaders.contentTypeHeader:
                                                  "application/json",
                                              HttpHeaders.authorizationHeader:
                                                  "Bearer " + token!
                                            }),
                                            data: {
                                              'uuid': widget.post['uuid']
                                            });
                                        widget.funcB(false);
                                      }
                                      setState(() {});
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
                            // Text(
                            //   posts[index]['description'],
                            //   overflow: TextOverflow.ellipsis,
                            //   textAlign: TextAlign.start,
                            // ),
                            Flexible(
                              child: RichText(
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.post['username'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: MediaQuery.of(context)
                                                    .platformBrightness ==
                                                Brightness.light
                                            ? kDark[900]
                                            : kLight,
                                      ),
                                    ),
                                    TextSpan(text: " "),
                                    TextSpan(
                                      text: widget.post['description'],
                                      style: TextStyle(
                                        color: MediaQuery.of(context)
                                                    .platformBrightness ==
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
                        removeComment: (ind) {
                          setState(() {
                            comments.remove(ind);
                          });
                        },
                        uuid: uuid,
                        isPost: true,
                      );
              },
              childCount: no_of_comments,
            ),
          )
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? kDark[900]
                : kLight,
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) {
                comment = val;
              },
              controller: _tc,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.all(20.0),
                hintText: 'Add a comment',
                prefixIcon: Container(
                  margin: EdgeInsets.all(4.0),
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                      // child: Image(
                      //   height: 48.0,
                      //   width: 48.0,
                      //   image: NetworkImage(widget.post['url']),
                      //   fit: BoxFit.cover,
                      // ),
                      child: FutureBuilder(
                          future: loadImg(widget.dp, memoizer2),
                          builder: (BuildContext context, AsyncSnapshot text) {
                            if (text.connectionState ==
                                ConnectionState.waiting) {
                              return Image(
                                height: 48.0,
                                width: 48.0,
                                image: AssetImage("assets/images/broken.png"),
                                fit: BoxFit.cover,
                              );
                            } else {
                              // return Image(
                              //   image: NetworkImage(text.data.toString()),
                              //   fit: BoxFit.cover,
                              // );
                              return Image(
                                height: 48.0,
                                width: 48.0,
                                image: NetworkImage(text.data.toString()),
                                fit: BoxFit.cover,
                              );
                            }
                          }),
                    ),
                  ),
                ),
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 4.0),
                  width: 70.0,
                  child: IconButton(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(30.0),
                    // ),
                    // color: Color(0xFF23B66F),
                    onPressed: () async {
                      var token = await storage.read(key: "token");
                      Response response = await dio.post(
                          "https://api-tassie.herokuapp.com/feed/addComment",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer " + token!
                          }),
                          data: {
                            'comment': comment,
                            'postUuid': widget.post['uuid']
                          });
                      if (response.data['status'] == true) {
                        widget.plusComment();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    super.widget));
                      }
                    },
                    icon: Icon(
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
