// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/screens/home/recPost.dart';

import '../../constants.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  // recs to be fetched from api
  // List recs = [];
  // List<Map> recs = [
  //   {"name": "Paneer Tikka", "user": "Sommy21", "url": "https://picsum.photos/200", "profilePic": "https://picsum.photos/200"},
  //   {"name": "Dhokla", "user": "parthnamdev", "url": "https://picsum.photos/200", "profilePic": "https://picsum.photos/200"},
  //   {"name": "Khamman", "user": "rishabh", "url": "https://picsum.photos/200", "profilePic": "https://picsum.photos/200"}
  // ];
  final ScrollController _sc = ScrollController();
  static int page = 1;
  static List recs = [];
  bool isLazyLoading = false;
  static bool isLoading = true;
  bool isEnd = false;
  final dio = Dio();
  final storage = FlutterSecureStorage();

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

  Widget _endMessage() {
    print(isEnd);
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: 0.8,
          child: Text('That\'s all for now!'),
        ),
      ),
    );
  }

  void _getMoreData(int index) async {
    if (!isEnd) {
      if (!isLazyLoading) {
        setState(() {
          isLazyLoading = true;
        });
        var url = "http://10.0.2.2:3000/recs/lazyrecs/" + index.toString();
        var token = await storage.read(key: "token");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer " + token!
          }),
        );
        // print(response);
        List tList = [];
        if (response.data['data']['recs'] != null) {
          for (int i = 0;
              i < response.data['data']['recs']['results'].length;
              i++) {
            tList.add(response.data['data']['recs']['results'][i]);
          }
          setState(() {
            if (index == 1) {
              isLoading = false;
            }
            isLazyLoading = false;
            recs.addAll(tList);
            print(recs[0]['name']);
            page++;
          });
          if (response.data['data']['recs']['results'].length == 0) {
            setState(() {
              isEnd = true;
            });
          }
        }
      }
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      page = 1;
      recs = [];
      isEnd = false;
      isLoading = true;
      _getMoreData(page);
    });
  }

  @override
  void initState() {
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
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return (isLoading == true)
        ? Scaffold(
            // backgroundColor: Colors.white,
            body: Center(
              child: SpinKitThreeBounce(
                color: kPrimaryColor,
                size: 50.0,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                  statusBarIconBrightness:
                      MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? Brightness.dark
                          : Brightness.light),
              title: Text(
                'Yumminess ahead !',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'StyleScript',
                  fontSize: 30.0,
                ),
              ),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: _refreshPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 10,
                    thickness: 0.5,
                  ),
                  if (recs.length > 0) ...[
                    Expanded(
                      child: GridView.builder(
                        controller: _sc,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (size.width / 2) /
                              ((size.width / 2) + (size.width / 10) + 100.0),
                        ),
                        itemBuilder: (context, index) {
                          return index == recs.length
                                ? isEnd
                                    ? _endMessage()
                                    : _buildProgressIndicator()
                                // : FeedPost(index: index, posts: posts);
                         : RecPost(recs: recs[index]);
                          // return Container(
                          //   color: Colors.red,
                          // );
                        },
                        itemCount: recs.length,
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.25,
                          ),
                          Image(
                            image: MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? AssetImage('assets/images/no_feed_dark.png')
                                : AssetImage('assets/images/no_feed_light.png'),
                            width: size.width * 0.75,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            width: size.width * 0.75,
                            child: Text(
                              'Subscribe to see others\' recs.',
                              style: TextStyle(fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
  }
}
