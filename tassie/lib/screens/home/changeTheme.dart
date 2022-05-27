import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/snackbar.dart';
import 'package:tassie/themePreferences.dart';
import 'package:tassie/theme_model.dart';
import 'package:provider/provider.dart';

class ChangeTheme extends StatefulWidget with ChangeNotifier {
  ChangeTheme({Key? key}) : super(key: key);

  @override
  _ChangeThemeState createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  // bool uniqueUsername = false;
  final _formKey = GlobalKey<FormState>();
  int selectedTheme = 0;
  String theme = "";

  // Future<void> checkUsername(username) async {
  //   var dio = Dio();
  //   // print(username);
  //   try {
  //     // print('');
  //     Response response =
  //         await dio.get("https://api-tassie.herokuapp.com/user/username/" + username);
  //     // var res = jsonDecode(response.toString());

  //     // if(response)
  //     // return res.status;
  //     // print(response);
  //     setState(() {
  //       uniqueUsername = response.data['status'];
  //     });
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       setState(() {
  //         uniqueUsername = e.response!.data['status'];
  //       });
  //     }
  //   }
  //   print(uniqueUsername);
  // }

  @override
  void initState() {
    super.initState();
    // ThemePreferences tp = ThemePreferences();
    // tp.getTheme();
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
        title: Text(
          "Change Email",
          // style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.done_rounded,
                // color: Colors.green,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();

                print('thai che a');
                Navigator.pop(context);
                // if (_formKey.currentState!.validate()) {
                // print(oldpass);
                // Response response = await dio
                //     .post("https://api-tassie.herokuapp.com/user/updatePassword",
                //         options: Options(headers: {
                //           HttpHeaders.contentTypeHeader: "application/json",
                //           HttpHeaders.authorizationHeader: "Bearer " + token!
                //         }),
                //         // data: jsonEncode(value),
                //         data: {
                //       "oldpass": oldpass,
                //       "newpass": newpass,
                //     });
                // if(response.data != null) {
                //   if (response.data['status'] == true) {
                //   Navigator.pop(context);
                // } else {
                //   showSnack(context, response.data['message'], () {}, 'OK', 4);
                // }
                // } else {
                //   showSnack(context, 'Server error', () {}, 'OK', 4);
                // }

                // }
                // if (theme == "System") {
                //   print('1');
                //   // if (themeNotifier.isDark['system'] == "false") {
                //   // themeNotifier.isDark = {
                //   //   "system": "true",
                //   //   "light": "false"
                //   // };
                //   Get.changeThemeMode(ThemeMode.system);
                //   Navigator.pop(context);
                //   // }
                // } else if (theme == "Light") {
                //   print('2');
                //   // themeNotifier.isDark = {
                //   //   "system": "false",
                //   //   "light": "true"
                //   // };
                //   Get.changeThemeMode(ThemeMode.light);
                //   Navigator.pop(context);
                // } else {
                //   print('3');
                //   // themeNotifier.isDark = {
                //   //   "system": "false",
                //   //   "light": "false"
                //   // };
                //   Get.changeThemeMode(ThemeMode.dark);
                //   Navigator.pop(context);
                // }
              })
        ],
      ),
      resizeToAvoidBottomInset: true,
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
                themeRadio(0, "System"),
                SizedBox(
                  height: 15.0,
                ),
                themeRadio(1, "Dark"),
                SizedBox(
                  height: 15.0,
                ),
                themeRadio(2, "Light"),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeTheme(int index, String thme) {
    setState(() {
      theme = thme;
      selectedTheme = index;
      if (theme == "System") {
        print('1');
        // if (themeNotifier.isDark['system'] == "false") {
        // themeNotifier.isDark = {
        //   "system": "true",
        //   "light": "false"
        // };
        Get.changeThemeMode(ThemeMode.system);
        // }
      } else if (theme == "Light") {
        print('2');
        // themeNotifier.isDark = {
        //   "system": "false",
        //   "light": "true"
        // };
        Get.changeThemeMode(ThemeMode.light);
      } else {
        print('3');
        // themeNotifier.isDark = {
        //   "system": "false",
        //   "light": "false"
        // };
        Get.changeThemeMode(ThemeMode.dark);
      }
    });
    // print(flavour);
  }

  Widget themeRadio(int index, String flav) {
    return Padding(
      padding: const EdgeInsets.only(right: kDefaultPadding),
      child: OutlinedButton(
        onPressed: () => changeTheme(index, flav),
        child: Text(flav),
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          padding: EdgeInsets.all(15.0),
          side: BorderSide(
            color: selectedTheme == index ? kPrimaryColor : kDark,
            width: selectedTheme == index ? 2 : 1,
          ),
          backgroundColor: selectedTheme == index
              ? kPrimaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
      ),
    );
  }
}
