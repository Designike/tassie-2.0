import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/showMoreText.dart';
import 'package:tassie/screens/home/snackbar.dart';
import 'package:tassie/screens/home/viewRecAllRatings.dart';
import 'package:tassie/screens/home/viewRecCommentChild.dart';
import 'package:tassie/screens/home/viewRecSimilarRec.dart';
import 'package:tassie/screens/imgLoader.dart';

import 'viewRecAllComments.dart';

class ViewRecPost extends StatefulWidget {
  const ViewRecPost({required this.recs, required this.funcB});
  final Map recs;
  final void Function(bool) funcB;
  @override
  _ViewRecPostState createState() => _ViewRecPostState();
}

class _ViewRecPostState extends State<ViewRecPost> {
  bool isSubscribed = false;
  bool isExpandedIng = false;
  bool isExpandedSteps = false;
  bool isBookmarked = false;
  bool isLiked = false;
  bool isLunch = false;
  bool isDinner = false;
  bool isBreakfast = false;
  bool isCraving = false;
  String course = "";
  String? uuid;
  List comments = [];
  String recipeImageID = "";
  String flavour = "";
  String recipeName = "";
  String chefName = "";
  bool isVeg = false;
  String? dp;
  // List ratings = [];
  bool isLoading = true;
  int one = 0;
  int two = 0;
  int three = 0;
  int four = 0;
  int five = 0;
  int totalRatings = 11;
  int estimatedTime = 0;
  // bool isLazyLoading = false;
  double rating = 0.0;
  double meanRating = 4.7;
  // String profilePic = "";
  final dio = Dio();
  final storage = FlutterSecureStorage();
  AsyncMemoizer memoizer = AsyncMemoizer();
  // Future<String> myFuture = "" as Future<String>;
  // var ingredientPics = [
  //   {'index': '1', 'fileID': 'https://picsum.photos/200'},
  //   {'index': '3', 'fileID': 'https://picsum.photos/200'}
  // ];
  List ingredientPics = [];

  // var ingredients = [
  //   'henlooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo',
  //   'henlo',
  //   'henlo',
  //   'henlo',
  //   'henlo',
  // ];
  List ingredients = [];

  // var steps = [
  //   'henlo',
  //   'henlo',
  //   'henlo',
  //   'henlo',
  //   'henlo',
  // ];
  List steps = [];
  int hours = 0;
  int mins = 0;
  // var stepPics = [
  //   {'index': '1', 'fileID': 'https://picsum.photos/200'},
  //   {'index': '3', 'fileID': 'https://picsum.photos/200'}
  // ];
  List stepPics = [];
  List similar = [];
  // String getImage(img) {
  //   String x = "";
  //   print(img);
  //   loadImg(img).then((result) {
  //     setState(() {
  //       x = result;
  //     });
  //     return x;
  //     print(x);
  //   });
  //   return x;
  // }

