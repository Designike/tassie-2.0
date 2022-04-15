import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:dio/dio.dart';

final dio = Dio();
// AsyncMemoizer _memoizer = AsyncMemoizer();
Future loadImg(key, AsyncMemoizer memoizer) async {
  // if (memoizer != "comment") {
  return memoizer.runOnce(() async {
    Response response = await dio.post(
        // "https://api-tassie.herokuapp.com/user/",
        "https://api-tassie.herokuapp.com/drive/file",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: {"key": key});
    // print(response.data['error']);
    return response.data['data']['url'];
  });
  // } else {
  //   Response response = await dio.post(
  //       // "https://api-tassie.herokuapp.com/user/",
  //       "https://api-tassie.herokuapp.com/drive/file",
  //       options: Options(headers: {
  //         HttpHeaders.contentTypeHeader: "application/json",
  //       }),
  //       data: {"key": key});
  //   // print(response.data['error']);
  //   return response.data['data']['url'];
  // }
}
