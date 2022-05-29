// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tassie/leftSwipe.dart';
import 'package:tassie/screens/home/home_home.dart';
import 'package:tassie/screens/home/snackbar.dart';
import 'package:tassie/screens/home/upload.dart';
import 'package:tassie/screens/home/uploadRecImages.dart';
import 'package:path/path.dart' as p;
import 'package:tassie/screens/imgLoader.dart';
import '../../constants.dart';
import 'addIngredient.dart';
import 'addStep.dart';
import 'hashtag_suggestions.dart';
import 'home.dart';

class EditRecipe extends StatefulWidget {
  final String uuid;
  final String desc;
  final List stepPics;
  final List steps;
  final List ingredients;
  final List ingredientPics;
  final String recipeImageID;
  final int hours;
  final int mins;
  final String recipeName;
  final String chefName;
  final bool isVeg;
  final String course;
  final String flavour;
  final bool isLunch;
  final bool isBreakfast;
  final bool isDinner;
  final bool isCraving;

  // final String folder;
  const EditRecipe({required this.uuid,required this.desc,required this.stepPics,required this.steps,required this.ingredients,required this.ingredientPics,required this.recipeImageID,required this.hours, required this.mins,required this.recipeName,required this.chefName,required this.isVeg,required this.course,required this.flavour,required this.isLunch,required this.isBreakfast,required this.isDinner,required this.isCraving, 
  // , required this.folder
  });

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  final dio = Dio();
  final storage = FlutterSecureStorage();
  int _currentStep = 0;
  File? _imageFile;
  String recipeName = "";
  String youtubeLink = "";
  String desc = "";
  File? recipePic;
  Map ingredientPics = {'0': ''};
  Map stepPics = {'0': ''};
  
  Map _clearSteps = {0: false};
  Map _clearIngs = {0: false};
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tagController = TextEditingController();
  final LocalStorage lstorage = LocalStorage('tassie');

  // final TextEditingController _stepController = TextEditingController();
  // final TextEditingController _ingredientController = TextEditingController();
  List<String?> stepsList = [null];
  List<String?> ingredientsList = [null];
  bool isVeg = true;
  int selectedFlavour = 0;
  int selectedCourse = 0;
  String flavour = "Spicy";
  String course = "Snack";
  List<bool> mealType = [false, false, false, false];
  List<String> hours=['0', '1', '2', '3'];
  final minutes=['00', '15', '30', '45'];
  bool isUpload = false;
  String hour = '0';
  String min = '15';
  // List<Widget> ingWidgetList = [];
  // List<Widget> stepsWidgetList = [];
  String? uuid;
  // bool isPop = false;
  bool isLoading = true;

