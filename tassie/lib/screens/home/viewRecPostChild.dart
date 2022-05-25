import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/editRecipe.dart';
import 'package:tassie/screens/home/showMoreText.dart';
import 'package:tassie/screens/home/snackbar.dart';
import 'package:tassie/screens/home/viewRecAllRatings.dart';
import 'package:tassie/screens/home/viewRecCommentChild.dart';
import 'package:tassie/screens/home/viewRecSimilarRec.dart';
import 'package:tassie/screens/imgLoader.dart';

import 'viewRecAllComments.dart';

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
      // required this.size,
      required this.url,
      required this.storedFuture})
      : super(key: key);
  final int index;
  final int count;
  final String text;
  // final Size size;
  final String Function(int) url;
  final Future Function(int) storedFuture;

  @override
  _StepIngImageState createState() => _StepIngImageState();
}

class _StepIngImageState extends State<StepIngImage> {
  AsyncMemoizer _memoizer1 = AsyncMemoizer();
  late Future _storedFuture1;
  bool _isLoading1 = true;
  Future<void> _getImage() async {
    // _storedFuture1 = loadImg(widget.url(widget.index), _memoizer1);
    _storedFuture1 = widget.storedFuture(widget.index);
    if (mounted) {
      setState(() {
        _isLoading1 = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _memoizer1 = AsyncMemoizer();
    _getImage();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (_isLoading1)
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          )
        : Column(
            children: [
              ListTile(
                leading: MyBullet(index: (widget.index + 1).toString()),
                title: Text(widget.text),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
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
                            width: size.width - (2 * kDefaultPadding),
                            height: size.width - (2 * kDefaultPadding),
                            // child: Image(
                            //   // image: NetworkImage(url),
                            //   image:
                            //       NetworkImage('https://picsum.photos/200'),
                            //   fit: BoxFit.cover,
                            // ),
                            child: FutureBuilder(
                                future: _storedFuture1,
                                builder:
                                    (BuildContext context, AsyncSnapshot text) {
                                  if (text.connectionState ==
                                      ConnectionState.waiting) {
                                    return Image.asset(
                                        "assets/images/broken.png");
                                  } else if (text.error != null) {
                                    return Image.asset(
                                        "assets/images/broken.png");
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
