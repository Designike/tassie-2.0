import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/imgLoader.dart';

class CreateComment extends StatefulWidget {
  const CreateComment(
      {Key? key,
      required this.recost,
      required this.index,
      required this.userUuid,
      required this.recipeUuid,
      required this.removeComment,
      required this.uuid,
      required this.isPost})
      : super(key: key);
  final Map recost;
  final int index;
  final String userUuid;
  final String recipeUuid;
  final void Function(int) removeComment;
  final String? uuid;
  final bool isPost;
  @override
  _CreateCommentState createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
  final storage = FlutterSecureStorage();
  AsyncMemoizer memoizerComment = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    memoizerComment = AsyncMemoizer();
    print(widget.recost['profilePic']);
  }

  @override
  Widget build(BuildContext context) {
    // print(comment);
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
                // child: Image(
                //   height: 50.0,
                //   width: 50.0,
                //   image: NetworkImage(comment['profilePic']),
                //   fit: BoxFit.cover,
                // ),
                child: FutureBuilder(
                    future:
                        loadImg(widget.recost['profilePic'], memoizerComment),
                    // future: loadImg('assets/Banana.png',memoizer),
                    builder: (BuildContext context, AsyncSnapshot text) {
                      if (text.connectionState == ConnectionState.waiting) {
                        return Image.asset("assets/images/broken.png",
                            fit: BoxFit.cover, height: 50.0, width: 50.0);
                      } else {
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
        title: Text(
          widget.recost['username'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
                icon: Icon(
                  Icons.delete_rounded,
                ),
                color: Colors.grey,
                onPressed: () async {
                  var token = await storage.read(key: "token");
                  String url = widget.isPost
                      ? "http://10.0.2.2:3000/feed/removeComment"
                      : "http://10.0.2.2:3000/recs/removeComment";
                  Map data = widget.isPost
                      ? {
                          'postUuid': widget.recipeUuid,
                          'commentUuid': widget.recost['uuid'],
                        }
                      : {
                          'recipeUuid': widget.recipeUuid,
                          'commentUuid': widget.recost['uuid'],
                        };
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
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
