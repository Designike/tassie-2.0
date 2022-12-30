import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/utils/snackbar.dart';

class ProfileUploader extends StatefulWidget {
  final File? file;
  // final String desc;
  // final bool edit;
  // final String? postUuid;
  // final GlobalKey<FormState> formKey;
  const ProfileUploader({this.file, Key? key
      // required this.desc,
      // required this.formKey,
      // required this.edit,
      // this.postUuid,
      })
      : super(key: key);

  @override
  ProfileUploaderState createState() => ProfileUploaderState();
}

class ProfileUploaderState extends State<ProfileUploader> {
  double progress = 0.0;
  Future<void> _startUpload() async {
    var dio = Dio();
    var storage = const FlutterSecureStorage();
    var token = await storage.read(key: "token");

    var formData = FormData();
    formData = FormData.fromMap({
      "media": await MultipartFile.fromFile(widget.file!.path),
    });

    Response response = await dio.post(
      // '$baseAPI/drive/upload',
      '$baseAPI/user/updateProfileImage',
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
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) {
      //     return Home();
      //   }),
      // );
      // await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.of(context).pop();
      await storage.write(
          key: "profilePic", value: response.data['data']['profilePic']);
      if (mounted) {
        setState(() {});
      }
    } else {
      // handle error
      // await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.of(context).pop();
      showSnack(context, response.data['message'], () {}, 'OK', 4);
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
      return Column(
        children: [
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
            onPressed: () => _startUpload(),
          ),
        ),
      );
    }
  }
}
