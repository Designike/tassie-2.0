import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../constants.dart';
import '../../../../utils/ingredient_data.dart';

class IngredientTextField extends StatefulWidget {
  late final int? index;
  final List ingredientsList;
  final Map newIngFlags;
  IngredientTextField({this.index, required this.ingredientsList, Key? key, required this.newIngFlags})
      : super(key: key);
  @override
  IngredientTextFieldState createState() => IngredientTextFieldState();
}

class IngredientTextFieldState extends State<IngredientTextField> {
  // late TextEditingController _ingredientController;
  final TextEditingController _ingredientController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // _ingredientController = TextEditingController();
    _ingredientController.selection = TextSelection.fromPosition(
        TextPosition(offset: _ingredientController.text.length));
    // _ingredientController.text = widget.ingredientsList[widget.index!];
  }

  @override
  void dispose() {
    // _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool index;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
        ),
        itemBuilder: (context, String? suggestion) => ListTile(
              title: Text(suggestion!),
            ),
        onSuggestionSelected: (String? v) {
          // setState(() {
          widget.ingredientsList[widget.index!] = v;
          widget.newIngFlags.remove(widget.index!);
          // print(_ingredientController.text);
          // });
        },
        validator: (v) {
          if (v!.trim().isEmpty) return 'Please enter something';
          return null;
        },
        noItemsFoundBuilder: (contxt) {
          var localizedMessage =
              "Type your own ingredient, we would be glad to add it to our list!";

          widget.newIngFlags[widget.index!] = widget.ingredientsList[widget.index!];

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 8,
            ),
            child: Text(localizedMessage, style: const TextStyle(color: kDark)),
          );
        });
  }
}
