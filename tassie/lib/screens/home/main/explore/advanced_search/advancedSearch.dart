import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/explore/advanced_search/advancedSearchResults.dart';
import 'package:tassie/utils/ingredient_data.dart';
import 'package:tassie/utils/snackbar.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({Key? key}) : super(key: key);

  @override
  AdvancedSearchState createState() => AdvancedSearchState();
}

class AdvancedSearchState extends State<AdvancedSearch> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tagController = TextEditingController();
  int isVeg = 2;
  int selectedFlavour = 5;
  int selectedCourse = 6;
  String flavour = "";
  String course = "";
  int selectedMeal = 4;
  List<bool> mealType = [false, false, false, false];
  List<String> hours = ['0', '1', '2', '3'];
  final minutes = ['00', '15', '30', '45'];
  String hour = '0';
  String min = '00';
  List ingredients = [];
  final storage = const FlutterSecureStorage();
  final dio = Dio();
  Map data = {
    'ingredients': [],
  };

  // void addKey(key,value) {
  //   data[key] = value;
  // }

  void changeFlavour(int index, String flav) {
    if (mounted) {
      setState(() {
        flavour = flav;
        selectedFlavour = index;
        data['flavour'] = flav;
        // print(data);
      });
    }
  }

  void changeCourse(int index, String cour) {
    if (mounted) {
      setState(() {
        course = cour;
        selectedCourse = index;
        data['course'] = cour;
        // print(data);
      });
    }
  }

  // void changeMeal(int index, String m) {
  //   if (mounted) {
  //     setState(() {
  //       // mealType[index] = check;
  //       meal = List.filled(4, false);
  //       meal[index] = true;
  //       selectedMeal = index;
  //       data['meal'] = meal;
  //     });
  //   }
  //   // print(course);
  // }
  void changeMeal(int index, bool check) {
    if (mounted) {
      setState(() {
        mealType[index] = check;
        data['meal'] = mealType;
        // print(data);
      });
    }
    // print(course);
  }

  Widget mealCheckBox(int index, String flav) {
    return Padding(
      padding: const EdgeInsets.only(
          right: kDefaultPadding, bottom: kDefaultPadding),
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
  // Widget mealRadio(int index, String m) {
  //   return Padding(
  //     padding: const EdgeInsets.only(right: kDefaultPadding, top: 10.0),
  //     child: OutlinedButton(
  //       onPressed: () => changeMeal(index, m),
  //       style: OutlinedButton.styleFrom(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  //         padding: const EdgeInsets.all(15.0),
  //         side: BorderSide(
  //           color: selectedMeal == index ? kPrimaryColor : kDark,
  //           width: selectedMeal == index ? 2 : 1,
  //         ),
  //         backgroundColor: selectedMeal == index
  //             ? kPrimaryColor.withOpacity(0.1)
  //             : Colors.transparent,
  //       ),
  //       child: Text(m),
  //     ),
  //   );
  // }

  Widget flavourRadio(int index, String flav) {
    return Padding(
      padding: const EdgeInsets.only(right: kDefaultPadding, top: 10.0),
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
      padding: const EdgeInsets.only(right: kDefaultPadding, top: 10.0),
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

  Widget newIngredient(int index, String ing) {
    return Stack(
      children: [
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () => _removeIngredient(index),
            child: ClipOval(
              child: Container(
                padding: const EdgeInsets.all(1.0),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    color: kPrimaryColor,
                    child: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding, top: 10.0),
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              padding: const EdgeInsets.all(15.0),
              side: const BorderSide(
                color: kDark,
                width: 1,
              ),
              backgroundColor: Colors.transparent,
            ),
            child: Text(ing),
          ),
        ),
      ],
    );
  }

  void _appendIngredient(ing) {
    // String desc1 = desc;
    if (!ingredients.contains(ing)) {
      if (mounted) {
        setState(() {
          ingredients.add(ing);
        });
      }
    }
  }

  void _removeIngredient(ind) {
    // String desc1 = desc;
    if (mounted) {
      setState(() {
        ingredients.removeAt(ind);
      });
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight * 1.1,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light),
        title: const Text(
          'What all you got?',
          style: TextStyle(
            color: kPrimaryColor,
            fontFamily: 'LobsterTwo',
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(kDefaultPadding * 1.5),
          children: [
            const Text(
              'Can\'t decide what to eat? We have got you! \nApply your filters, and get ready for some yumminess.',
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) {
                    return Scaffold(
                      // backgroundColor: Colors.white,
                      body: Container(
                        // width: size.width,
                        // height: size.height,
                        child: TextLiquidFill(
                          text: 'Tassie',
                          boxHeight: size.height,
                          boxWidth: size.width,
                          waveColor: kPrimaryColor,
                          loadDuration: Duration(seconds: 3),
                          boxBackgroundColor: kDark[900]!,
                          textStyle: const TextStyle(
                            fontSize: 56.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "LobsterTwo",
                          ),
                        ),
                      ),
                    );
                  }),
                );
                // await Future.delayed(Duration(milliseconds: 500));
                var token = await storage.read(key: "token");
                // print(formData.files[0]);
                // print(flavour);
                Response response = await dio.post(
                    // 'https://api-tassie.herokuapp.com/drive/upload',
                    'https://api-tassie.herokuapp.com/search/guess',
                    options: Options(headers: {
                      HttpHeaders.contentTypeHeader: "application/json",
                      HttpHeaders.authorizationHeader: "Bearer ${token!}"
                    }),
                    data: {
                      'ingredients': [],
                      'meal': [false, false, false, false],
                    });
                // print(response);
                var id = response.data['data']['id'];
                if (response.data != null) {
                  if (response.data['data']['id'] != null) {
                    await Future.delayed(const Duration(milliseconds: 1000));

                    if (!mounted) return;
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return AdvancedSearchResults(suggestionID: id);
                      }),
                    );
                  } else {
                    // await Future.delayed(const Duration(seconds: 1));

                    if (!mounted) return;
                    Navigator.of(context, rootNavigator: true).pop();
                    showSnack(context, 'No results found.', () {}, 'OK', 3);
                  }
                } else {
                  // await Future.delayed(const Duration(seconds: 1));

                  if (!mounted) return;
                  showSnack(context, 'Some error occured. Try again!', () {},
                      'OK', 3);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? kDark[900]
                    : kPrimaryColor,
                primary: Theme.of(context).brightness == Brightness.dark
                    ? kPrimaryColor
                    : kLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: const Text('Suggest trending recipes'),
              ),
            ),
            SizedBox(
              height: 2 * kDefaultPadding,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Advanced Search',
                style: TextStyle(fontSize: 22, color: kPrimaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: kDefaultPadding, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Category'),
                  TextButton(
                    onPressed: () {
                      // change data - remove veg
                      if (data['veg'] != null) {
                        data.remove('veg');
                      }
                      print(data);
                      setState(() {
                        isVeg = 2;
                      });
                    },
                    style: TextButton.styleFrom(
                        // backgroundColor:
                        // Theme.of(context).brightness == Brightness.dark
                        //     ? kDark[900]
                        //     : kPrimaryColor,
                        primary: Theme.of(context).brightness == Brightness.dark
                            ? kPrimaryColor
                            : kLight),
                    child: Text('Reset'),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 3 * kDefaultPadding,),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: kDefaultPadding),
                  child: OutlinedButton(
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          isVeg = 0;
                          data['veg'] = true;
                        });
                        print(data);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      padding: const EdgeInsets.all(15.0),
                      side: BorderSide(
                        color: isVeg == 0 ? Colors.green : kDark,
                        width: isVeg == 0 ? 2 : 1,
                      ),
                      backgroundColor: isVeg == 0
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
                        isVeg = 1;
                        if (data['veg'] != null) {
                          data['veg'] = false;
                        }
                      });
                      print(data);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    padding: const EdgeInsets.all(15.0),
                    side: BorderSide(
                      color: isVeg == 1 ? Colors.red : kDark,
                      width: isVeg == 1 ? 2 : 1,
                    ),
                    backgroundColor: isVeg == 1
                        ? kPrimaryColor.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: const Text('Non Veg'),
                ),
              ],
            ),
            // SizedBox(
            //   height: kDefaultPadding,
            // ),
            Padding(
              padding: EdgeInsets.only(top: kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Meal Type'),
                  TextButton(
                    onPressed: () {
                      // change data - set meal to false * 4
                      if (data['meal'] != null) {
                        data['meal'] = [false, false, false, false];
                      }
                      setState(() {
                        mealType = [false, false, false, false];
                      });
                      print(data);
                    },
                    style: TextButton.styleFrom(
                        // backgroundColor:
                        // Theme.of(context).brightness == Brightness.dark
                        //     ? kDark[900]
                        //     : kPrimaryColor,
                        primary: Theme.of(context).brightness == Brightness.dark
                            ? kPrimaryColor
                            : kLight),
                    child: Text('Reset'),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 3 * kDefaultPadding,),
            Wrap(
              children: [
                mealCheckBox(0, 'Breakfast'),
                mealCheckBox(1, 'Lunch'),
                mealCheckBox(2, 'Dinner'),
                mealCheckBox(3, 'Craving'),
              ],
            ),
            // SizedBox(
            //   height: kDefaultPadding,
            // ),
            Padding(
              padding: EdgeInsets.only(top: kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Flavour'),
                  TextButton(
                    onPressed: () {
                      // change data - remove veg
                      if (data['flavour'] != null) {
                        data.remove('flavour');
                      }
                      setState(() {
                        selectedFlavour = 5;
                      });
                      print(data);
                    },
                    style: TextButton.styleFrom(
                        // backgroundColor:
                        // Theme.of(context).brightness == Brightness.dark
                        //     ? kDark[900]
                        //     : kPrimaryColor,
                        primary: Theme.of(context).brightness == Brightness.dark
                            ? kPrimaryColor
                            : kLight),
                    child: Text('Reset'),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 3 * kDefaultPadding,),
            Wrap(
              children: [
                flavourRadio(0, 'Spicy'),
                flavourRadio(1, 'Sweet'),
                flavourRadio(2, 'Sour'),
                flavourRadio(3, 'Salty'),
                flavourRadio(4, 'Bitter'),
              ],
            ),
            // SizedBox(
            //   height: kDefaultPadding,
            // ),
            Padding(
              padding: EdgeInsets.only(top: kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Course'),
                  TextButton(
                    onPressed: () {
                      // change data - remove course
                      if (data['course'] != null) {
                        data.remove('course');
                      }
                      setState(() {
                        selectedCourse = 6;
                      });
                      print(data);
                    },
                    style: TextButton.styleFrom(
                        // backgroundColor:
                        // Theme.of(context).brightness == Brightness.dark
                        //     ? kDark[900]
                        //     : kPrimaryColor,
                        primary: Theme.of(context).brightness == Brightness.dark
                            ? kPrimaryColor
                            : kLight),
                    child: Text('Reset'),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 3 * kDefaultPadding,),
            Wrap(
              children: [
                courseRadio(0, 'Snack'),
                courseRadio(1, 'Starter'),
                courseRadio(2, 'Farali'),
                courseRadio(3, 'Main course'),
                courseRadio(4, 'Dessert'),
                courseRadio(5, 'Drinks'),
              ],
            ),
            // SizedBox(
            //   height: kDefaultPadding,
            // ),
            Padding(
              padding: EdgeInsets.only(top: kDefaultPadding, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cooking Time (HH : MM)'),
                  TextButton(
                    onPressed: () {
                      // change data - remove maxTime
                      if (data['maxTime'] != null) {
                        data.remove('maxTime');
                      }
                      setState(() {
                        hour = '0';
                        min = '00';
                      });
                      print(data);
                    },
                    style: TextButton.styleFrom(
                        // backgroundColor:
                        // Theme.of(context).brightness == Brightness.dark
                        //     ? kDark[900]
                        //     : kPrimaryColor,
                        primary: Theme.of(context).brightness == Brightness.dark
                            ? kPrimaryColor
                            : kLight),
                    child: Text('Reset'),
                  ),
                ],
              ),
            ),
            Row(
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
            const Padding(
              padding: EdgeInsets.only(top: kDefaultPadding, bottom: 10.0),
              child: Text('What all ingredients do you have?'),
            ),
            Padding(
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
                    suggestionsCallback: IngredientData.getSuggestions,
                    textFieldConfiguration: TextFieldConfiguration(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _tagController,
                      onChanged: (v) {},
                      decoration: InputDecoration(
                        labelText: 'Add Ingredient',
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
                      // setState(() {
                      _appendIngredient(v);
                      _tagController.text = "";
                      // });
                    },
                    validator: (val) => val!.isEmpty || val.length > 500
                        ? 'Description should be within 500 characters'
                        : null,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Wrap(
                children: [
                  for (int i = 0; i < ingredients.length; i++) ...[
                    newIngredient(i, ingredients[i])
                  ],
                ],
              ),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),

            TextButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) {
                    return Scaffold(
                      // backgroundColor: Colors.white,
                      body: Container(
                        // width: size.width,
                        // height: size.height,
                        child: TextLiquidFill(
                          text: 'Tassie',
                          boxHeight: size.height,
                          boxWidth: size.width,
                          waveColor: kPrimaryColor,
                          loadDuration: Duration(seconds: 3),
                          boxBackgroundColor: kDark[900]!,
                          textStyle: const TextStyle(
                            fontSize: 56.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "LobsterTwo",
                          ),
                        ),
                      ),
                    );
                  }),
                );
                // await Future.delayed(Duration(milliseconds: 500));
                var token = await storage.read(key: "token");
                // print(formData.files[0]);
                // print(flavour);
                Response response = await dio.post(
                    // 'https://api-tassie.herokuapp.com/drive/upload',
                    'https://api-tassie.herokuapp.com/search/guess',
                    options: Options(headers: {
                      HttpHeaders.contentTypeHeader: "application/json",
                      HttpHeaders.authorizationHeader: "Bearer ${token!}"
                    }),
                    data: data);
                // print(response);
                var id = response.data['data']['id'];
                if (response.data != null) {
                  if (response.data['status'] == true) {
                    if (response.data['data']['id'] != null) {
                      await Future.delayed(const Duration(milliseconds: 1000));

                      if (!mounted) return;
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return AdvancedSearchResults(suggestionID: id);
                        }),
                      );
                    } else {
                      // await Future.delayed(const Duration(seconds: 1));

                      if (!mounted) return;
                      Navigator.of(context, rootNavigator: true).pop();
                      showSnack(
                          context,
                          'No results found. Try some other combination!',
                          () {},
                          'OK',
                          3);
                    }
                  } else {
                    // await Future.delayed(const Duration(seconds: 1));

                    if (!mounted) return;
                    showSnack(
                        context, response.data['message'], () {}, 'OK', 3);
                  }
                } else {
                  // await Future.delayed(const Duration(seconds: 1));

                  if (!mounted) return;
                  showSnack(context, 'Some error occured. Try again!', () {},
                      'OK', 3);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? kDark[900]
                    : kPrimaryColor,
                primary: Theme.of(context).brightness == Brightness.dark
                    ? kPrimaryColor
                    : kLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: const Text('Find Recipes'),
              ),
            ),
            const SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }
}
