// ignore_for_file: prefer_const_constructors

import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tassie/screens/authenticate/otp.dart';
import 'package:tassie/screens/home/snackbar.dart';

import '../../constants.dart';

class Register extends StatefulWidget {
  final Function? func;
  // ignore: use_key_in_widget_constructors
  const Register({this.func});

  @override
  _RegisterState createState() => _RegisterState();
}

//CHANGE KRVANU CHE AYA
class _RegisterState extends State<Register> {
  bool uniqueUsername = true;
  bool uniqueEmail = true;
  var dio = Dio();
  bool isClicked = false;

  Future<void> checkUsername(username) async {
    // var dio = Dio();
    try {
      Response response = await dio.get(
          "https://api-tassie.herokuapp.com/user/username/" + username);
      // var res = jsonDecode(response.toString());

      // if(response)
      // return res.status;

      uniqueUsername = response.data['status'];
    } on DioError catch (e) {
      if (e.response != null) {
        uniqueUsername = e.response!.data['status'];
      }
    }
  }

  Future<void> checkEmail(email) async {
    // var dio = Dio();
    try {
      Response response = await dio
          .get("https://api-tassie.herokuapp.com/user/checkEmail/" + email);
      // var res = jsonDecode(response.toString());

      // if(response)
      // return res.status;

      uniqueEmail = response.data['status'];
    } on DioError catch (e) {
      if (e.response != null) {
        uniqueEmail = e.response!.data['status'];
      }
    }
  }

  String password = "";
  String email = "";
  String error = "";
  String name = "";
  String username = "";
  int number = 0;
  String website = "";
  String bio = "";

  final _formKey = GlobalKey<FormState>();

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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.15,
            ),
            Container(
              padding: EdgeInsets.all(kDefaultPadding * 1.2),
              child: Text(
                'Hey\nThere!',
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  // color: kDark[800]!,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(kDefaultPadding * 1.2),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'NAME',
                          labelStyle: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 12.0,
                            // color: kDark[800]!.withOpacity(0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor))),
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (val) =>
                          val!.length < 2 ? 'Enter valid name' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'USERNAME',
                          labelStyle: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 12.0,
                            // color: kDark[800]!.withOpacity(0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor))),
                      onChanged: (value) async {
                        username = value;
                        if (value.length > 4) {
                          await checkUsername(value);
                        }
                      },
                      validator: (val) {
                        if (!RegExp(r"^(?=[a-zA-Z0-9._]{6,32}$)")
                            .hasMatch(val!)) {
                          return 'Please enter a valid Username';
                        }
                        // checkUsername(val);
                        if (!uniqueUsername) {
                          return "Username already exists";
                        }
                        //aya pan
                        // checkUsername(val);
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 12.0,
                            // color: kDark[800]!.withOpacity(0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor))),
                      onChanged: (value) async {
                        email = value;
                        if (value.contains('@') && value.length > 8) {
                          await checkEmail(value);
                        }
                      },
                      validator: (val) {
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
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 12.0,
                            // color: kDark[800]!.withOpacity(0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor))),
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (val) => val!.length < 6
                          ? 'Enter password 6+ characters long'
                          : null,
                    ),
                    SizedBox(height: 50.0),
                    GestureDetector(
                      onTap: () async {
                        // if (_formKey.currentState!.validate()) {
                        //   dynamic result =
                        //       await _auth.registerWithEmailAndPasword(
                        //           email, password, name);
                        //   if (result == null) {
                        //     if (this.mounted) {
                        //       setState(() {
                        //         error = "Something went wrong";
                        //       });
                        //     }
                        //   }
                        // }
                        if (_formKey.currentState!.validate()) {
                          // final response = await dio.post(
                          //   "https://api-tassie.herokuapp.com/user/login/",
                          //   options: Options(headers: {
                          //     HttpHeaders.contentTypeHeader: "application/json",
                          //   }),
                          //   // data: jsonEncode(value),
                          //   data: email != ""
                          //       ? {"email": email, "password": password}
                          //       : {"username": username, "password": password},
                          // );
                          // print(response.toString());
                          setState(() {
                            isClicked = true;
                          });
                          try {
                            // Response response = await dio.post(
                            //     // "https://api-tassie.herokuapp.com/user/",
                            //     "https://api-tassie.herokuapp.com/user/",
                            //     options: Options(headers: {
                            //       HttpHeaders.contentTypeHeader:
                            //           "application/json",
                            //     }),
                            //     data: {
                            //       "name": name,
                            //       "username": username,
                            //       "email": email,
                            //       "password": password,
                            //     });
                            // print(response.data['data']['uuid']);
                            // if (response.data['status' == true]) {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) {
                            //       return OTP(
                            //           uuid: response.data['data']['uuid'],
                            //           time: response.data['data']['time']);
                            //     }),
                            //   );
                            // } else {
                            //   showSnack(context, response.data['message'],
                            //       () {}, 'OK', 4);
                            //   setState(() {
                            //     isClicked = false;
                            //   });
                            // }
                          } on DioError catch (e) {
                            if (e.response != null) {
                              var errorMessage = e.response!.data;
                              print(errorMessage);
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 50.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(25.0),
                          shadowColor: kPrimaryColorAccent,
                          color: kPrimaryColor,
                          elevation: 5.0,
                          child: Center(
                            child: isClicked
                                ? Transform.scale(
                                    scale: 0.6,
                                    child: CircularProgressIndicator(
                                      color: kLight,
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                : Text(
                                    'REGISTER',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      color: kLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        widget.func!();
                      },
                      child: Container(
                        height: 50.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? kDark[800]!
                                    : kLight,
                                style: BorderStyle.solid,
                                width: 2.0,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Center(
                                child: Text(
                                  'Already have an account? Sign In',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    // color: kDark[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
