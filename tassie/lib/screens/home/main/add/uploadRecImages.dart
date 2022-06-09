import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/utils/snackbar.dart';

import '../../../../constants.dart';

class RecImageUploader extends StatefulWidget {
  const RecImageUploader(
      {required this.uuid,
      required this.file,
      required this.keyValue,
      required this.keyName,
      required this.imgName,
      // required this.folder,
      required this.clearRecost,
      required this.trueResp,
      required this.falseResp,
      required this.imageNull,
      required this.onClear,
      required this.onCrop,
      Key? key})
      : super(key: key);
  final File? file;
  final String uuid;
  final String keyValue;
  final String keyName;
  final String imgName;
  // final String folder;
  final bool clearRecost;
  final void Function() trueResp;
  final void Function() falseResp;
  final void Function() imageNull;
  final void Function() onClear;
  final void Function() onCrop;
  @override
  RecImageUploaderState createState() => RecImageUploaderState();
}

class RecImageUploaderState extends State<RecImageUploader> {
  double progress = 0.0;
  bool isUploaded = false;
  Future<void> _startUpload(
      File? file, String keyValue, String keyName, String imgName
      // , String folder
      ) async {
    var dio = Dio();
    var storage = const FlutterSecureStorage();
    var formData = FormData();
    formData = FormData.fromMap({
      "media": await MultipartFile.fromFile(file!.path),
      keyName: keyValue,
      "imgName": imgName,
      // "folder": folder,
      "uuid": widget.uuid
    });
    widget.imageNull();
    // _imageFile = null;
    var token = await storage.read(key: "token");
    Response response = await dio.post(
      // 'https://api-tassie.herokuapp.com/drive/upload',
      'https://api-tassie.herokuapp.com/recs/updateRecipe/',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "multipart/form-data",
        HttpHeaders.authorizationHeader: "Bearer ${token!}"
      }),
      data: formData,
      onSendProgress: (int sent, int total) {
        if (mounted) {
          setState(() {
            // print(progress);
            progress = (sent / total * 100);
            // print(progress);
          });
        }
      },
    );

    if (response.data['status'] == false) {
      widget.falseResp();
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      showSnack(context, response.data['message'], () {}, 'OK', 5);
    }
    if (response.data['status'] == true) {
      widget.trueResp();
      if (mounted) {
        setState(() {
          isUploaded = true;
        });
      }
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      showSnack(context, response.data['message'], () {}, 'OK', 3);
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
    if ((progress != 0.0 && isUploaded == true) || widget.clearRecost) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: const Icon(Icons.refresh),
            onPressed: () => widget.onClear(),
          ),
        ],
      );
    } else if (progress != 0.0 && isUploaded == false) {
      return const Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Center(
          child: Opacity(
            opacity: 1,
            child: CircularProgressIndicator(
              color: kPrimaryColor,
              strokeWidth: 2.0,
            ),
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: const Icon(Icons.crop),
            onPressed: () => widget.onCrop(),
          ),
          TextButton(
            child: const Icon(Icons.refresh),
            onPressed: () => widget.onClear(),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: kDark[900],
            ),
            child: IconButton(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
              icon: const Icon(Icons.cloud_upload),
              iconSize: 30.0,
              color: Theme.of(context).brightness == Brightness.dark
                  ? kPrimaryColor
                  : kPrimaryColorAccent,
              onPressed: () {
                _startUpload(widget.file, widget.keyValue, widget.keyName,
                    widget.imgName);
              },
            ),
          ),
        ],
      );
    }
  }
}
