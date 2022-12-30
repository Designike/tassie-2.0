import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tassie/screens/home/main/add/uploadPostImage.dart';
import 'package:image/image.dart' as im;
import '../../../../constants.dart';
import '../../../../utils/hashtagSuggestions.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  AddPostState createState() => AddPostState();
}

class AddPostState extends State<AddPost> {
  File? _imageFile;
  bool isCompressed = false;
  static String desc = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tagController = TextEditingController();
  @override
  void initState() {
    desc = '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkFields() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  /// Cropper plugin
  Future<void> _cropImage() async {
    CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 5,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Garnish it',
            toolbarColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarWidgetColor: Theme.of(context).brightness == Brightness.dark
                ? kDark
                : kDark[900],
          ),
          IOSUiSettings(title: 'Garnish it,')
        ]);
    if (mounted) {
      setState(() {
        _imageFile = cropped == null ? null : File(cropped.path);
      });
    }
    _imageFile = await compress(_imageFile!);
    // print(_imageFile!.lengthSync());
    setState(() {});
  }

  // Future<File> compress(File image1, int counter) async {
  //   if (image1.lengthSync() < 1000000) {
  //     return File(image1.path);
  //   }
  //   // print(image.lengthSync());
  //   CroppedFile? selected = await ImageCropper()
  //       .cropImage(sourcePath: image1.path, compressQuality: counter);
  //   print(image1.path);
  //   print(image1.lengthSync());
  //   print(counter);
  //   return await compress(File(selected!.path), counter + 10);
  // }

  Future<File> compress(File image1) async {
    while (image1.lengthSync() > 250000) {
      // print(image1.lengthSync());
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

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      XFile? selected = await ImagePicker().pickImage(source: source);
      if (selected == null) return;
      if (mounted) {
        setState(() {
          _imageFile = File(selected.path);
        });
      }
      _cropImage();

      // if (isCompressed) {
      //   if (!mounted) return;
      //   Navigator.of(context).pop();

      // } else {
      //   if (!mounted) return;
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //         builder: (context) => const Scaffold(
      //               // backgroundColor: Colors.white,
      //               body: Center(
      //                 child: SpinKitThreeBounce(
      //                   color: kPrimaryColor,
      //                   size: 50.0,
      //                 ),
      //               ),
      //             )),
      //   );
      // }
    }
  }

  String _appendHashtag(desc1, tag) {
    // String desc1 = desc;
    String last = desc1.substring(desc1.length - 1);
    while (last != '#') {
      desc1 = desc1.substring(0, desc1.length - 1);
      last = desc1.substring(desc1.length - 1);
    }
    return desc1 + tag.substring(1, tag.length);
  }

  /// Remove image
  void _clear() {
    if (mounted) {
      setState(() => _imageFile = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // Select an image from the camera or gallery
      // bottomNavigationBar: BottomAppBar(
      //   color: Theme.of(context).brightness == Brightness.dark
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
            const SizedBox(height: 15.0),
            const Text(
              'Some toppings ...',
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
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // TextFormField(
                      //   // style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                      //   //     ? kLight
                      //   //     : kDark[900]),
                      //         initialValue: desc.isNotEmpty ? desc : '',
                      //         decoration: InputDecoration(
                      //             labelText: 'DESCRIPTION',

                      //             labelStyle: TextStyle(
                      //               // fontFamily: 'Raleway',
                      //               fontSize: 16.0,
                      //               color: Theme.of(context).brightness == Brightness.dark
                      //       ? kPrimaryColor
                      //       : kDark[900],
                      //             ),
                      //             contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: kDefaultPadding),
                      //             floatingLabelBehavior: FloatingLabelBehavior.always,
                      //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), ),
                      //             focusedBorder: OutlineInputBorder(
                      //                 borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark
                      //       ? kPrimaryColor
                      //       : kDark[900]!),borderRadius: BorderRadius.circular(15.0),),
                      //                 ),
                      //         keyboardType: TextInputType.multiline,

                      //         maxLines: null,
                      //         onChanged: (value) {
                      //           desc = value;
                      //         },
                      //         validator: (val) => val!.isEmpty || val.length > 500
                      //             ? 'Description should be within 500 characters'
                      //             : null,
                      //       ),
                      TypeAheadFormField<String?>(
                        hideOnEmpty: true,
                        debounceDuration: const Duration(seconds: 1),
                        direction: AxisDirection.up,
                        // suggestionsCallback: _ingredientController.text.isNotEmpty ? _ingredientController.text.characters.last != '#' ? Hashtags.getSuggestions : (v) => [] : (v) => [],
                        suggestionsCallback: Hashtags.getSuggestions,
                        textFieldConfiguration: TextFieldConfiguration(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _tagController,
                          onChanged: (v) {
                            setState(() {
                              desc = v;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                              // fontFamily: 'Raleway',
                              fontSize: 16.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? kPrimaryColor
                                  : kDark[900],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: kDefaultPadding),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? kPrimaryColor
                                      : kDark[900]!),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        itemBuilder: (context, String? suggestion) => ListTile(
                          title: Text(suggestion!),
                        ),
                        onSuggestionSelected: (v) {
                          _tagController.text = _appendHashtag(desc, v);
                          setState(() {
                            desc = _tagController.text;
                          });
                        },
                        validator: (val) => val!.isEmpty || val.length > 500
                            ? 'Description should be within 500 characters'
                            : null,
                      ),
                    ],
                  )),
            ),
            // onTap: () async {
            //             if (_formKey.currentState!.validate()) {
            //               Response response = await dio.post(
            //                 "$baseAPI/user/login/",
            //                 options: Options(headers: {
            //                   HttpHeaders.contentTypeHeader: "application/json",
            //                 }),
            //                 // data: jsonEncode(value),
            //                 data: email != ""
            //                     ? {"email": email, "password": password}
            //                     : {"username": username, "password": password},
            //               );
            //               print('1');
            //               await storage.write(
            //                   key: "token",
            //                   value: response.data['data']['token']);
            //               print('2');
            //               Navigator.pushReplacement(
            //                 context,
            //                 MaterialPageRoute(builder: (context) {
            //                   return Home();
            //                 }),
            //               );
            //               print(response.toString());
            //             }
            //           },
            if (!isCompressed) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              ),
            ] else ...[
              Uploader(
                  file: _imageFile, desc: desc, formKey: _formKey, edit: false)
            ]
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: [
                  const Text(
                    'What\'s cooking ?',
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
                      'Hey! pick some appetizing stuff !',
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
