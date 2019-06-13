import 'package:my_todo/entity/base_dto.dart';
import 'package:my_todo/entity/login_dto.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/net/requestimpl.dart';

abstract class Request {
  static RequestImpl _impl;

  Request.internal();

  factory Request() {
    if (_impl == null) {
      _impl = RequestImpl();
    }
    return _impl;
  }

  //登录
  Future<BaseDTO> login(String username, String password);

  //注册
  Future<LoginDTO> register(
      String username, String password, String repassword);

  //登出
  Future<Null> logout();

  // 获取计划清单
  Future<List<MatterData>> getTodoList(
      bool isFinish, int type, int page, int orderby);
}
