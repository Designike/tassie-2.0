// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tassie/screens/home/upload.dart';

import '../../constants.dart';
import 'hashtag_suggestions.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? _imageFile;
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
        compressQuality: 80,
        uiSettings:[
        AndroidUiSettings(
          toolbarTitle: 'Garnish it,'
          toolbarColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarWidgetColor: Theme.of(context).brightness == Brightness.dark
                    ? kDark
                    : kDark[900],
        ),
        IOSUiSettings(
          title: 'Garnish it,'
        )]
        );

    setState(() {
      _imageFile =  cropped == null ? null : File(cropped.path);
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

  String _appendHashtag(desc1, tag) {
    print(desc1);
    print(tag);
    // String desc1 = desc;
    String last = desc1.substring(desc1.length-1);
    while(last != '#') {
      desc1 = desc1.substring(0, desc1.length-1);
      last = desc1.substring(desc1.length-1);
    }
    print(desc1 + tag.substring(1,tag.length));
    return desc1 + tag.substring(1,tag.length);
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
            SizedBox(height: 15.0),
            Text(
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
            child: Form(
              key: _formKey,
              child: Column(children: [
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
                      hideOnEmpty:true, 
                      debounceDuration: Duration(seconds:1),
                      direction: AxisDirection.up,
                      // suggestionsCallback: _ingredientController.text.isNotEmpty ? _ingredientController.text.characters.last != '#' ? Hashtags.getSuggestions : (v) => [] : (v) => [],
                      suggestionsCallback: Hashtags.getSuggestions,
                      textFieldConfiguration: TextFieldConfiguration(
                        keyboardType: TextInputType.multiline,
                                      
                        maxLines: null,
                        controller: _tagController,
                        onChanged: (v) {
                          desc = v;        
                          },
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            // fontFamily: 'Raleway',
                            fontSize: 16.0,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? kPrimaryColor
                                : kDark[900],
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 25.0, vertical: kDefaultPadding),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).brightness == Brightness.dark
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
                        // setState(() {
                          print("first");
                          print(_appendHashtag(desc, v));
                          _tagController.text = _appendHashtag(desc, v);
                          print("second");
                        print(_tagController.text);
                        // });
                      },
                      validator: (val) => val!.isEmpty || val.length > 500
                                          ? 'Description should be within 500 characters'
                                          : null,
                          
    ),
                    
                    
            ],)),
            ),
            // onTap: () async {
            //             if (_formKey.currentState!.validate()) {
            //               Response response = await dio.post(
            //                 "https://api-tassie.herokuapp.com/user/login/",
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

            Uploader(file: _imageFile, desc: desc, formKey: _formKey, edit: false)
          ] else ... [
            Container(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
              
                children: [
                  Text(
                'What\'s cooking ?',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontFamily: 'LobsterTwo',
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
                    color: Theme.of(context).brightness == Brightness.dark
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
                    color: Theme.of(context).brightness == Brightness.dark
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
