import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/utils/snackbar.dart';
import '../../constants.dart';

class OTP2Form extends StatefulWidget {
  const OTP2Form({required this.uuid, Key? key}) : super(key: key);
  final String uuid;

  @override
  OTP2FormState createState() => OTP2FormState();
}

class OTP2FormState extends State<OTP2Form> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  var dio = Dio();
  final storage = const FlutterSecureStorage();
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
        borderSide: const BorderSide(color: kDark),
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
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  // maxLength: 1,
                  onChanged: (value) {
                    if (value.length == 1) {
                      totp[0] = value;
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
                  style: const TextStyle(fontSize: 24),
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
                  style: const TextStyle(fontSize: 24),
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
                  style: const TextStyle(fontSize: 24),
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
                  style: const TextStyle(fontSize: 24),
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
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      totp[5] = value;
                      pin6FocusNode!.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
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
              //     "$baseAPI/user/login/",
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
                var token = await storage.read(key: "token");
                Response response = await dio.post(
                    // "$baseAPI/user/tsa/" + widget.uuid,
                    "$baseAPI/user/verifyEmail",
                    options: Options(headers: {
                      HttpHeaders.contentTypeHeader: "application/json",
                      HttpHeaders.authorizationHeader: "Bearer ${token!}",
                    }),
                    data: {"totp": otp});
                if (response.data != null) {
                  if (response.data['status'] == true) {
                    // await storage.write(
                    //     key: "token", value: response.data['data']['token']);
                    // await storage.write(
                    //     key: "uuid", value: response.data['data']['uuid']);
                    // Response response1 = await dio.get(
                    //     "$baseAPI/user/getProfilePic/",
                    //     options: Options(headers: {
                    //       HttpHeaders.contentTypeHeader: "application/json",
                    //       HttpHeaders.authorizationHeader:
                    //           "Bearer " + response.data['data']['token']
                    //     }));
                    // if (response.data['data']['profilePic'] != "") {
                    // await storage.write(
                    //     key: "profilePic",
                    //     value: response.data['data']['profilePic']);
                    // } else {
                    //   List option = [
                    //     'assets/Avacado.png',
                    //     'assets/Banana.png',
                    //     'assets/Pineapple.png',
                    //     'assets/Pumpkin.png',
                    //     'assets/Shushi.png'
                    //   ];
                    //   String randomItem = (option..shuffle()).first;
                    //   await storage.write(key: "profilePic", value: randomItem);
                    // }
                    // await Future.delayed(const Duration(seconds: 1));
                    if (!mounted) return;
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    // await Future.delayed(const Duration(seconds: 1));
                    if (!mounted) return;
                    showSnack(
                        context, response.data['message'], () {}, 'OK', 4);
                  }
                } else {
                  // await Future.delayed(const Duration(seconds: 1));
                  if (!mounted) return;
                  showSnack(context, 'Unable to connect', () {}, 'OK', 4);
                }

                // print(widget.uuid);
                // print(response.data);
              } on DioError {
                // if (e.response != null) {
                // }
                showSnack(context, 'Unable to connect', () {}, 'OK', 4);
              }
            },
            child: SizedBox(
              height: 50.0,
              child: Material(
                borderRadius: BorderRadius.circular(25.0),
                shadowColor: kPrimaryColorAccent,
                color: kPrimaryColor,
                elevation: 5.0,
                child: const Center(
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
          const SizedBox(height: 20.0),
          GestureDetector(
            onTap: () async {
              // widget.func!();
              try {
                Response response = await dio.get(
                  // "$baseAPI/user/",
                  "$baseAPI/user/mail/${widget.uuid}",
                  options: Options(headers: {
                    HttpHeaders.contentTypeHeader: "application/json",
                  }),
                );
                if (response.data != null) {
                  if (response.data['status'] == true) {
                    // await Future.delayed(const Duration(seconds: 1));
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return OTP2(
                            uuid: response.data['data']['uuid'],
                            time: response.data['data']['time']);
                      }),
                    );
                  } else {
                    // await Future.delayed(const Duration(seconds: 1));
                    if (!mounted) return;
                    showSnack(
                        context, response.data['message'], () {}, 'OK', 4);
                  }
                } else {
                  // await Future.delayed(const Duration(seconds: 1));
                  if (!mounted) return;
                  showSnack(context, 'Unable to connect', () {}, 'OK', 4);
                }
              } on DioError catch (e) {
                if (e.response != null) {
                  // var errorMessage = e.response!.data;
                  showSnack(context, 'Unable to connect', () {}, 'OK', 4);
                }
              }
            },
            child: Container(
              height: 50.0,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.light
                          ? kDark[800]!
                          : kLight,
                      style: BorderStyle.solid,
                      width: 2.0,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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

class OTP2 extends StatefulWidget {
  final String uuid;
  final int time;
  const OTP2({required this.uuid, required this.time, Key? key})
      : super(key: key);

  @override
  OTP2State createState() => OTP2State();
}

class OTP2State extends State<OTP2> {
  final _formKey = GlobalKey<FormState>();
  String? value;
  var dio = Dio();
  Future<String?> check() async {
    const storage = FlutterSecureStorage();
    value = await storage.read(key: "token");
    return null;
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
              padding: const EdgeInsets.all(kDefaultPadding * 1.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Verify your\nemail!',
                    style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      // color: kDark[800]!,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text('We have sent OTP to your email.'),
                  Row(
                    children: [
                      const Text('Your code will expire in'),
                      TweenAnimationBuilder(
                        tween: Tween(begin: widget.time, end: 0.0),
                        duration: Duration(seconds: widget.time),
                        builder: (_, dynamic value, child) => Text(
                          " ${value.toInt()} seconds",
                          style: const TextStyle(color: kPrimaryColor),
                        ),
                      )
                    ],
                  ),
                  OTP2Form(uuid: widget.uuid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
