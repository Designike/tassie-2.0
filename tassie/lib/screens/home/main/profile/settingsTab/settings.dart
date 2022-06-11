import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/main/profile/editProfile/changeEmail.dart';
import 'package:tassie/screens/home/main/profile/editProfile/changePassword.dart';
import 'package:tassie/screens/home/main/profile/settingsTab/changeTheme.dart';
import 'package:tassie/screens/home/main/profile/editProfile/changeUsername.dart';
import 'package:tassie/utils/snackbar.dart';
import 'package:tassie/screens/wrapper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  var dio = Dio();
  final storage = const FlutterSecureStorage();
  bool isClicked = false;

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
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light),
        title: const Text(
          "Settings",
          // style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: ListView(
          children: [
            // Text(
            //   "Settings",
            //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            // ),
            // SizedBox(
            //   height: 40,
            // ),
            Row(
              children: const [
                Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            buildAccountOptionRow("Change username", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const ChangeUsername();
                }),
              );
            }),
            buildAccountOptionRow("Password", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const ChangePassword();
                }),
              );
            }),
            buildAccountOptionRow("Update Email", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const ChangeEmail();
                }),
              );
            }),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: const [
                Icon(
                  Icons.settings,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "General",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),

            buildNotificationOptionRow("Notifications", true),
            buildAccountOptionRow("Theme", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChangeTheme();
                }),
              );
            }),
            buildAccountOptionRow("Opportunity", () {}),

            const SizedBox(
              height: 50,
            ),
            Center(
              child: OutlinedButton(
                // padding: EdgeInsets.symmetric(horizontal: 40),

                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20)),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  try {
                    if (mounted) {
                      setState(() {
                        isClicked = true;
                      });
                    }
                    var token = await storage.read(key: "token");
                    await dio.get(
                      "https://api-tassie.herokuapp.com/user/logout/",
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer ${token!}"
                      }),
                    );
                    await storage.delete(key: "token");
                    // await Future.delayed(const Duration(seconds: 1));

                    if (!mounted) return;
                    Navigator.pop(context);
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const Wrapper()),
                        (route) => false);
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) {
                    //     return Wrapper();
                    //   }),
                    // );
                  } catch (e) {
                    showSnack(context, "Oops! Something went wrong. Try again.",
                        () {}, 'OK', 4);
                    // setState(() {
                    //   isClicked = false;
                    // });
                  }
                },
                child: isClicked
                    ? Transform.scale(
                        scale: 0.6,
                        child: const CircularProgressIndicator(
                          color: kPrimaryColor,
                          strokeWidth: 3.0,
                        ),
                      )
                    : const Text(
                        "SIGN OUT",
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2,
                          // color: Colors.black,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              activeColor: kPrimaryColor,
              value: isActive,
              onChanged: (bool val) {
                isActive = val;
              },
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
