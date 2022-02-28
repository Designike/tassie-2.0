import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  bool uniqueUsername = false;
  final _formKey = GlobalKey<FormState>();
  String username = "";
  Future<void> checkUsername(username) async {
    var dio = Dio();
    // print(username);
    try {
      // print('');
      Response response =
          await dio.get("http://10.0.2.2:3000/user/username/" + username);
      // var res = jsonDecode(response.toString());

      // if(response)
      // return res.status;
      // print(response);
      setState(() {
        uniqueUsername = response.data['status'];
      });
    } on DioError catch (e) {
      if (e.response != null) {
        setState(() {
          uniqueUsername = e.response!.data['status'];
        });
      }
    }
    print(uniqueUsername);
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
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light),
        title: Text(
          "Change Username",
          // style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          uniqueUsername
              ? IconButton(
                  icon: Icon(
                    Icons.done_rounded,
                    // color: Colors.green,
                  ),
                  onPressed: () async {
                    var dio = Dio();
                    var storage = FlutterSecureStorage();
                    var token = await storage.read(key: "token");
                    if (_formKey.currentState!.validate()) {
                      print(username);
                      Response response = await dio.post(
                          "http://10.0.2.2:3000/profile/updateUsername/",
                          options: Options(headers: {
                            HttpHeaders.contentTypeHeader: "application/json",
                            HttpHeaders.authorizationHeader: "Bearer " + token!
                          }),
                          // data: jsonEncode(value),
                          data: {
                            "username": username,
                          });
                      if (response.data['status']) {
                        Navigator.pop(context);
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
                  "Name",
                  username,
                  false,
                  TextInputType.text,
                  (val) async {
                    username = val;
                    // print(username);
                    if (val.length > 4) {
                      // print('1');
                      await checkUsername(val);
                      // print('2');
                    }
                  },
                  (val) {
                    if (!RegExp(r"^(?=[a-zA-Z0-9._]{5,32}$)").hasMatch(val!)) {
                      return 'Please enter a valid Username';
                    }
                    if (!uniqueUsername) {
                      return "Username already exists";
                    }
                    return null;
                  },
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
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
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
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
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
