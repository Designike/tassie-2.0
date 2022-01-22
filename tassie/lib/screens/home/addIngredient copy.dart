
import 'package:flutter/material.dart';

import '../../constants.dart';

class IngredientTextField extends StatefulWidget {
  late final int? index;
  final List ingredientsList;
  IngredientTextField({this.index, required this.ingredientsList});
  @override
  _IngredientTextFieldState createState() => _IngredientTextFieldState();
}

class _IngredientTextFieldState extends State<IngredientTextField> {
  late TextEditingController _ingredientController;
  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _ingredientController.text =
          widget.ingredientsList[widget.index!] ?? '';
    });
    return TextFormField(
      controller: _ingredientController,
      onChanged: (v) => widget.ingredientsList[widget.index!] = v,
      decoration: InputDecoration(
        labelText: 'Add Ingredient',
        labelStyle: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 20.0,
          color: kDark[800]!.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}