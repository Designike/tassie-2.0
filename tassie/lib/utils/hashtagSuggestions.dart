import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';

class Hashtags {
  static const storage = FlutterSecureStorage();

  // static final LocalStorage lstorage = LocalStorage('tassie');

  static String? ing = "";
  // static List<dynamic> ingred = [];
  static List<String> tags = [];

  static Future<void> getIng(String query) async {
    var temp = query.split("#");
    var tag = "";

    if (!temp.contains(" ") && temp.length > 1) {
      tag = temp[temp.length - 1];
      var dio = Dio();
      var token = await storage.read(key: "token");
      Response response = await dio.post(
        // '$baseAPI/drive/upload',
        '$baseAPI/recs/getHashtag',
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          },
        ),
        data: {
          "tag": "#$tag",
        },
      );

      tags = [];
      for (final i in response.data['data']) {
        tags.add(i['name']);
      }
      // tags.addAll(response.data['name']);
      // print(tags);
    } else {
      tags = [];
    }
  }

  // static final List<String> ingreds = [
  //   'paneer',
  //   'rice',
  //   'wheat',
  //   'salt',
  //   'sugar'
  // ];
  // static Future<void> getIng() async {
  //   ing = await storage.read(key: 'ingreds');
  //   print(json.decode(ing!));
  // }

  static List<String> getSuggestions(String query) {
    // print('thai che');
    // print(query);
    getIng(query);
    // print(tags);
    return query.isEmpty
        ? []
        // : List.of(ingreds).where((tag) {
        //     final tagLower = tag.toLowerCase();
        //     final queryLower = query.toLowerCase();

        //     return tagLower.startsWith(queryLower);
        //   }).toList();
        : tags;
  }
}
