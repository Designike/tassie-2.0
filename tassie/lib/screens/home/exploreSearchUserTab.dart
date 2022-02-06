import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

class ExploreSearchUserTab extends StatefulWidget {
  const ExploreSearchUserTab(
      {required this.users,
      required this.isEndU,
      required this.isLazyLoadingU});
  final List users;
  final bool isEndU;
  final bool isLazyLoadingU;
  @override
  _ExploreSearchUserTabState createState() => _ExploreSearchUserTabState();
}

class _ExploreSearchUserTabState extends State<ExploreSearchUserTab> {
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: widget.isLazyLoadingU ? 0.8 : 00,
          child: CircularProgressIndicator(
            color: kPrimaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _endMessage() {
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
    List users = widget.users;
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index]['username']),
          subtitle: Text(
            users[index]['name'],
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
                image: NetworkImage(users[index]['profilePic']),
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
