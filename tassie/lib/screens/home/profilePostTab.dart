import 'package:flutter/material.dart';

class PostTab extends StatefulWidget {
  const PostTab({Key? key}) : super(key: key);

  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  // final ScrollController _sc = ScrollController();
  List<Map> recs = [
    {
      "name": "Paneer Tikka",
      "user": "Sommy21",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "name": "Dhokla",
      "user": "parthnamdev",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    },
    {
      "name": "Khamman",
      "user": "rishabh",
      "url": "https://picsum.photos/200",
      "profilePic": "https://picsum.photos/200"
    }
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
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
                  return
                      // index == recs.length
                      //     ? isEnd
                      //         ? _endMessage()
                      //         : _buildProgressIndicator()
                      //     // : FeedPost(index: index, posts: posts);
                      //     :
                      Image.network(recs[index]['url']);
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
                    'No posts yet',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
      ],
    );
    // return Container();
  }
}
