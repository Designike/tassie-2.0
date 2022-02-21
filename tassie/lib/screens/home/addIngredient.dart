// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../constants.dart';
import 'ingredient_data.dart';

class IngredientTextField extends StatefulWidget {
  late final int? index;
  final List ingredientsList;
  IngredientTextField({this.index, required this.ingredientsList});
  @override
  _IngredientTextFieldState createState() => _IngredientTextFieldState();
}

class _IngredientTextFieldState extends State<IngredientTextField> {
  // late TextEditingController _ingredientController;
  @override
  void initState() {
    super.initState();
    // _ingredientController = TextEditingController();
  }

  @override
  void dispose() {
    // _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool index;
    final TextEditingController _ingredientController = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _ingredientController.text = widget.ingredientsList[widget.index!] ?? '';
    });
    // return TextFormField(
    //   controller: _ingredientController,
    //   onChanged: (v) => widget.ingredientsList[widget.index!] = v,
    //   decoration: InputDecoration(
    //     labelText: 'Add Ingredient',
    //     labelStyle: TextStyle(
    //       fontFamily: 'Raleway',
    //       fontSize: 20.0,
    //       color: kDark[800]!.withOpacity(0.5),
    //       fontWeight: FontWeight.w500,
    //     ),
    //     focusedBorder: UnderlineInputBorder(
    //       borderSide: BorderSide(color: kPrimaryColor),
    //     ),
    //   ),
    //   validator: (v) {
    //     if (v!.trim().isEmpty) return 'Please enter something';
    //     return null;
    //   },
    // );
    return TypeAheadFormField<String?>(
      // direction: AxisDirection.up,
      autoFlipDirection: true,
      suggestionsCallback: IngredientData.getSuggestions,
      textFieldConfiguration: TextFieldConfiguration(
        controller: _ingredientController,
        onChanged: (v) => widget.ingredientsList[widget.index!] = v,
        decoration: InputDecoration(
          labelText: 'Add Ingredient',
          labelStyle: TextStyle(
            // fontFamily: 'Raleway',
            fontSize: 16.0,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
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
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? kPrimaryColor
                        : kDark[900]!),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      itemBuilder: (context, String? suggestion) => ListTile(
        title: Text(suggestion!),
      ),
      onSuggestionSelected: (String? v) {
        // setState(() {
        widget.ingredientsList[widget.index!] = v;
        // print(_ingredientController.text);
        // });
      },
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