  Future<void> getRecipe() async {
    // isLazyLoading = true;
    var token = await storage.read(key: 'token');
    uuid = await storage.read(key: "uuid");
    dp = await storage.read(key: "profilePic");
    Response response = await dio.post(
        // 'https://api-tassie.herokuapp.com/drive/upload',
        'https://api-tassie.herokuapp.com/recs/getRecipe/',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + token!
        }),
        data: {
          'uuid': widget.recs['uuid'],
          'chefUuid': widget.recs['userUuid']
        });

    if (response.data != null) {
      setState(() {
        stepPics.addAll(response.data['data']['recipe']['stepPics']);
        steps.addAll(response.data['data']['recipe']['steps']);
        ingredients.addAll(response.data['data']['recipe']['ingredients']);
        ingredientPics
            .addAll(response.data['data']['recipe']['ingredientPics']);
        comments.addAll(response.data['data']['recipe']['comments']);
        similar.addAll(response.data['data']['similar']);
        isBookmarked = response.data['data']['recipeData']['isBookmarked'];
        isLiked = response.data['data']['recipeData']['isLiked'];
        recipeImageID = response.data['data']['recipe']['recipeImageID'];
        // isLazyLoading = false;
        if (response.data['data']['recipeData']['userRating'].isNotEmpty) {
          rating = response.data['data']['recipeData']['userRating'][0]['star']
              .toDouble();
        } else {
          rating = 0.0;
        }
        estimatedTime = response.data['data']['recipe']['estimatedTime'];
        setTime(estimatedTime);
        isSubscribed = response.data['data']['isSubscribed'];
        recipeName = response.data['data']['recipe']['name'];
        chefName = response.data['data']['recipe']['username'];
        isVeg = response.data['data']['recipe']['veg'];
        course = response.data['data']['recipe']['course'];
        flavour = response.data['data']['recipe']['flavour'];
        isLunch = response.data['data']['recipe']['isLunch'];
        isBreakfast = response.data['data']['recipe']['isBreakfast'];
        isDinner = response.data['data']['recipe']['isDinner'];
        isCraving = response.data['data']['recipe']['isCraving'];
        one = response.data['data']['recipeData']['1'];
        two = response.data['data']['recipeData']['2'];
        three = response.data['data']['recipeData']['3'];
        four = response.data['data']['recipeData']['4'];
        five = response.data['data']['recipeData']['5'];
        totalRatings = response.data['data']['recipeData']['ratings'];
        if (totalRatings != 0) {
          meanRating =
              ((five * 5) + (four * 4) + (three * 3) + (two * 2) + (one * 1)) /
                  totalRatings;
        } else {
          meanRating = 0;
        }
        isLoading = false;
      });
    }
  }

  void setTime(int time) {
    setState(() {
      hours = time ~/ 60;
      mins = time % 60;
    });
  }

  String desc =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  Widget _createComment(Map comment, int index) {
    // Map post = widget.post;
    // print(post);
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
              child: Image(
                height: 50.0,
                width: 50.0,
                image: NetworkImage(comment['profilePic']),
                fit: BoxFit.cover,
              ),
            ),
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
            color: Theme.of(context).brightness == Brightness.dark
                ? kLight
                : kDark[900],
            // color:Colors.red,
          ),
        ),
        trailing: (widget.recs['userUuid'] == uuid ||
                comment['uuid'].split('_comment_')[0] == uuid)
            ? IconButton(
                icon: Icon(
                  Icons.delete_rounded,
                ),
                color: Colors.grey,
                onPressed: () async {
                  var token = await storage.read(key: "token");
                  Response response =
                      await dio.post("https://api-tassie.herokuapp.com/recs/removeComment",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer " + token!
                          }),
                          data: {
                        'recipeUuid': widget.recs['uuid'],
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

  Column myList(size, listItems, listImages, showMoreBtn, isIng) {
    return Column(
      children: [
        ListView.builder(
            padding: EdgeInsets.all(0.0),
            itemCount: listItems.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String url = "";
              for (var i = 0; i < listImages.length; i++) {
                if (listImages[i]["index"] == (index + 1).toString()) {
                  url = listImages[i]['fileID'];
                }
              }
              return StepIngImage(
                index: index,
                text: listItems[index],
                count: listImages.length,
                size: size,
                url: url,
              );
            }),
        showMoreBtn
            ? TextButton.icon(
                icon: isIng
                    ? isExpandedIng
                        ? Icon(Icons.keyboard_arrow_up_rounded)
                        : Icon(Icons.keyboard_arrow_down_rounded)
                    : isExpandedSteps
                        ? Icon(Icons.keyboard_arrow_up_rounded)
                        : Icon(Icons.keyboard_arrow_down_rounded),
                label: isIng
                    ? isExpandedIng
                        ? Text('Show less')
                        : Text('Show more')
                    : isExpandedSteps
                        ? Text('Show less')
                        : Text('Show more'),
                onPressed: () {
                  setState(() {
                    if (isIng == true) {
                      isExpandedIng = !isExpandedIng;
                    } else {
                      isExpandedSteps = !isExpandedSteps;
                    }
                  });
                },
                style: TextButton.styleFrom(primary: kPrimaryColor),
              )
            : SizedBox(
                height: 0.0,
              ),
      ],
    );
  }

  Widget _createRatingPercentBar(Size size, int star, int rating, Color color) {
    return Row(children: [
      Text(star.toString()),
      Icon(Icons.star, size: 14.0, color: kDark),
      SizedBox(width: 5.0),
      Container(
        width: size.width * 0.45,
        child: LinearProgressIndicator(
          value: totalRatings == 0 ? 0.0 : rating / totalRatings,
          color: color,
        ),
      ),
    ]);
  }

  @override
  void initState() {
    isLoading = true;
    getRecipe();
    // myFuture = loadImg(x);
    memoizer = AsyncMemoizer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leadingWidth: kToolbarHeight * 1.1,
            toolbarHeight: kToolbarHeight * 1.1,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                statusBarIconBrightness:
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light),
            leading: ClipOval(
              child: Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.transparent,
                child: ClipOval(
                  child: Container(
                    // padding: EdgeInsets.all(8.0),
                    width: (kToolbarHeight * 1.1) - 16.0,
                    color: kPrimaryColor,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.transparent,
                  child: ClipOval(
                    child: Container(
                      // padding: EdgeInsets.all(8.0),
                      width: (kToolbarHeight * 1.1) - 16.0,
                      color: kPrimaryColor,
                      child: IconButton(
                        icon: (isBookmarked)
                            ? Icon(Icons.bookmark)
                            : Icon(Icons.bookmark_border),
                        iconSize: 30.0,
                        onPressed: () async {
                          if (!isBookmarked) {
                            var token = await storage.read(key: "token");
                            Response response = await dio
                                .post("https://api-tassie.herokuapp.com/recs/bookmark",
                                    options: Options(headers: {
                                      HttpHeaders.contentTypeHeader:
                                          "application/json",
                                      HttpHeaders.authorizationHeader:
                                          "Bearer " + token!
                                    }),
                                    data: {'uuid': widget.recs['uuid']});
                            widget.funcB(false);
                            setState(() {
                              isBookmarked = !isBookmarked;
                            });
                          } else {
                            var token = await storage.read(key: "token");
                            Response response = await dio.post(
                                "https://api-tassie.herokuapp.com/recs/removeBookmark",
                                options: Options(headers: {
                                  HttpHeaders.contentTypeHeader:
                                      "application/json",
                                  HttpHeaders.authorizationHeader:
                                      "Bearer " + token!
                                }),
                                data: {'uuid': widget.recs['uuid']});
                            widget.funcB(true);
                            setState(() {
                              isBookmarked = !isBookmarked;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              ClipOval(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.transparent,
                  child: ClipOval(
                    child: Container(
                      // padding: EdgeInsets.all(8.0),
                      width: (kToolbarHeight * 1.1) - 16.0,
                      color: kPrimaryColor,
                      child: IconButton(
                        onPressed: () async {
                          if (isLiked) {
                            // print(post);

                            var token = await storage.read(key: "token");
                            dio.post("https://api-tassie.herokuapp.com/recs/unlike",
                                options: Options(headers: {
                                  HttpHeaders.contentTypeHeader:
                                      "application/json",
                                  HttpHeaders.authorizationHeader:
                                      "Bearer " + token!
                                }),
                                data: {'uuid': widget.recs['uuid']});
                            // widget.func(false);
                            setState(() {
                              isLiked = !isLiked;
                            });
                          } else {
                            var token = await storage.read(key: "token");
                            dio.post("https://api-tassie.herokuapp.com/recs/like",
                                options: Options(headers: {
                                  HttpHeaders.contentTypeHeader:
                                      "application/json",
                                  HttpHeaders.authorizationHeader:
                                      "Bearer " + token!
                                }),
                                data: {'uuid': widget.recs['uuid']});
                            // widget.func(true);
                            setState(() {
                              isLiked = !isLiked;
                            });
                          }
                          // print(likeNumber.toString());
                        },
                        icon: (!isLiked)
                            ? Icon(Icons.favorite_border)
                            : Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   width: kToolbarHeight * 1.1,
              //   height: kToolbarHeight * 1.1,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(100.0),
              //     color:
              //         Theme.of(context).brightness == Brightness.dark
              //             ? kLight
              //             : kDark[900],
              //   ),
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: Icon(Icons.bookmark_outline_rounded),
              //   ),
              // ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.favorite_border),
              // ),
            ],
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                )
              : ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: [
                    Hero(
                      tag: widget.recs['uuid'],
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: size.width,
                          height: size.width,
                          // child: recipeImageID != " "
                          //     ? Image(
                          //         image: NetworkImage(getImage(recipeImageID)),
                          //         fit: BoxFit.cover,
                          //       )
                          //     : null,
                          child: FutureBuilder(
                              future: loadImg(recipeImageID, memoizer),
                              builder:
                                  (BuildContext context, AsyncSnapshot text) {
                                if (text.connectionState ==
                                    ConnectionState.waiting) {
                                  return Image.asset(
                                      "assets/images/broken.png");
                                } else {
                                  return Image.network(text.data.toString());
                                }
                              }),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -20.0),
                      child: Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                recipeName,
                                style: TextStyle(
                                  // color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width * 0.7,
                                    child: Wrap(
                                      runSpacing: 10.0,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            child: Text(
                                              flavour,
                                              style: TextStyle(color: kDark),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              padding: EdgeInsets.all(10.0),
                                              side: BorderSide(
                                                color: kDark,
                                                width: 1,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            child: Text(
                                              course,
                                              style: TextStyle(color: kDark),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              padding: EdgeInsets.all(10.0),
                                              side: BorderSide(
                                                color: kDark,
                                                width: 1,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        if (isLunch) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Lunch',
                                                style: TextStyle(color: kDark),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding: EdgeInsets.all(10.0),
                                                side: BorderSide(
                                                  color: kDark,
                                                  width: 1,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            ),
                                          )
                                        ],
                                        if (isBreakfast) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Breakfast',
                                                style: TextStyle(color: kDark),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding: EdgeInsets.all(10.0),
                                                side: BorderSide(
                                                  color: kDark,
                                                  width: 1,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            ),
                                          )
                                        ],
                                        if (isDinner) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Dinner',
                                                style: TextStyle(color: kDark),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding: EdgeInsets.all(10.0),
                                                side: BorderSide(
                                                  color: kDark,
                                                  width: 1,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            ),
                                          )
                                        ],
                                        if (isCraving) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Craving',
                                                style: TextStyle(color: kDark),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding: EdgeInsets.all(10.0),
                                                side: BorderSide(
                                                  color: kDark,
                                                  width: 1,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            ),
                                          )
                                        ],
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 36.0,
                                    width: 36.0,
                                    margin: EdgeInsets.only(top: 8.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                            color: isVeg
                                                ? Colors.green
                                                : Colors.red)),
                                    child: ClipOval(
                                      child: Container(
                                        // padding: EdgeInsets.all(10.0),
                                        color:
                                            isVeg ? Colors.green : Colors.red,
                                        // height: 10.0,
                                        // width: 10.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        if (hours != 0) ...[
                                          TextSpan(
                                            text: hours.toString() + 'h ',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: MediaQuery.of(context)
                                                          .platformBrightness ==
                                                      Brightness.dark
                                                  ? kLight
                                                  : kDark[900],
                                            ),
                                          ),
                                        ],
                                        TextSpan(
                                          text: mins.toString() + 'm',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.dark
                                                ? kLight
                                                : kDark[900],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              ListTile(
                                minLeadingWidth: (size.width - 40.0) / 10,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 0),
                                leading: Container(
                                  width: (size.width - 40.0) / 10,
                                  height: (size.width - 40.0) / 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    child: ClipOval(
                                      child: Image(
                                        height: (size.width - 40.0) / 10,
                                        width: (size.width - 40.0) / 10,
                                        image: NetworkImage(
                                            'https://picsum.photos/200'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  chefName,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: isSubscribed
                                    ? TextButton.icon(
                                        icon: Icon(Icons.check_circle),
                                        label: Text('SUBSCRIBED'),
                                        onPressed: () async {
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
                                              data: {
                                                'uuid': widget.recs['userUuid']
                                              });
                                          if (response.data['status'] == true) {
                                            setState(() {
                                              isSubscribed = false;
                                            });
                                          } else {
                                            showSnack(
                                                context,
                                                "Unable to unsubscribe, try again!",
                                                () {},
                                                "OK",
                                                3);
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                            primary: kPrimaryColor),
                                      )
                                    : TextButton(
                                        child: Text('SUBSCRIBE'),
                                        onPressed: () async {
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
                                              data: {
                                                'uuid': widget.recs['userUuid']
                                              });
                                          if (response.data['status'] == true) {
                                            setState(() {
                                              isSubscribed = true;
                                            });
                                          } else {
                                            showSnack(
                                                context,
                                                "Unable to subscribe, try again!",
                                                () {},
                                                "OK",
                                                3);
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                            primary: kPrimaryColor),
                                      ),
                              ),
                            ]),
                      ),
                    ),
                    Divider(
                      thickness: 8,
                    ),
                    if (desc != "") ...[
                      Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: ShowMoreText(text: desc),
                      ),
                      SizedBox(height: 10.0)
                    ],
                    // Divider(
                    //   thickness: 5,
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    Container(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ingredients',
                                style: TextStyle(
                                  // color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              ingredients.length > 2
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isExpandedIng = !isExpandedIng;
                                        });
                                      },
                                      icon: isExpandedIng
                                          ? Icon(
                                              Icons.keyboard_arrow_up_rounded)
                                          : Icon(Icons
                                              .keyboard_arrow_down_rounded),
                                      iconSize: 35.0,
                                      padding: EdgeInsets.all(0.0),
                                      color: kDark,
                                    )
                                  : SizedBox(
                                      width: 0.0,
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          // !isExpandedIng
                          //     ? ingredients.length > 2
                          //         ? myList(size, ingredients.sublist(0, 2),
                          //             ingredientPics, true, true)
                          //         : myList(
                          //             size, ingredients, ingredientPics, false, true)
                          //     : myList(size, ingredients, ingredientPics, true, true),

                          ingredients.length > 2
                              ? !isExpandedIng
                                  ? myList(size, ingredients.sublist(0, 2),
                                      ingredientPics, true, true)
                                  : myList(size, ingredients, ingredientPics,
                                      true, true)
                              : myList(size, ingredients, ingredientPics, false,
                                  true),
                          // MyList(listItems: ingredients, listImages: ingredientPics)
                          // ListView.builder(
                          //     padding: EdgeInsets.only(bottom: 30.0),
                          //     itemCount: ingredients.length,
                          //     shrinkWrap: true,
                          //     physics: NeverScrollableScrollPhysics(),
                          //     itemBuilder: (context, index) {
                          //       return ListTile(
                          //         leading: MyBullet(),
                          //         title: Text(listItems[index]),
                          //       );
                          //     })
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 8,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recipe steps',
                                style: TextStyle(
                                  // color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              steps.length > 2
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isExpandedSteps = !isExpandedSteps;
                                        });
                                      },
                                      icon: isExpandedSteps
                                          ? Icon(
                                              Icons.keyboard_arrow_up_rounded)
                                          : Icon(Icons
                                              .keyboard_arrow_down_rounded),
                                      iconSize: 35.0,
                                      padding: EdgeInsets.all(0.0),
                                      color: kDark,
                                    )
                                  : SizedBox(
                                      width: 0.0,
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          // !isExpandedSteps
                          //     ? steps.length > 2
                          //         ? myList(
                          //             size, steps.sublist(0, 2), stepPics, true, false)
                          //         : myList(size, steps, stepPics, false, false)
                          //     : myList(size, steps, stepPics, true, false),

                          steps.length > 2
                              ? !isExpandedSteps
                                  ? myList(size, steps.sublist(0, 2), stepPics,
                                      true, false)
                                  : myList(size, steps, stepPics, true, false)
                              : myList(size, steps, stepPics, false, false),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 8,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    Container(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ratings',
                            style: TextStyle(
                              // color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          if (totalRatings != 0) ...[
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: kDefaultPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: meanRating.toString(),
                                                  style: TextStyle(
                                                    color: MediaQuery.of(
                                                                    context)
                                                                .platformBrightness ==
                                                            Brightness.dark
                                                        ? kDark
                                                        : kDark[700],
                                                    fontSize: 56.0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '/ 5',
                                                  style: TextStyle(
                                                    color: MediaQuery.of(
                                                                    context)
                                                                .platformBrightness ==
                                                            Brightness.dark
                                                        ? kDark
                                                        : kDark[700],
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(height: 10.0),
                                          RatingBarIndicator(
                                            rating: meanRating,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: kPrimaryColor,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _createRatingPercentBar(
                                              size, 5, five, Colors.green),
                                          _createRatingPercentBar(
                                              size, 4, four, Colors.lightGreen),
                                          _createRatingPercentBar(
                                              size, 3, three, Colors.yellow),
                                          _createRatingPercentBar(
                                              size, 2, two, Colors.amber),
                                          _createRatingPercentBar(
                                              size, 1, one, Colors.orange),

                                          // Container(
                                          // width: 10.0, color: kDark, height: 10.0),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: totalRatings.toString(),
                                          style: TextStyle(
                                            // color: kDark,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' tassite ratings.',
                                          style: TextStyle(
                                            color: kDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewRecAllRatings(
                                        userUuid: widget.recs['userUuid'],
                                        recipeUuid: widget.recs['uuid'],
                                        dp: dp),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Show ratings'),
                                    Icon(Icons.keyboard_arrow_right_rounded),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    // color: Theme.of(context).brightness ==
                                    //         Brightness.dark
                                    //     ? kDark[900]
                                    //     : kLight,
                                    border: Border.all(color: kDark),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                          ] else ...[
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? kDark[900]
                                        : kLight,
                                    // border: Border.all(color: kDark),
                                    borderRadius: BorderRadius.circular(10.0)),
                                padding: EdgeInsets.all(kDefaultPadding * 1.5),
                                margin: EdgeInsets.only(top: 20.0),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.icecream_outlined,
                                        size: 35.0, color: kDark),
                                    SizedBox(height: 10.0),
                                    Text('No Ratings yet'),
                                  ],
                                ),
                              ),
                            )
                          ],
                          SizedBox(height: 40.0),
                          Text('Rate this recipe!'),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingBar.builder(
                                initialRating: rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? kDark[200]
                                      : kDark[700],
                                ),
                                updateOnDrag: false,
                                tapOnlyMode: true,
                                onRatingUpdate: (rate) async {
                                  setState(() {
                                    rating = rate;
                                  });
                                  //to update user rating
                                  var token = await storage.read(key: "token");
                                  Response response = await dio.post(
                                      "https://api-tassie.herokuapp.com/recs/addRating",
                                      options: Options(headers: {
                                        HttpHeaders.contentTypeHeader:
                                            "application/json",
                                        HttpHeaders.authorizationHeader:
                                            "Bearer " + token!
                                      }),
                                      data: {
                                        'uuid': widget.recs['uuid'],
                                        'star': rating,
                                      });
                                  if (response.data != null) {
                                    if (response.data['status'] == true) {
                                      showSnack(context, "Thanks for rating!",
                                          () {}, 'OK', 3);
                                    } else {
                                      showSnack(
                                          context,
                                          "Unable to update rating!",
                                          () {},
                                          'OK',
                                          3);
                                    }
                                  }
                                },
                              ),
                              IconButton(
                                  onPressed: () async {
                                    // to reset user rating
                                    var token =
                                        await storage.read(key: "token");
                                    Response response = await dio.post(
                                        "https://api-tassie.herokuapp.com/recs/resetRating",
                                        options: Options(headers: {
                                          HttpHeaders.contentTypeHeader:
                                              "application/json",
                                          HttpHeaders.authorizationHeader:
                                              "Bearer " + token!
                                        }),
                                        data: {
                                          'uuid': widget.recs['uuid'],
                                          'star': rating,
                                        });
                                    setState(() {
                                      rating = 0.0;
                                    });

                                    if (response.data != null) {
                                      if (response.data['status'] == true) {
                                        showSnack(context, "Rating deleted!",
                                            () {}, 'OK', 3);
                                      } else {
                                        showSnack(
                                            context,
                                            "Unable to reset rating!",
                                            () {},
                                            'OK',
                                            3);
                                      }
                                    }
                                  },
                                  icon: Icon(Icons.restart_alt))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 8,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comments',
                              style: TextStyle(
                                // color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            // ListView.builder(
                            //   itemBuilder: (context, index) {
                            //     return _createComment(comments[index], index);
                            //   },
                            //   itemCount: comments.length,
                            // ),
                            if (comments.isNotEmpty) ...[
                              for (var i = 0; i < comments.length; i++) ...[
                                // createComment(comment: comments[i],index: i, )
                                CreateComment(
                                  recost: comments[i],
                                  index: i,
                                  userUuid: widget.recs['userUuid'],
                                  recipeUuid: widget.recs['uuid'],
                                  removeComment: (ind) {
                                    setState(() {
                                      comments.remove(ind);
                                    });
                                  },
                                  uuid: uuid,
                                  isPost: false,
                                )
                              ],
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => ViewRecAllComments(
                                          userUuid: widget.recs['userUuid'],
                                          recipeUuid: widget.recs['uuid'],
                                          dp: dp),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Show all comments'),
                                      Icon(Icons.keyboard_arrow_right_rounded),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      // color: Theme.of(context).brightness ==
                                      //         Brightness.dark
                                      //     ? kDark[900]
                                      //     : kLight,
                                      border: Border.all(color: kDark),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ),
                            ] else ...[
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? kDark[900]
                                          : kLight,
                                      // border: Border.all(color: kDark),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  padding:
                                      EdgeInsets.all(kDefaultPadding * 1.5),
                                  margin: EdgeInsets.only(top: 20.0),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.question_answer_rounded,
                                          size: 35.0, color: kDark),
                                      SizedBox(height: 10.0),
                                      Text('No comments yet'),
                                    ],
                                  ),
                                ),
                              )
                            ],
                            SizedBox(height: 10.0),
                            Center(
                                child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewRecAllComments(
                                                  userUuid:
                                                      widget.recs['userUuid'],
                                                  recipeUuid:
                                                      widget.recs['uuid'],
                                                  dp: dp),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.add_comment_rounded),
                                    label: Text('Add Comment'))),
                          ],
                        )),
                    Divider(
                      thickness: 8,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (similar.isNotEmpty) ...[
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "More recipes from ",
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? kLight
                                          : kDark[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: chefName,
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? kLight
                                          : kDark[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  )
                                ]),
                                overflow: TextOverflow.clip,
                              )
                            ] else ...[
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Seems like ",
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? kLight
                                          : kDark[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: chefName,
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? kLight
                                          : kDark[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " hasn't posted more recipes.",
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? kLight
                                          : kDark[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ]),
                                overflow: TextOverflow.clip,
                              )
                            ],
                            Container(
                              width: size.width,
                              padding: EdgeInsets.only(top: 30.0),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (var i = 0; i < similar.length; i++)
                                      ViewRecSimilarRec(
                                          recs: similar[i], funcB: (test) {}),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 100.0,
                    ),
                  ],
                )),
    );
  }
}

