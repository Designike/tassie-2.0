import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/screens/home/main/recs/viewRecipe.dart';
import 'package:tassie/utils/imgLoader.dart';

import '../../../../constants.dart';

class ExploreRec extends StatefulWidget {
  const ExploreRec(
      {required this.recs,
      required this.recostData,
      required this.funcB,
      Key? key})
      : super(key: key);

  final Map recs;
  final Map recostData;
  final void Function(bool) funcB;
  // final int index;

  @override
  ExploreRecState createState() => ExploreRecState();
}

class ExploreRecState extends State<ExploreRec> {
  String image = "";
  bool isImage = false;
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizer1 = AsyncMemoizer();
  late Future storedFuture;
  late Future storedFuture1;

  @override
  void initState() {
    super.initState();
    memoizer = AsyncMemoizer();
    memoizer1 = AsyncMemoizer();
    storedFuture = loadImg(widget.recs['recipeImageID'], memoizer);
    storedFuture1 = loadImg(widget.recs['profilePic'], memoizer1);
    if (widget.recs['recipeImageID'] != "") {
      isImage = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var storage = const FlutterSecureStorage();
    var dio = Dio();
    bool isBookmarked = widget.recostData['isBookmarked'];
    Size size = MediaQuery.of(context).size;
    Map recs = widget.recs;
    return Container(
      width: double.infinity,
      // height: ((size.width - 42.0)/2) + 120.0, // minus padding, plus list tile
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
        children: [
          Column(
            children: [
              Hero(
                tag: recs['uuid'],
                child: FutureBuilder(
                    future: storedFuture,
                    builder: (BuildContext context, AsyncSnapshot text) {
                      if (text.connectionState == ConnectionState.waiting) {
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
                      } else if (text.error != null) {
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
                        //   image: CachedNetworkImageProvider(text.data.toString()),
                        //   fit: BoxFit.cover,
                        // );
                        if (!text.hasData) {
                          return Container(
                              margin: const EdgeInsets.all(10.0),
                              width: double.infinity,
                              height: (size.width / 2) - 20.0 - 14.0,
                              child: const Center(
                                child: Icon(
                                  Icons.refresh,
                                  size: 50.0,
                                  color: kDark,
                                ),
                              ));
                        }
                        return InkWell(
                          onDoubleTap: () => {},
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            width: double.infinity,
                            height: (size.width / 2) - 20.0 - 14.0,
                            // height: 400.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  text.data.toString(),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              ),
              ListTile(
                dense: true,
                leading: Container(
                  width: (size.width - 42.0) / 12,
                  height: (size.width - 42.0) / 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: FutureBuilder(
                          future: storedFuture1,
                          builder: (BuildContext context, AsyncSnapshot text) {
                            if ((text.connectionState ==
                                    ConnectionState.waiting) ||
                                text.hasError) {
                              return Image(
                                height: (size.width - 42.0) / 12,
                                width: (size.width - 42.0) / 12,
                                image: const AssetImage(
                                    'assets/images/broken.png'),
                                fit: BoxFit.cover,
                              );
                            } else {
                              if (!text.hasData) {
                                return const Center(
                                  child: Icon(
                                    Icons.refresh,
                                    // size: 50.0,
                                    color: kDark,
                                  ),
                                );
                              }
                              return Image(
                                height: (size.width - 42.0) / 12,
                                width: (size.width - 42.0) / 12,
                                image: CachedNetworkImageProvider(
                                    text.data.toString()),
                                fit: BoxFit.cover,
                              );
                            }
                          }),
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: (isBookmarked)
                      ? const Icon(Icons.bookmark)
                      : const Icon(Icons.bookmark_border),
                  // color: Colors.black,
                  onPressed: () async {
                    if (!isBookmarked) {
                      var token = await storage.read(key: "token");
                      await dio.post(
                          "https://api-tassie.herokuapp.com/recs/bookmark",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer ${token!}"
                          }),
                          data: {'uuid': recs['uuid']});
                      widget.funcB(true);
                    } else {
                      var token = await storage.read(key: "token");
                      await dio.post(
                          "https://api-tassie.herokuapp.com/recs/removeBookmark",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer ${token!}"
                          }),
                          data: {'uuid': recs['uuid']});
                      widget.funcB(false);
                    }
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewRecPost(recs: recs, funcB: widget.funcB),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    recs['name'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                          text: recs['username'],
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? kDark[900]
                                    : kLight,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => Profile(
                                  uuid: recs['userUuid'],
                                ),
                              ));
                            },
                        ),
                      ])),
                  isThreeLine: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
