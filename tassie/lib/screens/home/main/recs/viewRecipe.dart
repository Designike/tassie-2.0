import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/screens/home/main/profile/recipeTab/editRecipe.dart';
import 'package:tassie/screens/home/main/recs/youtubeFullscreen.dart';
import 'package:tassie/utils/showMoreText.dart';
import 'package:tassie/utils/snackbar.dart';
import 'package:tassie/utils/string_extension.dart';
import 'package:tassie/screens/home/main/recs/viewRecAllRatings.dart';
import 'package:tassie/screens/home/main/recs/viewRecCommentChild.dart';
import 'package:tassie/screens/home/main/recs/viewRecListChild.dart';
import 'package:tassie/screens/home/main/recs/viewRecSimilar.dart';
import 'package:tassie/utils/imgLoader.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'viewRecAllComments.dart';

class ViewRecPost extends StatefulWidget {
  const ViewRecPost(
      {required this.recs, required this.funcB, this.refreshPage, Key? key})
      : super(key: key);
  final Map recs;
  final void Function(bool) funcB;
  final void Function()? refreshPage;
  @override
  ViewRecPostState createState() => ViewRecPostState();
}

class ViewRecPostState extends State<ViewRecPost> {
  late YoutubePlayerController yController;
  bool isPop = false;
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
  final storage = const FlutterSecureStorage();
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizer3 = AsyncMemoizer();
  late Future storedFuture;
  late Future storedFuture3;
  List ingredientPics = [];
  List ingredients = [];
  List steps = [];
  int hours = 0;
  int mins = 0;
  List stepPics = [];
  List similar = [];
  var items = ["Edit", "Delete"];
  String youtubeLink = "";

  int checker = 0;

  List<Widget> ingWidgetList = [];
  List<Widget> stepsWidgetList = [];
  List<Widget> commentsWidgetList = [];
  List<Widget> similarWidgetList = [];

  Map ingStoredFutures = {};
  Map stepStoredFutures = {};
  Map commentStoredFutures = {};
  Map similarStoredFutures = {};
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
  bool _isPlayerReady = false;

