import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function? func;
  // ignore: use_key_in_widget_constructors
  const Register({this.func});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // await Navigator.pushReplacement(
  //                                   context,
  //                                   MaterialPageRoute(builder: (context) {
  //                                     return Home();
  //                                   }),
  //                                 ); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
          child: Row(
        children: [TextFormField(initialValue: 'Username',),TextFormField(initialValue: 'Password',),],
      )),
    );
  }
}
