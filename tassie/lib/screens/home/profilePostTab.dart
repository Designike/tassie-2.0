import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

class PostTab extends StatefulWidget {
  const PostTab(
      {required this.refreshPage, required this.posts, required this.isEnd});
  final Future<void> Function() refreshPage;
  final List posts;
  final bool isEnd;
  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
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
  Widget build(BuildContext context) {
    List posts = widget.posts;
    // print(posts);
    Size size = MediaQuery.of(context).size;
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
                        : Image.network(posts[index]['url']);
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
