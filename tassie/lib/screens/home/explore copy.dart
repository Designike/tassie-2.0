import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:tassie/constants.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  var dio = Dio();
  var storage = FlutterSecureStorage();
  List recosts_toggle = ['1', '1', '1', '2', '2'];

  List recosts = ['one', 'two', 'three', 'four', 'five'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // return Container(
    // child: FloatingActionButton(onPressed: () async {
    //   var token = await storage.read(key: "token");
    //   // print(formData.files[0]);
    //   Response response = await dio.post(
    //       // 'http://10.0.2.2:3000/drive/upload',
    //       'http://10.0.2.2:3000/search/guess/',
    //       options: Options(headers: {
    //         HttpHeaders.contentTypeHeader: "application/json",
    //         HttpHeaders.authorizationHeader: "Bearer " + token!
    //       }),
    //       data: {
    //         'start': 0,
    //         'veg': true,
    //         'flavour': 'Spicy',
    //         'course': 'Main course',
    //         'maxTime': 30,
    //         'ingredients': ['sev', 'Maida', 'sugar']
    //       });
    //   print(response);
    // }),
    // );
    return Scaffold(
      appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              showSearch(context: context, delegate: SearchBar());
            },
            child: Container(
              // child: Row(
              //   children: [
              //     Text('Search ', style: TextStyle(color: kDark)),
              //     AnimatedTextKit(
              //       pause: Duration(milliseconds: 3000),
              //       repeatForever: false,
              //       animatedTexts: [
              //         FadeAnimatedText('recipes!',
              //             textStyle: TextStyle(color: kDark)),
              //         FadeAnimatedText('tassites!',
              //             textStyle: TextStyle(color: kDark)),
              //         FadeAnimatedText('posts!',
              //             textStyle: TextStyle(color: kDark)),
              //       ],
              //     ),
              //   ],
              // ),
              child: const Text('Search', style: TextStyle(color: kDark)),
              decoration: BoxDecoration(
                color: kDark[900],
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: size.width * 0.8,
              padding: EdgeInsets.all(15.0),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchBar());
              },
              icon: const Icon(Icons.search_rounded),
            ),
          ]),
      body: Stack(
        children: [
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            height: size.width + 50.0,
            child: Column(
              children: [
                Center(
                  child: Container(
                    // padding: EdgeInsets.all(5.0),
                    margin: EdgeInsets.only(top: 50.0, bottom: kDefaultPadding),
                    width: size.width * 0.5,
                    child: Lottie.asset('assets/images/cooker.json',
                        fit: BoxFit.cover),
                    decoration: BoxDecoration(
                        color: kDark[900],
                        borderRadius: BorderRadius.circular(size.width)),
                  ),
                ),
                Text('Tap to suggest recipe!',
                    style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
          
          Positioned(
            top: 500,
            left: 0,
            right: 0,
            // height: 200,
            child: Container(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: recosts.length,
                itemBuilder: (context, index) {
                  return recosts_toggle[index] == '1'
                      ? Container(
                          height: 100.0,
                          color: Colors.red,
                        )
                      : Container(height: 150.0, color: Colors.green);
                },
              ),
            ),
          ),
        ],
        // ),
      ),
    );
  }
}

class SearchBar extends SearchDelegate<String> {
  final suggestions = ['paneer', 'sandwich', 'pani puri'];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = suggestions;
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionsList[index]),
          subtitle: Text(suggestionsList[index]),
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
      itemCount: suggestionsList.length,
    );
  }
}
