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
    // print('1');
    if (!isEndR || !isEndU || !isEndT) {
      // print('2');
      if (!isLazyLoadingR || !isLazyLoadingU || !isLazyLoadingT) {
        // showSuggestions(context);
        // print('3');
        if (mounted) {
          setState(() {
            isLazyLoadingR = true;
            isLazyLoadingU = true;
            isLazyLoadingT = true;
          });
        }
        query = query.replaceAll(RegExp(r'[^\w\s]+'), '');
        var url =
            "https://api-tassie.herokuapp.com/search/lazySearch/${index.toString()}/$query";
        var token = await storage.read(key: "token");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          }),
        );
        // print('4');
        // print(response.data);
        if (response.data['data'] != null) {
          // print('5');
          if (mounted) {
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
                // print("HERE");
                // print(recipes);
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
          }
          // print(response.data['data']['posts']);
          if (response.data['data']['recs'] == null) {
            // print('6');
            if (mounted) {
              setState(() {
                isEndR = true;
              });
            }
          }
          if (response.data['data']['users'] == null) {
            // print('7');
            if (mounted) {
              setState(() {
                isEndU = true;
              });
            }
          }
          if (response.data['data']['tags'] == null) {
            print('8');
            if (mounted) {
              setState(() {
                isEndT = true;
              });
            }
          }
          // print(recs);
        } else {
          print('9');
          if (mounted) {
            setState(() {
              isLoading = false;
              isLazyLoadingR = false;
              isLazyLoadingU = false;
              isLazyLoadingT = false;
            });
          }
        }
      }
      print('10');
    }
    print('11');
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
  void initState() {
    super.initState();
    isLazyLoadingR = false;
    isLazyLoadingU = false;
    isLazyLoadingT = false;
    isLoading = false;
    isEndR = false;
    isEndU = false;
    isEndT = false;
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
                  validator: (val) => val!.isEmpty
                      //  || (!RegExp(r"^[a-zA-Z0-9]+").hasMatch(val))
                      ? 'Search name should not be empty'
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
                      if (mounted) {
                        setState(() {
                          isLoading = true;
                          isLazyLoadingR = false;
                          isLazyLoadingU = false;
                          isLazyLoadingT = false;
                          isEndR = false;
                          isEndU = false;
                          isEndT = false;
                        });
                      }

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
