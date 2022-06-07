import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/home.dart';
import 'package:tassie/screens/home/profile.dart';
import 'package:tassie/screens/imgLoader.dart';

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
      shrinkWrap: true,
      padding: EdgeInsets.all(0.0),
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
    // TODO: implement initState
    super.initState();
    memoizer = AsyncMemoizer();
    storedFuture = loadImg(widget.profilePic, memoizer);
    // loadImg(widget.profilePic).then((result) {
    //   setState(() {
    //     _image = result;
    //     // isImage = true;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    // return Image(
    //   height: 50.0,
    //   width: 50.0,
    //   // image: _image == ""
    //   //     ? Image.asset('assets/images/broken.png', fit: BoxFit.cover).image
    //   //     : Image.network(_image, fit: BoxFit.cover).image,
    //   image: NetworkImage(widget.profilePic),
    //   fit: BoxFit.cover,
    // );
    return FutureBuilder(
        future: storedFuture,
        builder: (BuildContext context, AsyncSnapshot text) {
          if ((text.connectionState == ConnectionState.waiting) ||
              text.hasError) {
            return Image(
              height: 50.0,
              width: 50.0,
              image: AssetImage('assets/images/broken.png'),
              fit: BoxFit.cover,
            );
          } else {
            // return Image(
            //   image: NetworkImage(text.data.toString()),
            //   fit: BoxFit.cover,
            // );
            if (!text.hasData) {
              return GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
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
