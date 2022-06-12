import 'package:flutter/material.dart';

import '../../../../constants.dart';

class StepTextField extends StatefulWidget {
  late final int? index;
  final List stepsList;
  StepTextField({this.index, required this.stepsList, Key? key})
      : super(key: key);
  @override
  StepTextFieldState createState() => StepTextFieldState();
}

class StepTextFieldState extends State<StepTextField> {
  // late TextEditingController _stepController;
  final TextEditingController _stepController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // _stepController = TextEditingController();
    _stepController.selection = TextSelection.fromPosition(
        TextPosition(offset: _stepController.text.length));
    // _stepController.text = widget.stepsList[widget.index!];
  }

  @override
  void dispose() {
    // _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stepController.text = widget.stepsList[widget.index!] ?? '';
    });
    // return TextFormField(
    //   controller: _stepController,
    //   onChanged: (v) => widget.stepsList[widget.index!] = v,
    //   decoration: InputDecoration(
    //     labelText: 'Add Step',
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
    return TextFormField(
      controller: _stepController,
      onChanged: (v) => widget.stepsList[widget.index!] = v,
      decoration: InputDecoration(
        labelText: 'Add Step',
        labelStyle: TextStyle(
          // fontFamily: 'Raleway',
          fontSize: 16.0,
          color: Theme.of(context).brightness == Brightness.dark
              ? kPrimaryColor
              : kDark[900],
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25.0, vertical: kDefaultPadding),
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
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
