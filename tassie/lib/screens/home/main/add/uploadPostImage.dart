import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/homeMapPageContoller.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';

import '../../../../utils/snackbar.dart';

class Uploader extends StatefulWidget {
  final File? file;
  final String desc;
  final bool edit;
  final String? postUuid;
  final GlobalKey<FormState> formKey;
  const Uploader({
    this.file,
    required this.desc,
    required this.formKey,
    required this.edit,
    this.postUuid,
    Key? key,
  }) : super(key: key);

  @override
  UploaderState createState() => UploaderState();
}

// class _UploaderState extends State<Uploader> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

class UploaderState extends State<Uploader> {
  // Starts an upload task

  double progress = 0.0;
  Future<void> _startUpload() async {
    var dio = Dio();
    var storage = const FlutterSecureStorage();
    var token = await storage.read(key: "token");
    if (widget.edit) {
      // edit post - start
      Response response = await dio.post(
        // 'https://api-tassie.herokuapp.com/drive/upload',
        'https://api-tassie.herokuapp.com/feed/editpost',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${token!}"
        }),
        data: {
          "desc": widget.desc,
          "postUuid": widget.postUuid,
        },
        onSendProgress: (int sent, int total) {
          if (mounted) {
            setState(() {
              progress = (sent / total * 100);
            });
          }
        },
      );
      if (response.data['status'] == true) {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return const Profile(
              uuid: 'user',
            );
          }),
        );
      } else {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        showSnack(context, 'Server error', () {}, 'OK', 4);
      }

      // edit post - end
    } else {
      // new post - start
      var formData = FormData();
      formData = FormData.fromMap({
        "media": await MultipartFile.fromFile(widget.file!.path),
        "desc": widget.desc,
      });

      Response response = await dio.post(
        // 'https://api-tassie.herokuapp.com/drive/upload',
        'https://api-tassie.herokuapp.com/feed/newpost',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "multipart/form-data",
          HttpHeaders.authorizationHeader: "Bearer ${token!}"
        }),
        data: formData,
        onSendProgress: (int sent, int total) {
          if (mounted) {
            setState(() {
              progress = (sent / total * 100);
            });
          }
        },
      );
      if (response.data['status'] == true) {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return const Home();
          }),
        );
      } else {
        // handle error
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        showSnack(context, 'Server error', () {}, 'OK', 4);
      }

      // new post - end
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                const CircularProgressIndicator(strokeWidth: 2.0),
                Expanded(
                  child: AnimatedTextKit(
                    pause: const Duration(milliseconds: 100),
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: kDark[900],
          ),
          child: IconButton(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            icon: const Icon(Icons.cloud_upload),
            iconSize: 30.0,
            color: Theme.of(context).brightness == Brightness.dark
                ? kPrimaryColor
                : kPrimaryColorAccent,
            onPressed: () => {
              if (widget.formKey.currentState!.validate()) {_startUpload()}
            },
          ),
        ),
      );
    }
  }
}
