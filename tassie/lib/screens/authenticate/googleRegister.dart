import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/wrapper.dart';
import 'package:tassie/utils/snackbar.dart';

import '../home/homeMapPageContoller.dart';

class GoogleRegister extends StatefulWidget {
  const GoogleRegister({
    Key? key,
    required this.email,
    required this.name,
    required this.password,
  }) : super(key: key);

  final String name;
  final String email;
  final String password;
  @override
  GoogleRegisterState createState() => GoogleRegisterState();
}

class GoogleRegisterState extends State<GoogleRegister> {
  bool uniqueUsername = false;
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String notUniqText = "";
  Future<void> checkUsername(username) async {
    var dio = Dio();
    // print(username);
    try {
      // print('');
      Response response = await dio
          .get("$baseAPI/user/username/$username");
      // var res = jsonDecode(response.toString());

      // if(response)
      // return res.status;
      // print(response);
      if (mounted) {
        setState(() {
          uniqueUsername = response.data['status'];
          notUniqText = response.data['message'];
        });
      }
    } on DioError catch (e) {
      if (mounted && e.response != null) {
        setState(() {
          uniqueUsername = e.response!.data['status'];
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
        title: const Text(
          "What should we call you?",
          // style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          uniqueUsername
              ? IconButton(
                  icon: const Icon(
                    Icons.done_rounded,
                    // color: Colors.green,
                  ),
                  onPressed: () async {
                    var dio = Dio();
                    var storage = const FlutterSecureStorage();
                    // var token = await storage.read(key: "token");
                    if (_formKey.currentState!.validate()) {
                      Response response = await dio.post(
                          "$baseAPI/user/googleRegister/",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            // HttpHeaders.authorizationHeader: "Bearer " + token!
                          }),
                          // data: jsonEncode(value),
                          data: {
                            "username": username,
                            "name": widget.name,
                            "password": widget.password,
                            "email": widget.email
                          });
                      if (response.data != null) {
                        if (response.data['status'] == true) {
                          // // await Future.delayed(const Duration(seconds: 1));

                          if (!mounted) return;
                          Navigator.pop(context);
                          await storage.write(
                              key: "token",
                              value: response.data['data']['token']);
                          await storage.write(
                              key: "uuid",
                              value: response.data['data']['uuid']);
                          await storage.write(
                              key: "profilePic",
                              value: response.data['data']['profilePic']);
                          // // await Future.delayed(const Duration(seconds: 1));

                          if (!mounted) return;
                          // print("dasoda");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const Home();
                            }),
                          );
                          // showSnack(context, 'Username update in progress',
                          //     () {}, 'OK', 3);
                        } else {
                          // print(response.data);
                          // // await Future.delayed(const Duration(seconds: 1));

                          if (!mounted) return;
                          showSnack(context, response.data['message'], () {},
                              'OK', 4);
                          Navigator.pop(context);
                        }
                      } else {
                        // print(response.data);

                        // await Future.delayed(const Duration(seconds: 1));

                        if (!mounted) return;
                        showSnack(context, 'Server error 2B', () {}, 'OK', 4);
                        Navigator.pop(context);
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
                  "Username",
                  username,
                  false,
                  TextInputType.text,
                  (val) async {
                    username = val;
                    // print(username);
                    if (val.length > 3) {
                      // print('1');
                      await checkUsername(val);
                      // print('2');
                    }
                  },
                  (val) {
                    if (!RegExp(r"^(?=[a-zA-Z0-9.-]{4,32}$)").hasMatch(val!)) {
                      return 'Please enter a valid Username';
                    }
                    if (!uniqueUsername) {
                      return "Username already exists";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                const Text(
                    'Type your username, if it is available the save button on corner will be enabled.\n\nUsername should have minimum 4 characters. Username can only include letters, numbers, "." and "-"'),
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
      bool isMultiline,
      TextInputType inputType,
      Function(String) onChange,
      String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: inputType,
        maxLines: isMultiline ? null : 1,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            // fontFamily: 'Raleway',
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
          // print(val);
          // print(username);
        },
        validator: validator,
      ),
    );
  }
}
