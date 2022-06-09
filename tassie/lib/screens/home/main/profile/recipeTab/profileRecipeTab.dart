import 'dart:typed_data';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/recs/viewRecipe.dart';
import 'package:tassie/utils/imgLoader.dart';

class RecipeTab extends StatefulWidget {
  const RecipeTab(
      {required this.refreshPage, required this.recipes, required this.isEnd});
  final Future<void> Function() refreshPage;
  final List recipes;
  final bool isEnd;
  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  // final ScrollController _sc = ScrollController();
  // List<Map> recs = [
  //   {
  //     "name": "Paneer Tikka",
  //     "user": "Sommy21",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "name": "Dhokla",
  //     "user": "parthnamdev",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   },
  //   {
  //     "name": "Khamman",
  //     "user": "rishabh",
  //     "url": "https://picsum.photos/200",
  //     "profilePic": "https://picsum.photos/200"
  //   }
  // ];
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

  Widget _endMessage() {
    // print(isEnd);
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
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
    // TODO: implement initState
    super.initState();
    print(widget.recipes);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List recs = widget.recipes;
    print('1');
    print(recs);
    return RefreshIndicator(
      onRefresh: widget.refreshPage,
      child: ListView(
        children: [
          recs.length > 0
              ? GridView.builder(
                  shrinkWrap: true,
                  // controller: _sc,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    // childAspectRatio: (size.width / 2) /
                    //     ((size.width / 2) + (size.width / 10) + 100.0),
                  ),
                  itemBuilder: (context, index) {
                    return index == recs.length
                        ? widget.isEnd
                            ? _endMessage()
                            : _buildProgressIndicator()
                        // : FeedPost(index: index, posts: posts);
                        : GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => ViewRecPost(
                                        recs: recs[index],
                                        refreshPage: widget.refreshPage,
                                        funcB: (isBookmarked) {})),
                              );
                            },
                            child: ProfileRecipeTabChild(
                                recID: recs[index]['recipeImageID']),
                          );
                    // return Container(
                    //   color: Colors.red,
                    // );
                  },
                  itemCount: recs.length,
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.15),
                    child: Text(
                      'No recipes yet',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class ProfileRecipeTabChild extends StatefulWidget {
  const ProfileRecipeTabChild({
    Key? key,
    required this.recID,
  }) : super(key: key);

  final String recID;

  @override
  State<ProfileRecipeTabChild> createState() => _ProfileRecipeTabChildState();
}

class _ProfileRecipeTabChildState extends State<ProfileRecipeTabChild>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // bool isImage = false;
  // String _image = "";
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;
  @override
  void didUpdateWidget(covariant ProfileRecipeTabChild oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoizer = AsyncMemoizer();
    print(widget.recID);
    storedFuture = loadImg(widget.recID, memoizer);
    // _image = "";
    // loadImg(widget.recID,memoizer).then((result) {
    //   print('recs refresh');
    //   if (mounted) {
    //     setState(() {
    //       print(result);
    //       _image = result;
    //       isImage = true;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // return !isImage ? Container() : Image.network(_image);
    return FutureBuilder(
        future: storedFuture,
        builder: (BuildContext context, AsyncSnapshot text) {
          if ((text.connectionState == ConnectionState.waiting) ||
              text.hasError) {
            // return Image.asset("assets/images/broken.png",
            //     fit: BoxFit.cover, height: 128, width: 128);
            return Container();
          } else {
            if (!text.hasData) {
              return GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                      child: Center(
                    child: Icon(
                      Icons.refresh,
                      // size: 50.0,
                      color: kDark,
                    ),
                  )));
            }
            return Image(
              image: NetworkImage(text.data.toString()),
              fit: BoxFit.cover,
            );
          }
        });
  }
}
