import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:async/async.dart';
import 'package:dio/dio.dart';



// AsyncMemoizer _memoizer = AsyncMemoizer();
Future loadImg(key, AsyncMemoizer memoizer) async {
  // if (memoizer != "comment") {
  final dio = Dio();
  return memoizer.runOnce(() async {
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print, // specify log function (optional)
      retries: 5, // retry count (optional)
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
        Duration(seconds: 5), // wait 3 sec before third retry
        Duration(seconds: 8), // wait 3 sec before third retry
      ],
    ));
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
