// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/screens/home/home.dart';
import 'package:tassie/screens/home/snackbar.dart';
import '../../constants.dart';

class SignIn extends StatefulWidget {
  final Function? func;
  // ignore: use_key_in_widget_constructors
  const SignIn({this.func});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String password = "";
  String username = "";
  String email = "";
  String error = "";
  final _formKey = GlobalKey<FormState>();
  String? value;
  final storage = FlutterSecureStorage();
  var dio = Dio();
  Future<String?> check() async {
    const storage = FlutterSecureStorage();
    value = await storage.read(key: "token");
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkFields() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: kLight,
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
                'Welcome\nBack!',
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
                          labelText: 'USERNAME OR EMAIL',
                          labelStyle: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 12.0,
                            // color: Colors.grey.withOpacity(0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor))),
                      onChanged: (value) {
                        username = value;
                      },
                      validator: (val) {
                        if (RegExp(
                                r"(^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+)")
                            .hasMatch(val!)) {
                          setState(() {
                            email = val;
                          });
                          return null;
                        }
                        // if (!RegExp(r"^[a-zA-Z0-9!#$%&-^_]+").hasMatch(val)) {
                        if (!RegExp(r"^(?=[a-zA-Z0-9._]{5,32}$)")
                            .hasMatch(val)) {
                          return 'Please enter a valid username or email';
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
                            // color: Colors.grey.withOpacity(0.5),
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
                      // onTap: () async {
                      //   if (_formKey.currentState!.validate()) {
                      //     dynamic result =
                      //         await _auth.signInWithEmailAndPassword(
                      //             username, password);
                      //     if (result == null) {
                      //       if (this.mounted) {
                      //         setState(() {
                      //           error = "Something went wrong";
                      //         });
                      //       }
                      //     }
                      //   }
                      // },
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          Response response = await dio.post(
                            "http://10.0.2.2:3000/user/login/",
                            options: Options(headers: {
                              HttpHeaders.contentTypeHeader: "application/json",
                            }),
                            // data: jsonEncode(value),
                            data: email != ""
                                ? {"email": email, "password": password}
                                : {"username": username, "password": password},
                          );
                          print('1');
                          if(response.data != null) {
                            if(response.data['status'] == true) {
                              
                          
                          await storage.write(
                              key: "token",
                              value: response.data['data']['token']);
                          await storage.write(
                              key: "uuid",
                              value: response.data['data']['uuid']);
                          print(response.data['data']['uuid']);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Home();
                            }),
                          );
                          print(response.toString());
                          } else {
                            print(response.toString());
                            showSnack(context, response.data['message'], () {}, 'OK', 4);
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
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                color: Colors.white,
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
                                color:
                                    MediaQuery.of(context).platformBrightness ==
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
                                  'Don\'t have an account? Register',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    // color: Colors.black,
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