// class TitleWithCustomUnderline extends StatelessWidget {
//   const TitleWithCustomUnderline({required this.text});

//   final String text;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 24,
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: kDefaultPadding / 4),
//             child: Text(
//               text,
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   // color: kDark[900],
//                   color: kPrimaryColor),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 7,
//               margin: EdgeInsets.only(
//                 right: kDefaultPadding / 4,
//               ),
//               color: kDark.withOpacity(0.4),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class MyList extends StatelessWidget {
//   MyList(
//       {required this.listItems,
//       required this.listImages,
//       required this.showMoreBtn,
//       required this.showLessBtn, required this.expandToggle});
//   final List<String> listItems;
//   final List<Map> listImages;
//   final bool showMoreBtn;
//   final bool showLessBtn;
//   final void Function() expandToggle;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         ListView.builder(
//             padding: EdgeInsets.only(bottom: 30.0),
//             itemCount: listItems.length,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               String url = "";
//               for (var i = 0; i < listImages.length; i++) {
//                 if (listImages[i]["index"] == (index + 1).toString()) {
//                   url = listImages[i]['url'];
//                 }
//               }
//               return Column(
//                 children: [
//                   ListTile(
//                     leading: MyBullet(index: (index + 1).toString()),
//                     title: Text(listItems[index]),
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
//                   ),
//                   url == ""
//                       ? Container()
//                       : Padding(
//                           padding: const EdgeInsets.only(top: 10.0),
//                           child: GestureDetector(
//                             onTap: () {},
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(15.0),
//                               child: SizedBox(
//                                 width: size.width - (2 * kDefaultPadding),
//                                 height: size.width - (2 * kDefaultPadding),
//                                 child: Image(
//                                   image: NetworkImage(url),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                   if (index != listItems.length - 1) ...[
//                     SizedBox(
//                       height: 15.0,
//                     ),
//                     Divider(
//                       thickness: 1.0,
//                     )
//                   ],
//                 ],
//               );
//             }),
//           TextButton.icon(icon: Icon(Icons.keyboard_arrow_down_rounded),
//                                 label: Text('Show more'),
//                                 onPressed: expandToggle,
//                                 style: TextButton.styleFrom(
//                                     primary: kPrimaryColor),
//                               )
//       ],
//     );
//   }
// }

