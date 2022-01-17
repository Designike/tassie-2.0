// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/viewComments.dart';

class FeedPost extends StatefulWidget {
  const FeedPost({
    required this.post,
    required this.noOfComment,
    required this.noOfLike
  });
  final Map post;
  final Map noOfComment;
  final Map noOfLike;
  @override
  _FeedPostState createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  // List<Map> posts = [
  //   {
  //     "name": "Soham",
  //     "time": "30 mins",
  //     "image": "https://picsum.photos/200/300",
  //     "description":
  //         "This is a sample caption for tassie aaaaaaaaaaaaaaaaa a a a a a abc bcd fghLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  //   },
  //   {
  //     "name": "Soham",
  //     "time": "30 mins",
  //     "image": "https://picsum.photos/200",
  //     "description": "This is a sample caption for tassie app."
  //   },
  //   {
  //     "name": "Soham",
  //     "time": "30 mins",
  //     "image": "https://picsum.photos/200",
  //     "description": "This is a sample caption for tassie app."
  //   }
  // ];

  Widget _feedPostElement() {
    Map post = widget.post;
    
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image(
                            height: 50.0,
                            width: 50.0,
                            image: NetworkImage(post['url']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      post['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      post['createdAt'],
                      style: TextStyle(
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? kLight
                              : kDark[900]),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.more_horiz),
                      // color: Colors.black,
                      onPressed: () => print('More'),
                    ),
                  ),
                  InkWell(
                    onDoubleTap: () => print('Like post'),
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: size.width - 40.0,
                      // height: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        image: DecorationImage(
                          image: NetworkImage(post['url']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  iconSize: 30.0,
                                  onPressed: () => print('Like post'),
                                ),
                                Text(
                                  widget.noOfLike['count'].toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20.0),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.chat),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ViewComments(
                                          post: post, noOfComment: widget.noOfComment, noOfLike: widget.noOfLike

                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  widget.noOfComment['count'].toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.bookmark_border),
                          iconSize: 30.0,
                          onPressed: () => print('Save post'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text(
                  //   posts[index]['description'],
                  //   overflow: TextOverflow.ellipsis,
                  //   textAlign: TextAlign.start,
                  // ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewComments(
                              post: post, noOfComment: widget.noOfComment, noOfLike: widget.noOfLike
                            ),
                          ),
                        );
                      },
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: post['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.light
                                        ? kDark[900]
                                        : kLight,
                              ),
                            ),
                            TextSpan(text: " "),
                            TextSpan(
                              text: post['description'],
                              style: TextStyle(
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.light
                                        ? kDark[900]
                                        : kLight,
                              ),
                            )
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _feedPostElement();
  }
}
