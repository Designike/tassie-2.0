import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/authenticate/otp2.dart';
import 'package:tassie/utils/snackbar.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  ChangeEmailState createState() => ChangeEmailState();
}

class ChangeEmailState extends State<ChangeEmail> {
  // bool uniqueUsername = false;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String newpass = "";
  bool uniqueEmail = true;
  String notUniqText = "";

  Future<void> checkEmail(email) async {
    var dio = Dio();
    try {
      Response response = await dio
          .get("https://api-tassie.herokuapp.com/user/checkEmail/$email");
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        title: const Text(
          "Change Email",
        ),
        actions: [
          uniqueEmail
              ? IconButton(
                  icon: const Icon(
                    Icons.done_rounded,
                    // color: Colors.green,
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    var dio = Dio();
                    var storage = const FlutterSecureStorage();
                    var token = await storage.read(key: "token");
                    if (_formKey.currentState!.validate()) {
                      Response response = await dio.post(
                          "https://api-tassie.herokuapp.com/user/email",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer ${token!}"
                          }),
                          // data: jsonEncode(value),
                          data: {
                            "email": email,
                          });
                      if (response.data != null) {
                        if (response.data['status'] == true) {
                          await Future.delayed(const Duration(seconds: 1));

                          if (!mounted) return;
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (context) {
                              return OTP2(
                                  uuid: response.data['data']['uuid'],
                                  time: response.data['data']['time']);
                            }),
                          );
                        } else {
                          await Future.delayed(const Duration(seconds: 1));

                          if (!mounted) return;
                          showSnack(context, response.data['message'], () {},
                              'OK', 4);
                        }
                      } else {
                        await Future.delayed(const Duration(seconds: 1));

                        if (!mounted) return;
                        showSnack(context, 'Server error', () {}, 'OK', 4);
                      }
                    }
                  })
              : Transform.scale(
                  scale: 0.4,
                  child: const SizedBox(
                    width: 55.0,
                    child: CircularProgressIndicator(),
                  )),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(
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
                const SizedBox(height: 20.0),
                const Text(
                    'Type your new email, if it is available the save button on corner will be enabled.'),
                const SizedBox(height: 20.0),
                Text(notUniqText, style: const TextStyle(color: kPrimaryColor)),
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
            fontSize: 16.0,
            color: Theme.of(context).brightness == Brightness.dark
                ? kPrimaryColor
                : kDark[900],
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 25.0, vertical: kDefaultPadding),
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
        },
        validator: validator,
      ),
    );
  }
}
