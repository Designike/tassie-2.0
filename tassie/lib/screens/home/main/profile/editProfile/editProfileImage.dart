import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tassie/screens/home/main/profile/editProfile/uploadProfilePic.dart';
import 'package:image/image.dart' as im;
import '../../../../../constants.dart';

class EditProfileImage extends StatefulWidget {
  const EditProfileImage({Key? key}) : super(key: key);

  @override
  EditProfileImageState createState() => EditProfileImageState();
}

class EditProfileImageState extends State<EditProfileImage> {
  File? _imageFile;
  bool isCompressed = false;
  @override
  void initState() {
    // desc = '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _cropImage() async {
    CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 80,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Few touch-ups!',
            toolbarColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarWidgetColor: Theme.of(context).brightness == Brightness.dark
                ? kDark
                : kDark[900],
          ),
          IOSUiSettings(title: 'Few touch-ups!,')
        ]);
    if (mounted) {
      setState(() {
        _imageFile = File(cropped!.path);
      });
      _imageFile = await compress(_imageFile!);
      print(_imageFile!.lengthSync());
      setState(() {});
    }
  }

  Future<File> compress(File image1) async {
    while (image1.lengthSync() > 150000) {
      print(image1.lengthSync());
      im.Image? image = im.decodeImage(await File(image1.path).readAsBytes());
      im.Image? compressed = im.copyResize(image!,
          width: image.width ~/ 2, height: image.height ~/ 2);
      File? compressedFile = File(image1.path);
      await compressedFile.writeAsBytes(im.encodeJpg(compressed, quality: 70));
      image1 = compressedFile;
    }
    setState(() {
      isCompressed = true;
    });
    return File(image1.path);
  }

  Future<void> _pickImage(ImageSource source) async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      XFile? selected = await ImagePicker().pickImage(source: source);
      if (selected == null) return;
      if (mounted) {
        setState(() {
          _imageFile = File(selected.path);
          _cropImage();
        });
      }
    }
  }

  void _clear() {
    if (mounted) {
      setState(() => _imageFile = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            const SizedBox(height: 15.0),
            const Text(
              'Ready to flex!',
              style: TextStyle(
                color: kPrimaryColor,
                fontFamily: 'LobsterTwo',
                fontSize: 35.0,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding * 1.5),
              child: Image.file(_imageFile!),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: _cropImage,
                    child: const Icon(Icons.crop),
                  ),
                  TextButton(
                    onPressed: _clear,
                    child: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding * 1.5),
              child: Column(
                children: const [],
              ),
            ),
            if (!isCompressed) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              ),
            ] else ...[
              ProfileUploader(file: _imageFile)
            ]
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: [
                  const Text(
                    'Fresh or Baked ?',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: 'LobsterTwo',
                      fontSize: 40.0,
                    ),
                  ),
                  const SizedBox(
                    height: 3 * kDefaultPadding,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? kDark[900]
                          : kLight,
                      border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.transparent
                              : Color(0xFFE4E4E4)),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(size.width * 0.1),
                      icon: const Icon(Icons.camera_alt_rounded),
                      iconSize: 50.0,
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? kDark[900]
                          : kLight,
                      border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.transparent
                              : Color(0xFFE4E4E4)),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(size.width * 0.1),
                      icon: const Icon(Icons.photo_library_rounded),
                      iconSize: 50.0,
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(
                    height: 2 * kDefaultPadding,
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: const Text(
                      'Let\'s pick some cool display picture !',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, height: 1.5),
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
