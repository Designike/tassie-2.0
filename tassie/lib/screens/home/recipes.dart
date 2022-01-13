import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light),
        title: Text(
          'yumminess\nahead!',
          style: TextStyle(
            color: kPrimaryColor,
            fontFamily: 'StyleScript',
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 10,
            thickness: 0.5,
          ),
          // Expanded(
          //   child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: kDefaultPadding, crossAxisSpacing: kDefaultPadding,), 
          //       itemBuilder: (context, index) {
          //         return RecPost(index: index);
          //       }),
          // ),
        ],
      ),
    );
  }
}
