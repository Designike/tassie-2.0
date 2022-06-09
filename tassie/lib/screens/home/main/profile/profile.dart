// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/profile/editProfile/editProfile.dart';
import 'package:tassie/screens/home/main/profile/editProfile/editProfileImage.dart';
import 'package:tassie/screens/home/main/profile/bookmarksTab/profileBookmarks.dart';
import 'package:tassie/screens/home/main/profile/postTab/profilePostTab.dart';
import 'package:tassie/screens/home/main/profile/settingsTab/settings.dart';
import 'package:tassie/utils/showMoreText.dart';
import 'package:tassie/utils/snackbar.dart';
import 'package:tassie/utils/imgLoader.dart';
import 'package:tassie/utils/themeModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'recipeTab/profileRecipeTab.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.uuid}) : super(key: key);
  final String uuid;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;
  var dio = Dio();
  final storage = FlutterSecureStorage();
  static int pageR = 1;
  static int pageP = 1;
  List recipes = [];
  List posts = [];
  // List tags = [];
  bool isLazyLoadingR = false;
  bool isLazyLoadingP = false;
  // bool isLazyLoadingT = false;
  // static bool isLoading = false;
  static bool isLoadingR = false;
  static bool isLoadingP = false;
  bool isEndR = false;
  bool isEndP = false;
  bool editBtnClicked = false;
  final ScrollController _sc = ScrollController();
  int subscribeds = 0;
  int subscribers = 0;
  int noOfPosts = 0;
  int noOfRecipes = 0;
  String username = "";
  String bio = "";
  String website = "";
  String name = "";
  bool isSubscribed = false;
  String profilePic = "";
  bool isLoading = true;
  // bool isEndT = false;
  // final dio = Dio();
  // final storage = FlutterSecureStorage();
  final TextEditingController _tc = TextEditingController();
  // Future<void> _getRecipes(int index) async {
  //   if (!isEndR || !isEndP) {
  //     if (!isLazyLoadingR || !isLazyLoadingP) {
  //       print('calling...');
  //       // showSuggestions(context);
  //       setState(() {
  //         isLazyLoadingR = true;
  //         isLazyLoadingP = true;
  //         // isLazyLoadingT = true;
  //       });

  //       // print(query);
  //       var url =
  //           "https://api-tassie.herokuapp.com/profile/lazyProfile/" + index.toString();
  //       var token = await storage.read(key: "token");
  //       Response response = await dio.get(
  //         url,
  //         options: Options(headers: {
  //           HttpHeaders.contentTypeHeader: "application/json",
  //           HttpHeaders.authorizationHeader: "Bearer " + token!
  //         }),
  //       );
  //       print(response);
  //       // print(response.data);
  //       if (response.data['data'] != null) {
  //         setState(() {
  //           // if (index == 1) {
  //           //   isLoading = false;
  //           // }
  //           isLazyLoadingR = false;
  //           isLazyLoadingP = false;
  //           // posts.addAll(tList);
  //           // print(recs);
  //           if (response.data['data']['recs'] != null) {
  //             recipes.addAll(response.data['data']['recs']);
  //             // print(noOfLikes);
  //           }
  //           // if (response.data['data']['tags'] != null) {
  //           //   tags.addAll(response.data['data']['tags']);
  //           //   // print(noOfLikes);
  //           // }
  //           if (response.data['data']['posts'] != null) {
  //             posts.addAll(response.data['data']['posts']);
  //             print(posts);
  //           }
  //           isLoading = false;
  //           page++;
  //         });
  //         // print(response.data['data']['posts']);
  //         if (response.data['data']['recs'] == null) {
  //           setState(() {
  //             isEndR = true;
  //           });
  //         }
  //         if (response.data['data']['posts'] == null) {
  //           setState(() {
  //             isEndP = true;
  //           });
  //         }

  //         // print(recs);
  //       } else {
  //         setState(() {
  //           isLoading = false;
  //           isLazyLoadingR = false;
  //           isLazyLoadingP = false;
  //         });
  //       }
  //     }
  //   }
  // }

  Future<void> _getProfile(memoizer) async {
    print("profile func calling ...");
    print(widget.uuid);
    var url =
        "https://api-tassie.herokuapp.com/profile/getProfile/" + widget.uuid;
    var token = await storage.read(key: "token");
    Response response = await dio.get(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer " + token!
      }),
    );
    print(response.data);
    if (response.data['data'] != null) {
      setState(() {
        subscribeds = response.data['data']['noOfSub']['subscribed'];
        subscribers = response.data['data']['noOfSub']['subscriber'];
        isSubscribed = response.data['data']['noOfSub']['isSubscribed'];
        noOfPosts = response.data['data']['noOfPosts'];
        noOfRecipes = response.data['data']['noOfRecipes'];
        username = response.data['data']['userData']['username'];
        bio = response.data['data']['userData']['bio'];
        website = response.data['data']['userData']['website'];
        name = response.data['data']['userData']['name'];
        profilePic = response.data['data']['userData']['profilePic'];
        isLoading = false;
        storedFuture = loadImg(profilePic, memoizer);
      });
      print("profile data");
      print(response.data['data']);
    } else {
      showSnack(context, "Unable to update", () {}, "OK", 3);
    }
  }

  Future<void> _getRecipes(int index) async {
    if (!isEndR) {
      if (!isLazyLoadingR) {
        print('calling...');
        // showSuggestions(context);
        setState(() {
          isLazyLoadingR = true;
          // isLazyLoadingT = true;
        });

        // print(query);
        var url = "https://api-tassie.herokuapp.com/profile/lazyProfileRecs/" +
            widget.uuid +
            "/" +
            index.toString();
        var token = await storage.read(key: "token");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer " + token!
          }),
        );
        print(response);
        // print(response.data);
        if (response.data['data'] != null) {
          setState(() {
            // if (index == 1) {
            //   isLoading = false;
            // }
            isLazyLoadingR = false;
            // posts.addAll(tList);
            // print(recs);
            if (response.data['data']['recs'] != null) {
              recipes.addAll(response.data['data']['recs']);
              // print(noOfLikes);
            }
            // if (response.data['data']['tags'] != null) {
            //   tags.addAll(response.data['data']['tags']);
            //   // print(noOfLikes);
            // }
            // if (response.data['data']['posts'] != null) {
            //   posts.addAll(response.data['data']['posts']);
            //   print(posts);
            // }
            isLoadingR = false;
            pageR++;
          });
          // print(response.data['data']['posts']);
          if (response.data['data']['recs'] == null) {
            setState(() {
              isEndR = true;
            });
          }

          // print(recs);
        } else {
          setState(() {
            isLoadingR = false;
            isLazyLoadingR = false;
          });
        }
      }
    }
  }

  Future<void> _getPosts(int index) async {
    if (!isEndP) {
      if (!isLazyLoadingP) {
        print('calling...');
        // showSuggestions(context);
        setState(() {
          isLazyLoadingP = true;
          // isLazyLoadingT = true;
        });

        // print(query);
        var url = "https://api-tassie.herokuapp.com/profile/lazyProfilePost/" +
            widget.uuid +
            "/" +
            index.toString();
        var token = await storage.read(key: "token");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer " + token!
          }),
        );
        print(response);
        // print(response.data);
        if (response.data['data'] != null) {
          setState(() {
            // if (index == 1) {
            //   isLoading = false;
            // }
            isLazyLoadingP = false;
            // posts.addAll(tList);
            // print(recs);

            // if (response.data['data']['tags'] != null) {
            //   tags.addAll(response.data['data']['tags']);
            //   // print(noOfLikes);
            // }
            if (response.data['data']['posts'] != null) {
              posts.addAll(response.data['data']['posts']);
              print(posts);
            }
            isLoadingP = false;
            pageP++;
          });
          // print(response.data['data']['posts']);

          if (response.data['data']['posts'] == null) {
            setState(() {
              isEndP = true;
            });
          }

          // print(recs);
        } else {
          setState(() {
            isLoadingP = false;
            isLazyLoadingP = false;
          });
        }
      }
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: 1,
          child: CircularProgressIndicator(
            color: kPrimaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  void _launchURL(url) async {
    try {
      if (!await launch(url)) {
        showSnack(context, 'Could not launch $url', () {}, 'OK', 4);
      }
    } catch (e) {
      showSnack(context, 'Unable to open url', () {}, 'OK', 4);
    }
  }

  Future<void> _refreshPostPage() async {
    if (mounted) {
      memoizer = AsyncMemoizer();
      setState(() {
        pageP = 1;
        // recipes = [];
        posts = [];
        // recosts_toggle = [];
        isEndP = false;
        // isEndR = false;
        isLoadingP = true;
        // isLazyLoadingR = false;
        isLazyLoadingP = false;
        _getProfile(memoizer);
        _getPosts(pageP);
        memoizer = AsyncMemoizer();
      });
    }
  }

  Future<void> _refreshRecipePage() async {
    if (mounted) {
      setState(() {
        pageR = 1;
        recipes = [];
        // posts = [];
        // recosts_toggle = [];
        // isEndP = false;
        isEndR = false;
        isLoadingR = true;
        isLazyLoadingR = false;
        // isLazyLoadingP = false;
        _getRecipes(pageR);
      });
    }
  }

  @override
  void initState() {
    pageR = 1;
    pageP = 1;
    isLoading = true;
    recipes = [];
    // recosts_toggle = [];
    posts = [];
    isEndP = false;
    isEndR = false;
    // isLoading = true;
    isLazyLoadingR = false;
    isLazyLoadingP = false;
    memoizer = AsyncMemoizer();
    _getProfile(memoizer);
    _getPosts(pageP);
    _getRecipes(pageR);

    super.initState();
    // load();

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getPosts(pageP);
        _getRecipes(pageR);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('tassie'),
    //     actions: [
    //       IconButton(
    //         icon: Icon(Icons.logout),
    //         onPressed: () async {
    //           var token = await storage.read(key: "token");
    //           print('1');
    //           Response response = await dio.get(
    //             "https://api-tassie.herokuapp.com/user/logout/",
    //             options: Options(headers: {
    //               HttpHeaders.contentTypeHeader: "application/json",
    //               HttpHeaders.authorizationHeader: "Bearer " + token!
    //             }),
    //           );
    //           print('1.1');
    //           await storage.delete(key: "token");
    //           print('1.1.1');
    //           Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(builder: (context) {
    //               return Wrapper();
    //             }),
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).brightness == Brightness.dark
              ? kLight
              : kDark[900],
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
          ),
          title: Text(
            username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              // color: Theme.of(context).brightness == Brightness.dark
              //     ? kLight
              //     : kDark[900],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.bookmark_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ProfileBookmarks();
                  }),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SettingsPage();
                  }),
                );
              },
            ),
          ],
        ),
        body: NestedScrollView(
          controller: _sc,
          physics: AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, isScrollable) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Center(
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Material(
                              // child: Ink.image(
                              //   height: 128,
                              //   width: 128,
                              //   image:
                              //       NetworkImage('https://picsum.photos/200'),
                              //   fit: BoxFit.cover,
                              //   child: InkWell(
                              //     onTap: () {},
                              //   ),
                              // ),
                              child: (!isLoading)
                                  ? FutureBuilder(
                                      future: storedFuture,
                                      builder: (BuildContext context,
                                          AsyncSnapshot text) {
                                        if ((text.connectionState ==
                                                ConnectionState.waiting) ||
                                            text.hasError) {
                                          return Image.asset(
                                              "assets/images/broken.png",
                                              fit: BoxFit.cover,
                                              height: 128,
                                              width: 128);
                                        } else {
                                          if (!text.hasData) {
                                            return GestureDetector(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Container(
                                                    height: 128,
                                                    width: 128,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.refresh,
                                                        // size: 50.0,
                                                        color: kDark,
                                                      ),
                                                    )));
                                          }
                                          return Ink.image(
                                            height: 128,
                                            width: 128,
                                            image: NetworkImage(
                                                text.data.toString()),
                                            fit: BoxFit.cover,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                    return EditProfileImage();
                                                  }),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      })
                                  : Image.asset("assets/images/broken.png",
                                      fit: BoxFit.cover,
                                      height: 128,
                                      width: 128),
                            ),
                          ),
                          if (widget.uuid == "user") ...[
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: ClipOval(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return EditProfileImage();
                                      }),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: ClipOval(
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        color: kPrimaryColor,
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.15, vertical: 30.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    noOfPosts.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text('Posts'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    noOfRecipes.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text('Recipes'),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            height: 50.0,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(subscribers.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Subscribers'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(subscribeds.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Subscribed'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Name and bio
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          if (bio != "") ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: ShowMoreText(text: bio),
                            ),
                            SizedBox(height: 10.0)
                          ],
                          // Text(
                          //   'm.youtube.com/mitchkoko/',
                          //   style: TextStyle(color: Colors.blue),
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 1,
                          // ),
                          if (website != "") ...[
                            RichText(
                              text: TextSpan(
                                text: website,
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchURL(website);
                                  },
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ]
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: widget.uuid == "user"
                                  ? GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          editBtnClicked = true;
                                        });
                                        var token =
                                            await storage.read(key: "token");
                                        Response response = await dio.post(
                                            "https://api-tassie.herokuapp.com/profile/currentProfile/",
                                            options: Options(headers: {
                                              HttpHeaders.contentTypeHeader:
                                                  "application/json",
                                              HttpHeaders.authorizationHeader:
                                                  "Bearer " + token!
                                            }),
                                            // data: jsonEncode(value),
                                            data: {});
                                        setState(() {
                                          editBtnClicked = false;
                                        });
                                        // print(response.data);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return EditProfilePage(
                                              name: response.data['data']
                                                  ['user']['name'],
                                              bio: response.data['data']['user']
                                                  ['bio'],
                                              website: response.data['data']
                                                  ['user']['website'],
                                              number: response.data['data']
                                                  ['user']['number'],
                                              gender: response.data['data']
                                                  ['user']['gender'],
                                            );
                                          }),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Center(
                                            child: editBtnClicked
                                                ? Text('Loading ...')
                                                : Text('Edit Profile')),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? kDark[900]
                                                    : kLight,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        if (isSubscribed) {
                                          setState(() {
                                            editBtnClicked = true;
                                          });
                                          var token =
                                              await storage.read(key: "token");
                                          Response response = await dio.post(
                                              "https://api-tassie.herokuapp.com/profile/unsubscribe/",
                                              options: Options(headers: {
                                                HttpHeaders.contentTypeHeader:
                                                    "application/json",
                                                HttpHeaders.authorizationHeader:
                                                    "Bearer " + token!
                                              }),
                                              // data: jsonEncode(value),
                                              data: {'uuid': widget.uuid});
                                          if (response.data['status'] == true) {
                                            setState(() {
                                              isSubscribed = false;
                                              editBtnClicked = false;
                                            });
                                          } else {
                                            showSnack(
                                                context,
                                                "Unable to unsubscribe, try again!",
                                                () {},
                                                "OK",
                                                3);
                                            setState(() {
                                              editBtnClicked = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            editBtnClicked = true;
                                          });
                                          var token =
                                              await storage.read(key: "token");
                                          Response response = await dio.post(
                                              "https://api-tassie.herokuapp.com/profile/subscribe/",
                                              options: Options(headers: {
                                                HttpHeaders.contentTypeHeader:
                                                    "application/json",
                                                HttpHeaders.authorizationHeader:
                                                    "Bearer " + token!
                                              }),
                                              // data: jsonEncode(value),
                                              data: {'uuid': widget.uuid});
                                          if (response.data['status'] == true) {
                                            setState(() {
                                              isSubscribed = true;
                                              editBtnClicked = false;
                                            });
                                          } else {
                                            showSnack(
                                                context,
                                                "Unable to subscribe, try again!",
                                                () {},
                                                "OK",
                                                3);
                                            setState(() {
                                              editBtnClicked = false;
                                            });
                                          }
                                        }
                                        // var token =
                                        //     await storage.read(key: "token");
                                        // Response response = await dio.post(
                                        //     "https://api-tassie.herokuapp.com/profile/currentProfile/",
                                        //     options: Options(headers: {
                                        //       HttpHeaders.contentTypeHeader:
                                        //           "application/json",
                                        //       HttpHeaders.authorizationHeader:
                                        //           "Bearer " + token!
                                        //     }),
                                        //     // data: jsonEncode(value),
                                        //     data: {});
                                        // setState(() {
                                        //
                                        // });
                                        // print(response.data);
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) {
                                        //     return EditProfilePage(
                                        //       name: response.data['data']
                                        //           ['user']['name'],
                                        //       bio: response.data['data']['user']
                                        //           ['bio'],
                                        //       website: response.data['data']
                                        //           ['user']['website'],
                                        //       number: response.data['data']
                                        //           ['user']['number'],
                                        //       gender: response.data['data']
                                        //           ['user']['gender'],
                                        //     );
                                        //   }),
                                        // );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Center(
                                          child: editBtnClicked
                                              ? Text('Loading ...')
                                              : isSubscribed
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('Subscribed',
                                                            style: TextStyle(
                                                                color:
                                                                    kPrimaryColor)),
                                                        Icon(Icons.check_circle,
                                                            color:
                                                                kPrimaryColor)
                                                      ],
                                                    )
                                                  : Text('Subscribe'),
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? kDark[900]
                                                    : kLight,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // stories
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
                    //   child: Container(
                    //     height: 110,
                    //     child: ListView(
                    //       scrollDirection: Axis.horizontal,
                    //       children: [
                    //         BubbleStories(text: 'story 1'),
                    //         BubbleStories(text: 'story 2'),
                    //         BubbleStories(text: 'story 3'),
                    //         BubbleStories(text: 'story 4'),
                    //         BubbleStories(text: 'story 5'),
                    //         BubbleStories(text: 'story 6'),
                    //         BubbleStories(text: 'story 7'),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    TabBar(
                      indicatorColor: kPrimaryColor,
                      unselectedLabelColor: kDark,
                      labelColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? kLight
                              : kDark[900],
                      tabs: [
                        Tab(icon: Icon(Icons.photo_rounded)),
                        Tab(
                          icon: Icon(Icons.fastfood_rounded),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.0,
                    )
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            dragStartBehavior: DragStartBehavior.down,
            children: [
              isLoadingP
                  ? _buildProgressIndicator()
                  : PostTab(
                      refreshPage: _refreshPostPage,
                      posts: posts,
                      isEnd: isEndP),
              isLoadingR
                  ? _buildProgressIndicator()
                  : RecipeTab(
                      refreshPage: _refreshRecipePage,
                      recipes: recipes,
                      isEnd: isEndR),
            ],
          ),
        ),
      ),
    );
  }
}
