// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tassie/screens/home/snackbar.dart';
import 'package:tassie/screens/home/upload.dart';

import '../../constants.dart';
import 'addIngredient.dart';
import 'addStep.dart';
import 'home.dart';

class AddRecipe extends StatefulWidget {
  final String uuid;
  final String folder;
  const AddRecipe({required this.uuid, required this.folder});

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final dio = Dio();
  final storage = FlutterSecureStorage();
  int _currentStep = 0;
  File? _imageFile;
  String recipeName = "";
  final _formKey = GlobalKey<FormState>();
  //a chene ek vaar set kri leje jyare recipe pic les ane validator ma check krvanu
  File? recipePic;
  //ama index thi save krto jaje etle update thatu jase
  Map ingredientPics = {'0': ''};
  //ama bhi same
  Map stepPics = {'0': ''};

  final TextEditingController _stepController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  static List<String?> stepsList = [null];
  static List<String?> ingredientsList = [null];

  //ane tassie mathi leto avje code plus vado e page ma bov kayi che nayi ena sivayi
  List<Widget> _UploadImg(size,key,index,image) {
    print('henlo-----------------------------');
    print('step pics');
    print(stepPics);
    print('ing pics');
    print(ingredientPics);
    print('image');
    print(image);
    print('index');
    print(index);
    print('---------------------------------');
  List<Widget> _upload = [
    if (image==null && _imageFile != null) ...[
        
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 1.5, horizontal: 5.0),
              child: Image.file(_imageFile!),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Icon(Icons.crop),
                    onPressed:_cropImage,
                  ),
                  TextButton(
                    child: Icon(Icons.refresh),
                    onPressed: _clear,
                  ),
                ],
              ),
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
            Container(
              child: IconButton(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                icon: Icon(Icons.cloud_upload),
                iconSize: 30.0,
                color: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? kPrimaryColor
                    : kPrimaryColorAccent,
                onPressed: () {
                  print('1');
                  
                    if(key=='r'){
                      recipePic = _imageFile;
                      print('2');
                    }else if(key=='i'){
                      ingredientPics[(index).toString()]=_imageFile;
                      print('3');
                    }else{
                      stepPics[(index).toString()]=_imageFile;
                      print('4');
                    }
                    print('5');
                    if (recipeName!='') {
                    _startUpload( _imageFile,recipeName,'name',key+'_'+(index+1).toString(), widget.folder);
                    }
                },
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: kDark[900],
              ),
            ),
          ] else if(image!='' && image!=null) ... [
             Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 1.5, horizontal: 5.0),
              child: Image.file(image),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Icon(Icons.crop),
                    onPressed:_cropImage,
                  ),
                  TextButton(
                    child: Icon(Icons.refresh),
                    onPressed: _clear,
                  ),
                ],
              ),
            ),
          ]
          else ... [
            Container(
              
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Text('Choose recipe image'),
                  ),
              // SizedBox(height: 3 * kDefaultPadding,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: kDefaultPadding),
                        child: IconButton(
                          padding: EdgeInsets.all(size.width * 0.05),
                          icon: Icon(Icons.camera_alt_rounded),
                          iconSize: 50.0,
                        onPressed: () => _pickImage(ImageSource.camera),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(size.width),
                        color: MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? kDark[900]
                        : kLight,),
                      ),
                          // SizedBox(height: kDefaultPadding,),
                  Container(
                    margin: EdgeInsets.only(left: kDefaultPadding),
                    child: IconButton(
                      padding: EdgeInsets.all(size.width * 0.05),
                      icon: Icon(Icons.photo_library_rounded),
                      iconSize: 50.0,
                    onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(size.width),
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? kDark[900]
                    : kLight,),
                  ),
                  // SizedBox(height: 2 * kDefaultPadding,),
              //     Container(
              //       width: size.width * 0.5,
              //       child: Text(
              //   'Hey! pick some appetizing stuff !',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontSize: 18.0,
              //       height: 1.5
                    
              //   ),
              // ),
              //     ),
                    ],
                  ),
              
                ],
              ),
            )
          ]
  ];
  return _upload;
  }

  List<Step> steps(Size size) => [
        Step(
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          title: Text('Recipe'),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Column(
              children: [
                TextFormField(
                  // style: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.dark
                  //     ? kLight
                  //     : kDark[900]),
                        initialValue: recipeName.isNotEmpty ? recipeName : '',
                        decoration: InputDecoration(
                            labelText: 'RECIPE NAME',
                            
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
                          recipeName = value;
                        },
                        validator: (val) => val!.isEmpty || val.length > 100
                            ? 'Recipe name should be within 100 characters'
                            : null,
                      ),

                      ... _UploadImg(size,'r',0,recipePic)
              ],
            ),
          ),
        ),
        Step(
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          title: Text('Ingredients'),
          subtitle: Text('Images are optional', 
                    style: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? kDark
                      : kDark[700]),),
          content: Column(
            children: [
              ... _getIngredient(size)
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 2,
          title: Text('Steps'),
          subtitle: Text('Images are optional', 
                    style: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? kDark
                      : kDark[700]),),
          content: Column(
            children: [
              ... _getRecipe(size)
            ],
          ),
        ),
      ];
  
  //////////add and subtract

