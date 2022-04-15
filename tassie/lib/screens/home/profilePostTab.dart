import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/profile.dart';
import 'package:tassie/screens/home/viewComments.dart';
import 'package:tassie/screens/home/viewCommentsPost.dart';
import 'package:tassie/screens/imgLoader.dart';

class PostTab extends StatefulWidget {
  const PostTab(
      {required this.refreshPage, required this.posts, required this.isEnd});
  final Future<void> Function() refreshPage;
  final List posts;
  final bool isEnd;
  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
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
  }

  @override
  Widget build(BuildContext context) {
    List posts = widget.posts;
    // print(posts);
    Size size = MediaQuery.of(context).size;
    print('henlo');
    print(posts);
    return RefreshIndicator(
      onRefresh: widget.refreshPage,
      child: ListView(
        children: [
          posts.length > 0
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
                    return index == posts.length
                        ? widget.isEnd
                            ? _endMessage()
                            : _buildProgressIndicator()
                        // : FeedPost(index: index, posts: posts);
                        : GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (_) => ViewCommentsPost(
                                    post: posts[index],
                                  ),
                                ),
                              );
                            },
                            child: ProfilePostTabChild(
                                postID: posts[index]['postID']));
                    // return Container(
                    //   color: Colors.red,
                    // );
                  },
                  itemCount: posts.length,
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.15),
                    child: Text(
                      'No posts yet',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
        ],
      ),
    );
    // return Container();
  }
}

class ProfilePostTabChild extends StatefulWidget {
  const ProfilePostTabChild({
    Key? key,
    required this.postID,
  }) : super(key: key);

  final String postID;

  @override
  State<ProfilePostTabChild> createState() => _ProfilePostTabChildState();
}

class _ProfilePostTabChildState extends State<ProfilePostTabChild> {
  // String _image = "";
  // bool isImage = false;
  AsyncMemoizer memoizer = AsyncMemoizer();

  @override
  void didUpdateWidget(covariant ProfilePostTabChild oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoizer = AsyncMemoizer();
    // _image = "";
    // loadImg(widget.postID,memoizer).then((result) {
    //   print('post refresh');
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
        future: loadImg(widget.postID, memoizer),
        builder: (BuildContext context, AsyncSnapshot text) {
          if (text.connectionState == ConnectionState.waiting) {
            // return Image.asset("assets/images/broken.png",
            //     fit: BoxFit.cover, height: 128, width: 128);
            return Container();
          } else {
            return Image(
              image: NetworkImage(text.data.toString()),
              fit: BoxFit.cover,
            );
          }
        });
  }
}
