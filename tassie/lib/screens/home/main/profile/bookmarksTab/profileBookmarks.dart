import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/feed/viewPost.dart';
import 'package:tassie/screens/home/main/profile/postTab/viewProfilePost.dart';
import 'package:tassie/screens/home/main/recs/viewRecipe.dart';
import 'package:tassie/utils/imgLoader.dart';

class ProfileBookmarks extends StatefulWidget {
  const ProfileBookmarks({Key? key}) : super(key: key);

  @override
  ProfileBookmarksState createState() => ProfileBookmarksState();
}

class ProfileBookmarksState extends State<ProfileBookmarks> {
  var dio = Dio();
  final storage = const FlutterSecureStorage();
  List posts = [];
  List recs = [];
  static int page = 1;
  bool isLazyLoadingR = false;
  bool isLazyLoadingP = false;
  bool isEndR = false;
  bool isEndP = false;
  bool isLoading = true;

  Future<void> _refreshPage() async {
    if (mounted) {
      setState(() {
        // page = 1;
        page = 1;
        recs = [];
        posts = [];
        isLazyLoadingR = false;
        isLazyLoadingP = false;
        isEndR = false;
        isEndP = false;
        isLoading = true;
        getBookmarks();
      });
    }
  }

  Future<void> getBookmarks() async {
    var url = "$baseAPI/profile/lazyBookmark/$page";
    var token = await storage.read(key: "token");
    Response response = await dio.get(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${token!}"
      }),
    );
    if (response.data['data'] != null) {
      if (mounted) {
        setState(() {
          if (page == 1) {
            isLoading = false;
          }
          isLazyLoadingR = false;
          isLazyLoadingP = false;
          if (response.data['data']['recs'] != null) {
            recs.addAll(response.data['data']['recs']);
          }
          if (response.data['data']['posts'] != null) {
            posts.addAll(response.data['data']['posts']);
            // print(posts);
          }
          isLoading = false;
          page++;
        });
      }
      if (response.data['data']['recs'] == null) {
        if (mounted) {
          setState(() {
            isEndR = true;
          });
        }
      }
      if (response.data['data']['posts'] == null) {
        if (mounted) {
          setState(() {
            isEndP = true;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
          isLazyLoadingR = false;
          isLazyLoadingP = false;
        });
      }
    }
  }

  Widget _buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(kDefaultPadding),
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
    page = 1;
    recs = [];
    posts = [];
    isLazyLoadingR = false;
    isLazyLoadingP = false;
    isEndR = false;
    isEndP = false;
    isLoading = true;
    getBookmarks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          physics: const AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, isScrollable) {
            return [
              SliverAppBar(
                elevation: 0,
                // forceElevated: isScrollable,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? kLight
                    : kDark[900],
                title: const Text('Your bookmarks'),
                bottom: TabBar(
                  indicatorColor: kPrimaryColor,
                  unselectedLabelColor: kDark,
                  labelColor: Theme.of(context).brightness == Brightness.dark
                      ? kLight
                      : kDark[900],
                  tabs: const [
                    Tab(icon: Icon(Icons.photo_rounded)),
                    Tab(
                      icon: Icon(Icons.fastfood_rounded),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: isLoading
              ? _buildProgressIndicator()
              : TabBarView(
                  children: [
                    RefreshIndicator(
                      onRefresh: _refreshPage,
                      child: ListView(
                        children: [
                          posts.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  // controller: _sc,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                    // childAspectRatio: (size.width / 2) /
                                    //     ((size.width / 2) + (size.width / 10) + 100.0),
                                  ),
                                  itemBuilder: (context, index) {
                                    return index == posts.length
                                        ? isEndP
                                            ? _endMessage()
                                            : _buildProgressIndicator()
                                        // : FeedPost(index: index, posts: posts);
                                        : GestureDetector(
                                            child: ProfileBookmarksPostChild(
                                                posts: posts[index]),
                                            onTap: () async {
                                              await Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewCommentsPost(
                                                          post: posts[index],
                                                          refreshPage:
                                                              _refreshPage),
                                                ),
                                              );
                                            },
                                          );
                                    // return Container(
                                    //   color: Colors.red,
                                    // );
                                  },
                                  itemCount: posts.length,
                                )
                              : Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(size.width * 0.15),
                                    child: const Text(
                                      'No posts saved',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: _refreshPage,
                      child: ListView(
                        children: [
                          recs.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  // controller: _sc,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                  ),
                                  itemBuilder: (context, index) {
                                    return index == recs.length
                                        ? isEndR
                                            ? _endMessage()
                                            : _buildProgressIndicator()
                                        : GestureDetector(
                                            child: ProfileBookmarksRecipeChild(
                                              recs: recs[index],
                                            ),
                                            onTap: () async {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) => ViewRecPost(
                                                        recs: recs[index],
                                                        refreshPage:
                                                            _refreshPage,
                                                        funcB:
                                                            (isBookmarked) {})),
                                              );
                                            });
                                  },
                                  itemCount: recs.length,
                                )
                              : Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(size.width * 0.15),
                                    child: const Text(
                                      'No recipes saved',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

class ProfileBookmarksPostChild extends StatefulWidget {
  const ProfileBookmarksPostChild({
    Key? key,
    required this.posts,
  }) : super(key: key);

  final Map posts;

  @override
  State<ProfileBookmarksPostChild> createState() =>
      _ProfileBookmarksPostChildState();
}

class _ProfileBookmarksPostChildState extends State<ProfileBookmarksPostChild> {
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;

  @override
  void didUpdateWidget(covariant ProfileBookmarksPostChild oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    memoizer = AsyncMemoizer();
    storedFuture = loadImg(widget.posts['postID'], memoizer);
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
            return Container();
          } else {
            if (!text.hasData) {
              return const Center(
                child: Icon(
                  Icons.refresh,
                  // size: 50.0,
                  color: kDark,
                ),
              );
            }
            return Image(
              image: CachedNetworkImageProvider(text.data.toString()),
              fit: BoxFit.cover,
            );
          }
        });
  }
}

class ProfileBookmarksRecipeChild extends StatefulWidget {
  const ProfileBookmarksRecipeChild({
    Key? key,
    required this.recs,
  }) : super(key: key);

  final Map recs;

  @override
  State<ProfileBookmarksRecipeChild> createState() =>
      _ProfileBookmarksRecipeChildState();
}

class _ProfileBookmarksRecipeChildState
    extends State<ProfileBookmarksRecipeChild> {
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;

  @override
  void didUpdateWidget(covariant ProfileBookmarksRecipeChild oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    memoizer = AsyncMemoizer();
    storedFuture = loadImg(widget.recs['recipeImageID'], memoizer);
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
            return Container();
          } else {
            if (!text.hasData) {
              return const Center(
                child: Icon(
                  Icons.refresh,
                  // size: 50.0,
                  color: kDark,
                ),
              );
            }
            return Image(
              image: CachedNetworkImageProvider(text.data.toString()),
              fit: BoxFit.cover,
            );
          }
        });
  }
}
