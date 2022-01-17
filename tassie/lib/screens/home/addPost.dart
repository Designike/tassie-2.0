// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tassie/screens/home/upload.dart';

import '../../constants.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File? cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile!.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 80,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Garnish it,'
          toolbarColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarWidgetColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? kDark
                    : kDark[900],
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Garnish it,'
        )
        );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      XFile? selected = await ImagePicker().pickImage(source: source);
      if (selected == null) return;
      setState(() {
        _imageFile = File(selected.path);
        _cropImage();
      });
    }
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // Select an image from the camera or gallery
      // bottomNavigationBar: BottomAppBar(
      //   color: MediaQuery.of(context).platformBrightness == Brightness.dark
      //       ? kDark[900]
      //       : kLight,
      //   child: Container(
      //     height: 65.0,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         MaterialButton(
      //           onPressed: () => _pickImage(ImageSource.camera),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Icon(Icons.photo_camera_rounded, color: kDark),
      //               Text(
      //                 'Camera',
      //                 style: TextStyle(color: kLight),
      //               ),
      //             ],
      //           ),
      //         ),
      //         MaterialButton(
      //           onPressed: () => _pickImage(ImageSource.gallery),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Icon(Icons.photo_library_rounded, color: kDark),
      //               Text(
      //                 'Gallery',
      //                 style: TextStyle(color: kLight),
      //               ),
      //             ],
      //           ),
      //         ),
      //         // IconButton(
      //         //   icon: Icon(Icons.photo_camera),
      //         //   onPressed: () => _pickImage(ImageSource.camera),
      //         // ),
      //         // IconButton(
      //         //   icon: Icon(Icons.photo_library),
      //         //   onPressed: () => _pickImage(ImageSource.gallery),
      //         // ),
      //       ],
      //     ),
      //   ),
      // ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Text(
                'Some toppings ...',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'StyleScript',
                  fontSize: 40.0,
                ),
                textAlign: TextAlign.center,
                ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding * 1.5),
              child: Image.file(_imageFile!),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Icon(Icons.crop),
                    onPressed: _cropImage,
                  ),
                  TextButton(
                    child: Icon(Icons.refresh),
                    onPressed: _clear,
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(kDefaultPadding * 1.5),
            child: Form(child: Column(children: [
              TextFormField(
                // style: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.dark
                //     ? kLight
                //     : kDark[900]),
                      decoration: InputDecoration(
                          labelText: 'DESCRIPTION',
                          
                          labelStyle: TextStyle(
                            // fontFamily: 'Raleway',
                            fontSize: 16.0,
                            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? kPrimaryColor
                    : kDark[900],
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: kDefaultPadding),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? kPrimaryColor
                    : kDark[900]!),borderRadius: BorderRadius.circular(15.0),),
                              ),
                      keyboardType: TextInputType.multiline,
                      
                      maxLines: null,
                      onChanged: (value) {
                        // password = value;
                      },
                      validator: (val) => val!.isEmpty || val.length > 500
                          ? 'Description should be within 500 characters'
                          : null,
                    ),
                    
            ],)),
            ),
            Uploader(file: _imageFile)
          ] else ... [
            Container(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
              
                children: [
                  Text(
                'What\'s cooking ?',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'StyleScript',
                  fontSize: 40.0,
                ),
                
              ),
              SizedBox(height: 3 * kDefaultPadding,),
                  Container(
                    child: IconButton(
                      padding: EdgeInsets.all(size.width * 0.1),
                      icon: Icon(Icons.camera_alt_rounded),
                      iconSize: 50.0,
                    onPressed: () => _pickImage(ImageSource.camera),
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(size.width),
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? kDark[900]
                    : kLight,),
                  ),
                  SizedBox(height: kDefaultPadding,),
                  Container(
                    child: IconButton(
                      padding: EdgeInsets.all(size.width * 0.1),
                      icon: Icon(Icons.photo_library_rounded),
                      iconSize: 50.0,
                    onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(size.width),
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? kDark[900]
                    : kLight,),
                  ),
                  SizedBox(height: 2 * kDefaultPadding,),
                  Container(
                    width: size.width * 0.5,
                    child: Text(
                'Hey! pick some appetizing stuff !',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0,
                    height: 1.5
                    
                ),
              ),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}
