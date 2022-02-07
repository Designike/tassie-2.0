import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tassie/constants.dart';
import 'package:tassie/screens/home/changeUsername.dart';
import 'package:tassie/screens/wrapper.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var dio = Dio();
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light),
        title: Text(
          "Settings",
          // style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(kDefaultPadding),
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
              children: [
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
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOptionRow("Change username", () {
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChangeUsername();
                }),
              );
            }),
            buildAccountOptionRow("Password", () {}),
            buildAccountOptionRow("Update Email", () {}),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
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
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),

            buildNotificationOptionRow("Notifications", true),
            buildAccountOptionRow("Theme", () {}),
            buildAccountOptionRow("Opportunity", () {}),

            SizedBox(
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
                  var token = await storage.read(key: "token");
                  print('1');
                  Response response = await dio.get(
                    "http://10.0.2.2:3000/user/logout/",
                    options: Options(headers: {
                      HttpHeaders.contentTypeHeader: "application/json",
                      HttpHeaders.authorizationHeader: "Bearer " + token!
                    }),
                  );
                  await storage.delete(key: "token");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Wrapper();
                    }),
                  );
                },
                child: Text(
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
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
