import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/profile/postTab/viewProfilePost.dart';
import 'package:tassie/utils/imgLoader.dart';

class PostTab extends StatefulWidget {
  const PostTab(
      {required this.refreshPage,
      required this.posts,
      required this.isEnd,
      Key? key})
      : super(key: key);
  final Future<void> Function() refreshPage;
  final List posts;
  final bool isEnd;
  @override
  PostTabState createState() => PostTabState();
}

class PostTabState extends State<PostTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
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
    // print(isEnd);
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List posts = widget.posts;
    // print(posts);
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: widget.refreshPage,
      child: ListView(
        cacheExtent: size.height * 2,
        children: [
          posts.isNotEmpty
              ? GridView.builder(
                  shrinkWrap: true,
                  // controller: _sc,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      refreshPage: widget.refreshPage),
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
                    child: const Text(
                      'No posts yet',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
        ],
      ),
    );
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
  late Future storedFuture;

  @override
  void didUpdateWidget(covariant ProfilePostTabChild oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    memoizer = AsyncMemoizer();
    storedFuture = loadImg(widget.postID, memoizer);
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
