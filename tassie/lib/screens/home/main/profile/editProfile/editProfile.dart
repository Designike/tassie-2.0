import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(
      {required this.name,
      required this.bio,
      required this.website,
      required this.number,
      required this.gender,
      Key? key})
      : super(key: key);
  final String name;
  final String bio;
  final String website;
  final String number;
  final String gender;

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  // bool showPassword = false;
  List<String> genders = ['', 'male', 'female', 'other'];
  int index = 0;
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
        foregroundColor: Theme.of(context).brightness == Brightness.light
                    ? kDark[900]
                    : kLight,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light),
        title:  Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
          
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.done_rounded,
                // color: Colors.green,
              ),
              onPressed: () async {
                var dio = Dio();
                var storage = const FlutterSecureStorage();
                var token = await storage.read(key: "token");
                if (_formKey.currentState!.validate()) {
                  Response response = await dio.post(
                      "https://api-tassie.herokuapp.com/profile/updateProfile/",
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer ${token!}"
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
                    // await Future.delayed(const Duration(seconds: 1));

                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                }
              }),
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
                        contentPadding: const EdgeInsets.symmetric(
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
                        if (mounted) {
                          setState(() {
                            gender = value!;
                          });
                        }
                      },
                      // borderRadius: BorderRadius.circular(15.0),
                      isExpanded: true),
                ),
                const SizedBox(
                  height: 35,
                ),
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
      ),
    );
  }
}