class MyBullet extends StatelessWidget {
  MyBullet({required this.index});
  final String index;
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: 10.0,
    //   width: 10.0,
    //   decoration: BoxDecoration(
    //     color: kDark[800],
    //     shape: BoxShape.circle,
    //   ),
    // );
    return Text(
      index,
      style: TextStyle(fontSize: 30.0, color: kPrimaryColor),
    );
  }
}

class StepIngImage extends StatefulWidget {
  const StepIngImage(
      {Key? key,
      required this.index,
      required this.text,
      required this.count,
      required this.size,
      required this.url})
      : super(key: key);
  final int index;
  final int count;
  final String text;
  final Size size;
  final String url;
  @override
  _StepIngImageState createState() => _StepIngImageState();
}

class _StepIngImageState extends State<StepIngImage> {
  AsyncMemoizer memoizer = AsyncMemoizer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: MyBullet(index: (widget.index + 1).toString()),
          title: Text(widget.text),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        ),
        widget.url == ""
            ? SizedBox(
                height: 0,
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: SizedBox(
                      width: widget.size.width - (2 * kDefaultPadding),
                      height: widget.size.width - (2 * kDefaultPadding),
                      // child: Image(
                      //   // image: NetworkImage(url),
                      //   image:
                      //       NetworkImage('https://picsum.photos/200'),
                      //   fit: BoxFit.cover,
                      // ),
                      child: FutureBuilder(
                          future: loadImg(widget.url, memoizer),
                          builder: (BuildContext context, AsyncSnapshot text) {
                            if (text.connectionState ==
                                ConnectionState.waiting) {
                              return Image.asset("assets/images/broken.png");
                            } else {
                              return Image(
                                image: NetworkImage(text.data.toString()),
                                fit: BoxFit.cover,
                              );
                            }
                          }),
                    ),
                  ),
                ),
              ),
        if (widget.index != widget.count - 1) ...[
          SizedBox(
            height: 15.0,
          ),
          Divider(
            thickness: 1.0,
          )
        ],
      ],
    );
  }
}
