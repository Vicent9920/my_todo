import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_todo/generated/i18n.dart';
import 'package:my_todo/page/splash_page.dart';
import 'package:my_todo/page/widget/toast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() =>
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) //竖屏
        .then((_) {
      runApp(new MyApp());
    });

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,

      home: WillPopScope(
          child: SplashPage(), onWillPop: () => _clickBack(context)),
    );
  }

  var last = 0;

  Future<bool> _clickBack(BuildContext context) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - last > 1000) {
      last = DateTime.now().millisecondsSinceEpoch;
      Toast.toast(context, '再按一次退出');
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
