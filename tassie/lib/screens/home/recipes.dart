// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tassie/screens/home/recPost.dart';

import '../../constants.dart';

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  // recs to be fetched from api
  // List recs = [];
  List<Map> recs = [
    {"name": "Paneer Tikka", "user": "Sommy21", "url": "https://picsum.photos/200", "profilePic": "https://picsum.photos/200"},
    {"name": "Dhokla", "user": "parthnamdev", "url": "https://picsum.photos/200", "profilePic": "https://picsum.photos/200"},
    {"name": "Khamman", "user": "rishabh", "url": "https://picsum.photos/200", "profilePic": "https://picsum.photos/200"}
  ];
  final ScrollController _sc = ScrollController();
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
          'Yumminess ahead !',
          style: TextStyle(
            color: kPrimaryColor,
            fontFamily: 'StyleScript',
            fontSize: 30.0,
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
      if (recs.length > 0) ...[
      
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (size.width/2)/((size.width/2) + (size.width/10) + 100.0),
                ), 
                itemBuilder: (context, index) {
                  return RecPost(index: index, recs: recs);
                  // return Container(
                  //   color: Colors.red,
                  // );
                }, itemCount: recs.length,),
          ),
          ] else ...[
            Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.25,
                        ),
                        Image(
                          image: MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? AssetImage('assets/images/no_feed_dark.png')
                              : AssetImage('assets/images/no_feed_light.png'),
                          width: size.width * 0.75,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: size.width * 0.75,
                          child: Text(
                            'Subscribe to see others\' recs.',
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
      ]
        ],
      ),

      
    );
  }
}
