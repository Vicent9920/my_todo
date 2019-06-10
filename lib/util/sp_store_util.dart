import 'dart:convert';

import 'package:my_todo/entity/login_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtils{
  static String _loginDTOKey = "loginDTOKey";
  static Future<bool> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) == null ? false : prefs.getBool(key);
  }

  static Future<bool> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) == null ? 0 : prefs.getInt(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, value);
  }

  static Future<double> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static Future<bool> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /**
   * 待实现序列化
   */
  static Future<bool> saveLoginDTO({bean:LoginDTO,str:String}) async {
    if(bean == null){
      return await setString(_loginDTOKey, str);
    }else{
      return await setString(_loginDTOKey, bean.toString());
    }

  }

  static Future<LoginDTO> getLoginDTO() async{
    String str = await getString(_loginDTOKey);
    if(str != null){
      LoginDTO.fromJson(json.decode(str));
    }else{
      // TODO 抛出异常
      LoginDTO.fromJson(json.decode(""));
    }

  }
}