import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/screens/home/snackbar.dart';

import '../../constants.dart';

class RecImageUploader extends StatefulWidget {
  const RecImageUploader(
      {required this.uuid,
      required this.file,
      required this.keyValue,
      required this.keyName,
      required this.imgName,
      required this.folder,
      required this.trueResp,
      required this.falseResp,
      required this.imageNull,
      required this.onClear,
      required this.onCrop});
  final File? file;
  final String uuid;
  final String keyValue;
  final String keyName;
  final String imgName;
  final String folder;
  final void Function() trueResp;
  final void Function() falseResp;
  final void Function() imageNull;
  final void Function() onClear;
  final void Function() onCrop;
  @override
  _RecImageUploaderState createState() => _RecImageUploaderState();
}

class _RecImageUploaderState extends State<RecImageUploader> {
  double progress = 0.0;
  bool isUploaded = false;
  Future<void> _startUpload(File? file, String keyValue, String keyName,
      String imgName, String folder) async {
    var dio = Dio();
    var storage = FlutterSecureStorage();
    var formData = FormData();
    print(file!.path);
    formData = FormData.fromMap({
      "media": await MultipartFile.fromFile(file.path),
      keyName: keyValue,
      "imgName": imgName,
      "folder": folder,
      "uuid": widget.uuid
    });
    widget.imageNull();
    // _imageFile = null;
    var token = await storage.read(key: "token");
    print(formData.files[0]);
    Response response = await dio.post(
      // 'https://api-tassie.herokuapp.com/drive/upload',
      'http://10.0.2.2:3000/recs/updateRecipe/',
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

    if (response.data['status'] == false) {
      widget.trueResp();
      showSnack(context, response.data['message'], () {}, 'OK', 5);
      // _imageFile = null;
      // if (imgName == 'r_1') {
      //   setState(() {
      //     isUpload = false;
      //   });
      // }
      // showSnack(context, response.data['message'], () {}, 'OK', 5);
    }
    if (response.data['status'] == true) {
      widget.falseResp();
      setState(() {
        isUploaded = true;
      });

      // if (imgName == 'r_1') {
      //   setState(() {
      //     isUpload = true;
      //   });
      // }
      showSnack(context, response.data['message'], () {}, 'OK', 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (progress != 0.0 && isUploaded == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: Icon(Icons.refresh),
            onPressed: () => widget.onClear(),
          ),
        ],
      );
    } else if (progress != 0.0 && isUploaded == false) {
      /// Manage the task state and event subscription with a StreamBuilder

      // return Column(
      //   children: [
      //     // if (_uploadTask.isComplete) Text('🎉🎉🎉'),

      //     // if (_uploadTask.isPaused)
      //     //   TextButton(
      //     //     child: Icon(Icons.play_arrow),
      //     //     onPressed: _uploadTask.resume,
      //     //   ),

      //     // if (_uploadTask.isInProgress)
      //     //   TextButton(
      //     //     child: Icon(Icons.pause),
      //     //     onPressed: _uploadTask.pause,
      //     //   ),

      //     // Progress bar
      //     Padding(
      //       padding:
      //           const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
      //       child: LinearProgressIndicator(value: progress),
      //     ),
      //     Text('${(progress).toStringAsFixed(2)} % '),
      //     Padding(
      //       padding:
      //           const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
      //       child: AnimatedTextKit(
      //         pause: Duration(milliseconds: 100),
      //         animatedTexts: [
      //           RotateAnimatedText('Blending your stuff'),
      //           RotateAnimatedText('Some Sautéing'),
      //           RotateAnimatedText('Let\'s Stir'),
      //           RotateAnimatedText('Baking up'),
      //         ],
      //       ),
      //     ),
      //   ],
      // );
      return Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
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
      // Allows user to decide when to start the upload
      // return IconButton(
      //   icon: Icon(Icons.cloud_upload),
      //   color: kPrimaryColor,
      //   onPressed: _startUpload,
      // );
      // return Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
      //   child: Container(
      //     child: IconButton(
      //       padding: EdgeInsets.symmetric(vertical: 10.0),
      //       icon: Icon(Icons.cloud_upload),
      //       iconSize: 30.0,
      //       color: MediaQuery.of(context).platformBrightness == Brightness.dark
      //           ? kPrimaryColor
      //           : kPrimaryColorAccent,
      //       onPressed: () => {
      //         _startUpload(widget.file, widget.keyValue, widget.keyName,
      //             widget.imgName, widget.folder)
      //       },
      //     ),
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(15.0),
      //       color: kDark[900],
      //     ),
      //   ),
      // );
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: Icon(Icons.crop),
            onPressed: () => widget.onCrop(),
          ),
          TextButton(
            child: Icon(Icons.refresh),
            onPressed: () => widget.onClear(),
          ),
          Container(
            child: IconButton(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
              icon: Icon(Icons.cloud_upload),
              iconSize: 30.0,
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? kPrimaryColor
                      : kPrimaryColorAccent,
              onPressed: () {
                // print('1');

                //   if(key=='r'){
                //     recipePic = _imageFile;
                //     _imageFile = null;
                //     _startUpload( recipePic,recipeName,'name',key+'_'+(index+1).toString(), widget.folder);
                //     print('2');
                //   }else if(key=='i'){
                //     ingredientPics[(index).toString()]=_imageFile;
                //     _imageFile = null;
                //     _startUpload( ingredientPics[(index).toString()],recipeName,'name',key+'_'+(index+1).toString(), widget.folder);
                //     print('3');
                //   }else{
                //     stepPics[(index).toString()]=_imageFile;
                //     _imageFile = null;
                //     _startUpload( stepPics[(index).toString()],recipeName,'name',key+'_'+(index+1).toString(), widget.folder);
                //     print('4');
                //   }
                //   print('5');

                // if (recipeName!='') {

                // // print(isClicked);
                _startUpload(widget.file, widget.keyValue, widget.keyName,
                    widget.imgName, widget.folder);

                // RecImageUploader(file: image, keyValue: recipeName,keyName: 'name', imgName: key+'_'+(index+1).toString(),folder: widget.folder, uuid: widget.uuid,trueResp: () {
                //   _imageFile = null;
                //   if (key+'_'+(index+1).toString() == 'r_1') {
                //     setState(() {
                //       isUpload = false;
                //     });
                //   }
                // }, falseResp: () {
                //   if (key+'_'+(index+1).toString() == 'r_1') {
                //     setState(() {
                //       isUpload = true;
                //     });
                //   }
                // },);

                // } else {
                //   showSnack(context, 'Enter recipe name', () {}, 'OK', 3);
                // }
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: kDark[900],
            ),
          ),
        ],
      );
    }
  }
}

