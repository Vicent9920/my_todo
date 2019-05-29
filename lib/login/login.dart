import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        SizedBox(
          height: 72,
        ),
        Center(
          child: Image.asset(
            "res/images/icon_logo.png",
            scale: 1.5,
          ),
        ),
        SizedBox(
          height: 36,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
          child: TextField(
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            maxLength: 11,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_circle,
                size: 40,
                color: Colors.blue,
              ),
              hintText: "请输入用户名",
            ),
          ),
        ),
        SizedBox(
          height: 14,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
          child: TextField(
            maxLength: 20,
            obscureText: true,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  size: 40,
                  color: Colors.blue,
                ),
                hintText: "请输入密码"),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Container(
          padding: new EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0.0),
          width: 240,
          child: new Card(
            color: Colors.blue,
            elevation: 16.0,
            child: FlatButton(
                child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '登录/注册',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            )),
          ),
        ),
      ],
    ));
  }
}
