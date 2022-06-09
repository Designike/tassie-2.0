import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  bool isVeg = true;
  int selectedFlavour = 0;
  int selectedCourse = 0;
  String flavour = "Spicy";
  String course = "Snack";
  int selectedMeal = 0;
  List<bool> meal = [true, false, false, false];
  List<String> hours = ['0', '1', '2', '3'];
  final minutes = ['00', '15', '30', '45'];
  String hour = '1';
  String min = '00';
  List ingredients = [];
  final storage = const FlutterSecureStorage();
  final dio = Dio();
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

  void changeMeal(int index, String m) {
    if (mounted) {
      setState(() {
        // mealType[index] = check;
        meal = List.filled(4, false);
        meal[index] = true;
        selectedMeal = index;
      });
    }
    // print(course);
  }

  Widget mealRadio(int index, String m) {
    return Padding(
      padding: const EdgeInsets.only(right: kDefaultPadding, top: 10.0),
      child: OutlinedButton(
        onPressed: () => changeMeal(index, m),
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          padding: const EdgeInsets.all(15.0),
          side: BorderSide(
            color: selectedMeal == index ? kPrimaryColor : kDark,
            width: selectedMeal == index ? 2 : 1,
          ),
          backgroundColor: selectedMeal == index
              ? kPrimaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Text(m),
      ),
    );
  }

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
            // SizedBox(
            //   height: 2 * kDefaultPadding,
            // ),
            const Padding(
              padding: EdgeInsets.only(top: kDefaultPadding, bottom: 10.0),
              child: Text('Category'),
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
            // SizedBox(
            //   height: kDefaultPadding,
            // ),
            const Padding(
              padding: EdgeInsets.only(top: kDefaultPadding),
              child: Text('Meal Type'),
            ),

            // SizedBox(height: 3 * kDefaultPadding,),
            Wrap(
              children: [
                mealRadio(0, 'Breakfast'),
                mealRadio(1, 'Lunch'),
                mealRadio(2, 'Dinner'),
                mealRadio(3, 'Craving'),
              ],
            ),
            // SizedBox(
            //   height: kDefaultPadding,
            // ),
            const Padding(
              padding: EdgeInsets.only(top: kDefaultPadding),
              child: Text('Flavour'),
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
            const Padding(
              padding: EdgeInsets.only(top: kDefaultPadding),
              child: Text('Course'),
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
            const Padding(
              padding: EdgeInsets.only(top: kDefaultPadding, bottom: 10.0),
              child: Text('Cooking Time (HH : MM)'),
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
                      body: Center(
                          // child: AnimatedTextKit(
                          //   pause: Duration(milliseconds: 100),
                          //   animatedTexts: [
                          //     FadeAnimatedText('Finding Trivets'),
                          //     FadeAnimatedText('Settling grubs'),
                          //     FadeAnimatedText('Hoarding stuff'),
                          //   ],
                          // ),
                          child: SizedBox(
                        width: size.width,
                        height: size.height,
                        child: TextLiquidFill(
                          text: 'Tassie',
                          waveColor: kPrimaryColor,
                          boxBackgroundColor: kDark[900]!,
                          textStyle: const TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "LobsterTwo",
                          ),
                          boxHeight: 300.0,
                        ),
                      )),
                    );
                  }),
                );
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
                      'veg': isVeg,
                      'flavour': flavour,
                      'course': course,
                      'maxTime': int.parse(hour) * 60 + int.parse(min),
                      'ingredients': ingredients,
                      'meal': meal,
                    });
                // print(response);
                var id = response.data['data']['id'];
                await Future.delayed(const Duration(seconds: 1));
                if (response.data != null) {
                  if (response.data['data']['id'] != null) {
                    await Future.delayed(const Duration(seconds: 1));

                    if (!mounted) return;
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return AdvancedSearchResults(suggestionID: id);
                      }),
                    );
                  } else {
                    await Future.delayed(const Duration(seconds: 1));

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
                  await Future.delayed(const Duration(seconds: 1));

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
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Text('Find Recipes'),
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
