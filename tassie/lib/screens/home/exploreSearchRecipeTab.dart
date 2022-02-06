import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

class ExploreSearchRecipeTab extends StatefulWidget {
  const ExploreSearchRecipeTab({required this.recipes});
  final List recipes;

  @override
  _ExploreSearchRecipeTabState createState() => _ExploreSearchRecipeTabState();
}

class _ExploreSearchRecipeTabState extends State<ExploreSearchRecipeTab> {
  @override
  Widget build(BuildContext context) {
    List recipes = widget.recipes;
    print(recipes);
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(recipes[index]['name']),
          subtitle: Text(
            recipes[index]['name'],
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
      itemCount: recipes.length,
    );
  }
}
