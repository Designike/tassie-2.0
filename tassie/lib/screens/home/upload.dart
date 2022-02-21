// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/home.dart';

class Uploader extends StatefulWidget {
  final File? file;
  final String desc;
  final GlobalKey<FormState> formKey;
  const Uploader({this.file, required this.desc, required this.formKey});

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
      "media": await MultipartFile.fromFile(widget.file!.path),
      "desc": widget.desc
    });
    var token = await storage.read(key: "token");
    print(formData.files[0]);
    Response response = await dio.post(
      // 'http://10.0.2.2:3000/drive/upload',
      'http://10.0.2.2:3000/feed/newpost',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "multipart/form-data",
        HttpHeaders.authorizationHeader: "Bearer " + token!
      }),
      data: formData,
      onSendProgress: (int sent, int total) {
        setState(() {
          print(progress);
          progress = (sent / total * 100);
          print(progress);
        });
      },
    );
    if (response.data['status'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return Home();
        }),
      );
    } else {
      // handle error
      print(response.data['message']);
      print(response.data['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
          //   child: LinearProgressIndicator(value: progress),
          // ),
          // Text('${(progress).toStringAsFixed(2)} % '),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
            child: Row(
              children: [
                CircularProgressIndicator(strokeWidth: 2.0),
                Expanded(
                  child: AnimatedTextKit(
                    pause: Duration(milliseconds: 100),
                    isRepeatingAnimation: true,
                    totalRepeatCount: 10,
                    animatedTexts: [
                      RotateAnimatedText('Blending your stuff'),
                      RotateAnimatedText('Some Sautéing'),
                      RotateAnimatedText('Let\'s Stir'),
                      RotateAnimatedText('Baking up'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Allows user to decide when to start the upload
      // return IconButton(
      //   icon: Icon(Icons.cloud_upload),
      //   color: kPrimaryColor,
      //   onPressed: _startUpload,
      // );
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
        child: Container(
          child: IconButton(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            icon: Icon(Icons.cloud_upload),
            iconSize: 30.0,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? kPrimaryColor
                : kPrimaryColorAccent,
            onPressed: () => {
              if (widget.formKey.currentState!.validate()) {_startUpload()}
            },
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: kDark[900],
          ),
        ),
      );
    }
  }
}
