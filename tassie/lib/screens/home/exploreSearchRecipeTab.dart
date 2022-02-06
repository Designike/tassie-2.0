import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

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
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? kLight
                          : kDark[900]),
                ),
                leading: CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      height: 50.0,
                      width: 50.0,
                      image: NetworkImage(recipes[index]['url']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
      },
      itemCount: recipes.length,
    );
  }
}