  Future<void> getImage() async {
    storedFuture = loadImg(recipeImageID, memoizer);
    storedFuture3 = loadImg(dp, memoizer3);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // void listener() {
  //   if (_isPlayerReady && mounted && !yController.value.isFullScreen) {
  //     setState(() {
  //       _playerState = yController.value.playerState;
  //       _videoMetaData = yController.metadata;
  //     });
  //   }
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
          HttpHeaders.authorizationHeader: "Bearer ${token!}"
        }),
        data: {
          'uuid': widget.recs['uuid'],
          'chefUuid': widget.recs['userUuid']
        });

    if (response.data != null) {
      if (mounted) {
        setState(() {
          // print("ertyu");
          desc = response.data['data']['recipe']['desc'];
          stepPics.addAll(response.data['data']['recipe']['stepPics']);
          steps.addAll(response.data['data']['recipe']['steps']);
          ingredients.addAll(response.data['data']['recipe']['ingredients']);
          // print(ingredients);
          ingredientPics
              .addAll(response.data['data']['recipe']['ingredientPics']);
          comments.addAll(response.data['data']['recipe']['comments']);
          similar.addAll(response.data['data']['similar']);
          isBookmarked = response.data['data']['recipeData']['isBookmarked'];
          isLiked = response.data['data']['recipeData']['isLiked'];
          recipeImageID = response.data['data']['recipe']['recipeImageID'];
          youtubeLink =
              (response.data['data']['recipe']['youtubeLink']).split('/')[3];
          // print(youtubeLink);
          // isLazyLoading = false;
          if (response.data['data']['recipeData']['userRating'].isNotEmpty) {
            rating = response.data['data']['recipeData']['userRating'][0]
                    ['star']
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
            meanRating = ((five * 5) +
                    (four * 4) +
                    (three * 3) +
                    (two * 2) +
                    (one * 1)) /
                totalRatings;
          } else {
            meanRating = 0;
          }
          yController = YoutubePlayerController(
              initialVideoId: youtubeLink,
              flags: const YoutubePlayerFlags(
                  mute: false, autoPlay: false, loop: false));

          // stepsWidgetList = generateList(steps, stepPics);
          // commentsWidgetList = generateCommentList();
          // similarWidgetList = generateSimilarList();
          // isLoading = false;
        });
      }
      ingWidgetList = await generateList(ingredients, ingredientPics, true);
      // print
      stepsWidgetList = await generateList(steps, stepPics, false);
      commentsWidgetList = await generateCommentList();
      similarWidgetList = await generateSimilarList();
      getImage();
    }
  }

  void setTime(int time) {
    if (mounted) {
      setState(() {
        hours = time ~/ 60;
        mins = time % 60;
      });
    }
  }

  String desc = "";

  // Widget _createComment(Map comment, int index) {
  //   // Map post = widget.post;
  //   // print(post);
  //   return Padding(
  //     padding: EdgeInsets.all(10.0),
  //     child: ListTile(
  //       leading: Container(
  //         width: 50.0,
  //         height: 50.0,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //         ),
  //         child: CircleAvatar(
  //           child: ClipOval(
  //             child: Image(
  //               height: 50.0,
  //               width: 50.0,
  //               image: NetworkImage(comment['profilePic']),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //       ),
  //       title: Text(
  //         comment['username'],
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       subtitle: Text(
  //         comment['comment'],
  //         style: TextStyle(
  //           color: Theme.of(context).brightness == Brightness.dark
  //               ? kLight
  //               : kDark[900],
  //           // color:Colors.red,
  //         ),
  //       ),
  //       trailing: (widget.recs['userUuid'] == uuid ||
  //               comment['uuid'].split('_comment_')[0] == uuid)
  //           ? IconButton(
  //               icon: Icon(
  //                 Icons.delete_rounded,
  //               ),
  //               color: Colors.grey,
  //               onPressed: () async {
  //                 var token = await storage.read(key: "token");
  //                 Response response = await dio.post(
  //                     "https://api-tassie.herokuapp.com/recs/removeComment",
  //                     options: Options(headers: {
  //                       HttpHeaders.contentTypeHeader: "application/json",
  //                       HttpHeaders.authorizationHeader: "Bearer " + token!
  //                     }),
  //                     data: {
  //                       'recipeUuid': widget.recs['uuid'],
  //                       'commentUuid': comment['uuid'],
  //                     });
  //                 setState(() {
  //                   comments.remove(index);
  //                 });
  //                 // widget.minusComment();
  //               },
  //             )
  //           : null,
  //     ),
  //   );
  // }

  // Column myList(size, listItems, listImages, showMoreBtn, isIng) {
  Column myList(showMoreBtn, isIng) {
    checker++;
    return Column(
      children: [
        // ListView.builder(
        //     padding: EdgeInsets.all(0.0),
        //     itemCount: listItems.length,
        //     shrinkWrap: true,
        //     cacheExtent: 20.0,
        //     physics: NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       String url = "";
        //       for (var i = 0; i < listImages.length; i++) {
        //         if (listImages[i]["index"] == (index + 1).toString()) {
        //           url = listImages[i]['fileID'];
        //         }
        //       }
        //       return StepIngImage(
        //         index: index,
        //         text: listItems[index],
        //         count: listImages.length,
        //         size: size,
        //         url: url,
        //       );
        //     }),

        // for (int k = 0; k < listImages.length; k++) ...[
        //   StepIngImage(
        //     index: k,
        //     text: listItems[k],
        //     count: listImages.length,
        //     size: size,
        //     url: (k) {
        //       for (var i = 0; i < listImages.length; i++) {
        //         if (listImages[i]["index"] == (k + 1).toString()) {
        //           return listImages[i]['fileID'];
        //         }
        //       }
        //       return "";
        //     },
        //   )
        // ],

        Column(
          // children: showMoreBtn
          //     ? (isIng
          //         ? ingWidgetList.sublist(0, 2)
          //         : stepsWidgetList.sublist(0, 2))
          //     : (isIng ? ingWidgetList : stepsWidgetList),
          children: isIng
              ? (isExpandedIng
                  ? ingWidgetList
                  : ingWidgetList.length > 2
                      ? ingWidgetList.sublist(0, 2)
                      : ingWidgetList)
              : (isExpandedSteps
                  ? stepsWidgetList
                  : stepsWidgetList.length > 2
                      ? stepsWidgetList.sublist(0, 2)
                      : stepsWidgetList),
        ),
        showMoreBtn
            ? TextButton.icon(
                icon: isIng
                    ? isExpandedIng
                        ? const Icon(Icons.keyboard_arrow_up_rounded)
                        : const Icon(Icons.keyboard_arrow_down_rounded)
                    : isExpandedSteps
                        ? const Icon(Icons.keyboard_arrow_up_rounded)
                        : const Icon(Icons.keyboard_arrow_down_rounded),
                label: isIng
                    ? isExpandedIng
                        ? const Text('Show less')
                        : const Text('Show more')
                    : isExpandedSteps
                        ? const Text('Show less')
                        : const Text('Show more'),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      if (isIng == true) {
                        isExpandedIng = !isExpandedIng;
                      } else {
                        isExpandedSteps = !isExpandedSteps;
                      }
                    });
                  }
                },
                style: TextButton.styleFrom(primary: kPrimaryColor),
              )
            : const SizedBox(
                height: 0.0,
              ),
      ],
    );
  }

  Future<List<Widget>> generateList(listItems, listImages, isIng) async {
    List<bool> isImage = List.filled(listItems.length, false, growable: true);
    for (int k = 0; k < listImages.length; k++) {
      AsyncMemoizer memoizer4 = AsyncMemoizer();
      String storedFuture = await loadImg(listImages[k]['fileID'], memoizer4);
      if (isIng) {
        ingStoredFutures[listImages[k]['index']] = storedFuture;
      } else {
        stepStoredFutures[listImages[k]['index']] = storedFuture;
      }
      isImage[int.parse(listImages[k]['index']) - 1] = true;
    }

    return [
      for (int k = 0; k < listItems.length; k++) ...[
        // storedFuture = loadImg();
        StepIngImage(
          index: k,
          text: listItems[k],
          count: listItems.length,
          storedFuture: (k) async {
            for (var i = 0; i < listImages.length; i++) {
              if (listImages[i]["index"] == (k + 1).toString()) {
                if (isIng) {
                  return ingStoredFutures[(k + 1).toString()];
                } else {
                  return stepStoredFutures[(k + 1).toString()];
                }
              }
            }
            return "";
          },
          isImage: isImage[k],
          // size: size,
          url: (k) {
            for (var i = 0; i < listImages.length; i++) {
              if (listImages[i]["index"] == (k + 1).toString()) {
                return listImages[i]['fileID'];
              }
            }
            return "";
          },
        )
      ],
    ];
  }

  Future<List<Widget>> generateCommentList() async {
    if (comments.isEmpty) return [];
    for (int k = 0; k < 2; k++) {
      AsyncMemoizer memoizer1 = AsyncMemoizer();
      Future storedFuture1 = loadImg(comments[k]['profilePic'], memoizer1);
      commentStoredFutures[(k + 1).toString()] = storedFuture1;
    }
    return [
      for (var i = 0; i < 2; i++) ...[
        // createComment(comment: comments[i],index: i, )
        CreateComment(
          recost: comments[i],
          index: i,
          userUuid: widget.recs['userUuid'],
          recipeUuid: widget.recs['uuid'],
          storedFuture: commentStoredFutures[(i + 1).toString()],
          removeComment: (ind) {
            if (mounted) {
              setState(() {
                comments.remove(ind);
              });
            }
          },
          uuid: uuid,
          isPost: false,
        )
      ],
    ];
  }

  Future<List<Widget>> generateSimilarList() async {
    for (int k = 0; k < similar.length; k++) {
      AsyncMemoizer memoizer2 = AsyncMemoizer();
      Future storedFuture2 = loadImg(similar[k]['recipeImageID'], memoizer2);
      similarStoredFutures[(k + 1).toString()] = storedFuture2;
    }
    return [
      for (var i = 0; i < similar.length; i++)
        ViewRecSimilarRec(
            recs: similar[i],
            funcB: (test) {},
            storedFuture: similarStoredFutures[(i + 1).toString()]),
    ];
  }

  Widget _createRatingPercentBar(Size size, int star, int rating, Color color) {
    return Row(children: [
      Text(star.toString()),
      const Icon(Icons.star, size: 14.0, color: kDark),
      const SizedBox(width: 5.0),
      SizedBox(
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
    super.initState();
    memoizer = AsyncMemoizer();
    memoizer3 = AsyncMemoizer();
    getRecipe();
    // myFuture = loadImg(x);

    // getImage();
    yController = YoutubePlayerController(
        initialVideoId: youtubeLink,
        flags: const YoutubePlayerFlags(
            mute: false, autoPlay: false, loop: false));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    yController.pause();
  }

  bool fullScreen = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: false).pop(true);
        return false;
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
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
                padding: const EdgeInsets.all(8.0),
                color: Colors.transparent,
                child: ClipOval(
                  child: Container(
                    // padding: EdgeInsets.all(8.0),
                    width: (kToolbarHeight * 1.1) - 16.0,
                    color: kPrimaryColor,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: false).pop();
                      },
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              ClipOval(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.transparent,
                  child: ClipOval(
                    child: Container(
                      // padding: EdgeInsets.all(8.0),
                      width: (kToolbarHeight * 1.1) - 16.0,
                      color: kPrimaryColor,
                      child: IconButton(
                        icon: (isBookmarked)
                            ? const Icon(Icons.bookmark)
                            : const Icon(Icons.bookmark_border),
                        iconSize: 30.0,
                        onPressed: () async {
                          if (!isBookmarked) {
                            var token = await storage.read(key: "token");
                            await dio.post(
                                "https://api-tassie.herokuapp.com/recs/bookmark",
                                options: Options(headers: {
                                  HttpHeaders.contentTypeHeader:
                                      "application/json",
                                  HttpHeaders.authorizationHeader:
                                      "Bearer ${token!}"
                                }),
                                data: {'uuid': widget.recs['uuid']});
                            widget.funcB(false);
                            if (mounted) {
                              setState(() {
                                isBookmarked = !isBookmarked;
                              });
                            }
                          } else {
                            var token = await storage.read(key: "token");
                            await dio.post(
                                "https://api-tassie.herokuapp.com/recs/removeBookmark",
                                options: Options(headers: {
                                  HttpHeaders.contentTypeHeader:
                                      "application/json",
                                  HttpHeaders.authorizationHeader:
                                      "Bearer ${token!}"
                                }),
                                data: {'uuid': widget.recs['uuid']});
                            widget.funcB(true);
                            if (mounted) {
                              setState(() {
                                isBookmarked = !isBookmarked;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              ClipOval(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
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
                            dio.post(
                                "https://api-tassie.herokuapp.com/recs/unlike",
                                options: Options(headers: {
                                  HttpHeaders.contentTypeHeader:
                                      "application/json",
                                  HttpHeaders.authorizationHeader:
                                      "Bearer ${token!}"
                                }),
                                data: {'uuid': widget.recs['uuid']});
                            // widget.func(false);
                            if (mounted) {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            }
                          } else {
                            var token = await storage.read(key: "token");
                            dio.post(
                                "https://api-tassie.herokuapp.com/recs/like",
                                options: Options(headers: {
                                  HttpHeaders.contentTypeHeader:
                                      "application/json",
                                  HttpHeaders.authorizationHeader:
                                      "Bearer ${token!}"
                                }),
                                data: {'uuid': widget.recs['uuid']});
                            // widget.func(true);
                            if (mounted) {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            }
                          }
                          // print(likeNumber.toString());
                        },
                        icon: (!isLiked)
                            ? const Icon(Icons.favorite_border)
                            : const Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              if (uuid == widget.recs['userUuid']) ...[
                ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.transparent,
                    child: ClipOval(
                      child: Container(
                        width: (kToolbarHeight * 1.1) - 16.0,
                        color: kPrimaryColor,
                        child: PopupMenuButton(
                          elevation: 20,
                          enabled: true,
                          onSelected: (value) async {
                            if (value == "edit") {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (context) => EditRecipe(
                                            recipeName: recipeName,
                                            uuid: widget.recs['uuid'],
                                            chefName: chefName,
                                            stepPics: stepPics,
                                            isLunch: isLunch,
                                            isVeg: isVeg,
                                            isDinner: isDinner,
                                            isCraving: isCraving,
                                            isBreakfast: isBreakfast,
                                            flavour: flavour,
                                            course: course,
                                            desc: desc,
                                            hours: hours,
                                            mins: mins,
                                            ingredientPics: ingredientPics,
                                            ingredients: ingredients,
                                            steps: steps,
                                            recipeImageID: recipeImageID,
                                          )));
                            } else if (value == "delete") {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete"),
                                      content: const Text("Are you sure?"),
                                      actionsPadding: const EdgeInsets.only(
                                          bottom: 20.0, right: 20.0),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text("No"),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        GestureDetector(
                                          onTap: () async {
                                            if (mounted) {
                                              setState(() {
                                                isPop = true;
                                              });
                                            }
                                            Navigator.of(context).pop(true);
                                            // Navigator.of(context, rootNavigator: false).pop();
                                            var url =
                                                "https://api-tassie.herokuapp.com/recs/deleteRecipe";
                                            var token = await storage.read(
                                                key: "token");
                                            Response response =
                                                await dio.post(url,
                                                    options: Options(headers: {
                                                      HttpHeaders
                                                              .contentTypeHeader:
                                                          "application/json",
                                                      HttpHeaders
                                                              .authorizationHeader:
                                                          "Bearer ${token!}"
                                                    }),
                                                    data: {
                                                  'uuid': widget.recs['uuid'],
                                                  // 'folder': widget.folder
                                                });
                                            if (response.data['status'] ==
                                                true) {
                                            } else {
                                              await Future.delayed(
                                                  const Duration(seconds: 1));

                                              if (!mounted) return;
                                              showSnack(
                                                  context,
                                                  response.data['message'],
                                                  () {},
                                                  'OK',
                                                  4);
                                            }
                                          },
                                          child: const Text("Yes"),
                                        ),
                                      ],
                                    );
                                  });
                              if (isPop) {
                                await Future.delayed(
                                    const Duration(seconds: 1));

                                if (!mounted) return;
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "edit",
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                              // ignore: sort_child_properties_last
                              child: Text("Delete"),
                              value: "delete",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.only(top: 0),
                  children: [
                    Hero(
                      tag: widget.recs['uuid'],
                      child: SizedBox(
                        width: size.width,
                        height: size.width,
                        // child: recipeImageID != " "
                        //     ? Image(
                        //         image: NetworkImage(getImage(recipeImageID)),
                        //         fit: BoxFit.cover,
                        //       )
                        //     : null,
                        child: FutureBuilder(
                            future: storedFuture,
                            builder:
                                (BuildContext context, AsyncSnapshot text) {
                              if ((text.connectionState ==
                                      ConnectionState.waiting) ||
                                  text.hasError) {
                                return Image.asset("assets/images/broken.png");
                              } else {
                                if (!text.hasData) {
                                  return const Center(
                                    child: Icon(
                                      Icons.refresh,
                                      size: 50.0,
                                      color: kDark,
                                    ),
                                  );
                                }
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) => PhotoView(
                                                  imageProvider: NetworkImage(
                                                      text.data.toString()))));
                                    },
                                    child: Image.network(text.data.toString()));
                              }
                            }),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -20.0),
                      child: Container(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                recipeName.capitaliz(),
                                style: const TextStyle(
                                  // color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.7,
                                    child: Wrap(
                                      runSpacing: 10.0,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              side: const BorderSide(
                                                color: kDark,
                                                width: 1,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            child: Text(
                                              flavour,
                                              style:
                                                  const TextStyle(color: kDark),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              side: const BorderSide(
                                                color: kDark,
                                                width: 1,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            child: Text(
                                              course,
                                              style:
                                                  const TextStyle(color: kDark),
                                            ),
                                          ),
                                        ),
                                        if (isLunch) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                side: const BorderSide(
                                                  color: kDark,
                                                  width: 1,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                              child: const Text(
                                                'Lunch',
                                                style: TextStyle(color: kDark),
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
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                side: const BorderSide(
                                                  color: kDark,
                                                  width: 1,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                              child: const Text(
                                                'Breakfast',
                                                style: TextStyle(color: kDark),
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
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                side: const BorderSide(
                                                  color: kDark,
                                                  width: 1,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                              child: const Text(
                                                'Dinner',
                                                style: TextStyle(color: kDark),
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
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                side: const BorderSide(
                                                  color: kDark,
                                                  width: 1,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                              child: const Text(
                                                'Craving',
                                                style: TextStyle(color: kDark),
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
                                    margin: const EdgeInsets.only(top: 8.0),
                                    padding: const EdgeInsets.all(10.0),
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
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.timer),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        if (hours != 0) ...[
                                          TextSpan(
                                            text: '${hours}h ',
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
                                          text: '${mins}m',
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
                              const SizedBox(
                                height: 20.0,
                              ),
                              ListTile(
                                minLeadingWidth: (size.width - 40.0) / 10,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                leading: Container(
                                  width: (size.width - 40.0) / 10,
                                  height: (size.width - 40.0) / 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    child: ClipOval(
                                      // child: Image(
                                      //   height: (size.width - 40.0) / 10,
                                      //   width: (size.width - 40.0) / 10,
                                      //   image: NetworkImage(
                                      //       'https://picsum.photos/200'),
                                      //   fit: BoxFit.cover,
                                      // ),
                                      child: FutureBuilder(
                                          future: storedFuture3,
                                          builder: (BuildContext context,
                                              AsyncSnapshot text) {
                                            if ((text.connectionState ==
                                                    ConnectionState.waiting) ||
                                                text.hasError) {
                                              return Image(
                                                height:
                                                    (size.width - 40.0) / 10,
                                                width: (size.width - 40.0) / 10,
                                                image: const AssetImage(
                                                    'assets/images/broken.png'),
                                                fit: BoxFit.cover,
                                              );
                                            } else {
                                              if (!text.hasData) {
                                                return SizedBox(
                                                    height:
                                                        (size.width - 40.0) /
                                                            10,
                                                    width: (size.width - 40.0) /
                                                        10,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.refresh,
                                                        // size: 50.0,
                                                        color: kDark,
                                                      ),
                                                    ));
                                              }
                                              return Image(
                                                height:
                                                    (size.width - 40.0) / 10,
                                                width: (size.width - 40.0) / 10,
                                                image: NetworkImage(
                                                    text.data.toString()),
                                                fit: BoxFit.cover,
                                              );
                                            }
                                          }),
                                    ),
                                  ),
                                ),
                                // title: Text(
                                //   chefName,
                                //   style: const TextStyle(
                                //     overflow: TextOverflow.ellipsis,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                title: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: chefName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? kDark[900]
                                              : kLight,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            if (uuid ==
                                                widget.recs['userUuid']) {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (_) => Profile(
                                                  uuid: widget.recs['userUuid'],
                                                ),
                                              ));
                                            }
                                          },
                                      ),
                                    ])),
                                trailing: uuid == widget.recs['userUuid']
                                    ? null
                                    : isSubscribed
                                        ? TextButton.icon(
                                            icon:
                                                const Icon(Icons.check_circle),
                                            label: const Text('SUBSCRIBED'),
                                            onPressed: () async {
                                              var token = await storage.read(
                                                  key: "token");
                                              Response response = await dio.post(
                                                  "https://api-tassie.herokuapp.com/profile/unsubscribe/",
                                                  options: Options(headers: {
                                                    HttpHeaders
                                                            .contentTypeHeader:
                                                        "application/json",
                                                    HttpHeaders
                                                            .authorizationHeader:
                                                        "Bearer ${token!}"
                                                  }),
                                                  // data: jsonEncode(value),
                                                  data: {
                                                    'uuid':
                                                        widget.recs['userUuid']
                                                  });
                                              if (response.data['status'] ==
                                                  true) {
                                                if (mounted) {
                                                  setState(() {
                                                    isSubscribed = false;
                                                  });
                                                }
                                              } else {
                                                await Future.delayed(
                                                    const Duration(seconds: 1));

                                                if (!mounted) return;
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
                                            onPressed: () async {
                                              var token = await storage.read(
                                                  key: "token");
                                              Response response = await dio.post(
                                                  "https://api-tassie.herokuapp.com/profile/subscribe/",
                                                  options: Options(headers: {
                                                    HttpHeaders
                                                            .contentTypeHeader:
                                                        "application/json",
                                                    HttpHeaders
                                                            .authorizationHeader:
                                                        "Bearer ${token!}"
                                                  }),
                                                  // data: jsonEncode(value),
                                                  data: {
                                                    'uuid':
                                                        widget.recs['userUuid']
                                                  });
                                              if (response.data['status'] ==
                                                  true) {
                                                if (mounted) {
                                                  setState(() {
                                                    isSubscribed = true;
                                                  });
                                                }
                                              } else {
                                                await Future.delayed(
                                                    const Duration(seconds: 1));

                                                if (!mounted) return;
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
                                            child: const Text('SUBSCRIBE'),
                                          ),
                              ),
                            ]),
                      ),
                    ),
                    const Divider(
                      thickness: 8,
                    ),
                    if (desc != "") ...[
                      Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: ShowMoreText(text: desc.capitaliz()),
                      ),
                      const SizedBox(height: 10.0)
                    ],
                    // Divider(
                    //   thickness: 5,
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    Container(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
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
                                        if (mounted) {
                                          setState(() {
                                            isExpandedIng = !isExpandedIng;
                                          });
                                        }
                                      },
                                      icon: isExpandedIng
                                          ? const Icon(
                                              Icons.keyboard_arrow_up_rounded)
                                          : const Icon(Icons
                                              .keyboard_arrow_down_rounded),
                                      iconSize: 35.0,
                                      padding: const EdgeInsets.all(0.0),
                                      color: kDark,
                                    )
                                  : const SizedBox(
                                      width: 0.0,
                                    ),
                            ],
                          ),
                          const SizedBox(
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
                                  // ? myList(size, ingredients.sublist(0, 2),
                                  //     ingredientPics, true, true)
                                  // : myList(size, ingredients, ingredientPics,
                                  //     true, true)
                                  ? myList(true, true)
                                  : myList(true, true)
                              // : myList(size, ingredients, ingredientPics, false,
                              //     true),
                              : myList(false, true),
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
                    const Divider(
                      thickness: 8,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
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
                                        if (mounted) {
                                          setState(() {
                                            isExpandedSteps = !isExpandedSteps;
                                          });
                                        }
                                      },
                                      icon: isExpandedSteps
                                          ? const Icon(
                                              Icons.keyboard_arrow_up_rounded)
                                          : const Icon(Icons
                                              .keyboard_arrow_down_rounded),
                                      iconSize: 35.0,
                                      padding: const EdgeInsets.all(0.0),
                                      color: kDark,
                                    )
                                  : const SizedBox(
                                      width: 0.0,
                                    ),
                            ],
                          ),
                          const SizedBox(
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
                                  // ? myList(size, steps.sublist(0, 2), stepPics,
                                  //     true, false)
                                  // : myList(size, steps, stepPics, true, false)
                                  ? myList(true, false)
                                  : myList(true, false)
                              // : myList(size, steps, stepPics, false, false),
                              : myList(false, false)
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 8,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      color: Colors.transparent,
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Youtube Video',
                              style: TextStyle(
                                // color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: YoutubePlayer(
                                  controller: yController, bottomActions: []),
                            ),
                            Center(
                              child: TextButton.icon(
                                icon: const Icon(Icons.fullscreen),
                                label: const Text('View in fullscreen'),
                                onPressed: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                        builder: (context) => YoutubeFullScreen(
                                            url: youtubeLink)),
                                  );
                                },
                                style: TextButton.styleFrom(
                                    primary: kPrimaryColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    const Divider(
                      thickness: 8,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    Container(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ratings',
                            style: TextStyle(
                              // color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          if (totalRatings != 0) ...[
                            Container(
                              margin: const EdgeInsets.symmetric(
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
                                                const Icon(
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
                                  const SizedBox(height: 10.0),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: totalRatings.toString(),
                                          style: const TextStyle(
                                            // color: kDark,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        const TextSpan(
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
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    // color: Theme.of(context).brightness ==
                                    //         Brightness.dark
                                    //     ? kDark[900]
                                    //     : kLight,
                                    border: Border.all(color: kDark),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Show ratings'),
                                    Icon(Icons.keyboard_arrow_right_rounded),
                                  ],
                                ),
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
                                padding:
                                    const EdgeInsets.all(kDefaultPadding * 1.5),
                                margin: const EdgeInsets.only(top: 20.0),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.icecream_outlined,
                                        size: 35.0, color: kDark),
                                    SizedBox(height: 10.0),
                                    Text('No Ratings yet'),
                                  ],
                                ),
                              ),
                            )
                          ],
                          const SizedBox(height: 40.0),
                          const Text('Rate this recipe!'),
                          const SizedBox(height: 10.0),
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
                                    const EdgeInsets.symmetric(horizontal: 4.0),
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
                                  if (mounted) {
                                    setState(() {
                                      rating = rate;
                                    });
                                  }
                                  //to update user rating
                                  var token = await storage.read(key: "token");
                                  Response response = await dio.post(
                                      "https://api-tassie.herokuapp.com/recs/addRating",
                                      options: Options(headers: {
                                        HttpHeaders.contentTypeHeader:
                                            "application/json",
                                        HttpHeaders.authorizationHeader:
                                            "Bearer ${token!}"
                                      }),
                                      data: {
                                        'uuid': widget.recs['uuid'],
                                        'star': rating,
                                      });
                                  if (response.data != null) {
                                    if (response.data['status'] == true) {
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      if (!mounted) return;
                                      showSnack(context, "Thanks for rating!",
                                          () {}, 'OK', 3);
                                    } else {
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      if (!mounted) return;
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
                                              "Bearer ${token!}"
                                        }),
                                        data: {
                                          'uuid': widget.recs['uuid'],
                                          'star': rating,
                                        });
                                    if (mounted) {
                                      setState(() {
                                        rating = 0.0;
                                      });
                                    }

                                    if (response.data != null) {
                                      if (response.data['status'] == true) {
                                        await Future.delayed(
                                            const Duration(seconds: 1));

                                        if (!mounted) return;
                                        showSnack(context, "Rating deleted!",
                                            () {}, 'OK', 3);
                                      } else {
                                        await Future.delayed(
                                            const Duration(seconds: 1));

                                        if (!mounted) return;
                                        showSnack(
                                            context,
                                            "Unable to reset rating!",
                                            () {},
                                            'OK',
                                            3);
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.restart_alt))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 8,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
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
                              Column(
                                children: commentsWidgetList,
                              ),
                              // for (var i = 0; i < comments.length; i++) ...[
                              //   // createComment(comment: comments[i],index: i, )
                              //   CreateComment(
                              //     recost: comments[i],
                              //     index: i,
                              //     userUuid: widget.recs['userUuid'],
                              //     recipeUuid: widget.recs['uuid'],
                              //     removeComment: (ind) {
                              //       setState(() {
                              //         comments.remove(ind);
                              //       });
                              //     },
                              //     uuid: uuid,
                              //     isPost: false,
                              //   )
                              // ],
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
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      // color: Theme.of(context).brightness ==
                                      //         Brightness.dark
                                      //     ? kDark[900]
                                      //     : kLight,
                                      border: Border.all(color: kDark),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Show all comments'),
                                      Icon(Icons.keyboard_arrow_right_rounded),
                                    ],
                                  ),
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
                                  padding: const EdgeInsets.all(
                                      kDefaultPadding * 1.5),
                                  margin: const EdgeInsets.only(top: 20.0),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.question_answer_rounded,
                                          size: 35.0, color: kDark),
                                      SizedBox(height: 10.0),
                                      Text('No comments yet'),
                                    ],
                                  ),
                                ),
                              )
                            ],
                            const SizedBox(height: 10.0),
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
                                    icon: const Icon(Icons.add_comment_rounded),
                                    label: const Text('Add Comment'))),
                          ],
                        )),
                    const Divider(
                      thickness: 8,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                        padding: const EdgeInsets.all(kDefaultPadding),
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
                              padding: const EdgeInsets.only(top: 30.0),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // children: [
                                  //   for (var i = 0; i < similar.length; i++)
                                  //     ViewRecSimilarRec(
                                  //         recs: similar[i], funcB: (test) {}),
                                  // ],
                                  children: similarWidgetList,
                                ),
                              ),
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 100.0,
                    ),
                  ],
                )),
    );

    // );
  }
}

class MyBullet extends StatelessWidget {
  const MyBullet({required this.index, Key? key}) : super(key: key);
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
      style: const TextStyle(fontSize: 30.0, color: kPrimaryColor),
    );
  }
}
