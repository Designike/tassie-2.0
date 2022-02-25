// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/viewComments.dart';
import 'package:tassie/screens/imgLoader.dart';

class ExplorePost extends StatefulWidget {
  const ExplorePost({
    required this.post,
    // required this.noOfComment,
    // required this.noOfLike,
    // required this.func,
    // required this.plusComment,
    // required this.bookmark,
    // required this.funcB,
    // required this.minusComment
  });
  final Map post;
  // final Map noOfComment;
  // final Map noOfLike;
  // final Map bookmark;
  // final void Function(bool) func;
  // final void Function(bool) funcB;
  // final void Function() plusComment;
  // final void Function() minusComment;
  @override
  _ExplorePostState createState() => _ExplorePostState();
}

class _ExplorePostState extends State<ExplorePost> {
  final dio = Dio();
  final storage = FlutterSecureStorage();
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizer1 = AsyncMemoizer();
  // String _image = "";
  // bool isImage = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoizer = AsyncMemoizer();
    memoizer1 = AsyncMemoizer();

    // loadImg(widget.post['postID']).then((result) {
    //   setState(() {
    //     _image = result;
    //     isImage = true;
    //   });
    // });
    // if (widget.post['postID'] != "") {
    //   isImage = true;
    // }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.bookmark);
    Map post = widget.post;
    // bool isBookmarked = widget.bookmark['isBookmarked'];
    // bool liked = widget.noOfLike['isLiked'];
    // int likeNumber = widget.noOfLike['count'];
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      // height: 560.0,
      decoration: BoxDecoration(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? kDark[900]
            : kLight,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              InkWell(
                // onDoubleTap: () async {
                //   if (!liked) {
                //     var token = await storage.read(key: "token");
                //     dio.post("http://10.0.2.2:3000/feed/like",
                //         options: Options(headers: {
                //           HttpHeaders.contentTypeHeader: "application/json",
                //           HttpHeaders.authorizationHeader:
                //               "Bearer " + token!
                //         }),
                //         data: {'uuid': post['uuid']});
                //     widget.func(true);
                //   }
                // },
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => ViewComments(
                  //         post: post,
                  //         noOfComment: widget.noOfComment,
                  //         noOfLike: widget.noOfLike,
                  //         func: widget.func,
                  //         plusComment: widget.plusComment,
                  //         funcB: widget.funcB,
                  //         bookmark: widget.bookmark,
                  //         minusComment: widget.minusComment,
                  //       ),
                  //     )
                  //     );
                },
                // child: Container(
                //   margin: EdgeInsets.all(10.0),
                //   width: double.infinity,
                //   height: (size.width / 2) - 20.0 - 14.0,
                //   // height: 400.0,
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
                    future: loadImg(widget.post['postID'], memoizer),
                    builder: (BuildContext context, AsyncSnapshot text) {
                      if (text.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: EdgeInsets.all(10.0),
                          width: double.infinity,
                          height: (size.width / 2) - 20.0 - 14.0,
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
                          height: (size.width / 2) - 20.0 - 14.0,
                          // height: 400.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            image: DecorationImage(
                              image: NetworkImage(text.data.toString()),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    }),
              ),
              ListTile(
                minLeadingWidth: (size.width - 42.0) / 12,
                leading: Container(
                  width: (size.width - 42.0) / 12,
                  height: (size.width - 42.0) / 12,
                  decoration: BoxDecoration(
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
                            future: loadImg(post['profilePic'], memoizer1),
                            builder:
                                (BuildContext context, AsyncSnapshot text) {
                              if (text.connectionState ==
                                  ConnectionState.waiting) {
                                // return Image.asset("assets/images/broken.png",
                                //     fit: BoxFit.cover, height: 128, width: 128);
                                return Image(
                                  height: (size.width - 42.0) / 12,
                                  width: (size.width - 42.0) / 12,
                                  image: AssetImage("assets/images/broken.png"),
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Image(
                                  height: (size.width - 42.0) / 12,
                                  width: (size.width - 42.0) / 12,
                                  image: NetworkImage(text.data.toString()),
                                  fit: BoxFit.cover,
                                );
                              }
                            }),),
                  ),
                ),
                title: Text(
                  post['username'],
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // subtitle: Text(
                //   post['createdAt'],
                //   style: TextStyle(
                //       color: MediaQuery.of(context).platformBrightness ==
                //               Brightness.dark
                //           ? kLight
                //           : kDark[900]),
                // ),
                // trailing: IconButton(
                //   icon: Icon(Icons.more_horiz),
                //   // color: Colors.black,
                //   onPressed: () => print('More'),
                // ),
                // trailing: IconButton(
                //       icon: (isBookmarked)
                //           ? Icon(Icons.bookmark)
                //           : Icon(Icons.bookmark_border),
                //       iconSize: 30.0,
                //       onPressed: () async {
                //         if (!isBookmarked) {
                //           var token = await storage.read(key: "token");
                //           Response response = await dio
                //               .post("http://10.0.2.2:3000/feed/bookmark",
                //                   options: Options(headers: {
                //                     HttpHeaders.contentTypeHeader:
                //                         "application/json",
                //                     HttpHeaders.authorizationHeader:
                //                         "Bearer " + token!
                //                   }),
                //                   data: {'uuid': post['uuid']});
                //           widget.funcB(true);
                //         } else {
                //           var token = await storage.read(key: "token");
                //           Response response = await dio.post(
                //               "http://10.0.2.2:3000/feed/removeBookmark",
                //               options: Options(headers: {
                //                 HttpHeaders.contentTypeHeader:
                //                     "application/json",
                //                 HttpHeaders.authorizationHeader:
                //                     "Bearer " + token!
                //               }),
                //               data: {'uuid': post['uuid']});
                //           widget.funcB(false);
                //         }
                //       },
                //     ),
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
              //                 icon: (!liked)
              //                     ? Icon(Icons.favorite_border)
              //                     : Icon(
              //                         Icons.favorite,
              //                         color: kPrimaryColor,
              //                       ),
              //                 iconSize: 30.0,
              //                 onPressed: () async {
              //                   if (liked) {
              //                     // print(post);

              //                     var token =
              //                         await storage.read(key: "token");
              //                     dio.post(
              //                         "http://10.0.2.2:3000/feed/unlike",
              //                         options: Options(headers: {
              //                           HttpHeaders.contentTypeHeader:
              //                               "application/json",
              //                           HttpHeaders.authorizationHeader:
              //                               "Bearer " + token!
              //                         }),
              //                         data: {'uuid': post['uuid']});
              //                     widget.func(false);
              //                   } else {
              //                     // print(post);

              //                     var token =
              //                         await storage.read(key: "token");
              //                     dio.post("http://10.0.2.2:3000/feed/like",
              //                         options: Options(headers: {
              //                           HttpHeaders.contentTypeHeader:
              //                               "application/json",
              //                           HttpHeaders.authorizationHeader:
              //                               "Bearer " + token!
              //                         }),
              //                         data: {'uuid': post['uuid']});
              //                     widget.func(true);
              //                   }
              //                   print(likeNumber.toString());
              //                 },
              //               ),
              //               Text(
              //                 likeNumber.toString(),
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
              //                       builder: (_) => ViewComments(
              //                           post: post,
              //                           noOfComment: widget.noOfComment,
              //                           noOfLike: widget.noOfLike,
              //                           func: widget.func,
              //                           plusComment: widget.plusComment,
              //                           funcB: widget.funcB,
              //                           bookmark: widget.bookmark,
              //                           minusComment: widget.minusComment),
              //                     ),
              //                   );
              //                 },
              //               ),
              //               Text(
              //                 widget.noOfComment['count'].toString(),
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
              //         icon: (isBookmarked)
              //             ? Icon(Icons.bookmark)
              //             : Icon(Icons.bookmark_border),
              //         iconSize: 30.0,
              //         onPressed: () async {
              //           if (!isBookmarked) {
              //             var token = await storage.read(key: "token");
              //             Response response = await dio
              //                 .post("http://10.0.2.2:3000/feed/bookmark",
              //                     options: Options(headers: {
              //                       HttpHeaders.contentTypeHeader:
              //                           "application/json",
              //                       HttpHeaders.authorizationHeader:
              //                           "Bearer " + token!
              //                     }),
              //                     data: {'uuid': post['uuid']});
              //             widget.funcB(true);
              //           } else {
              //             var token = await storage.read(key: "token");
              //             Response response = await dio.post(
              //                 "http://10.0.2.2:3000/feed/removeBookmark",
              //                 options: Options(headers: {
              //                   HttpHeaders.contentTypeHeader:
              //                       "application/json",
              //                   HttpHeaders.authorizationHeader:
              //                       "Bearer " + token!
              //                 }),
              //                 data: {'uuid': post['uuid']});
              //             widget.funcB(false);
              //           }
              //         },
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
          //       //   posts[index]['description'],
          //       //   overflow: TextOverflow.ellipsis,
          //       //   textAlign: TextAlign.start,
          //       // ),
          //       Flexible(
          //         child: GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (_) => ViewComments(
          //                     post: post,
          //                     noOfComment: widget.noOfComment,
          //                     noOfLike: widget.noOfLike,
          //                     func: widget.func,
          //                     plusComment: widget.plusComment,
          //                     funcB: widget.funcB,
          //                     bookmark: widget.bookmark,
          //                     minusComment: widget.minusComment,
          //                   ),
          //                 )
          //                 );
          //           },
          //           child: RichText(
          //             overflow: TextOverflow.ellipsis,
          //             text: TextSpan(
          //               children: [
          //                 TextSpan(
          //                   text: post['username'],
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     color:
          //                         MediaQuery.of(context).platformBrightness ==
          //                                 Brightness.light
          //                             ? kDark[900]
          //                             : kLight,
          //                   ),
          //                 ),
          //                 TextSpan(text: " "),
          //                 TextSpan(
          //                   text: post['description'],
          //                   style: TextStyle(
          //                     color:
          //                         MediaQuery.of(context).platformBrightness ==
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
