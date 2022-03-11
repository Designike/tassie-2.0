import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/imgLoader.dart';

class ExploreSearchRecipeTab extends StatefulWidget {
  const ExploreSearchRecipeTab(
      {required this.recipes,
      required this.isEndR,
      required this.isLazyLoadingR});
  final List recipes;
  final bool isEndR;
  final bool isLazyLoadingR;

  @override
  _ExploreSearchRecipeTabState createState() => _ExploreSearchRecipeTabState();
}

class _ExploreSearchRecipeTabState extends State<ExploreSearchRecipeTab> {
  // AsyncMemoizer memoizer = AsyncMemoizer();
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: widget.isLazyLoadingR ? 0.8 : 00,
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
    List recipes = widget.recipes;
    print(recipes);
    return ListView.builder(
      itemBuilder: (context, index) {
        return index == recipes.length
            ? widget.isEndR
                ? _endMessage()
                : _buildProgressIndicator()
            : ListTile(
                title: Text(recipes[index]['name']),
                subtitle: Text(
                  recipes[index]['username'],
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? kLight
                          : kDark[900]),
                ),
                leading: CircleAvatar(
                  child: ClipOval(
                    child: exploreRecipeAvatar(
                        recipeImageID: recipes[index]['recipeImageID']),
                  ),
                ),
              );
      },
      itemCount: recipes.length,
    );
  }
}

class exploreRecipeAvatar extends StatefulWidget {
  const exploreRecipeAvatar({
    Key? key,
    required this.recipeImageID,
  }) : super(key: key);
  final String recipeImageID;
  @override
  State<exploreRecipeAvatar> createState() => _exploreRecipeAvatarState();
}

class _exploreRecipeAvatarState extends State<exploreRecipeAvatar> {
  AsyncMemoizer memoizer = AsyncMemoizer();
  // String _image = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoizer = AsyncMemoizer();
    // loadImg(widget.recipeImageID,memoizer).then((result) {
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
    //   fit: BoxFit.cover,
    //   image: _image == ""
    //       ? Image.asset('assets/images/broken.png', fit: BoxFit.cover).image
    //       : Image.network(_image, fit: BoxFit.cover).image,
    // );
    return FutureBuilder(
        future: loadImg(widget.recipeImageID, memoizer),
        builder: (BuildContext context, AsyncSnapshot text) {
          if (text.connectionState == ConnectionState.waiting) {
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
