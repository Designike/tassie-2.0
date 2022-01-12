// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants.dart';

class OTPForm extends StatefulWidget {
  const OTPForm({required this.uuid});
  final String uuid;

  @override
  _OTPFormState createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  var dio = Dio();
  List<String> totp = List<String>.filled(6, '', growable: true);
  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    OutlineInputBorder outlineInputBorder() {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(size.width * 0.02),
        borderSide: BorderSide(color: kDark),
      );
    }

    final otpInputDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      border: outlineInputBorder(),
      focusedBorder: outlineInputBorder(),
      enabledBorder: outlineInputBorder(),
    );

    return Form(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.1,
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  // maxLength: 1,
                  onChanged: (value) {
                    print(totp);
                    if (value.length == 1) {
                      totp[0] = value;
                      print(totp);
                    }
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.1,
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    totp[1] = value;
                    nextField(value, pin3FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.1,
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    totp[2] = value;
                    nextField(value, pin4FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.1,
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    totp[3] = value;
                    nextField(value, pin5FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.1,
                child: TextFormField(
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    totp[4] = value;
                    nextField(value, pin6FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.1,
                child: TextFormField(
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      totp[5] = value;
                      print(totp);
                      pin6FocusNode!.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
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
              // if (_formKey.currentState!.validate()) {
              //   final response = await dio.post(
              //     "https://api-tassie.herokuapp.com/user/login/",
              //     options: Options(headers: {
              //       HttpHeaders.contentTypeHeader: "application/json",
              //     }),
              //     // data: jsonEncode(value),
              //     data: email != ""
              //         ? {"email": email, "password": password}
              //         : {"username": username, "password": password},
              //   );
              //   print(response.toString());
              // }
              var otp = totp.join("");
              try {
                print(totp);
                print(otp);
                Response response = await dio.post(
                    "https://api-tassie.herokuapp.com/user/tsa/" + widget.uuid,
                    // "https://10.0.2.2:3000/user/tsa/" + widget.uuid,
                    options: Options(headers: {
                      HttpHeaders.contentTypeHeader: "application/json",
                    }),
                    data: {"totp": otp});
                print(widget.uuid);
                print(response.data);
              } on DioError catch (e) {
                // if (e.response != null) {
                print(e.response!.data);
                // }
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
                    'Verify',
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
              // widget.func!();
            },
            child: Container(
              height: 50.0,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: MediaQuery.of(context).platformBrightness ==
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
                        'Code expired? Resend',
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
        ],
      ),
    );
  }
}

class OTP extends StatefulWidget {
  final String uuid;
  const OTP({required this.uuid});

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final _formKey = GlobalKey<FormState>();
  String? value;
  var dio = Dio();
  Future<String?> check() async {
    const storage = FlutterSecureStorage();
    value = await storage.read(key: "token");
  }

  @override
  void initState() {
    super.initState();
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
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'One Last\nStep!',
                    style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      // color: kDark[800]!,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text('We have sent OTP to your email.'),
                  Row(
                    children: [
                      Text('Your code will expire in'),
                      TweenAnimationBuilder(
                        tween: Tween(begin: 100.0, end: 0.0),
                        duration: Duration(seconds: 100),
                        builder: (_, dynamic value, child) => Text(
                          " ${value.toInt()} seconds",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      )
                    ],
                  ),
                  OTPForm(uuid: widget.uuid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
