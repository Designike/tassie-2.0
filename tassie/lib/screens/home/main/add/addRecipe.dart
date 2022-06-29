import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tassie/utils/leftSwipe.dart';
import 'package:tassie/screens/home/home.dart';
import 'package:tassie/utils/snackbar.dart';
import 'package:tassie/screens/home/main/add/uploadRecImages.dart';
import 'package:path/path.dart' as p;
import '../../../../constants.dart';
import 'addIngredient.dart';
import 'addStep.dart';
import '../../../../utils/hashtagSuggestions.dart';
import '../../homeMapPageContoller.dart';
import 'package:image/image.dart' as im;

class AddRecipe extends StatefulWidget {
  final String uuid;
  // final String folder;
  const AddRecipe({required this.uuid, Key? key}) : super(key: key);

  @override
  AddRecipeState createState() => AddRecipeState();
}

class AddRecipeState extends State<AddRecipe> {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  int _currentStep = 0;
  File? _imageFile;
  bool isCompressed = true;
  String recipeName = "";
  String youtubeLink = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tagController = TextEditingController();
  String desc = "";
  File? recipePic;
  Map ingredientPics = {'0': ''};
  Map stepPics = {'0': ''};

  Map clearSteps = {0: false};
  Map clearIngs = {0: false};

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
  List<String> hours = ['0', '1', '2', '3'];
  final minutes = ['00', '15', '30', '45'];
  bool isUpload = false;
  String hour = '0';
  String min = '15';
  Map newIngFlags = {};
  // RangeValues _currentRangeValues = RangeValues(0, 15);
  //ane tassie mathi leto avje code plus vado e page ma bov kayi che nayi ena sivayi
  List<Widget> _uploadImg(size, key, index, image) {
    // print(image);
    // image = File(image.path);
    List<Widget> upload = [
      if (image != '' && image != null) ...[
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding * 1.5, horizontal: 5.0),
          child: Image.file(File(image.path)),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
          child: RecImageUploader(
            file: File(image.path),
            keyValue: recipeName,
            keyName: 'name',
            imgName: key + '_' + (index + 1).toString(),
            uuid: widget.uuid,
            clearRecost: key == 'i' ? clearIngs[index] : clearSteps[index],
            falseResp: () {
              if (mounted) {
                setState(() {
                  if (key == 'r') {
                    recipePic = null;
                    _imageFile = null;
                  } else if (key == 'i') {
                    ingredientPics[(index).toString()] = null;
                    _imageFile = null;
                  } else {
                    stepPics[(index).toString()] = null;
                    _imageFile = null;
                  }
                });
              }

              if (key + '_' + (index + 1).toString() == 'r_1') {
                if (mounted) {
                  setState(() {
                    isUpload = false;
                  });
                }
              }
            },
            trueResp: () {
              if (key + '_' + (index + 1).toString() == 'r_1') {
                if (mounted) {
                  setState(() {
                    isUpload = true;
                  });
                }
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
      ] else ...[
        if (isCompressed) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Text('Choose recipe image'),
              ),
              // SizedBox(height: 3 * kDefaultPadding,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: kDefaultPadding),
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
                      padding: EdgeInsets.all(size.width * 0.05),
                      icon: const Icon(Icons.camera_alt_rounded),
                      iconSize: 50.0,
                      onPressed: () =>
                          _pickImage(ImageSource.camera, key, index),
                    ),
                  ),
                  // SizedBox(height: kDefaultPadding,),
                  Container(
                    margin: const EdgeInsets.only(left: kDefaultPadding),
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
                      padding: EdgeInsets.all(size.width * 0.05),
                      icon: const Icon(Icons.photo_library_rounded),
                      iconSize: 50.0,
                      onPressed: () =>
                          _pickImage(ImageSource.gallery, key, index),
                    ),
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
          )
        ] else ...[
          Padding(
            padding: EdgeInsets.all(kDefaultPadding * 2),
            child: Center(
              child: const Text('Loading ...'),
            ),
          ),
        ],
      ]
    ];
    return upload;
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

  void changeFlavour(int index, String flav) {
    if (mounted) {
      setState(() {
        flavour = flav;
        selectedFlavour = index;
      });
    }
  }

  void changeCourse(int index, String cour) {
    if (mounted) {
      setState(() {
        course = cour;
        selectedCourse = index;
      });
    }
  }

  void changeMeal(int index, bool check) {
    if (mounted) {
      setState(() {
        mealType[index] = check;
      });
    }
    // print(course);
  }

  Widget mealCheckBox(int index, String flav) {
    return Padding(
      padding: const EdgeInsets.only(right: kDefaultPadding),
      child: OutlinedButton(
        onPressed: () => changeMeal(index, !mealType[index]),
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          padding: const EdgeInsets.all(15.0),
          side: BorderSide(
            color: mealType[index] ? kPrimaryColor : kDark,
            width: mealType[index] ? 2 : 1,
          ),
          backgroundColor: mealType[index]
              ? kPrimaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Text(flav),
      ),
    );
  }

  Widget flavourRadio(int index, String flav) {
    return Padding(
      padding: const EdgeInsets.only(right: kDefaultPadding),
      child: OutlinedButton(
        onPressed: () => changeFlavour(index, flav),
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          padding: const EdgeInsets.all(15.0),
          side: BorderSide(
            color: selectedFlavour == index ? kPrimaryColor : kDark,
            width: selectedFlavour == index ? 2 : 1,
          ),
          backgroundColor: selectedFlavour == index
              ? kPrimaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Text(flav),
      ),
    );
  }

  Widget courseRadio(int index, String cour) {
    return Padding(
      padding: const EdgeInsets.only(right: kDefaultPadding),
      child: OutlinedButton(
        onPressed: () => changeCourse(index, cour),
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          padding: const EdgeInsets.all(15.0),
          side: BorderSide(
            color: selectedCourse == index ? kPrimaryColor : kDark,
            width: selectedCourse == index ? 2 : 1,
          ),
          backgroundColor: selectedCourse == index
              ? kPrimaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Text(cour),
      ),
    );
  }

  List<Step> steps(Size size) => [
        Step(
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          title: const Text('Recipe'),
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: kDefaultPadding),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kPrimaryColor
                              : kDark[900]!),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
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
                ..._uploadImg(size, 'r', 0, recipePic)
              ],
            ),
          ),
        ),
        Step(
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          title: const Text('Tags'),
          // subtitle: Text('Images are optional',
          //           style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
          //             ? kDark
          //             : kDark[700]),),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                          if (mounted) {
                            setState(() {
                              isVeg = true;
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          padding: const EdgeInsets.all(15.0),
                          side: BorderSide(
                            color: isVeg ? Colors.green : kDark,
                            width: isVeg ? 2 : 1,
                          ),
                          backgroundColor: isVeg
                              ? kPrimaryColor.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: const Text('Veg'),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            isVeg = false;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        padding: const EdgeInsets.all(15.0),
                        side: BorderSide(
                          color: !isVeg ? Colors.red : kDark,
                          width: !isVeg ? 2 : 1,
                        ),
                        backgroundColor: !isVeg
                            ? kPrimaryColor.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: const Text('Non Veg'),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text('Meal Type'),
              ),

              // SizedBox(height: 3 * kDefaultPadding,),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      mealCheckBox(0, 'Lunch'),
                      mealCheckBox(1, 'Breakfast'),
                      mealCheckBox(2, 'Dinner'),
                      mealCheckBox(3, 'Craving'),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text('Flavour'),
              ),

              // SizedBox(height: 3 * kDefaultPadding,),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      flavourRadio(0, 'Spicy'),
                      flavourRadio(1, 'Sweet'),
                      flavourRadio(2, 'Sour'),
                      flavourRadio(3, 'Salty'),
                      flavourRadio(4, 'Bitter'),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text('Course'),
              ),

              // SizedBox(height: 3 * kDefaultPadding,),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      courseRadio(0, 'Snack'),
                      courseRadio(1, 'Starter'),
                      courseRadio(2, 'Farali'),
                      courseRadio(3, 'Main course'),
                      courseRadio(4, 'Dessert'),
                      courseRadio(5, 'Drinks'),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text('Cooking Time (HH : MM)'),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: kDark),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            value: hour,
                            items: hours.map((String i) {
                              return DropdownMenuItem(
                                value: i,
                                child: Text(i),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  hour = value!;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(15.0),
                            isExpanded: true),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: kDark),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            value: min,
                            items: minutes.map((String i) {
                              return DropdownMenuItem(
                                value: i,
                                child: Text(i),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  min = value!;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(15.0),
                            isExpanded: true),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          title: const Text('Ingredients'),
          subtitle: Text(
            'Images are optional',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? kDark
                    : kDark[700]),
          ),
          content: Column(
            children: [
              ..._getIngredient(size),
              GestureDetector(
                onTap: () {
                  int index = ingredientsList.length - 1;
                  ingredientsList.insert(index + 1, "");
                  ingredientPics[(index + 1).toString()] = '';
                  if (mounted) {
                    setState(() {
                      clearIngs[index + 1] = false;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? kDark[900]
                        : kLight,
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.transparent
                            : Color(0xFFE4E4E4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Add Ingredient'),
                      const SizedBox(width: 5.0),
                      Icon(Icons.add,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kPrimaryColor
                              : kPrimaryColorAccent),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 3,
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          title: const Text('Steps'),
          subtitle: Text(
            'Images are optional',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? kDark
                    : kDark[700]),
          ),
          content: Column(
            children: [
              ..._getRecipe(size),
              GestureDetector(
                onTap: () {
                  int index = stepsList.length - 1;
                  stepsList.insert(index + 1, "");
                  stepPics[(index + 1).toString()] = '';
                  if (mounted) {
                    setState(() {
                      clearSteps[index + 1] = false;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? kDark[900]
                        : kLight,
                    border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.transparent
                            : Color(0xFFE4E4E4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Add Step'),
                      const SizedBox(width: 5.0),
                      Icon(Icons.add,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kPrimaryColor
                              : kPrimaryColorAccent),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Step(
          isActive: _currentStep >= 4,
          state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          title: const Text('Description'),
          subtitle: Text(
            'You can also add hashtags and mentions',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? kDark
                    : kDark[700]),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Column(
              children: [
                TypeAheadFormField<String?>(
                  hideOnEmpty: true,
                  debounceDuration: const Duration(seconds: 1),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: kDefaultPadding),
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
                    _tagController.text = _appendHashtag(desc, v);
                    desc = _tagController.text;
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
          title: const Text('Youtube link'),
          subtitle: Text(
            'Namak Swaad Anusaar!  (Optional)',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? kDark
                    : kDark[700]),
          ),
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: kDefaultPadding),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kPrimaryColor
                              : kDark[900]!),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,

                  maxLines: null,
                  onChanged: (value) {
                    youtubeLink = value;
                  },
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      if (!RegExp(
                              r"http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?​=]*)?")
                          .hasMatch(val)) {
                        return 'Please enter a valid youtube link';
                      }
                    }
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
                const SizedBox(
                  width: 16,
                ),
                _addRemoveButtonR(i == 0, stepsList.length - 1, i),
              ],
            ),
            ..._uploadImg(size, 's', i, stepPics[i.toString()])
          ],
        ),
      ));
    }
    return recipeTextFields;
  }

  Widget _addRemoveButtonR(bool add, int index, int i) {
    return InkWell(
      onTap: () async {
        if (add) {
          stepsList.insert(index + 1, "");
          stepPics[(index + 1).toString()] = '';
          if (mounted) {
            setState(() {
              clearSteps[index + 1] = false;
            });
          }
          // print(_clearSteps);
        } else {
          stepsList.removeAt(i);
          stepPics[i.toString()] = '';
          await _clear('s', i, 's_${i + 1}', true);
          stepPics = await _adjustImages(i, stepPics, false, "s_");
          if (mounted) {
            setState(() {});
          }
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
                Expanded(
                    child: IngredientTextField(
                        index: i,
                        ingredientsList: ingredientsList,
                        newIngFlags: newIngFlags)),
                const SizedBox(
                  width: 16,
                ),
                _addRemoveButtonI(i == 0, ingredientsList.length - 1, i),
              ],
            ),
            ..._uploadImg(size, 'i', i, ingredientPics[i.toString()])
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
          ingredientPics[(index + 1).toString()] = '';
          if (mounted) {
            setState(() {
              clearIngs[index + 1] = false;
            });
          }
        } else {
          ingredientsList.removeAt(i);
          ingredientPics[i.toString()] = '';
          await _clear('i', i, 'i_${i + 1}', true);
          ingredientPics = await _adjustImages(i, ingredientPics, true, "i_");
          if (mounted) {
            setState(() {});
          }
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
    CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 80,
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
    setState(() {
      isCompressed = false;
    });
    if (key == 'r') {
      recipePic = (cropped != null) ? await compress(File(cropped.path)) : null;
      if (recipePic == null) {
        setState(() {
          isCompressed = true;
        });
      }
      _imageFile = null;
    } else if (key == 'i') {
      ingredientPics[(index).toString()] =
          (cropped != null) ? await compress(File(cropped.path)) : null;
      if (ingredientPics[(index).toString()] == null) {
        setState(() {
          isCompressed = true;
        });
      }
      _imageFile = null;
    } else {
      stepPics[(index).toString()] =
          (cropped != null) ? await compress(File(cropped.path)) : null;
      if (stepPics[(index).toString()] == null) {
        setState(() {
          isCompressed = true;
        });
      }
      _imageFile = null;
    }
    if (mounted) {
      setState(() {});
    }
    // if (mounted) {
    //   setState(() {
    //     if (key == 'r') {
    //       recipePic = File(cropped!.path);
    //       _imageFile = null;
    //     } else if (key == 'i') {
    //       ingredientPics[(index).toString()] = cropped;
    //       _imageFile = null;
    //     } else {
    //       stepPics[(index).toString()] = cropped;
    //       _imageFile = null;
    //     }
    //   });
    // }
    // _imageFile = await compress(_imageFile!);
    // print(_imageFile!.lengthSync());
    // setState(() {});
  }

  Future<File> compress(File image1) async {
    while (image1.lengthSync() > 200000) {
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
  Future<void> _pickImage(ImageSource source, key, index) async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      XFile? selected = await ImagePicker().pickImage(source: source);
      if (selected == null) return;
      if (mounted) {
        setState(() {
          _imageFile = File(selected.path);
          _cropImage(key, index);
        });
      }
    }
  }

  /// Remove image
  Future<void> _clear(key, index, imgName, [clearRecost = false]) async {
    if (key == 'r') {
      if (mounted) {
        setState(() {
          recipePic = null;
          isUpload = false;
        });
      }

      var token = await storage.read(key: "token");
      // print(formData.files[0]);
      await dio.post(
          // 'https://api-tassie.herokuapp.com/drive/upload',
          'https://api-tassie.herokuapp.com/recs/resetImage/',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
          data: {'uuid': widget.uuid, 'imgName': imgName});
    } else if (key == 'i') {
      if (mounted) {
        setState(() {
          ingredientPics[(index).toString()] = '';
          if (clearRecost) {
            clearIngs[index] = true;
          }
        });
      }
      var token = await storage.read(key: "token");
      // print(formData.files[0]);
      await dio.post(
          // 'https://api-tassie.herokuapp.com/drive/upload',
          'https://api-tassie.herokuapp.com/recs/resetImage/',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
          data: {'uuid': widget.uuid, 'imgName': imgName});
    } else {
      if (mounted) {
        setState(() {
          stepPics[(index).toString()] = '';
          if (clearRecost) {
            clearSteps[index] = true;
          }
        });
      }

      var token = await storage.read(key: "token");
      // print(formData.files[0]);
      await dio.post(
          // 'https://api-tassie.herokuapp.com/drive/upload',
          'https://api-tassie.herokuapp.com/recs/resetImage/',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
          data: {'uuid': widget.uuid, 'imgName': imgName});
    }
  }

  Future<Map> _adjustImages(
      int index, Map x, bool isIngredient, String key) async {
    // print('hfsdjsndfsdkfj');
    // print(x['0'].path);
    int l = x.length;
    Map send = {};
    // print(x);
    // print("index");
    // print(index+1);
    for (int j = index; j < l - 1; j++) {
      // print('----------------------------------');
      x[j.toString()] = x[(j + 1).toString()];
      if (x[(j + 1).toString()] != '') {
        // print(x[(j+1).toString()]);
        send[key + (j + 1).toString() + p.extension(x[(j).toString()].path)] =
            key + (j + 2).toString() + p.extension(x[(j + 1).toString()].path);
      }
      // print(x);
    }
    x.remove((l - 1).toString());
    // print(x);
    try {
      var token = await storage.read(key: "token");
      // print("index");
      // print(index+1);
      // print("length");
      // print(l);
      // print("send");
      // print(send);
      if (send.isNotEmpty) {
        Response response = await dio.post(
          // 'https://api-tassie.herokuapp.com/drive/upload',
          'https://api-tassie.herokuapp.com/recs/renameImages',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${token!}"
          }),
          data: {
            "index": index + 1,
            "isIngredient": isIngredient,
            "recipeUuid": widget.uuid,
            "length": l,
            "renameMap": send
          },
        );
        if (response.data["status"] == false) {
          // await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return {};
          showSnack(context, "Oops something went wrong. Please try again!",
              () {}, "OK", 4);
        }
      }
      return x;
    } catch (e) {
      showSnack(context, "Oops something went wrong. Please try again!", () {},
          "OK", 4);
      return x;
    }
  }

  double progress = 0.0;

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
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            actionsPadding: const EdgeInsets.all(20.0),
            title: const Text('Are you sure?'),
            content: const Text('Do you want to go back'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No"),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  Provider.of<LeftSwipe>(context, listen: false).setSwipe(true);
                  // Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context, rootNavigator: true)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return const Home();
                  }));
                  var url =
                      "https://api-tassie.herokuapp.com/recs/deleteRecipe";
                  var token = await storage.read(key: "token");
                  Response response = await dio.post(url,
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer ${token!}"
                      }),
                      data: {
                        'uuid': widget.uuid,
                        // 'folder': widget.folder
                      });
                  if (response.data['status'] == true) {
                  } else {
                    // await Future.delayed(const Duration(seconds: 1));
                    if (!mounted) return;
                    showSnack(
                        context,
                        "Oops something went wrong. Please try again!",
                        () {},
                        "OK",
                        4);
                  }
                },
                child: const Text("Yes"),
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
          foregroundColor: Theme.of(context).brightness == Brightness.dark
              ? kLight
              : kDark[900],
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).scaffoldBackgroundColor,
              statusBarIconBrightness:
                  Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light),
          title: const Text(
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
              physics: const ClampingScrollPhysics(),
              type: StepperType.vertical,
              onStepTapped: (value) => {},
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final isLastStep = _currentStep == steps(size).length - 1;
                return Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: details.onStepContinue,
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? kDark[900]
                                  : kPrimaryColor,
                          primary:
                              Theme.of(context).brightness == Brightness.dark
                                  ? kPrimaryColor
                                  : kLight),
                      child: Text(isLastStep ? 'UPLOAD' : 'NEXT'),
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
                final isLastStep = _currentStep == steps(size).length - 1;
                if (isLastStep) {
                  if (_formKey.currentState!.validate() && isUpload) {
                    if (hour != null && min != null) {
                      if (hour == '0' && min == '00') {
                        showSnack(
                            context,
                            'Cooking time cannot be 0:00, Are you cooking at light\'s speed xD?',
                            () {},
                            'OK',
                            4);
                      } else {
                        // to submit here
                        var url =
                            "https://api-tassie.herokuapp.com/recs/updateRecipe";
                        var token = await storage.read(key: "token");
                        await dio.post(url,
                            options: Options(headers: {
                              HttpHeaders.contentTypeHeader: "application/json",
                              HttpHeaders.authorizationHeader:
                                  "Bearer ${token!}"
                            }),
                            data: {
                              'uuid': widget.uuid,
                              // 'folder': widget.folder,
                              'youtubeLink': youtubeLink
                            });
                        // await Future.delayed(const Duration(seconds: 1));
                        if (!mounted) return;

                        Provider.of<LeftSwipe>(context, listen: false)
                            .setSwipe(true);
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const Home();
                          }),
                        );
                      }
                    } else {
                      showSnack(context, 'Add cooking time', () {}, 'OK', 4);
                    }
                  } else {
                    showSnack(
                        context,
                        'Check missing ingredients or steps or recipe image!',
                        () {},
                        'OK',
                        4);
                  }
                } else {
                  if (mounted) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }
                  if (_currentStep == 1) {
                    var url =
                        "https://api-tassie.herokuapp.com/recs/updateRecipe";
                    var token = await storage.read(key: "token");
                    await dio.post(url,
                        options: Options(headers: {
                          HttpHeaders.contentTypeHeader: "application/json",
                          HttpHeaders.authorizationHeader: "Bearer ${token!}"
                        }),
                        data: {
                          'uuid': widget.uuid,
                          // 'folder': widget.folder,
                          'name': recipeName
                        });
                  }
                  if (_currentStep == 2) {
                    if (hour != null && min != null) {
                      if (hour == '0' && min == '00') {
                        // await Future.delayed(const Duration(seconds: 1));
                        if (!mounted) return;
                        showSnack(
                            context,
                            'Cooking time cannot be 0:00, Are you cooking at light\'s speed xD?',
                            () {},
                            'OK',
                            4);
                      } else {
                        var url =
                            "https://api-tassie.herokuapp.com/recs/updateRecipe";
                        var token = await storage.read(key: "token");
                        var time = int.parse(hour) * 60 + int.parse(min);
                        await dio.post(url,
                            options: Options(headers: {
                              HttpHeaders.contentTypeHeader: "application/json",
                              HttpHeaders.authorizationHeader:
                                  "Bearer ${token!}"
                            }),
                            data: {
                              'uuid': widget.uuid,
                              // 'folder': widget.folder,
                              'flavour': flavour,
                              'veg': isVeg,
                              'course': course,
                              'estimatedTime': time,
                              'isLunch': mealType[0],
                              'isBreakfast': mealType[1],
                              'isDinner': mealType[2],
                              'isCraving': mealType[3]
                            });
                      }
                    } else {
                      // await Future.delayed(const Duration(seconds: 1));
                      if (!mounted) return;
                      showSnack(context, 'Add cooking time', () {}, 'OK', 4);
                    }
                  }
                  if (_currentStep == 3) {
                    var url =
                        "https://api-tassie.herokuapp.com/recs/updateRecipe";
                    var token = await storage.read(key: "token");
                    await dio.post(url,
                        options: Options(headers: {
                          HttpHeaders.contentTypeHeader: "application/json",
                          HttpHeaders.authorizationHeader: "Bearer ${token!}"
                        }),
                        data: {
                          'uuid': widget.uuid,
                          // 'folder': widget.folder,
                          'ingredients':
                              ingredientsList == [null] ? [] : ingredientsList,
                          'newIngFlags': newIngFlags
                        });
                  }
                  if (_currentStep == 4) {
                    var url =
                        "https://api-tassie.herokuapp.com/recs/updateRecipe";
                    var token = await storage.read(key: "token");
                    await dio.post(url,
                        options: Options(headers: {
                          HttpHeaders.contentTypeHeader: "application/json",
                          HttpHeaders.authorizationHeader: "Bearer ${token!}"
                        }),
                        data: {
                          'uuid': widget.uuid,
                          // 'folder': widget.folder,
                          'steps': stepsList == [null] ? [] : stepsList
                        }); // 'folder': widget.folder,
                  }
                  if (_currentStep == 5) {
                    var url =
                        "https://api-tassie.herokuapp.com/recs/addHashtag";
                    var token = await storage.read(key: "token");
                    await dio.post(url,
                        options: Options(headers: {
                          HttpHeaders.contentTypeHeader: "application/json",
                          HttpHeaders.authorizationHeader: "Bearer ${token!}"
                        }),
                        data: {
                          'uuid': widget.uuid,
                          // 'folder': widget.folder,
                          'desc': desc
                        }); // 'folder': widget.folder,
                  }
                }
              },
              onStepCancel: () {
                _currentStep == 0
                    ? null
                    : (mounted)
                        ? setState(() {
                            _currentStep -= 1;
                          })
                        : null;
              },
              steps: steps(size),
            ),
          ),
        ),
      ),
    );
  }
}
