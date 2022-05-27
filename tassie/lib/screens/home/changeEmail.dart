import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/authenticate/otp2.dart';
import 'package:tassie/screens/home/snackbar.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  // bool uniqueUsername = false;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String newpass = "";
  bool uniqueEmail = true;
  String notUniqText = "";
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

  Future<void> checkEmail(email) async {
    var dio = Dio();
    try {
      Response response = await dio
          .get("https://api-tassie.herokuapp.com/user/checkEmail/" + email);
      // var res = jsonDecode(response.toString());

      // if(response)
      // return res.status;
      setState(() {
        uniqueEmail = response.data['status'];
        notUniqText = response.data['message'];
      });
    } on DioError catch (e) {
      if (e.response != null) {
        setState(() {
          uniqueEmail = e.response!.data['status'];
          notUniqText = e.response!.data['message'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light),
        title: Text(
          "Change Email",
          // style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          uniqueEmail
              ? IconButton(
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
                      print(email);
                      Response response = await dio.post(
                          "https://api-tassie.herokuapp.com/user/email",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer " + token!
                          }),
                          // data: jsonEncode(value),
                          data: {
                            "email": email,
                          });
                      if (response.data != null) {
                        print(response.data);
                        if (response.data['status'] == true) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) {
                              return OTP2(
                                  uuid: response.data['data']['uuid'],
                                  time: response.data['data']['time']);
                            }),
                          );
                        } else {
                          showSnack(context, response.data['message'], () {},
                              'OK', 4);
                        }
                      } else {
                        showSnack(context, 'Server error', () {}, 'OK', 4);
                      }
                    }
                  })
              : Transform.scale(
                  scale: 0.4,
                  child: Container(
                    child: CircularProgressIndicator(),
                    width: 55.0,
                  )),
        ],
      ),
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
                  "New Email",
                  '',
                  false,
                  TextInputType.emailAddress,
                  (val) async {
                    email = val;
                    if (val.contains('@') && val.length > 8) {
                      await checkEmail(val);
                    }
                    // print(username);
                  },
                  (val) {
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)) {
                      return 'Please enter a valid Email';
                    }
                    if (!uniqueEmail) {
                      return "Email already exists";
                    }
                    return null;
                  },
                ),
                // buildTextField(
                //   "New password",
                //   '',
                //   true,
                //   TextInputType.text,
                //   (val) async {
                //     newpass = val;
                //     // print(username);
                //   },
                //   (val) => val!.length < 6
                //       ? 'Enter password 6+ characters long'
                //       : null,
                // ),
                SizedBox(height: 20.0),
                Text(
                    'Type your new email, if it is available the save button on corner will be enabled.'),
                SizedBox(height: 20.0),
                Text(notUniqText, style: TextStyle(color: kPrimaryColor)),
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
