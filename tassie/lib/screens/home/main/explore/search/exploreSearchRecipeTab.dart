import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/utils/imgLoader.dart';

class ExploreSearchRecipeTab extends StatefulWidget {
  const ExploreSearchRecipeTab(
      {required this.recipes,
      required this.isEndR,
      required this.isLazyLoadingR,
      Key? key})
      : super(key: key);
  final List recipes;
  final bool isEndR;
  final bool isLazyLoadingR;

  @override
  ExploreSearchRecipeTabState createState() => ExploreSearchRecipeTabState();
}

class ExploreSearchRecipeTabState extends State<ExploreSearchRecipeTab> {
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: widget.isLazyLoadingR ? 0.8 : 00,
          child: const CircularProgressIndicator(
            color: kPrimaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _endMessage() {
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
    List recipes = widget.recipes;
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
                    child: ExploreRecipeAvatar(
                        recipeImageID: recipes[index]['recipeImageID']),
                  ),
                ),
              );
      },
      itemCount: recipes.length,
    );
  }
}

class ExploreRecipeAvatar extends StatefulWidget {
  const ExploreRecipeAvatar({
    Key? key,
    required this.recipeImageID,
  }) : super(key: key);
  final String recipeImageID;
  @override
  State<ExploreRecipeAvatar> createState() => _ExploreRecipeAvatarState();
}

class _ExploreRecipeAvatarState extends State<ExploreRecipeAvatar> {
  AsyncMemoizer memoizer = AsyncMemoizer();
  late Future storedFuture;
  // String _image = "";
  @override
  void initState() {
    super.initState();
    memoizer = AsyncMemoizer();
    storedFuture = loadImg(widget.recipeImageID, memoizer);
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
            return const Image(
              height: 50.0,
              width: 50.0,
              image: AssetImage('assets/images/broken.png'),
              fit: BoxFit.cover,
            );
          } else {
            if (!text.hasData) {
              return const SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: Center(
                    child: Icon(
                      Icons.refresh,
                      // size: 50.0,
                      color: kDark,
                    ),
                  ));
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
