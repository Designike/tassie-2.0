import 'dart:io';
import 'package:async/async.dart';
import 'package:dio/dio.dart';

// AsyncMemoizer _memoizer = AsyncMemoizer();
Future loadImg(key, AsyncMemoizer memoizer) async {
  // if (memoizer != "comment") {
  try {
    final dio = Dio();
    return memoizer.runOnce(() async {
      Response response = await dio.post(
          // "https://api-tassie.herokuapp.com/user/",
          "https://api-tassie.herokuapp.com/drive/file",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: {"key": key});
      return response.data['data']['url'];
    });
  } catch (e) {
    return null;
  }
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
