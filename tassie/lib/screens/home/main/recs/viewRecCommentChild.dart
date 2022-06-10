import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';

class CreateComment extends StatefulWidget {
  const CreateComment(
      {Key? key,
      required this.recost,
      required this.index,
      required this.userUuid,
      required this.recipeUuid,
      required this.removeComment,
      required this.uuid,
      required this.isPost,
      required this.storedFuture})
      : super(key: key);
  final Map recost;
  final int index;
  final String userUuid;
  final String recipeUuid;
  final void Function(int) removeComment;
  final String? uuid;
  final bool isPost;
  final Future storedFuture;
  @override
  CreateCommentState createState() => CreateCommentState();
}

class CreateCommentState extends State<CreateComment> {
  final storage = const FlutterSecureStorage();
  AsyncMemoizer memoizerComment = AsyncMemoizer();
  late Future storedFuture;
  final dio = Dio();
  @override
  void initState() {
    super.initState();
    memoizerComment = AsyncMemoizer();
    // storedFuture = loadImg(widget.recost['profilePic'], memoizerComment);
    storedFuture = widget.storedFuture;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(comment);
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
                //   image: NetworkImage(comment['profilePic']),
                //   fit: BoxFit.cover,
                // ),
                child: FutureBuilder(
                    future: storedFuture,
                    // future: loadImg('assets/Banana.png',memoizer),
                    builder: (BuildContext context, AsyncSnapshot text) {
                      if ((text.connectionState == ConnectionState.waiting) ||
                          text.hasError) {
                        return Image.asset("assets/images/broken.png",
                            fit: BoxFit.cover, height: 50.0, width: 50.0);
                      } else {
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
                          image: NetworkImage(text.data.toString()),
                          fit: BoxFit.cover,
                        );
                      }
                    })),
          ),
        ),
        // title: Text(
        //   widget.recost['username'],
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        title: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(children: [
              TextSpan(
                text: widget.recost['username'],
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? kDark[900]
                      : kLight,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => Profile(
                        uuid: widget.recost['userUuid'],
                      ),
                    ));
                  },
              ),
            ])),
        subtitle: Text(
          widget.recost['comment'],
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? kLight
                : kDark[900],
          ),
        ),
        trailing: (widget.userUuid == widget.uuid ||
                widget.recost['uuid'].split('_comment_')[0] == widget.uuid)
            ? IconButton(
                icon: const Icon(
                  Icons.delete_rounded,
                ),
                color: Colors.grey,
                onPressed: () async {
                  var token = await storage.read(key: "token");
                  String url = widget.isPost
                      ? "https://api-tassie.herokuapp.com/feed/removeComment"
                      : "https://api-tassie.herokuapp.com/recs/removeComment";
                  Map data = widget.isPost
                      ? {
                          'postUuid': widget.recipeUuid,
                          'commentUuid': widget.recost['uuid'],
                        }
                      : {
                          'recipeUuid': widget.recipeUuid,
                          'commentUuid': widget.recost['uuid'],
                        };
                  await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer ${token!}"
                      }),
                      data: data);

                  // setState(() {
                  //   widget.comments.remove(widget.index);
                  // });

                  widget.removeComment(widget.index);
                  // setState(() {});
                },
              )
            : null,
      ),
    );
  }
}
