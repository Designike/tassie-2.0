import 'dart:io';
import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

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
      var res = await http.get(Uri.parse(response.data['data']['url']));

      return res.statusCode == 200 ? response.data['data']['url'] : null;
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