  Future<File> _fileFromImageUrl(filepath) async {
    AsyncMemoizer memoizer = AsyncMemoizer();
    String storedFuture = await loadImg(filepath,memoizer);
    final response = await http.get(Uri.parse(storedFuture));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(p.join(documentDirectory.path, 'test.jpg'));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  Future<void> urlToFile() async {
    widget.stepPics.forEach((element) async {
      stepPics[element['index']] = await _fileFromImageUrl(element['fileID']);
    });

    widget.ingredientPics.forEach((element) async {
      ingredientPics[element['index']] = await _fileFromImageUrl(element['fileID']);
    });

    setState(() {
      isLoading = false;
    });
  }
  // RangeValues _currentRangeValues = RangeValues(0, 15);
  //ane tassie mathi leto avje code plus vado e page ma bov kayi che nayi ena sivayi
  List<Widget> _uploadImg(size,key,index,image) {
        // print(image);
        List<Widget> _upload = [
          if(image!='' && image!=null) ... [
             Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 1.5, horizontal: 5.0),
              child: Image.file(image),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
              child: RecImageUploader(
                file: image, 
                keyValue: recipeName,
                keyName: 'name', 
                imgName: key+'_'+(index+1).toString(),
                uuid: widget.uuid,
                clearRecost: key == 'i' ? _clearIngs[index] : _clearSteps[index],
                falseResp: () {
                      print("working");
                      setState(() {
                        if(key=='r'){
                            recipePic = null;
                            _imageFile = null;
                        }else if(key=='i'){
                            ingredientPics[(index).toString()]= null;
                            _imageFile = null;
                        }else{
                            stepPics[(index).toString()]= null;
                            _imageFile = null;
                        }
                      });

                      if (key+'_'+(index+1).toString() == 'r_1') {
                        setState(() {
                          isUpload = false;
                        });
                      }

                    }, 
                trueResp: () {
                  if (key+'_'+(index+1).toString() == 'r_1') {
                    setState(() {
                      isUpload = true;
                    });
                  }
                }, 
                imageNull: () {
                  _imageFile = null;

                },
                onClear: () async {
                  await _clear(key, index, key + '_' + (index + 1).toString());
                },
                onCrop: () {
                  _cropImage(key, index);
                },
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
                        onPressed: () => _pickImage(ImageSource.camera, key, index),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(size.width),
                        color: Theme.of(context).brightness == Brightness.dark
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
                    onPressed: () => _pickImage(ImageSource.gallery, key,index),
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(size.width),
                    color: Theme.of(context).brightness == Brightness.dark
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
  
  void changeFlavour(int index, String flav) {
    setState(() {
      flavour = flav;
      selectedFlavour = index;
    });
    print(flavour);
  }

  void changeCourse(int index, String cour) {
    setState(() {
      course = cour;
      selectedCourse = index;
    });
    print(course);
  }

  void changeMeal(int index, bool check) {
    setState(() {
      mealType[index] = check;
    });
    // print(course);
  }

  Widget mealCheckBox(int index, String flav) {
    return Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding),
            child: OutlinedButton(
              onPressed: () => changeMeal(index, !mealType[index]),
              child: Text(flav),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                padding: EdgeInsets.all(15.0),
                side: BorderSide(
                  color: mealType[index] ? kPrimaryColor : kDark,
                  width: mealType[index] ? 2 : 1,
                ),
                backgroundColor: mealType[index] ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
              ),

            ),
          );
  }

  Widget flavourRadio(int index, String flav) {
    return Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding),
            child: OutlinedButton(
              onPressed: () => changeFlavour(index, flav),
              child: Text(flav),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                padding: EdgeInsets.all(15.0),
                side: BorderSide(
                  color: selectedFlavour == index ? kPrimaryColor : kDark,
                  width: selectedFlavour == index ? 2 : 1,
                ),
                backgroundColor: selectedFlavour == index ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
              ),

            ),
          );
  }

  Widget courseRadio(int index, String cour) {
    return Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding),
            child: OutlinedButton(
              onPressed: () => changeCourse(index, cour),
              child: Text(cour),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                padding: EdgeInsets.all(15.0),
                side: BorderSide(
                  color: selectedCourse == index ? kPrimaryColor : kDark,
                  width: selectedCourse == index ? 2 : 1,
                ),
                backgroundColor: selectedCourse == index ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
              ),

            ),
          );
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
                  // style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                  //     ? kLight
                  //     : kDark[900]),
                        initialValue: recipeName.isNotEmpty ? recipeName : '',
                        decoration: InputDecoration(
                            labelText: 'Recipe Name',
                            
                            labelStyle: TextStyle(
                              // fontFamily: 'Raleway',
                              fontSize: 16.0,
                              color: Theme.of(context).brightness == Brightness.dark
                      ? kPrimaryColor
                      : kDark[900],
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: kDefaultPadding),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark
                      ? kPrimaryColor
                      : kDark[900]!),borderRadius: BorderRadius.circular(15.0),),
                                ),
                        // keyboardType: TextInputType.multiline,
                        
                        // maxLines: null,
                        onChanged: (value) {
                          recipeName = value;
                        },
                        validator: (val) => val!.isEmpty || val.length > 100
                            ? 'Recipe name should be within 100 characters'
                            : null,
                      ),

                      ... _uploadImg(size,'r',0,recipePic)
              ],
            ),
          ),
        ),
        Step(
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          title: Text('Tags'),
          // subtitle: Text('Images are optional', 
          //           style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
          //             ? kDark
          //             : kDark[700]),),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Text('Category'),
                  ),
              // SizedBox(height: 3 * kDefaultPadding,),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Padding(
                          padding: const EdgeInsets.only(right: kDefaultPadding),
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                isVeg = true;
                              });
                            },
                            child: Text('Veg'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                              padding: EdgeInsets.all(15.0),
                              side: BorderSide(
                                color: isVeg ? Colors.green : kDark,
                                 width: isVeg ? 2 : 1,
                              ),
                              backgroundColor: isVeg ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
                            ),
            
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isVeg = false;
                            });
                          },
                          child: Text('Non Veg'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            padding: EdgeInsets.all(15.0),
                            side: BorderSide(
                              color: !isVeg ? Colors.red : kDark,
                               width: !isVeg ? 2 : 1,
                            ),
                            backgroundColor: !isVeg ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
                          ),
            
                        ),
                        
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Text('Meal Type'),
                  ),
                  
              // SizedBox(height: 3 * kDefaultPadding,),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          mealCheckBox(0,'Lunch'),
                          mealCheckBox(1,'Breakfast'),
                          mealCheckBox(2,'Dinner'),
                          mealCheckBox(3,'Craving'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Text('Flavour'),
                  ),
                  
              // SizedBox(height: 3 * kDefaultPadding,),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          flavourRadio(0,'Spicy'),
                          flavourRadio(1,'Sweet'),
                          flavourRadio(2,'Sour'),
                          flavourRadio(3,'Salty'),
                          flavourRadio(4,'Bitter'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Text('Course'),
                  ),
                  
              // SizedBox(height: 3 * kDefaultPadding,),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          courseRadio(0,'Snack'),
                          courseRadio(1,'Starter'),
                          courseRadio(2,'Farali'),
                          courseRadio(3,'Main course'),
                          courseRadio(4,'Dessert'),
                          courseRadio(5,'Drinks'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Text('Cooking Time (HH : MM)'),
                  ),
                  Padding(padding: const EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                          border: Border.all(color: kDark),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(value:hour,items: hours.map((String i){return DropdownMenuItem(
                                      value: i,
                                      child: Text(i),
                                    );}).toList() , onChanged: (value) {
                                            setState(() {
                             hour = value!;                 
                                            });
                                            
                                          },
                                          borderRadius: BorderRadius.circular(15.0),
                                          isExpanded:true),
                        ),
                  
                      ),
                      SizedBox(
                    width: 10.0,
                  ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                          border: Border.all(color: kDark),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(value:min,items: minutes.map((String i){return DropdownMenuItem(
                                      value: i,
                                      child: Text(i),
                                    );}).toList() , onChanged: (value) {
                                            setState(() {
                             min = value!;                 
                                            });
                                            
                                          },
                                          borderRadius: BorderRadius.circular(15.0),
                                          isExpanded:true),
                        ),
                  
                      ),
                    ],
                  ),)
                  
                  
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          title: Text('Ingredients'),
          subtitle: Text('Images are optional', 
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                      ? kDark
                      : kDark[700]),),
          content: Column(
            children: [
              ... _getIngredient(size)
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 3,
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          title: Text('Steps'),
          subtitle: Text('Images are optional', 
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                      ? kDark
                      : kDark[700]),),
          content: Column(
            children: [
              ... _getRecipe(size)
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 4,
          title: Text('Description'),
          subtitle: Text('You can also add hashtags and mentions', 
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                      ? kDark
                      : kDark[700]),),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Column(
              children: [
                TypeAheadFormField<String?>(
                      hideOnEmpty:true, 
                      debounceDuration: Duration(seconds:1),
                      // direction: AxisDirection.up,
                      autoFlipDirection: true,
                      keepSuggestionsOnSuggestionSelected: true,
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
              ],
            ),
          ),
        ),
        Step(
          isActive: _currentStep >= 5,
          title: Text('Youtube link'),
          subtitle: Text('Namak Swaad Anusaar!  (Optional)', 
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                      ? kDark
                      : kDark[700]),),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Column(
              children: [
                TextFormField(
                    // style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                    //     ? kLight
                    //     : kDark[900]),
                          initialValue: youtubeLink.isNotEmpty ? youtubeLink : '',
                          decoration: InputDecoration(
                              labelText: 'Tutorial Link',
                              
                              labelStyle: TextStyle(
                                // fontFamily: 'Raleway',
                                fontSize: 16.0,
                                color: Theme.of(context).brightness == Brightness.dark
                        ? kPrimaryColor
                        : kDark[900],
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: kDefaultPadding),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark
                        ? kPrimaryColor
                        : kDark[900]!),borderRadius: BorderRadius.circular(15.0),),
                                  ),
                          keyboardType: TextInputType.multiline,
                          
                          maxLines: null,
                          onChanged: (value) {
                            youtubeLink = value;
                          },
                          validator: (val) {
                            if(val!.isNotEmpty) {
                            if (!RegExp(r"http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?​=]*)?")
                              .hasMatch(val)) {
                            return 'Please enter a valid youtube link';
                          }}
                          return null;
                          },
                        ),
              ],
            ),
          ),
        ),
        
      ];
  
  //////////add and subtract