List<Widget> _getRecipe(size) {
    List<Widget> recipeTextFields = [];
    for (int i = 0; i < stepsList.length; i++) {
      recipeTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: StepTextField(index: i, stepsList: stepsList)),
                SizedBox(
                  width: 16,
                ),
                _addRemoveButtonR(i == 0, stepsList.length - 1, i),
              ],
            ),
            ... _UploadImg(size,'s',i,stepPics[i.toString()])
          ],
        ),
      ));
    }
    return recipeTextFields;
  }

  Widget _addRemoveButtonR(bool add, int index, int i) {
    return InkWell(
      onTap: () {
        if (add) {
          stepsList.insert(index + 1, "");
          stepPics[(index + 1).toString()] = '';
        } else {
          stepsList.removeAt(i);
          stepPics[i.toString()] = '';
          
        }
        if (mounted) {
          setState(() {});
        }
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: (add) ? kPrimaryColor : kDark[800],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _getIngredient(size) {
    List<Widget> ingredientsTextFields = [];
    for (int i = 0; i < ingredientsList.length; i++) {
      ingredientsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: IngredientTextField(index: i, ingredientsList: ingredientsList,)),
                SizedBox(
                  width: 16,
                ),
                _addRemoveButtonI(i == 0, ingredientsList.length - 1, i),
              ],
            ),
            ... _UploadImg(size,'i',i,ingredientPics[i.toString()])
          ],
        ),
      ));
    }
    return ingredientsTextFields;
  }

  Widget _addRemoveButtonI(bool add, int index, int i) {
    return InkWell(
      onTap: () {
        if (add) {
          ingredientsList.insert(index + 1, "");
          ingredientPics[i.toString()] = '';
        } else{
          ingredientsList.removeAt(i);
          ingredientPics[i.toString()] = '';
        }
        if (mounted) {
          setState(() {});
        }
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: (add) ? kPrimaryColor : kDark[800],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  ////////  

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

  double progress = 0.0;
  Future<void> _startUpload(File? file,String keyValue, String keyName, String imgName, String folder) async {
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
    _imageFile = null;
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
      _imageFile = null;
      showSnack(context, response.data['message'], () {}, 'OK', 5);
    }
    if (response.data['status'] == true) {
     
      showSnack(context, response.data['message'], () {}, 'OK', 3);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            actionsPadding: EdgeInsets.all(20.0),
            title: Text('Are you sure?'),
            content: Text('Do you want to go back'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No"),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  var url = "http://10.0.2.2:3000/recs/deleteRecipe";
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      data: {'uuid': widget.uuid, 'folder': widget.folder});
                  if (response.data['status'] == true) {
                    print('deleted');
                  } else {
                    //aama uuid send karvani che, get -> post kari nakh
                    print('not deleted');
                  }
                },
                child: Text("Yes"),
              ),
            ],
          ),
        );
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).scaffoldBackgroundColor,
              statusBarIconBrightness:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light),
          title: Text(
            'Add some savors!',
            style: TextStyle(
              color: kPrimaryColor,
              fontFamily: 'LobsterTwo',
              fontSize: 30.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stepper(
              physics: ClampingScrollPhysics(),
              type: StepperType.vertical,
              onStepTapped: (value) => setState(() {
                _currentStep = value;
              }),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final _isLastStep = _currentStep == steps(size).length - 1;
                return Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: details.onStepContinue,
                      child: Text(_isLastStep ? 'UPLOAD' : 'NEXT'),
                      style: TextButton.styleFrom(
                          backgroundColor:
                              MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark
                                  ? kDark[900]
                                  : kPrimaryColor,
                          primary: MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? kPrimaryColor
                              : kLight),
                    ),
                    if (_currentStep != 0) ...[
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('BACK'),
                      ),
                    ]
                  ],
                );
              },
              currentStep: _currentStep,
              onStepContinue: () async {
                final _isLastStep = _currentStep == steps(size).length - 1;
                if (_isLastStep) {
                  if (_formKey.currentState!.validate()){
                  // to submit here
                  
                  var url = "http://10.0.2.2:3000/recs/updateRecipe";
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      data: {'uuid': widget.uuid, 'folder': widget.folder, 'steps': stepsList});
                  }
                  
                } else {
                  setState(() {
                    _currentStep += 1;
                    print(_currentStep);
                  });
                  print('2.d');
                  if(_currentStep == 2){
                  var url = "http://10.0.2.2:3000/recs/updateRecipe";
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      data: {'uuid': widget.uuid, 'folder': widget.folder, 'ingredients': ingredientsList});
                  }
                  
                }
              },
              onStepCancel: () {
                _currentStep == 0
                    ? null
                    : setState(() {
                        _currentStep -= 1;
                      });
              },
              steps: steps(size),
            ),
          ),
        ),
      ),
    );
  }
}
