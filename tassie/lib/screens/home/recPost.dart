// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/screens/home/viewRecPost.dart';
import 'package:tassie/screens/imgLoader.dart';

import '../../constants.dart';

class RecPost extends StatefulWidget {
  const RecPost(
      {required this.recs, required this.recipeData, required this.funcB});
  final Map recs;
  final Map recipeData;
  final void Function(bool) funcB;
  // final int index;

  @override
  _RecPostState createState() => _RecPostState();
}

class _RecPostState extends State<RecPost> {
  var storage = FlutterSecureStorage();
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
    // TODO: implement initState
    super.initState();
    memoizer = AsyncMemoizer();
    memoizer1 = AsyncMemoizer();
    storedFuture = loadImg(widget.recs['recipeImageID'], memoizer);
    print("HENLO");
    print(storedFuture);
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
  Widget build(BuildContext context) {
    bool isBookmarked = widget.recipeData['isBookmarked'];
    Size size = MediaQuery.of(context).size;
    Map recs = widget.recs;
    return (isLoading)
        ? Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 50.0,
            ),
          )
        : Padding(
            padding: EdgeInsets.all(10.0),
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
                                if (text.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    margin: EdgeInsets.all(10.0),
                                    width: double.infinity,
                                    height: ((size.width - 40.0) / 2) - 20.0,
                                    // height: 400.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
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
                          decoration: BoxDecoration(
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
                                        image: AssetImage(
                                            'assets/images/broken.png'),
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      // return Image(
                                      //   image: NetworkImage(text.data.toString()),
                                      //   fit: BoxFit.cover,
                                      // );
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
                                ? Icon(Icons.bookmark)
                                : Icon(Icons.bookmark_border),
                            // color: Colors.black,
                            onPressed: () async {
                              if (!isBookmarked) {
                                var token = await storage.read(key: "token");
                                Response response = await dio.post(
                                    "https://api-tassie-alt.herokuapp.com/recs/bookmark",
                                    options: Options(headers: {
                                      HttpHeaders.contentTypeHeader:
                                          "application/json",
                                      HttpHeaders.authorizationHeader:
                                          "Bearer " + token!
                                    }),
                                    data: {'uuid': recs['uuid']});
                                widget.funcB(true);
                              } else {
                                var token = await storage.read(key: "token");
                                Response response = await dio.post(
                                    "https://api-tassie-alt.herokuapp.com/recs/removeBookmark",
                                    options: Options(headers: {
                                      HttpHeaders.contentTypeHeader:
                                          "application/json",
                                      HttpHeaders.authorizationHeader:
                                          "Bearer " + token!
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            recs['username'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? kLight
                                    : kDark[900]),
                          ),
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
                      //                       builder: (_) => ViewRecPost(
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
                  //                 builder: (_) => ViewRecPost(
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
            ),
          );
  }
}
