import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../wrapper.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var dio = Dio();
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tassie'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              var token = await storage.read(key: "token");
              Response response = await dio
                  .post("https://api-tassie.herokuapp.com/user/logout/",
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                        HttpHeaders.authorizationHeader: "Bearer " + token!
                      }),
                      // data: jsonEncode(value),
                      data: {});
              await storage.delete(key: "token");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return Wrapper();
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
