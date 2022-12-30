import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/utils/imgLoader.dart';

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
  CreateRatingState createState() => CreateRatingState();
}

class CreateRatingState extends State<CreateRating> {
  final storage = const FlutterSecureStorage();
  AsyncMemoizer memoizerComment = AsyncMemoizer();
  late Future storedFuture;

  @override
  void initState() {
    super.initState();
    memoizerComment = AsyncMemoizer();
    storedFuture = loadImg(widget.rating['profilePic'], memoizerComment);
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
                //   image: CachedNetworkImageProvider(comment['profilePic']),
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
                          image:
                              CachedNetworkImageProvider(text.data.toString()),
                          fit: BoxFit.cover,
                        );
                      }
                    })),
          ),
        ),
        // title: Text(
        //   widget.rating['username'],
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        title: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(children: [
              TextSpan(
                text: widget.rating['username'],
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? kDark[900]
                      : kLight,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => Profile(
                        uuid: widget.rating['uuid'],
                      ),
                    ));
                  },
              ),
            ])),
        subtitle: RatingBarIndicator(
          rating: widget.rating['star'].toDouble(),
          itemBuilder: (context, index) => const Icon(
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
        //               await dio.post("$baseAPI/recs/removeComment",
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
