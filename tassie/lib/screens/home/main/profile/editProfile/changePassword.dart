import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/utils/snackbar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // bool uniqueUsername = false;
  final _formKey = GlobalKey<FormState>();
  String oldpass = "";
  String newpass = "";
  // Future<void> checkUsername(username) async {
  //   var dio = Dio();
  //   // print(username);
  //   try {
  //     // print('');
  //     Response response =
  //         await dio.get("https://api-tassie.herokuapp.com/user/username/" + username);
  //     // var res = jsonDecode(response.toString());

  //     // if(response)
  //     // return res.status;
  //     // print(response);
  //     setState(() {
  //       uniqueUsername = response.data['status'];
  //     });
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       setState(() {
  //         uniqueUsername = e.response!.data['status'];
  //       });
  //     }
  //   }
  //   print(uniqueUsername);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? kLight
            : kDark[900],
        // elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light),
        title: Text(
          "Change Password",
          // style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.done_rounded,
                // color: Colors.green,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                var dio = Dio();
                var storage = FlutterSecureStorage();
                var token = await storage.read(key: "token");
                if (_formKey.currentState!.validate()) {
                  print(oldpass);
                  Response response = await dio.post(
                      "https://api-tassie.herokuapp.com/user/updatePassword",
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      // data: jsonEncode(value),
                      data: {
                        "oldpass": oldpass,
                        "newpass": newpass,
                      });
                  if (response.data != null) {
                    if (response.data['status'] == true) {
                      Navigator.pop(context);
                    } else {
                      showSnack(
                          context, response.data['message'], () {}, 'OK', 4);
                    }
                  } else {
                    showSnack(context, 'Server error', () {}, 'OK', 4);
                  }
                }
              })
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 15.0,
                ),
                buildTextField(
                  "Old password",
                  '',
                  true,
                  TextInputType.text,
                  (val) async {
                    oldpass = val;
                    // print(username);
                  },
                  (val) => val!.length < 6
                      ? 'Enter password 6+ characters long'
                      : null,
                ),
                buildTextField(
                  "New password",
                  '',
                  true,
                  TextInputType.text,
                  (val) async {
                    newpass = val;
                    // print(username);
                  },
                  (val) => val!.length < 6
                      ? 'Enter password 6+ characters long'
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText,
      String initialValue,
      bool isPassword,
      TextInputType inputType,
      Function(String) onChange,
      String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: inputType,
        obscureText: isPassword ? true : false,
        decoration: InputDecoration(
          labelText: labelText,
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
                color: Theme.of(context).brightness == Brightness.dark
                    ? kPrimaryColor
                    : kDark[900]!),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onChanged: (val) {
          onChange(val);
          // print(val);
          // print(username);
        },
        validator: validator,
      ),
    );
  }
}
