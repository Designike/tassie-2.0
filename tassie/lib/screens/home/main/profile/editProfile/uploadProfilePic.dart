// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/homeMapPageContoller.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';
import 'package:tassie/utils/snackbar.dart';

class ProfileUploader extends StatefulWidget {
  final File? file;
  // final String desc;
  // final bool edit;
  // final String? postUuid;
  // final GlobalKey<FormState> formKey;
  const ProfileUploader({
    this.file,
    // required this.desc,
    // required this.formKey,
    // required this.edit,
    // this.postUuid,
  });

  @override
  _ProfileUploaderState createState() => _ProfileUploaderState();
}

// class _UploaderState extends State<Uploader> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

class _ProfileUploaderState extends State<ProfileUploader> {
  // Starts an upload task

  double progress = 0.0;
  Future<void> _startUpload() async {
    var dio = Dio();
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    // if (widget.edit) {
    //   // edit post - start
    //   Response response = await dio.post(
    //     // 'https://api-tassie.herokuapp.com/drive/upload',
    //     'https://api-tassie.herokuapp.com/feed/editpost',
    //     options: Options(headers: {
    //       HttpHeaders.contentTypeHeader: "application/json",
    //       HttpHeaders.authorizationHeader: "Bearer " + token!
    //     }),
    //     data: {
    //       "desc": widget.desc,
    //       "postUuid": widget.postUuid,
    //     },
    //     onSendProgress: (int sent, int total) {
    //       setState(() {
    //         print(progress);
    //         progress = (sent / total * 100);
    //         print(progress);
    //       });
    //     },
    //   );
    //   if (response.data['status'] == true) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) {
    //         return Profile(
    //           uuid: 'user',
    //         );
    //       }),
    //     );
    //   } else {
    //     // handle error
    //     print(response.data['message']);
    //     print(response.data['error']);
    //   }

    //   // edit post - end
    // } else {
    // new post - start
    var formData = FormData();
    print(widget.file!.path);
    formData = FormData.fromMap({
      "media": await MultipartFile.fromFile(widget.file!.path),
      // "desc": widget.desc,
    });

    print(formData.files[0]);
    Response response = await dio.post(
      // 'https://api-tassie.herokuapp.com/drive/upload',
      'https://api-tassie.herokuapp.com/user/updateProfileImage',
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
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) {
      //     return Home();
      //   }),
      // );
      Navigator.of(context).pop();
      await storage.write(
          key: "profilePic", value: response.data['data']['profilePic']);
      setState(() {});
    } else {
      // handle error
      Navigator.of(context).pop();
      showSnack(context, response.data['message'], () {}, 'OK', 4);
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
                      RotateAnimatedText('Start flexing 😎'),
                      RotateAnimatedText('Bronzing'),
                      RotateAnimatedText('Settling Spray'),
                      RotateAnimatedText('Don\'t Blush 😆'),
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
            color: Theme.of(context).brightness == Brightness.dark
                ? kPrimaryColor
                : kPrimaryColorAccent,
            onPressed: () => _startUpload(),
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
