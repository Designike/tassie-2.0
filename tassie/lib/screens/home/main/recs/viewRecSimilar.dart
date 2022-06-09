// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/screens/home/main/recs/viewRecipe.dart';
import 'package:tassie/utils/imgLoader.dart';

import '../../../../constants.dart';

class ViewRecSimilarRec extends StatefulWidget {
  const ViewRecSimilarRec(
      {required this.recs, required this.funcB, required this.storedFuture});

  final Map recs;
  // final Map recostData;
  final void Function(bool) funcB;
  final Future storedFuture;
  // final int index;

  @override
  _ViewRecSimilarRecState createState() => _ViewRecSimilarRecState();
}

class _ViewRecSimilarRecState extends State<ViewRecSimilarRec> {
  // String _image = "";
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.recs);
    memoizer = AsyncMemoizer();
    // storedFuture = loadImg(widget.recs['recipeImageID'], memoizer);
    storedFuture = widget.storedFuture;
    // loadImg(widget.recs['recipeImageID'], memoizer).then((result) {
    //   setState(() {
    //     _image = result;
    //     // isImage = true;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var storage = FlutterSecureStorage();
    var dio = Dio();
    // bool isBookmarked = widget.recostData['isBookmarked'];
    Size size = MediaQuery.of(context).size;
    Map recs = widget.recs;
    return Container(
      width: 150.0,
      margin: EdgeInsets.only(right: 15.0),
      // height: 300.0,
      // height: ((size.width - 42.0)/2) + 120.0, // minus padding, plus list tile
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
              InkWell(
                  // onDoubleTap: () => print('Bookmark recipe'),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  // child: Container(
                  //   margin: EdgeInsets.all(10.0),
                  //   width: double.infinity,
                  //   height: ((size.width - 42.0) / 2) -
                  //       20, // minus padding, minus margin
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(25.0),
                  //     image: DecorationImage(
                  //       image: _image == ""
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
                      builder: (BuildContext context, AsyncSnapshot text) {
                        if ((text.connectionState == ConnectionState.waiting) ||
                            text.hasError) {
                          // return Image.asset("assets/images/broken.png",
                          //     fit: BoxFit.cover, height: 128, width: 128);
                          return Container(
                            margin: EdgeInsets.all(10.0),
                            width: double.infinity,
                            // height: ((size.width - 42.0) / 2) -
                            //     20, // minus padding, minus margin
                            height: 150 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              image: DecorationImage(
                                image: AssetImage('assets/images/broken.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          if (!text.hasData) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    width: double.infinity,
                                    // height: ((size.width - 42.0) / 2) -
                                    //     20, // minus padding, minus margin
                                    height: 150 - 20,
                                    child: Center(
                                      child: Icon(
                                        Icons.refresh,
                                        size: 50.0,
                                        color: kDark,
                                      ),
                                    )));
                          }
                          return Container(
                            margin: EdgeInsets.all(10.0),
                            width: double.infinity,
                            // height: ((size.width - 42.0) / 2) -
                            //     20, // minus padding, minus margin
                            height: 150 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              image: DecorationImage(
                                image: NetworkImage(text.data.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      })),
              // ListTile(
              //   dense: true,
              //   leading: Container(
              //     width: (size.width - 42.0) / 12,
              //     height: (size.width - 42.0) / 12,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //     ),
              //     child: CircleAvatar(
              //       child: ClipOval(
              //         child: Image(
              //           height: (size.width - 42.0) / 12,
              //           width: (size.width - 42.0) / 12,
              //           image: NetworkImage(recs['profilePic']),
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //   ),
              //   trailing: IconButton(
              //     icon: (isBookmarked)
              //         ? Icon(Icons.bookmark)
              //         : Icon(Icons.bookmark_border),
              //     // color: Colors.black,
              //     onPressed: () async {
              //       if (!isBookmarked) {
              //         var token = await storage.read(key: "token");
              //         Response response =
              //             await dio.post("https://api-tassie.herokuapp.com/recs/bookmark",
              //                 options: Options(headers: {
              //                   HttpHeaders.contentTypeHeader:
              //                       "application/json",
              //                   HttpHeaders.authorizationHeader:
              //                       "Bearer " + token!
              //                 }),
              //                 data: {'uuid': recs['uuid']});
              //         widget.funcB(true);
              //       } else {
              //         var token = await storage.read(key: "token");
              //         Response response = await dio.post(
              //             "https://api-tassie.herokuapp.com/recs/removeBookmark",
              //             options: Options(headers: {
              //               HttpHeaders.contentTypeHeader: "application/json",
              //               HttpHeaders.authorizationHeader: "Bearer " + token!
              //             }),
              //             data: {'uuid': recs['uuid']});
              //         widget.funcB(false);
              //       }
              //     },
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) =>
                  // ViewRecPost(recs: recs, funcB: widget.funcB),
                  //   ),
                  // );
                },
                child: ListTile(
                  title: Text(
                    recs['name'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // subtitle: Text(
                  //   recs['username'],
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //       color: Theme.of(context).brightness == Brightness.dark
                  //           ? kLight
                  //           : kDark[900]),
                  // ),
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
                                  uuid: recs['uuid'],
                                ),
                              ));
                            },
                        ),
                      ])),
                  isThreeLine: true,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           Row(
              //             children: [
              //               IconButton(
              //                 icon: Icon(Icons.favorite_border),
              //                 iconSize: 30.0,
              //                 onPressed: () => print('Like post'),
              //               ),
              //               Text(
              //                 '2,515',
              //                 style: TextStyle(
              //                   fontSize: 14.0,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           SizedBox(width: 20.0),
              //           Row(
              //             children: <Widget>[
              //               IconButton(
              //                 icon: Icon(Icons.chat),
              //                 iconSize: 30.0,
              //                 onPressed: () {
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (_) => ViewViewRecSimilarRec(
              //                         recs: recs[index],
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               ),
              //               Text(
              //                 '350',
              //                 style: TextStyle(
              //                   fontSize: 14.0,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //       IconButton(
              //         icon: Icon(Icons.bookmark_border),
              //         iconSize: 30.0,
              //         onPressed: () => print('Save post'),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 20.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       // Text(
          //       //   recs[index]['description'],
          //       //   overflow: TextOverflow.ellipsis,
          //       //   textAlign: TextAlign.start,
          //       // ),
          //       Flexible(
          //         child: GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (_) => ViewViewRecSimilarRec(
          //                   recs: recs[index],
          //                 ),
          //               ),
          //             );
          //           },
          //           child: RichText(
          //             overflow: TextOverflow.ellipsis,
          //             text: TextSpan(
          //               children: [
          //                 TextSpan(
          //                   text: recs[index]['username'],
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     color:
          //                         Theme.of(context).brightness ==
          //                                 Brightness.light
          //                             ? kDark[900]
          //                             : kLight,
          //                   ),
          //                 ),
          //                 TextSpan(text: " "),
          //                 TextSpan(
          //                   text: recs[index]['description'],
          //                   style: TextStyle(
          //                     color:
          //                         Theme.of(context).brightness ==
          //                                 Brightness.light
          //                             ? kDark[900]
          //                             : kLight,
          //                   ),
          //                 )
          //               ],
          //             ),
          //             textAlign: TextAlign.start,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
