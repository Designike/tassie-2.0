import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  /// Starts an upload task
  late Response response;
  static double progress = 0.0;
  Future<void> _startUpload() async {
    var dio = Dio();
    var formData = FormData();
    formData.files.add(MapEntry(
      "Picture",
      await MultipartFile.fromFile(widget.file!.path, filename: "pic-name.png"),
    ));
    response = await dio.put(
      'https://api-tassie.herokuapp.com/drive/upload',
      data: formData,
      onSendProgress: (int sent, int total) {
        setState(() {
          progress = (sent / total * 100);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (response != null) {
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
