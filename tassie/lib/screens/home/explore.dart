import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  var dio = Dio();
  var storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(onPressed: () async {
        var token = await storage.read(key: "token");
        // print(formData.files[0]);
        Response response = await dio.post(
            // 'https://api-tassie.herokuapp.com/drive/upload',
            'http://10.0.2.2:3000/search/guess/',
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: "Bearer " + token!
            }),
            data: {
              'start': 0,
              'veg': true,
              'flavour': 'spicy',
              'course': 'desert',
              'estTime': 30,
              'ingredients': ['methi', 'chana']
            });
        print(response);
      }),
    );
  }
}
