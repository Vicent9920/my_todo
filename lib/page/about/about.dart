import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _appName = '';
  String _appVersion = '';

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              MethodChannel('channel_native').invokeMethod(
                  'method_share', 'https://github.com/Vicent9920/my_todo');
            },
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 14,
            ),
            Image.asset(
              'res/images/ic_launcher_foreground.png',
              width: 120,
              height: 120,
            ),
            Center(
              child: Text(
                _appName,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Center(
              child: Text(
                _appVersion,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: '说明\n\n',
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black87),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '第二个flutter 应用，该应用仅限于学习flutter的相关知识，通过实战学习相关api以及掌握学习新知识的方法\n\n',
                            ),
                            TextSpan(
                                text: 'Api 由 WAN ANDROID 提供\n\n',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text:
                                    'https://www.wanandroid.com/blog/show/2442\n\n',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => _launchURL(
                                      'https://www.wanandroid.com/blog/show/2442')),
                            TextSpan(
                                text: '开源地址\n\n',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text:
                                    'https://github.com/Vicent9920/my_todo\n\n',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => _launchURL(
                                      'https://github.com/Vicent9920/my_todo')),
                            TextSpan(
                                text: '博客地址\n\n',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text:
                                    'https://juejin.im/post/5cf0d254518825581878205c',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => _launchURL(
                                      'https://juejin.im/post/5cf0d254518825581878205c')),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }

  _init() async {
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _appName = info.appName;
        _appVersion = info.version;
      });
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
