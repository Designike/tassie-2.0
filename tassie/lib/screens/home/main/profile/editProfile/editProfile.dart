import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/profile/profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(
      {required this.name,
      required this.bio,
      required this.website,
      required this.number,
      required this.gender});
  final String name;
  final String bio;
  final String website;
  final String number;
  final String gender;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // bool showPassword = false;
  List<String> genders = ['', 'male', 'female', 'other'];
  int index = 0;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    index = genders.indexOf(widget.gender);
    String bio = widget.bio;
    String website = widget.website;
    String name = widget.name;
    String number = widget.number;
    String gender = genders[index];

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
          "Edit Profile",
          // style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.done_rounded,
                // color: Colors.green,
              ),
              onPressed: () async {
                var dio = Dio();
                var storage = FlutterSecureStorage();
                var token = await storage.read(key: "token");
                //         Response response =
                //             await dio.post("https://api-tassie.herokuapp.com/recs/bookmark",
                //                 options: Options(headers: {
                //                   HttpHeaders.contentTypeHeader:
                //                       "application/json",
                //                   HttpHeaders.authorizationHeader:
                //                       "Bearer " + token!
                //                 }),
                //                 data: {'uuid': recs['uuid']});
                if (_formKey.currentState!.validate()) {
                  Response response = await dio.post(
                      "https://api-tassie.herokuapp.com/profile/updateProfile/",
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      // data: jsonEncode(value),
                      data: {
                        "name": name,
                        "website": website,
                        "bio": bio,
                        "number": number,
                        "gender": gender
                      });
                  if (response.data['status']) {
                    Navigator.pop(context);
                  }
                }
              }),
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
                buildTextField("Name", name, false, TextInputType.text, (val) {
                  name = val;
                }),
                buildTextField("Website", website, false, TextInputType.url,
                    (val) {
                  website = val;
                }),
                buildTextField("Number", number, false, TextInputType.number,
                    (val) {
                  number = val;
                }),
                buildTextField("Bio", bio, true, TextInputType.multiline,
                    (val) {
                  bio = val;
                }),
                DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                      value: genders[index],
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(
                          // fontFamily: 'Raleway',
                          fontSize: 16.0,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kPrimaryColor
                              : kDark[900],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: kDefaultPadding),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? kPrimaryColor
                                  : kDark[900]!),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      items: genders.map((String i) {
                        return DropdownMenuItem(
                          value: i,
                          child: Text(i == '' ? 'Prefer not to say' : i),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                      // borderRadius: BorderRadius.circular(15.0),
                      isExpanded: true),
                ),
                SizedBox(
                  height: 35,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     OutlineButton(
                //       padding: EdgeInsets.symmetric(horizontal: 50),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(20)),
                //       onPressed: () {},
                //       child: Text("CANCEL",
                //           style: TextStyle(
                //               fontSize: 14,
                //               letterSpacing: 2.2,
                //               color: Colors.black)),
                //     ),
                //     RaisedButton(
                //       onPressed: () {},
                //       color: Colors.green,
                //       padding: EdgeInsets.symmetric(horizontal: 50),
                //       elevation: 2,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(20)),
                //       child: Text(
                //         "SAVE",
                //         style: TextStyle(
                //             fontSize: 14,
                //             letterSpacing: 2.2,
                //             color: Colors.white),
                //       ),
                //     )
                //   ],
                // )
                // GestureDetector(
                //   // onTap: () async {
                //   //   if (_formKey.currentState!.validate()) {
                //   //     dynamic result =
                //   //         await _auth.signInWithEmailAndPassword(
                //   //             username, password);
                //   //     if (result == null) {
                //   //       if (this.mounted) {
                //   //         setState(() {
                //   //           error = "Something went wrong";
                //   //         });
                //   //       }
                //   //     }
                //   //   }
                //   // },
                //   onTap: () async {
                //     // if (_formKey.currentState!.validate()) {
                //     //   Response response = await dio.post(
                //     //     "https://api-tassie.herokuapp.com/user/login/",
                //     //     options: Options(headers: {
                //     //       HttpHeaders.contentTypeHeader: "application/json",
                //     //     }),
                //     //     // data: jsonEncode(value),
                //     //     data: email != ""
                //     //         ? {"email": email, "password": password}
                //     //         : {"username": username, "password": password},
                //     //   );
                //     //   print('1');
                //     //   if (response.data != null) {
                //     //     if (response.data['status'] == true) {
                //     //       await storage.write(
                //     //           key: "token",
                //     //           value: response.data['data']['token']);
                //     //       await storage.write(
                //     //           key: "uuid", value: response.data['data']['uuid']);
                //     //       print(response.data['data']['uuid']);
                //     //       Navigator.pushReplacement(
                //     //         context,
                //     //         MaterialPageRoute(builder: (context) {
                //     //           return Home();
                //     //         }),
                //     //       );
                //     //       print(response.toString());
                //     //     } else {
                //     //       print(response.toString());
                //     //       showSnack(
                //     //           context, response.data['message'], () {}, 'OK', 4);
                //     //     }
                //     //   }
                //     // }
                //   },
                //   child: Container(
                //     height: 50.0,
                //     child: Material(
                //       borderRadius: BorderRadius.circular(25.0),
                //       shadowColor: kPrimaryColorAccent,
                //       color: kPrimaryColor,
                //       elevation: 5.0,
                //       child: Center(
                //         child: Text(
                //           'SAVE',
                //           style: TextStyle(
                //             // fontFamily: 'Raleway',
                //             letterSpacing: 2.2,
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String initialValue, bool isMultiline,
      TextInputType inputType, Function(String) onChange) {
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
        },
      ),
    );
  }
}
