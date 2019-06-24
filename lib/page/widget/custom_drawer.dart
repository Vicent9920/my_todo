import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_todo/net/request.dart';
import 'package:my_todo/page/about/about.dart';
import 'package:my_todo/page/login/login.dart';
import 'package:my_todo/page/widget/toast.dart';
import 'package:my_todo/util/sp_store_util.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final String _userName;

  CustomDrawer(this._userName);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //侧边栏按钮Drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            //Material内置控件
            accountName: Text(
              _userName,
            ), //用户名
            currentAccountPicture: CircleAvatar(
              //圆形图标控件
              child: Image.asset('res/images/ic_launcher.png'),
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('res/images/splash.jpg'),
              ),
            ),
            accountEmail: Text(''),
          ),
          ListTile(
              title: Text('建议与反馈'),
              leading: Icon(Icons.send),
              onTap: () {
                Navigator.of(context).pop();
                _feedBack(context);
              }),
          ListTile(
              //第二个功能项
              title: Text('关于'),
              leading: Icon(Icons.info_outline),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AboutPage();
                }));
              }),
          Divider(),
          ListTile(
            title: Text('退出登录'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              _loginOut(context);
            },
          ),
        ],
      ),
    );
  }

  _feedBack(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              '建议与反馈',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                '取消',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('发送邮件'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _launchURL('mailto:weixing9920@163.com?subject=myTodo 反馈');
                },
              ),
              CupertinoActionSheetAction(
                child: Text('访问Github'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _launchURL(
                      'https://github.com/Vicent9920/my_todo/issues/new');
                },
              ),
              CupertinoActionSheetAction(
                child: Text('添加微信'),
                onPressed: () {
                  Navigator.of(context).pop();
                  MethodChannel('channel_native').invokeMethod(
                      'method_copy', ['Vicent_0310', '微信号已复制到剪切板']);
                  MethodChannel('channel_native').invokeMethod('launch_weixin');
                },
              ),
            ],
          );
        });
  }

  _loginOut(BuildContext context) {
    Request().logout().then((result) {
      SpUtils.deleteValue(SpUtils.USER_NAME).then((result) {
        if (result) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          Toast.toast(context, '退出失败');
        }
      });
    }).catchError((error) {
      Toast.toast(context, "网络异常，请稍候重试！");
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
