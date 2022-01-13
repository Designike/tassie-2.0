// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/feedPost.dart';
import 'package:tassie/screens/home/profile.dart';
import 'package:tassie/screens/wrapper.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  // List<Map> posts = [
  //   {"name": "Soham", "time": "30 mins", "image": "https://picsum.photos/200"},
  //   {"name": "Soham", "time": "30 mins", "image": "https://picsum.photos/200"},
  //   {"name": "Soham", "time": "30 mins", "image": "https://picsum.photos/200"}
  // ];
  late List posts;
  late List nameList;
  bool isLoading = true;
  final dio = Dio();
  final storage = FlutterSecureStorage();
  Future<void> load() async {
    var token = await storage.read(key: "token");
    // try {
    Response response = await dio.post("https://api-tassie.herokuapp.com/feed/",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token!
        }),
        data: {});

    // to fix error
    if (response.data['data'] != null) {
      print(response.data['data']['post']);

      posts = response.data['data']['post'][0];
    } else {
      posts = [];
    }
    if (response.data['data']['nameList'] != null) {
      nameList = response.data['data']['nameList'];
    } else {
      nameList = [];
    }
    setState(() {
      isLoading = false;
    });
    // } on DioError catch (e) {
    //   if (e.response!.statusCode == 401 &&
    //       e.response!.statusMessage == "Unauthorized") {
    //     await storage.delete(key: "token");
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) {
    //         return Wrapper();
    //       }),
    //     );
    //   } else {
    //     print(e);
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                'Tassie',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'StyleScript',
                  fontSize: 40.0,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 10,
                  thickness: 0.5,
                ),
                if (posts.length > 0)
                  Expanded(
                    child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return FeedPost(
                              index: index, posts: posts, nameList: nameList);
                        }),
                  )
                else
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
                            'Hey! Subscribe other Tassites to get them in feed.',
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
  }
}
