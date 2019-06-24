import 'package:flutter/material.dart';
import 'package:my_todo/entity/login_dto.dart';
import 'package:my_todo/net/request.dart';
import 'package:my_todo/page/widget/psd_field.dart';
import 'package:my_todo/page/widget/toast.dart';
import 'package:my_todo/page/widget/user_name_field.dart';
import 'package:my_todo/util/sp_store_util.dart';
import 'package:my_todo/util/util.dart';

import 'package:my_todo/page/home/main_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  FocusNode _userFocusNode = new FocusNode();
  FocusNode _psdFocusNode = new FocusNode();
  FocusScopeNode focusScopeNode;
  String _userName;
  bool _userNameValid = false;
  String _psd;
  bool _psdValid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
      child: ListView(
        children: <Widget>[
          // 上边距占位
          SizedBox(
            height: 72,
          ),
          // 圆形ICON
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 56.0,
            child: Image.asset(
              "res/images/icon_logo.png",
              color: Colors.white,
              scale: 1.8,
            ),
          ),
          SizedBox(
            height: 36,
          ),
          UserNameField(
            fieldCallBack: (username, valid) {
              _userNameValid = valid;
              if (valid) _userName = username;
            },
            autofocus: true,
            focusNode: _userFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            labelText: "用户名",
            hintText: "手机号或者邮箱",
            prefixIcon: Icon(Icons.person),
            suffixIcon: Icon(
              Icons.clear,
              color: Colors.grey[200],
            ),
            validator: (str) {
              var userName = str.trim();
              bool state =
                  isChinaPhoneLegal(userName) || isEmailValid(userName);
              return state ? null : "用户名必须是手机号或者邮箱地址";
            },
            maxLength: 30,
            onEditingComplete: () {
              if (null == focusScopeNode) {
                focusScopeNode = FocusScope.of(context);
              }
              focusScopeNode.requestFocus(_psdFocusNode);
            },
          ),
          PasswordField(
            fieldCallBack: (psd, valid) {
              _psdValid = valid;
              if (valid) {
                _psd = psd;
              }
            },
            maxLength: 20,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Icons.lock),
            focusNode: _psdFocusNode,
            validator: (v) {
              // 可在此通过正则表达式校验密码是否符合规则
              return v.trim().length > 5 ? null : "密码不能少于6位";
            },
            onEditingComplete: () {
              _userFocusNode.unfocus();
              _psdFocusNode.unfocus();
            },
          ),
          Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text("忘记密码"),
                onPressed: () => {},
              )),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
            child: RaisedButton(
                color: Colors.blue,
                highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                padding: EdgeInsets.all(10),
                child: Text(
                  "登录/注册",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () => {
                      if (_userNameValid && _psdValid)
                        {
                          Request().login(_userName, _psd).then((result) {
                            if (result.errorCode != -1) {
                              LoginDTO entity = LoginDTO.fromJson(result.data);
                              SpUtils.setString(
                                  SpUtils.USER_NAME, entity.username);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()));
                            } else {
                              if (result.errorMsg == '账号密码不匹配！') {
                                register(context);
                              }
                              // TODO 注册
                            }
                          }).catchError((e) {
                            print("登录异常：${e.message}");
                            //登录异常：网络错误：405
                          })
                        }
                    }),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(left: 24),
              height: 72,
              child: FlatButton(
                child: Text(
                  "跳过登录",
                  style: TextStyle(fontSize: 12.0),
                ),
                onPressed: () => {
                      // 跳过登录
                    },
              )),
        ],
      ),
    ));
  }

  void register(BuildContext context) {
    Request().register(_userName, _psd, _psd).then((result) {
      SpUtils.setString(SpUtils.USER_NAME, result.username);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    }).catchError((error) {
      print("登录异常：${error}");
      Toast.toast(context, "注册失败");
    });
  }
}
