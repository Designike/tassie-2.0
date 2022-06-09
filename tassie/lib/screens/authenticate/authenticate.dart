import 'package:flutter/material.dart';
import 'package:tassie/screens/authenticate/register.dart';
import 'package:tassie/screens/authenticate/signin.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  AuthenticateState createState() => AuthenticateState();
}

class AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggle() {
    if (mounted) {
      setState(() {
        showSignIn = !showSignIn;
      });
    }
  }

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
    if (showSignIn) {
      return SignIn(func: toggle);
    } else {
      return Register(func: toggle);
    }
  }
}
