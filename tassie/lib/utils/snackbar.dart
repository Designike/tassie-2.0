// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

void showSnack(BuildContext context, String message, void Function() onClick, String closeButtonText, int seconds) {
  final snackbar = SnackBar(
    backgroundColor: kPrimaryColor,

    content: Text(message, textAlign: TextAlign.center, style: TextStyle(color: kDark[900]),),
    duration: Duration(seconds: seconds),
    shape: StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(kDefaultPadding * 2),
    action: SnackBarAction(label: closeButtonText, onPressed: onClick, textColor: kDark[900],),
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}