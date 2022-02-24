import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/imgLoader.dart';

class ViewRecAllComments extends StatefulWidget {
  const ViewRecAllComments(
      {Key? key, required this.userUuid, required this.recipeUuid})
      : super(key: key);
  final String userUuid;
  final String recipeUuid;
  @override
  _ViewRecAllCommentsState createState() => _ViewRecAllCommentsState();
}

class _ViewRecAllCommentsState extends State<ViewRecAllComments> {
  List comments = [];
  String? uuid;
  final dio = Dio();
  final storage = FlutterSecureStorage();

  final ScrollController _sc = ScrollController();
  final TextEditingController _tc = TextEditingController();
  // static List comments = [];
  bool isLazyLoading = false;
  static bool isLoading = true;
  static int page = 1;
  bool isEnd = false;
  // final dio = Dio();
  // final storage = FlutterSecureStorage();
  String comm = '';
  // String? uuid;

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: isLazyLoading ? 0.8 : 00,
          child: CircularProgressIndicator(
            color: kPrimaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _createComment(Map comment, int index) {
    // Map post = widget.post;
    print(comment);
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
                    future: loadImg(comment['profilePic']),
                    // future: loadImg('assets/Banana.png'),
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
          comment['username'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          comment['comment'],
          style: TextStyle(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? kLight
                : kDark[900],
          ),
        ),
        trailing: (widget.userUuid == uuid ||
                comment['uuid'].split('_comment_')[0] == uuid)
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
                        'commentUuid': comment['uuid'],
                      });
                  setState(() {
                    comments.remove(index);
                  });
                  // widget.minusComment();
                },
              )
            : null,
      ),
    );
  }

  void _getMoreData(int index) async {
    if (!isEnd) {
      print('1');
      if (!isLazyLoading) {
        print('2');
        setState(() {
          isLazyLoading = true;
        });
        var url = "http://10.0.2.2:3000/recs/lazyreccomment/" +
            widget.recipeUuid +
            '/' +
            widget.userUuid +
            '/' +
            index.toString();

        var token = await storage.read(key: "token");
        uuid = await storage.read(key: "uuid");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer " + token!
          }),
        );
        List tList = [];
        print(response);
        if (response.data['data']['comments']['results'] != null) {
          for (int i = 0;
              i <
                  response
                      .data['data']['comments']['results']['comments'].length;
              i++) {
            tList.add(
                response.data['data']['comments']['results']['comments'][i]);
          }

          setState(() {
            if (index == 1) {
              isLoading = false;
            }
            isLazyLoading = false;
            comments.addAll(tList);
            page++;
          });
          if (response.data['data']['comments']['results']['comments'].length ==
              0) {
            setState(() {
              isEnd = true;
            });
          }
        }
        // print(comments);
      }
    }
  }

  @override
  void initState() {
    page = 1;
    comments = [];
    _getMoreData(page);
    super.initState();
    // load();

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      // backgroundColor: Color(0xFFEDF0F6),
      body: CustomScrollView(
        controller: _sc,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return index == comments.length
                    ? isEnd
                        ? null
                        : _buildProgressIndicator()
                    : _createComment(comments[index], index);
              },
              childCount: comments.length,
            ),
          )
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? kDark[900]
                : kLight,
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) {
                comm = val;
              },
              controller: _tc,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.all(20.0),
                hintText: 'Add a comment',
                prefixIcon: Container(
                  margin: EdgeInsets.all(4.0),
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                        // child: Image(
                        //   height: 48.0,
                        //   width: 48.0,
                        //   image: NetworkImage('https://picsum.photos/200'),
                        //   fit: BoxFit.cover,
                        // ),
                        child: FutureBuilder(
                            future: loadImg(storage.read(key: "profilePic")),
                            // future: loadImg('assets/Banana.png'),
                            builder:
                                (BuildContext context, AsyncSnapshot text) {
                              if (text.connectionState ==
                                  ConnectionState.waiting) {
                                return Image.asset("assets/images/broken.png",
                                    fit: BoxFit.cover,
                                    height: 48.0,
                                    width: 48.0);
                              } else {
                                return Image(
                                  height: 48.0,
                                  width: 48.0,
                                  image: NetworkImage(text.data.toString()),
                                  fit: BoxFit.cover,
                                );
                              }
                            })),
                  ),
                ),
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 4.0),
                  width: 70.0,
                  child: IconButton(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(30.0),
                    // ),
                    // color: Color(0xFF23B66F),
                    onPressed: () async {
                      var token = await storage.read(key: "token");
                      Response response = await dio.post(
                          "http://10.0.2.2:3000/recs/addComment",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer " + token!
                          }),
                          data: {
                            'comment': comm,
                            'recipeUuid': widget.recipeUuid
                          });
                      if (response.data['status'] == true) {
                        // widget.plusComment();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    super.widget));
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      size: 25.0,
                      // color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
