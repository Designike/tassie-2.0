import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/imgLoader.dart';

class CreateRating extends StatefulWidget {
  const CreateRating(
      {Key? key,
      required this.rating,
      required this.index,
      required this.userUuid,
      required this.recipeUuid,
      required this.removeRating,
      required this.uuid})
      : super(key: key);
  final Map rating;
  final int index;
  final String userUuid;
  final String recipeUuid;
  final void Function(int) removeRating;
  final String? uuid;
  @override
  _CreateRatingState createState() => _CreateRatingState();
}

class _CreateRatingState extends State<CreateRating> {
  final storage = FlutterSecureStorage();
  AsyncMemoizer memoizerComment = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    memoizerComment = AsyncMemoizer();
    print(widget.rating['profilePic']);
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
                        loadImg(widget.rating['profilePic'], memoizerComment),
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
          widget.rating['username'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: RatingBarIndicator(
          rating: widget.rating['star'].toDouble(),
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: kPrimaryColor,
          ),
          itemCount: 5,
          itemSize: 20.0,
        ),
        // trailing: (widget.userUuid == widget.uuid ||
        //         widget.rating['uuid'].split('_comment_')[0] == widget.uuid)
        //     ? IconButton(
        //         icon: Icon(
        //           Icons.delete_rounded,
        //         ),
        //         color: Colors.grey,
        //         onPressed: () async {
        //           var token = await storage.read(key: "token");
        //           Response response =
        //               await dio.post("https://api-tassie-alt.herokuapp.com/recs/removeComment",
        //                   options: Options(headers: {
        //                     HttpHeaders.contentTypeHeader: "application/json",
        //                     HttpHeaders.authorizationHeader: "Bearer " + token!
        //                   }),
        //                   data: {
        //                 'recipeUuid': widget.recipeUuid,
        //                 'commentUuid': widget.rating['uuid'],
        //               });

        //           // setState(() {
        //           //   widget.comments.remove(widget.index);
        //           // });

        //           widget.removeRating(widget.index);
        //           // setState(() {});
        //         },
        //       )
        //     : null,
      ),
    );
  }
}
