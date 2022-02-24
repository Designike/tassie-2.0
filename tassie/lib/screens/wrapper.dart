import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tassie/constants.dart';

import 'authenticate/authenticate.dart';
import 'home/home.dart';

// ignore: use_key_in_widget_constructors
class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  String? value;
  bool isLoading = true;
  Future<String?> check() async {
    const storage = FlutterSecureStorage();
    var x = await storage.read(key: "token");
    setState(() {
      value = x;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        // backgroundColor: Colors.white,
        body: Center(
          child: SpinKitThreeBounce(
            color: kPrimaryColor,
            size: 50.0,
          ),
        ),
      );
    } else {
      if (value != null) {
        return const Home();
        // return Navigator(
        //   key: key,
        //   onGenerateRoute: (routeSettings) {
        //     return MaterialPageRoute(builder: (context) => const Home());
        //   },
        // );
      } else {
        return const Authenticate();
      }
    }
  }
}
