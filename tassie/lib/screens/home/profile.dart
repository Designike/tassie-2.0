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
              print('1');
              Response response = await dio.get(
                "http://10.0.2.2:3000/user/logout/",
                options: Options(headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                  HttpHeaders.authorizationHeader: "Bearer " + token!
                }),
              );
              print('1.1');
              await storage.delete(key: "token");
              print('1.1.1');
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
