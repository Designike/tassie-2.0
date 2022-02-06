import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // bool showPassword = false;
  List<String> genders = ['male', 'female', 'other'];
  String? gender;
  String bio = "";
  String website = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // elevation: 1,
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
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(
                height: 15.0,
              ),
              buildTextField("Name", "Dor Alex"),
              buildTextField("Website", "alexd@gmail.com"),
              buildTextField("Number", "********"),
              buildTextField("Number", "********"),
              buildTextField("Bio", "TLV, Israel"),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                    value: gender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(
                        // fontFamily: 'Raleway',
                        fontSize: 16.0,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
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
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? kPrimaryColor
                                : kDark[900]!),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    items: genders.map((String i) {
                      return DropdownMenuItem(
                        value: i,
                        child: Text(i),
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
                  //   Response response = await dio.post(
                  //     "http://10.0.2.2:3000/user/login/",
                  //     options: Options(headers: {
                  //       HttpHeaders.contentTypeHeader: "application/json",
                  //     }),
                  //     // data: jsonEncode(value),
                  //     data: email != ""
                  //         ? {"email": email, "password": password}
                  //         : {"username": username, "password": password},
                  //   );
                  //   print('1');
                  //   if (response.data != null) {
                  //     if (response.data['status'] == true) {
                  //       await storage.write(
                  //           key: "token",
                  //           value: response.data['data']['token']);
                  //       await storage.write(
                  //           key: "uuid", value: response.data['data']['uuid']);
                  //       print(response.data['data']['uuid']);
                  //       Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(builder: (context) {
                  //           return Home();
                  //         }),
                  //       );
                  //       print(response.toString());
                  //     } else {
                  //       print(response.toString());
                  //       showSnack(
                  //           context, response.data['message'], () {}, 'OK', 4);
                  //     }
                  //   }
                  // }
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
                        'SAVE',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        initialValue:
            initialValue, // obscureText: isPasswordTextField ? showPassword : false,
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
      ),
    );
  }
}
