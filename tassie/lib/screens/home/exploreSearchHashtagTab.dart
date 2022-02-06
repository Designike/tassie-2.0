import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

class ExploreSearchHashtagTab extends StatefulWidget {
  const ExploreSearchHashtagTab({required this.hashtags});
  final List hashtags;

  @override
  _ExploreSearchHashtagTabState createState() =>
      _ExploreSearchHashtagTabState();
}

class _ExploreSearchHashtagTabState extends State<ExploreSearchHashtagTab> {
  @override
  Widget build(BuildContext context) {
    List hashtags = widget.hashtags;
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(hashtags[index]),
          subtitle: Text(
            hashtags[index],
            style: TextStyle(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? kLight
                        : kDark[900]),
          ),
          leading: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50.0,
                width: 50.0,
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      itemCount: hashtags.length,
    );
  }
}
