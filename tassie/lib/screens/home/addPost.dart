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
        compressQuality: 80);

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
      });
    }
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? kDark[900]
            : kLight,
        child: Container(
          height: 65.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera_rounded, color: kDark),
                    Text(
                      'Camera',
                      style: TextStyle(color: kLight),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_library_rounded, color: kDark),
                    Text(
                      'Gallery',
                      style: TextStyle(color: kLight),
                    ),
                  ],
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.photo_camera),
              //   onPressed: () => _pickImage(ImageSource.camera),
              // ),
              // IconButton(
              //   icon: Icon(Icons.photo_library),
              //   onPressed: () => _pickImage(ImageSource.gallery),
              // ),
            ],
          ),
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile!),
            Row(
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
            Uploader(file: _imageFile)
          ]
        ],
      ),
    );
  }
}
