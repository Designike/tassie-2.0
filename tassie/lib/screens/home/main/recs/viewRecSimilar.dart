import 'package:async/async.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';

import '../../../../constants.dart';

class ViewRecSimilarRec extends StatefulWidget {
  const ViewRecSimilarRec(
      {required this.recs,
      required this.funcB,
      required this.storedFuture,
      Key? key})
      : super(key: key);

  final Map recs;
  // final Map recostData;
  final void Function(bool) funcB;
  final Future storedFuture;
  // final int index;

  @override
  ViewRecSimilarRecState createState() => ViewRecSimilarRecState();
}

class ViewRecSimilarRecState extends State<ViewRecSimilarRec> {
  // String _image = "";
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;
  @override
  void initState() {
    super.initState();
    // print(widget.recs);
    memoizer = AsyncMemoizer();
    // storedFuture = loadImg(widget.recs['recipeImageID'], memoizer);
    storedFuture = widget.storedFuture;
    // loadImg(widget.recs['recipeImageID'], memoizer).then((result) {
    //   setState(() {
    //     _image = result;
    //     // isImage = true;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isBookmarked = widget.recostData['isBookmarked'];
    Map recs = widget.recs;
    return Container(
      width: 150.0,
      margin: const EdgeInsets.only(right: 15.0),
      // height: 300.0,
      // height: ((size.width - 42.0)/2) + 120.0, // minus padding, plus list tile
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? kDark[900]
            : kLight,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        children: [
          Column(
            children: [
              InkWell(
                  // onDoubleTap: () => print('Bookmark recipe'),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  // child: Container(
                  //   margin: EdgeInsets.all(10.0),
                  //   width: double.infinity,
                  //   height: ((size.width - 42.0) / 2) -
                  //       20, // minus padding, minus margin
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(25.0),
                  //     image: DecorationImage(
                  //       image: _image == ""
                  //           ? Image.asset('assets/images/broken.png',
                  //                   fit: BoxFit.cover)
                  //               .image
                  //           : Image.network(_image, fit: BoxFit.cover).image,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  child: FutureBuilder(
                      future: storedFuture,
                      builder: (BuildContext context, AsyncSnapshot text) {
                        if ((text.connectionState == ConnectionState.waiting) ||
                            text.hasError) {
                          // return Image.asset("assets/images/broken.png",
                          //     fit: BoxFit.cover, height: 128, width: 128);
                          return Container(
                            margin: const EdgeInsets.all(10.0),
                            width: double.infinity,
                            // height: ((size.width - 42.0) / 2) -
                            //     20, // minus padding, minus margin
                            height: 150 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/broken.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          if (!text.hasData) {
                            return GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(10.0),
                                    width: double.infinity,
                                    // height: ((size.width - 42.0) / 2) -
                                    //     20, // minus padding, minus margin
                                    height: 150 - 20,
                                    child: const Center(
                                      child: Icon(
                                        Icons.refresh,
                                        size: 50.0,
                                        color: kDark,
                                      ),
                                    )));
                          }
                          return Container(
                            margin: const EdgeInsets.all(10.0),
                            width: double.infinity,
                            // height: ((size.width - 42.0) / 2) -
                            //     20, // minus padding, minus margin
                            height: 150 - 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              image: DecorationImage(
                                image: NetworkImage(text.data.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      })),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) =>
                  // ViewRecPost(recs: recs, funcB: widget.funcB),
                  //   ),
                  // );
                },
                child: ListTile(
                  title: Text(
                    recs['name'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // subtitle: Text(
                  //   recs['username'],
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //       color: Theme.of(context).brightness == Brightness.dark
                  //           ? kLight
                  //           : kDark[900]),
                  // ),
                  subtitle: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                          text: recs['username'],
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? kDark[900]
                                    : kLight,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => Profile(
                                  uuid: recs['uuid'],
                                ),
                              ));
                            },
                        ),
                      ])),
                  isThreeLine: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
