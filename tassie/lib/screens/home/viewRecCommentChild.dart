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
      required this.comment,
      required this.index,
      required this.userUuid,
      required this.recipeUuid,
      required this.removeComment,
      required this.uuid})
      : super(key: key);
  final Map comment;
  final int index;
  final String userUuid;
  final String recipeUuid;
  final void Function(int) removeComment;
  final String? uuid;
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
    print(widget.comment['profilePic']);
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
                        loadImg(widget.comment['profilePic'], memoizerComment),
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
          widget.comment['username'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          widget.comment['comment'],
          style: TextStyle(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? kLight
                : kDark[900],
          ),
        ),
        trailing: (widget.userUuid == widget.uuid ||
                widget.comment['uuid'].split('_comment_')[0] == widget.uuid)
            ? IconButton(
                icon: Icon(
                  Icons.delete_rounded,
                ),
                color: Colors.grey,
                onPressed: () async {
                  var token = await storage.read(key: "token");
                  Response response =
                      await dio.post("http://10.0.2.2:3000/recs/removeComment",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer " + token!
                          }),
                          data: {
                        'recipeUuid': widget.recipeUuid,
                        'commentUuid': widget.comment['uuid'],
                      });

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
