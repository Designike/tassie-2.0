import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/explore/search/exploreSearchHashtagTab.dart';
import 'package:tassie/screens/home/main/explore/search/exploreSearchRecipeTab.dart';
import 'package:tassie/screens/home/main/explore/search/exploreSearchUserTab.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  String query = "";
  static int page = 1;
  List recipes = [];
  List users = [];
  List tags = [];
  bool isLazyLoadingR = false;
  bool isLazyLoadingU = false;
  bool isLazyLoadingT = false;
  static bool isLoading = false;
  bool isEndR = false;
  bool isEndU = false;
  bool isEndT = false;
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final TextEditingController _tc = TextEditingController();
  void _getRecosts(int index) async {
    if (!isEndR || !isEndU || !isEndT) {
      if (!isLazyLoadingR || !isLazyLoadingU || !isLazyLoadingT) {
        // showSuggestions(context);
        setState(() {
          isLazyLoadingR = true;
          isLazyLoadingU = true;
          isLazyLoadingT = true;
        });

        var url =
            "https://api-tassie.herokuapp.com/search/lazySearch/${index.toString()}/$query";
        var token = await storage.read(key: "token");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
        );
        // print(response.data);
        if (response.data['data'] != null) {
          setState(() {
            // if (index == 1) {
            //   isLoading = false;
            // }
            isLazyLoadingR = false;
            isLazyLoadingU = false;
            isLazyLoadingT = false;
            // posts.addAll(tList);
            // print(recs);
            if (response.data['data']['recs'] != null) {
              recipes.addAll(response.data['data']['recs']);
              // print(noOfLikes);
            }
            if (response.data['data']['tags'] != null) {
              tags.addAll(response.data['data']['tags']);
              // print(noOfLikes);
            }
            if (response.data['data']['users'] != null) {
              users.addAll(response.data['data']['users']);
              // print(noOfLikes);
            }
            isLoading = false;
            page++;
          });
          // print(response.data['data']['posts']);
          if (response.data['data']['recs'] == null) {
            setState(() {
              isEndR = true;
            });
          }
          if (response.data['data']['users'] == null) {
            setState(() {
              isEndU = true;
            });
          }
          if (response.data['data']['tags'] == null) {
            setState(() {
              isEndT = true;
            });
          }
          // print(recs);
        } else {
          setState(() {
            isLoading = false;
            isLazyLoadingR = false;
            isLazyLoadingU = false;
            isLazyLoadingT = false;
          });
        }
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, isScrollable) {
            return [
              SliverAppBar(
                elevation: 0,
                // forceElevated: isScrollable,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? kLight
                    : kDark[900],
                pinned: true,
                // backgroundColor: Colors.transparent,
                title: TextFormField(
                  controller: _tc,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    query = value;
                  },
                  validator: (val) => val!.isEmpty || val.length > 100
                      ? 'Recipe name should be within 100 characters'
                      : null,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      // clear query
                      _tc.text = "";
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () {
                      // search here
                      page = 1;
                      recipes = [];
                      users = [];
                      tags = [];
                      setState(() {
                        isLoading = true;
                      });
                      _getRecosts(page);
                    },
                  ),
                ],
                bottom: TabBar(
                  indicatorColor: kPrimaryColor,
                  unselectedLabelColor: kDark,
                  labelColor: Theme.of(context).brightness == Brightness.dark
                      ? kLight
                      : kDark[900],
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.fastfood_rounded),
                    ),
                    Tab(
                      icon: Icon(Icons.account_circle),
                    ),
                    Tab(
                      icon: Icon(Icons.tag_rounded),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 2.0,
                ),
              ),
            ];
          },
          body: isLoading
              ? _buildProgressIndicator()
              : TabBarView(
                  children: [
                    ExploreSearchRecipeTab(
                      recipes: recipes,
                      isEndR: isEndR,
                      isLazyLoadingR: isLazyLoadingR,
                    ),
                    ExploreSearchUserTab(
                      users: users,
                      isEndU: isEndU,
                      isLazyLoadingU: isLazyLoadingU,
                    ),
                    ExploreSearchHashtagTab(
                        hashtags: tags,
                        isEndT: isEndT,
                        isLazyLoadingT: isLazyLoadingT),
                  ],
                ),
        ),
      ),
    );
  }
}
