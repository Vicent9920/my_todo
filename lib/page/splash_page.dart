import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_todo/net/request.dart';
import 'package:my_todo/page/home/main_page.dart';
import 'package:my_todo/page/login/login.dart';
import 'package:my_todo/util/sp_store_util.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPage();
  }
}

class _SplashPage extends State<SplashPage> {
  Timer timer;
  var login = '今日事今日毕！';

  @override
  void initState() {
    super.initState();
    Request();
    timer = new Timer(const Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      SpUtils.getString(SpUtils.USER_NAME).then((entity) {
        if (entity != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        }
      }).catchError((e) {
        print(e.toString());
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image(image: AssetImage('res/images/splash.jpg'), fit: BoxFit.fill,),
        Text(
          login,
          style: TextStyle(
            fontSize: 22,
            color: Colors.green,
            decoration: TextDecoration.none,
            fontFamily: "Shadows",
          ),
        ),
      ],

    );
  }
}
