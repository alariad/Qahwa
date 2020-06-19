import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp1/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/sign_in.dart';
import 'package:flutterapp1/screens/authenticate/Authenticate.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    FirebaseUser user = Provider.of<FirebaseUser>(context);
    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return TopicsScreen();
    }


  }
}