// ignore_for_file: prefer_const_constructors

// import 'dart:io';

// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:tassie/constants.dart';
// import 'package:tassie/screens/home/home.dart';

// class Uploader extends StatefulWidget {
//   final File? file;
//   final String desc;
//   final GlobalKey<FormState> formKey;
//   const Uploader({this.file, required this.desc, required this.formKey});

//   @override
//   _UploaderState createState() => _UploaderState();
// }

// class _UploaderState extends State<Uploader> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

// class _UploaderState extends State<Uploader> {
//   // Starts an upload task

//   double progress = 0.0;
//   Future<void> _startUpload() async {
//     var dio = Dio();
//     var storage = FlutterSecureStorage();
//     var formData = FormData();
//     print(widget.file!.path);
//     formData = FormData.fromMap({
//       "media": await MultipartFile.fromFile(widget.file!.path),
//       "desc": widget.desc
//     });
//     var token = await storage.read(key: "token");
//     print(formData.files[0]);
//     Response response = await dio.post(
//       // 'https://api-tassie.herokuapp.com/drive/upload',
//       'http://10.0.2.2:3000/feed/newpost',
//       options: Options(headers: {
//         HttpHeaders.contentTypeHeader: "multipart/form-data",
//         HttpHeaders.authorizationHeader: "Bearer " + token!
//       }),
//       data: formData,
//       onSendProgress: (int sent, int total) {
//         setState(() {
//           print(progress);
//           progress = (sent / total * 100);
//           print(progress);
//         });
//       },
//     );
//     if (response.data['status'] == true) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) {
//           return Home();
//         }),
//       );
//     } else {
//       // handle error

//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     if (progress != 0.0) {
//       /// Manage the task state and event subscription with a StreamBuilder

//       return Column(
//         children: [
//           // if (_uploadTask.isComplete) Text('🎉🎉🎉'),

//           // if (_uploadTask.isPaused)
//           //   TextButton(
//           //     child: Icon(Icons.play_arrow),
//           //     onPressed: _uploadTask.resume,
//           //   ),

//           // if (_uploadTask.isInProgress)
//           //   TextButton(
//           //     child: Icon(Icons.pause),
//           //     onPressed: _uploadTask.pause,
//           //   ),

//           // Progress bar
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
//             child: LinearProgressIndicator(value: progress),
//           ),
//           Text('${(progress).toStringAsFixed(2)} % '),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
//             child: AnimatedTextKit(
//               pause: Duration(milliseconds: 100),
//               animatedTexts: [
//                 RotateAnimatedText('Blending your stuff'),
//                 RotateAnimatedText('Some Sautéing'),
//                 RotateAnimatedText('Let\'s Stir'),
//                 RotateAnimatedText('Baking up'),
//               ],
//             ),
//           ),
//         ],
//       );
//     } else {
//       // Allows user to decide when to start the upload
//       // return IconButton(
//       //   icon: Icon(Icons.cloud_upload),
//       //   color: kPrimaryColor,
//       //   onPressed: _startUpload,
//       // );
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
//         child: Container(
//           child: IconButton(
//             padding: EdgeInsets.symmetric(vertical: 10.0),
//             icon: Icon(Icons.cloud_upload),
//             iconSize: 30.0,
//             color: MediaQuery.of(context).platformBrightness == Brightness.dark
//                 ? kPrimaryColor
//                 : kPrimaryColorAccent,
//             onPressed: () => {
//               if (widget.formKey.currentState!.validate()) {_startUpload()}
//             },
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15.0),
//             color: kDark[900],
//           ),
//         ),
//       );
//     }
//   }
// }
