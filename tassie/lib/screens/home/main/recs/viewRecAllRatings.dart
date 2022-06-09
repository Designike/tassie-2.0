import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/recs/viewRecRatingChild.dart';

class ViewRecAllRatings extends StatefulWidget {
  const ViewRecAllRatings(
      {Key? key,
      required this.userUuid,
      required this.recipeUuid,
      required this.dp})
      : super(key: key);
  final String userUuid;
  final String recipeUuid;
  final String? dp;
  @override
  ViewRecAllRatingsState createState() => ViewRecAllRatingsState();
}

class ViewRecAllRatingsState extends State<ViewRecAllRatings> {
  List ratings = [];
  String? uuid;
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  AsyncMemoizer memoizer = AsyncMemoizer();
  // AsyncMemoizer memoizer1 = AsyncMemoizer();
  // String? dp;
  final ScrollController _sc = ScrollController();
  // static List comments = [];
  bool isLazyLoading = false;
  static bool isLoading = true;
  static int page = 1;
  bool isEnd = false;
  // final dio = Dio();
  // final storage = FlutterSecureStorage();
  // String comm = '';
  // String? uuid;

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

  void _getMoreData(int index) async {
    if (!isEnd) {
      if (!isLazyLoading) {
        if (mounted) {
          setState(() {
            isLazyLoading = true;
          });
        }
        var url =
            "https://api-tassie.herokuapp.com/recs/lazyrating/${widget.recipeUuid}/${widget.userUuid}/${index.toString()}";

        var token = await storage.read(key: "token");
        uuid = await storage.read(key: "uuid");
        Response response = await dio.get(
          url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
        );
        List tList = [];
        if (response.data['data']['ratings']['results'] != null) {
          for (int i = 0;
              i < response.data['data']['ratings']['results']['ratings'].length;
              i++) {
            tList
                .add(response.data['data']['ratings']['results']['ratings'][i]);
          }

          // print(dp);
          if (mounted) {
            setState(() {
              if (index == 1) {
                isLoading = false;
              }
              isLazyLoading = false;
              ratings.addAll(tList);
              page++;
            });
          }
          if (response.data['data']['ratings']['results']['ratings'].length ==
              0) {
            if (mounted) {
              setState(() {
                isEnd = true;
              });
            }
          }
        }
        // print(comments);
      }
    }
  }

  @override
  void initState() {
    page = 1;
    ratings = [];
    _getMoreData(page);
    super.initState();
    // load();
    memoizer = AsyncMemoizer();
    // memoizer1 = AsyncMemoizer();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ratings"),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? kLight
            : kDark[900],
      ),
      // backgroundColor: Color(0xFFEDF0F6),
      body: CustomScrollView(
        controller: _sc,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return index == ratings.length
                    ? isEnd
                        ? null
                        : _buildProgressIndicator()
                    : CreateRating(
                        rating: ratings[index],
                        index: index,
                        userUuid: widget.userUuid,
                        recipeUuid: widget.recipeUuid,
                        removeRating: (ind) {
                          if (mounted) {
                            setState(() {
                              ratings.remove(ind);
                            });
                          }
                        },
                        uuid: uuid,
                      );
              },
              childCount: ratings.length,
            ),
          )
        ],
      ),
    );
  }
}
