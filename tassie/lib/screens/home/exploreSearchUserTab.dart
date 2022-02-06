import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

class ExploreSearchUserTab extends StatefulWidget {
  const ExploreSearchUserTab({required this.users});
  final List users;

  @override
  _ExploreSearchUserTabState createState() => _ExploreSearchUserTabState();
}

class _ExploreSearchUserTabState extends State<ExploreSearchUserTab> {
  @override
  Widget build(BuildContext context) {
    List users = widget.users;
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index]),
          subtitle: Text(
            users[index],
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
      itemCount: users.length,
    );
  }
}
