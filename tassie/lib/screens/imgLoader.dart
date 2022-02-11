import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

final dio = Dio();
Future loadImg(key) async {
  Response response = await dio.post(
      // "http://10.0.2.2:3000/user/",
      "http://10.0.2.2:3000/drive/file",
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: {"key": key});
  // print(response);
  return response.data['data']['url'];
}
