import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tassie/screens/authenticate/googleRegister.dart';
import 'package:tassie/screens/home/homeMapPageContoller.dart';
import 'package:tassie/utils/snackbar.dart';
import '../../constants.dart';

class SignIn extends StatefulWidget {
  final Function? func;
  const SignIn({this.func, Key? key}) : super(key: key);
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  String password = "";
  String username = "";
  String email = "";
  String error = "";
  final _formKey = GlobalKey<FormState>();
  String? value;
  final storage = const FlutterSecureStorage();
  var dio = Dio();
  final google = GoogleSignIn();
  bool isClicked = false;

  // Future<GoogleSignInAuthentication?> login()
  Future<GoogleSignInAccount?> login() => google.signIn().then((result) {
        result?.authentication.then((googleKey) async {
          Response response = await dio.post(
              // "https://api-tassie.herokuapp.com/user/tsa/" + widget.uuid,
              "https://api-tassie.herokuapp.com/user/googleSignin",
              options: Options(headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                // HttpHeaders.authorizationHeader: "Bearer " + token!,
              }),
              data: {"email": result.email});
          if (response.data != null) {
            if (response.data['status'] == true) {
              await storage.write(
                  key: "token", value: response.data['data']['token']);
              await storage.write(
                  key: "uuid", value: response.data['data']['uuid']);
              await storage.write(
                  key: "profilePic",
                  value: response.data['data']['profilePic']);
              // await Future.delayed(const Duration(seconds: 1));
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return const Home();
                }),
              );
            } else {
              // await Future.delayed(const Duration(seconds: 1));
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return GoogleRegister(
                      name: result.displayName!,
                      email: result.email,
                      password: result.id);
                }),
              );
            }
          } else {
            // await Future.delayed(const Duration(seconds: 1));
            if (!mounted) return;
            showSnack(context, 'Unable to connect 1A', () {}, 'OK', 4);
          }
        }).catchError((err) {
          showSnack(context, 'Unable to connect 2B', () {}, 'OK', 4);
        });
      }).catchError((err) {
        showSnack(context, 'Unable to connect 3C', () {}, 'OK', 4);
      });

  Future<String?> check() async {
    const storage = FlutterSecureStorage();
    value = await storage.read(key: "token");
    return null;
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
              padding: const EdgeInsets.all(kDefaultPadding * 1.2),
              child: const Text(
                'Welcome\nBack!',
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  // color: kDark[800]!,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(kDefaultPadding * 1.2),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
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
                          if (mounted) {
                            setState(() {
                              email = val;
                            });
                          }
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
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 50.0),
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
                          if (mounted) {
                            setState(() {
                              isClicked = true;
                            });
                          }
                          Response response = await dio.post(
                            "https://api-tassie.herokuapp.com/user/login/",
                            options: Options(headers: {
                              HttpHeaders.contentTypeHeader: "application/json",
                            }),
                            // data: jsonEncode(value),
                            data: email != ""
                                ? {"email": email, "password": password}
                                : {"username": username, "password": password},
                          );
                          if (response.data != null) {
                            if (response.data['status'] == true) {
                              await storage.write(
                                  key: "token",
                                  value: response.data['data']['token']);
                              await storage.write(
                                  key: "uuid",
                                  value: response.data['data']['uuid']);
                              // Response response1 = await dio.get(
                              //     "https://api-tassie.herokuapp.com/user/getProfilePic/",
                              //     options: Options(headers: {
                              //       HttpHeaders.contentTypeHeader:
                              //           "application/json",
                              //       HttpHeaders.authorizationHeader: "Bearer " +
                              //           response.data['data']['token']
                              //     }));
                              // if (response.data['data']['profilePic'] != "") {
                              await storage.write(
                                  key: "profilePic",
                                  value: response.data['data']['profilePic']);
                              // } else {
                              //   List option = [
                              //     'assets/Avacado.png',
                              //     'assets/Banana.png',
                              //     'assets/Pineapple.png',
                              //     'assets/Pumpkin.png',
                              //     'assets/Shushi.png'
                              //   ];
                              //   String randomItem = (option..shuffle()).first;
                              //   await storage.write(
                              //       key: "profilePic", value: randomItem);
                              // }
                              // await Future.delayed(const Duration(seconds: 1));
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const Home();
                                }),
                              );
                            } else {
                              // await Future.delayed(const Duration(seconds: 1));
                              if (!mounted) return;
                              showSnack(context, response.data['message'],
                                  () {}, 'OK', 4);
                              if (mounted) {
                                setState(() {
                                  isClicked = false;
                                });
                              }
                            }
                          }
                        }
                      },
                      child: SizedBox(
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
                                    child: const CircularProgressIndicator(
                                      color: kLight,
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                : const Text(
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

                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () async {
                        try {
                          await login();
                        } catch (e) {
                          showSnack(context, "Error", () {}, 'OK', 4);
                        }
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
                            children: [
                              Center(
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/google.png'),
                                        height: 40.0,
                                      ),
                                    ),
                                    Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                        // color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                            children: const [
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
                    // IconButton(
                    //   onPressed: () async {
                    //     try {
                    //       await login();
                    //       // print(x);
                    //     } catch (e) {
                    //       print(e);
                    //     }
                    //   },
                    //   icon: Icon(Icons.login_rounded),
                    // ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        error,
                        style: const TextStyle(
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
