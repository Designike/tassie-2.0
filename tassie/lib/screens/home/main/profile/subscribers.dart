import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/utils/imgLoader.dart';

class Subscribers extends StatefulWidget {
  const Subscribers({Key? key}) : super(key: key);

  @override
  State<Subscribers> createState() => _SubscribersState();
}

class _SubscribersState extends State<Subscribers> {
  static bool isLoading = false;
  static int page = 1;
  bool isLazyLoading = false;
  bool isEnd = false;
  String uuid = "";

  List users = [
    {
      "uuid": '1',
      'name': 'John',
      'username': 'John',
      'profilePic': 'assets/Avacado.png'
    },
    {
      "uuid": '1',
      'name': 'John',
      'username': 'John',
      'profilePic': 'assets/Avacado.png'
    },
    {
      "uuid": '1',
      'name': 'John',
      'username': 'John',
      'profilePic': 'assets/Avacado.png'
    },
  ];

  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final ScrollController _sc = ScrollController();

  Future<void> getSubscribers() async {
    // var url =
    //         "https://api-tassie.herokuapp.com/feed/lazycomment/${widget.post['uuid']}/${widget.post['userUuid']}/$index";
    //     var token = await storage.read(key: "token");
    // var uuid = await storage.read(key: "uuid");
    // Response response = await dio.get(
    //   url,
    //   options: Options(headers: {
    //     HttpHeaders.contentTypeHeader: "application/json",
    //     HttpHeaders.authorizationHeader: "Bearer ${token!}"
    //   }),
    // );
  }

  void _getMoreData(int index) async {
    if (!isEnd) {
      if (!isLazyLoading) {
        if (mounted) {
          setState(() {
            isLazyLoading = true;
          });
        }
        uuid = (await storage.read(key: "uuid"))!;
        var url =
            "https://api-tassie.herokuapp.com/feed/lazycomment/$uuid/${index.toString()}";
        var token = await storage.read(key: "token");

        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
        );
        List tList = [];
        if (response.data['data']['comments']['results'] != null) {
          for (int i = 0;
              i <
                  response
                      .data['data']['comments']['results']['comments'].length;
              i++) {
            tList.add(
                response.data['data']['comments']['results']['comments'][i]);
          }
          if (mounted) {
            setState(() {
              if (index == 1) {
                isLoading = false;
              }
              isLazyLoading = false;
              users.addAll(tList);
              // for (int i = 0; i < tList.length; i++) {
              //   AsyncMemoizer memoizer4 = AsyncMemoizer();
              //   Future storedFuture =
              //       loadImg(tList[i]['profilePic'], memoizer4);
              //   commentStoredFutures.add(storedFuture);
              // }
              page++;
            });
          }
          if (response.data['data']['comments']['results']['comments'].length ==
              0) {
            if (mounted) {
              setState(() {
                isEnd = true;
              });
            }
          }
        }
      }
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: isLazyLoading ? 0.8 : 00,
          child: const CircularProgressIndicator(
            color: kPrimaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _endMessage() {
    return const Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: 0.8,
          child: Text('That\'s all for now!'),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getMoreData(page);
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
    return (isLoading == true)
        ? const Scaffold(
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
              toolbarHeight: kToolbarHeight * 1.1,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                  statusBarIconBrightness:
                      Theme.of(context).brightness == Brightness.light
                          ? Brightness.dark
                          : Brightness.light),
              title: const Text(
                'Subscribers!',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'LobsterTwo',
                  fontSize: 30.0,
                ),
              ),
              centerTitle: true,
            ),
            body: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Profile(uuid: users[index]['uuid']);
                      }),
                    );
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) {
                    //     return Home();
                    //   }),
                    // );
                  },
                  title: Text(users[index]['username']),
                  subtitle: Text(
                    users[index]['name'],
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? kLight
                            : kDark[900]),
                  ),
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: SubscriberUserAvatar(
                          profilePic: users[index]['profilePic']),
                    ),
                  ),
                );
              },
              itemCount: users.length,
            ),
          );
  }
}

class SubscriberUserAvatar extends StatefulWidget {
  const SubscriberUserAvatar({
    Key? key,
    required this.profilePic,
  }) : super(key: key);

  final String profilePic;

  @override
  State<SubscriberUserAvatar> createState() => _SubscriberUserAvatarState();
}

class _SubscriberUserAvatarState extends State<SubscriberUserAvatar> {
  // String _image = "";
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;

  @override
  void initState() {
    super.initState();
    memoizer = AsyncMemoizer();
    storedFuture = loadImg(widget.profilePic, memoizer);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storedFuture,
        builder: (BuildContext context, AsyncSnapshot text) {
          if ((text.connectionState == ConnectionState.waiting) ||
              text.hasError) {
            return const Image(
              height: 50.0,
              width: 50.0,
              image: AssetImage('assets/images/broken.png'),
              fit: BoxFit.cover,
            );
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
              image: NetworkImage(text.data.toString()),
              fit: BoxFit.cover,
            );
          }
        });
  }
}