List<Widget> _getRecipe(size) {
    List<Widget> recipeTextFields = [];
    for (int i = 0; i < stepsList.length; i++) {
      // print(i);
      // print(stepPics[i.toString()]);
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
            ... _uploadImg(size,'s',i,stepPics[i.toString()])
          ],
        ),
      ));
    }
    return recipeTextFields;
  }

  Widget _addRemoveButtonR(bool add, int index, int i) {
    return InkWell(
      onTap: () async{
        if (add) {
          stepsList.insert(index + 1, "");
          stepPics[(index + 1).toString()] = '';
          setState((){
            _clearSteps[index+1] = false;
          });
          // print(_clearSteps);
        } else {
          stepsList.removeAt(i);
          stepPics[i.toString()] = '';
          await _clear('s',i,'s_'+(i+1).toString(), true);
          stepPics = await _adjustImages(i,stepPics,false,"s_");
          setState(() {});
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
                Expanded(child: IngredientTextField(index: i, ingredientsList: ingredientsList)),
                SizedBox(
                  width: 16,
                ),
                _addRemoveButtonI(i == 0, ingredientsList.length - 1, i),
              ],
            ),
            ... _uploadImg(size,'i',i,ingredientPics[i.toString()])
          ],
        ),
      ));
    }
    return ingredientsTextFields;
  }

  Widget _addRemoveButtonI(bool add, int index, int i) {
    return InkWell(
      onTap: () async {
        if (add) {
          ingredientsList.insert(index + 1, "");
          ingredientPics[(index+1).toString()] = '';
        } else{
          ingredientsList.removeAt(i);
          ingredientPics[i.toString()] = '';
          await _clear('i',i,'i_'+(i+1).toString(), true);
          ingredientPics = await _adjustImages(i,ingredientPics,true,"i_");
          setState(() {});

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
  Future<void> _cropImage(key, index) async {
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
          toolbarTitle: 'Garnish it'
          toolbarColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarWidgetColor: Theme.of(context).brightness == Brightness.dark
                    ? kDark
                    : kDark[900],
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Garnish it,'
        )
        );

    setState(() {
      if(key=='r'){
          recipePic = cropped;
          _imageFile = null;
          
        }else if(key=='i'){
          ingredientPics[(index).toString()]= cropped;
          _imageFile = null;
          
        }else{
          stepPics[(index).toString()]= cropped;
          _imageFile = null;
        }
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source, key, index) async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      XFile? selected = await ImagePicker().pickImage(source: source);
      if (selected == null) return;
      setState(() {
        _imageFile = File(selected.path);
        _cropImage(key, index);
      });
    }
  }

  /// Remove image
  Future<void> _clear(key, index,imgName, [clearRecost = false]) async {
    print(widget.uuid);
      if(key=='r'){
        setState(() {
          recipePic = null;
          
        });
          
          var token = await storage.read(key: "token");
    // print(formData.files[0]);
    Response response = await dio.post(
      // 'https://api-tassie.herokuapp.com/drive/upload',
      'https://api-tassie.herokuapp.com/recs/resetImage/',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer " + token!
      }),
      data: {'uuid':widget.uuid,'imgName':imgName});

        }else if(key=='i'){
        setState(() {
          ingredientPics[(index).toString()]= '';
          if(clearRecost){
            _clearIngs[index] = true;
          }
        });
          print(widget.uuid);
          var token = await storage.read(key: "token");
    // print(formData.files[0]);
    Response response = await dio.post(
      // 'https://api-tassie.herokuapp.com/drive/upload',
      'https://api-tassie.herokuapp.com/recs/resetImage/',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer " + token!
      }),
      data: {'uuid':widget.uuid,'imgName':imgName});


        }else{
          setState(() {
          stepPics[(index).toString()]= '';
          if(clearRecost){
            _clearSteps[index] = true;
          }
        });
          
          var token = await storage.read(key: "token");
    // print(formData.files[0]);
    Response response = await dio.post(
      // 'https://api-tassie.herokuapp.com/drive/upload',
      'https://api-tassie.herokuapp.com/recs/resetImage/',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer " + token!
      }),
      data: {'uuid':widget.uuid,'imgName':imgName});
        }
    
  }

  Future<Map> _adjustImages(int index,Map x,bool isIngredient,String key) async {
    // print('hfsdjsndfsdkfj');
    // print(x['0'].path);
    int l = x.length;
    Map send = {};
    // print(x);
    // print("index");
    // print(index+1);
    for(int j=index; j<l-1; j++) {
      // print('----------------------------------');
      x[j.toString()]=x[(j+1).toString()];
      if(x[(j+1).toString()] != ''){
      // print(x[(j+1).toString()]);
      send[key+(j+1).toString()+p.extension(x[(j).toString()].path)]=key+(j+2).toString()+p.extension(x[(j+1).toString()].path);
      }
      // print(x);
    }
    x.remove((l-1).toString());
    // print(x);
    try {
    var token = await storage.read(key: "token");
    // print("index");
    // print(index+1);
    // print("length");
    // print(l);
    // print("send");
    // print(send);
    if(send.length!=0){
    Response response = await dio.post(
      // 'https://api-tassie.herokuapp.com/drive/upload',
      'https://api-tassie.herokuapp.com/recs/renameImages',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer " + token!
      }),
      data: {"index":index+1,"isIngredient": isIngredient,"recipeUuid":widget.uuid,"length":l,"renameMap":send},);
      if(response.data["status"] == false) {
        showSnack(context, "Oops something went wrong. Please try again!", (){}, "OK", 4);
      }
    }
    return x;
    } catch (e) {
      print(e);
      showSnack(context, "Oops something went wrong. Please try again!", (){}, "OK", 4);
      return x;
    }

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
      'https://api-tassie.herokuapp.com/recs/updateRecipe/',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "multipart/form-data",
        HttpHeaders.authorizationHeader: "Bearer " + token!
      }),
      data: formData,
      onSendProgress: (int sent, int total) {
        // setState(() {
        //   print(progress);
        //   progress = (sent / total * 100);
        //   print(progress);
          
        // });
      },
    );
    
    if (response.data['status'] == false) {
      _imageFile = null;
      if(imgName=='r_1'){
        setState(() {
                  isUpload=false;
                });
      }
      showSnack(context, response.data['message'], () {}, 'OK', 5);
    }
    if (response.data['status'] == true) {
      if(imgName=='r_1'){
        setState(() {
                  isUpload=true;
                });
      }
      showSnack(context, response.data['message'], () {}, 'OK', 3);
    }
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      desc = widget.desc;
      widget.steps.forEach((element) { stepsList.add(element);});
      widget.ingredients.forEach((element) { ingredientsList.add(element);});
      hour = widget.hours.toString();
      min = widget.mins.toString();
      recipeName = widget.recipeName;
      isVeg = widget.isVeg;
      mealType = [widget.isLunch, widget.isBreakfast, widget.isDinner, widget.isCraving];
      course = widget.course;
      flavour = widget.flavour;
    });
    urlToFile();
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
            content: Text('Some changes might be discarded. Continue?'),
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
                  print("henlooooooooo");
                  Provider.of<LeftSwipe>(context, listen: false).setSwipe(true);
                  // Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  // Navigator.of(context,rootNavigator: true).pushReplacement
                  //   (MaterialPageRoute(builder: (context) {
                  //         return HomeHome();
                  //       }));
                  // var url = "https://api-tassie.herokuapp.com/recs/deleteRecipe";
                  // var token = await storage.read(key: "token");
                  // Response response = await dio.post(url,
                  //     options: Options(headers: {
                  //       HttpHeaders.contentTypeHeader: "application/json",
                  //       HttpHeaders.authorizationHeader: "Bearer " + token!
                  //     }),
                  //     data: {'uuid': widget.uuid, 
                  //     // 'folder': widget.folder
                  //     });
                  // if (response.data['status'] == true) {
                  //   print('deleted');
                  // } else {
                  //   //aama uuid send karvani che, get -> post kari nakh
                  //   print('not deleted');
                  // }
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
      child: (isLoading == true)
        ? Scaffold(
            // backgroundColor: Colors.white,
            body: Center(
              child: SpinKitThreeBounce(
                color: kPrimaryColor,
                size: 50.0,
              ),
            ),
          )
        : Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).brightness == Brightness.dark
                ? kLight
                : kDark[900],
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).scaffoldBackgroundColor,
              statusBarIconBrightness:
                  Theme.of(context).brightness == Brightness.light
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
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stepper(
              physics: ClampingScrollPhysics(),
              type: StepperType.vertical,
              onStepTapped: (value) => {},
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final _isLastStep = _currentStep == steps(size).length - 1;
                return Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: details.onStepContinue,
                      child: Text(_isLastStep ? 'UPLOAD' : 'NEXT'),
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? kDark[900]
                                  : kPrimaryColor,
                          primary: Theme.of(context).brightness ==
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
                  if (_formKey.currentState!.validate() && isUpload){
                    if(hour != null && min != null) {
                      if(hour == '0' && min == '00')  {
                        showSnack(context, 'Cooking time cannot be 0:00, Are you cooking at light\'s speed xD?', () {}, 'OK', 4);
                      } else {
                  // to submit here
                  var url = "https://api-tassie.herokuapp.com/recs/updateRecipe";
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      data: {'uuid': widget.uuid, 
                      // 'folder': widget.folder, 
                      'youtubeLink': youtubeLink});
                      Provider.of<LeftSwipe>(context, listen: false).setSwipe(true);
                        Navigator.of(context).pop();
                       Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Home();
                        }),
                      );
                      
                      }
                    } else {
                      showSnack(context, 'Add cooking time', () {}, 'OK', 4);
                    }
                  } else {
                    showSnack(context, 'Check missing ingredients or steps or recipe image!', () {}, 'OK', 4);
                  }
                  
                } else {
                  setState(() {
                    _currentStep += 1;
                    print('currentstep :');
                    print(_currentStep);
                  });
                  print('2.d');
                  if(_currentStep == 1){
                  var url = "https://api-tassie.herokuapp.com/recs/updateRecipe";
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      data: {'uuid': widget.uuid,
                      // 'folder': widget.folder, 
                      'name': recipeName});
                  }
                  if(_currentStep == 2){
                    if(hour != null && min != null) {
                      if(hour == '0' && min == '00')  {
                        showSnack(context, 'Cooking time cannot be 0:00, Are you cooking at light\'s speed xD?', () {}, 'OK', 4);
                      } else {
                    
                  var url = "https://api-tassie.herokuapp.com/recs/updateRecipe";
                  var token = await storage.read(key: "token");
                  var time = int.parse(hour)*60 + int.parse(min);
                  print('should print');
                  print(flavour);
                  print(course);
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      
                      data: {'uuid': widget.uuid,
                      // 'folder': widget.folder,
                      'flavour':flavour,'veg':isVeg,'course':course,'estimatedTime':time, 'isLunch': mealType[0], 'isBreakfast': mealType[1], 'isDinner': mealType[2], 'isCraving': mealType[3]});
                      }
                    } else {
                      showSnack(context, 'Add cooking time', () {}, 'OK', 4);
                    }
                  }
                  if(_currentStep == 3){
                  var url = "https://api-tassie.herokuapp.com/recs/updateRecipe";
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      data: {'uuid': widget.uuid,
                      // 'folder': widget.folder, 
                      'ingredients': ingredientsList});
                  }
                  if(_currentStep == 4){
                  var url = "https://api-tassie.herokuapp.com/recs/updateRecipe";
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      data: {'uuid': widget.uuid,
                      // 'folder': widget.folder,
                      'steps': stepsList}); // 'folder': widget.folder, 
                  }
                  if(_currentStep == 5){
                  var url = "https://api-tassie.herokuapp.com/recs/addHashtag";
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      data: {'uuid': widget.uuid,
                      // 'folder': widget.folder,
                      'desc': desc}); // 'folder': widget.folder, 
                  }
                }
              },
              onStepCancel: () {
                _currentStep == 0
                    ? null
                    : setState(() {
                      print('current step back');
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
