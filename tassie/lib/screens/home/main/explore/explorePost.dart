import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/explore/exploreViewPost.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/utils/imgLoader.dart';

class ExplorePost extends StatefulWidget {
  const ExplorePost(
      {required this.post,
      // required this.recostData, required this.funcB
      required this.noOfComment,
      required this.noOfLike,
      required this.isLiked,
      required this.func,
      required this.plusComment,
      required this.bookmark,
      required this.funcB,
      required this.minusComment,
      Key? key})
      : super(key: key);
  final Map post;
  final int noOfComment;
  final int noOfLike;
  final bool bookmark;
  final bool isLiked;
  final void Function(bool) func;
  final void Function(bool) funcB;
  final void Function() plusComment;
  final void Function() minusComment;
  @override
  ExplorePostState createState() => ExplorePostState();
}

class ExplorePostState extends State<ExplorePost> {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizer1 = AsyncMemoizer();
  String? dp;
  late Future storedFuture;
  late Future storedFuture1;
  // String _image = "";
  // bool isImage = false;

  Future<void> getdp() async {
    dp = await storage.read(key: "profilePic");
  }

  @override
  void initState() {
    super.initState();
    getdp();
    memoizer = AsyncMemoizer();
    memoizer1 = AsyncMemoizer();
    storedFuture = loadImg(widget.post['postID'], memoizer);
    storedFuture1 = loadImg(widget.post['profilePic'], memoizer1);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.bookmark);
    Map post = widget.post;
    Size size = MediaQuery.of(context).size;
    return Container(
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
          Column(
            children: <Widget>[
              FutureBuilder(
                  future: storedFuture,
                  builder: (BuildContext context, AsyncSnapshot text) {
                    if ((text.connectionState == ConnectionState.waiting) ||
                        text.hasError) {
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        height: (size.width / 2) - 20.0 - 14.0,
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
                      // return Image(
                      //   image: NetworkImage(text.data.toString()),
                      //   fit: BoxFit.cover,
                      // );

                      if (!text.hasData) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: Container(
                                margin: const EdgeInsets.all(10.0),
                                width: double.infinity,
                                height: (size.width / 2) - 20.0 - 14.0,
                                child: const Center(
                                  child: Icon(
                                    Icons.refresh,
                                    size: 50.0,
                                    color: kDark,
                                  ),
                                )));
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExploreViewComments(
                                    post: post,
                                    noOfComment: widget.noOfComment,
                                    noOfLike: widget.noOfLike,
                                    isLiked: widget.isLiked,
                                    func: widget.func,
                                    plusComment: widget.plusComment,
                                    funcB: widget.funcB,
                                    bookmark: widget.bookmark,
                                    minusComment: widget.minusComment,
                                    dp: dp),
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: double.infinity,
                          height: (size.width / 2) - 20.0 - 14.0,
                          // height: 400.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            image: DecorationImage(
                              image: NetworkImage(text.data.toString()),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }
                  }),
              GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) {
                      return ExploreViewComments(
                          post: post,
                          noOfComment: widget.noOfComment,
                          noOfLike: widget.noOfLike,
                          isLiked: widget.isLiked,
                          func: widget.func,
                          plusComment: widget.plusComment,
                          funcB: widget.funcB,
                          bookmark: widget.bookmark,
                          minusComment: widget.minusComment,
                          dp: dp);
                    }),
                  );
                },
                child: ListTile(
                  minLeadingWidth: (size.width - 42.0) / 12,
                  leading: Container(
                    width: (size.width - 42.0) / 12,
                    height: (size.width - 42.0) / 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      child: ClipOval(
                        // child: Image(
                        //   height: (size.width - 42.0) / 12,
                        //   width: (size.width - 42.0) / 12,
                        //   image: NetworkImage(post['profilePic']),
                        //   fit: BoxFit.cover,
                        // ),
                        child: FutureBuilder(
                            future: storedFuture1,
                            builder:
                                (BuildContext context, AsyncSnapshot text) {
                              if ((text.connectionState ==
                                      ConnectionState.waiting) ||
                                  text.hasError) {
                                // return Image.asset("assets/images/broken.png",
                                //     fit: BoxFit.cover, height: 128, width: 128);
                                return Image(
                                  height: (size.width - 42.0) / 12,
                                  width: (size.width - 42.0) / 12,
                                  image: const AssetImage(
                                      "assets/images/broken.png"),
                                  fit: BoxFit.cover,
                                );
                              } else {
                                if (!text.hasData) {
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                          child: const Center(
                                        child: Icon(
                                          Icons.refresh,
                                          size: 50.0,
                                          color: kDark,
                                        ),
                                      )));
                                }
                                return Image(
                                  height: (size.width - 42.0) / 12,
                                  width: (size.width - 42.0) / 12,
                                  image: NetworkImage(text.data.toString()),
                                  fit: BoxFit.cover,
                                );
                              }
                            }),
                      ),
                    ),
                  ),
                  title: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                          text: post['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.light
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
                      ])),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
