// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Uploader extends StatefulWidget {
  final File? file;
  const Uploader({this.file});

  @override
  _UploaderState createState() => _UploaderState();
}

// class _UploaderState extends State<Uploader> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

class _UploaderState extends State<Uploader> {
  // Starts an upload task

  double progress = 0.0;
  Future<void> _startUpload() async {
    var dio = Dio();
    var storage = FlutterSecureStorage();
    var formData = FormData();
    print(widget.file!.path);
    formData = FormData.fromMap({
      "media":
          await MultipartFile.fromFile(widget.file!.path),
    });
    var token = await storage.read(key: "token");
    print(formData.files[0]);
    Response response = await dio.post(
      // 'https://api-tassie.herokuapp.com/drive/upload',
      'http://10.0.2.2:3000/drive/upload',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "multipart/form-data",
        // HttpHeaders.authorizationHeader: "Bearer " + token!
      }),
      data: formData,
      onSendProgress: (int sent, int total) {
        setState(() {
          progress = (sent / total * 100);
        });
      },
    );
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    if (progress != 0.0) {
      /// Manage the task state and event subscription with a StreamBuilder

      return Column(
        children: [
          // if (_uploadTask.isComplete) Text('🎉🎉🎉'),

          // if (_uploadTask.isPaused)
          //   TextButton(
          //     child: Icon(Icons.play_arrow),
          //     onPressed: _uploadTask.resume,
          //   ),

          // if (_uploadTask.isInProgress)
          //   TextButton(
          //     child: Icon(Icons.pause),
          //     onPressed: _uploadTask.pause,
          //   ),

          // Progress bar
          LinearProgressIndicator(value: progress),
          Text('${(progress).toStringAsFixed(2)} % '),
        ],
      );
    } else {
      // Allows user to decide when to start the upload
      return TextButton(
        child: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}
