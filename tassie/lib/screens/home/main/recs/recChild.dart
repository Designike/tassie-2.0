import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/screens/home/main/recs/viewRecipe.dart';
import 'package:tassie/utils/imgLoader.dart';

import '../../../../constants.dart';

class RecPost extends StatefulWidget {
  const RecPost(
      {required this.recs,
      required this.recipeData,
      required this.funcB,
      Key? key})
      : super(key: key);
  final Map recs;
  final Map recipeData;
  final void Function(bool) funcB;
  // final int index;

  @override
  RecPostState createState() => RecPostState();
}

class RecPostState extends State<RecPost> {
  var storage = const FlutterSecureStorage();
  var dio = Dio();
  // String _image = "";
  // bool isImage = false;
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizer1 = AsyncMemoizer();
  late Future storedFuture;
  late Future storedFuture1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    memoizer = AsyncMemoizer();
    memoizer1 = AsyncMemoizer();
    storedFuture = loadImg(widget.recs['recipeImageID'], memoizer);

    storedFuture1 = loadImg(widget.recs['profilePic'], memoizer1);
    isLoading = false;
    // loadImg(widget.recs['recipeImageID'],memoizer).then((result) {
    //   setState(() {
    //     _image = result;
    //     isImage = true;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isBookmarked = widget.recipeData['isBookmarked'];
    Size size = MediaQuery.of(context).size;
    Map recs = widget.recs;
    return (isLoading)
        ? const Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 50.0,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              height: ((size.width - 40.0) / 2) +
                  50.0, // minus padding, plus list tile
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? kDark[900]
                    : kLight,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Hero(
                        tag: widget.recs['uuid'],
                        child: InkWell(
                          // onDoubleTap: () => print('Bookmark recipe'),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          // child: Container(
                          //   margin: EdgeInsets.all(10.0),
                          //   width: double.infinity,
                          //   height: ((size.width - 40.0) / 2) -
                          //       20, // minus padding, minus margin
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(25.0),
                          //     image: DecorationImage(
                          //       image: !isImage
                          //           ? Image.asset('assets/images/broken.png',
                          //                   fit: BoxFit.cover)
                          //               .image
                          //           : Image.network(_image, fit: BoxFit.cover).image,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          child: FutureBuilder(
                              future: storedFuture,
                              builder:
                                  (BuildContext context, AsyncSnapshot text) {
                                if ((text.connectionState ==
                                        ConnectionState.waiting) ||
                                    text.hasError) {
                                  return Container(
                                    margin: const EdgeInsets.all(10.0),
                                    width: double.infinity,
                                    height: ((size.width - 40.0) / 2) - 20.0,
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
                                    return Container(
                                        margin: const EdgeInsets.all(10.0),
                                        width: double.infinity,
                                        height:
                                            ((size.width - 40.0) / 2) - 20.0,
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
                                    height: ((size.width - 40.0) / 2) - 20.0,
                                    // height: 400.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(text.data.toString()),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        leading: Container(
                          width: (size.width - 40.0) / 12,
                          height: (size.width - 40.0) / 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            child: ClipOval(
                              // child: Image(
                              //   height: (size.width - 40.0) / 12,
                              //   width: (size.width - 40.0) / 12,
                              //   image: NetworkImage(recs['profilePic']),
                              //   fit: BoxFit.cover,
                              // ),
                              child: FutureBuilder(
                                  future: storedFuture1,
                                  builder: (BuildContext context,
                                      AsyncSnapshot text) {
                                    if (text.connectionState ==
                                        ConnectionState.waiting) {
                                      return Image(
                                        height: (size.width - 40.0) / 12,
                                        width: (size.width - 40.0) / 12,
                                        image: const AssetImage(
                                            'assets/images/broken.png'),
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      // return Image(
                                      //   image: NetworkImage(text.data.toString()),
                                      //   fit: BoxFit.cover,
                                      // );
                                      if (!text.hasData) {
                                        return SizedBox(
                                            height: (size.width - 40.0) / 12,
                                            width: (size.width - 40.0) / 12,
                                            child: const Center(
                                              child: Icon(
                                                Icons.refresh,
                                                // size: 50.0,
                                                color: kDark,
                                              ),
                                            ));
                                      }
                                      return Image(
                                        height: (size.width - 40.0) / 12,
                                        width: (size.width - 40.0) / 12,
                                        image:
                                            NetworkImage(text.data.toString()),
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
                                      HttpHeaders.contentTypeHeader:
                                          "application/json",
                                      HttpHeaders.authorizationHeader:
                                          "Bearer ${token!}"
                                    }),
                                    data: {'uuid': recs['uuid']});
                                widget.funcB(true);
                              } else {
                                var token = await storage.read(key: "token");
                                await dio.post(
                                    "https://api-tassie.herokuapp.com/recs/removeBookmark",
                                    options: Options(headers: {
                                      HttpHeaders.contentTypeHeader:
                                          "application/json",
                                      HttpHeaders.authorizationHeader:
                                          "Bearer ${token!}"
                                    }),
                                    data: {'uuid': recs['uuid']});
                                widget.funcB(false);
                              }
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewRecPost(
                                recs: recs,
                                funcB: widget.funcB,
                              ),
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
                          // subtitle: Text(
                          //   recs['username'],
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(
                          //       color: Theme.of(context).brightness ==
                          //               Brightness.dark
                          //           ? kLight
                          //           : kDark[900]),
                          // ),
                          subtitle: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: recs['username'],
                                  style: TextStyle(
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
            ),
          );
  }
}
