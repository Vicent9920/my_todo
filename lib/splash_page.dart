
import 'dart:async';

import 'package:flutter/material.dart';

import 'login/login.dart';

class SplashPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return _SplashPage();
  }

}

class _SplashPage extends State<SplashPage>{

  Timer timer;
  @override
  void initState() {
    super.initState();
    timer = new Timer(const Duration(milliseconds: 3000), () {
      try {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } catch (e) {

      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Image(image: AssetImage('res/images/splash.jpg'), fit: BoxFit.fill);;
  }



}