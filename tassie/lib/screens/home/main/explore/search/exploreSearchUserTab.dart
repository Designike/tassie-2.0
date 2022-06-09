import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/utils/imgLoader.dart';

class ExploreSearchUserTab extends StatefulWidget {
  const ExploreSearchUserTab(
      {required this.users,
      required this.isEndU,
      required this.isLazyLoadingU,
      Key? key}): super(key: key);
  final List users;
  final bool isEndU;
  final bool isLazyLoadingU;
  @override
  ExploreSearchUserTabState createState() => ExploreSearchUserTabState();
}

class ExploreSearchUserTabState extends State<ExploreSearchUserTab> {


  @override
  Widget build(BuildContext context) {
    List users = widget.users;
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return Profile(uuid: users[index]['uuid']);
              }),
            );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) {
            //     return Home();
            //   }),
            // );
          },
          title: Text(users[index]['username']),
          subtitle: Text(
            users[index]['name'],
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? kLight
                    : kDark[900]),
          ),
          leading: CircleAvatar(
            child: ClipOval(
              child: ExploreUserAvatar(profilePic: users[index]['profilePic']),
            ),
          ),
        );
      },
      itemCount: users.length,
    );
  }
}

class ExploreUserAvatar extends StatefulWidget {
  const ExploreUserAvatar({
    Key? key,
    required this.profilePic,
  }) : super(key: key);

  final String profilePic;

  @override
  State<ExploreUserAvatar> createState() => _ExploreUserAvatarState();
}

class _ExploreUserAvatarState extends State<ExploreUserAvatar> {
  // String _image = "";
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;

  @override
  void initState() {
    super.initState();
    memoizer = AsyncMemoizer();
    storedFuture = loadImg(widget.profilePic, memoizer);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storedFuture,
        builder: (BuildContext context, AsyncSnapshot text) {
          if ((text.connectionState == ConnectionState.waiting) ||
              text.hasError) {
            return const Image(
              height: 50.0,
              width: 50.0,
              image: AssetImage('assets/images/broken.png'),
              fit: BoxFit.cover,
            );
          } else {
            if (!text.hasData) {
              return GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: const SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Center(
                        child: Icon(
                          Icons.refresh,
                          // size: 50.0,
                          color: kDark,
                        ),
                      )));
            }
            return Image(
              height: 50.0,
              width: 50.0,
              image: NetworkImage(text.data.toString()),
              fit: BoxFit.cover,
            );
          }
        });
  }
}
