import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:my_todo/entity/base_dto.dart';
import 'package:my_todo/entity/login_dto.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/entity/todo_group_entity.dart';
import 'package:my_todo/net/api.dart';
import 'package:my_todo/net/request.dart';
import 'package:path_provider/path_provider.dart';

class RequestImpl extends Request {
  Dio _dio;

  RequestImpl() : super.internal() {
    var option = BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: 30 * 1000,
        receiveTimeout: 30 * 1000);
    _dio = Dio(option);
    _dio.interceptors
      ..add(LogInterceptor())
      ..add(InterceptorsWrapper(
        onError: onError,
      ));
    _setPersistCookieJar();
  }

  onSuccess(Response response) {
    Map<String, dynamic> resJson;
    if (response.data is String) {
      resJson = json.decode(response.data);
    } else if (response.data is Map<String, dynamic>) {
      resJson = response.data;
    } else {
      throw DioError(message: '数据解析错误');
    }
    BaseDTO base = BaseDTO.fromJson(resJson);
    return base;
  }

  _setPersistCookieJar() async {
    Directory dir = await getApplicationDocumentsDirectory();
    _dio.interceptors..add(CookieManager(PersistCookieJar(dir: dir.path)));
  }

  onError(DioError error) {
    switch (error.type) {
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
        throw DioError(message: '连接超时');
        break;
      case DioErrorType.RESPONSE:
        throw DioError(message: '网络错误：' + error.response.statusCode.toString());
        break;
      default:
        throw DioError(message: '网络错误');
        break;
    }
  }

  _handleRes(Response response) {
    Map<String, dynamic> resJson;
    if (response.data is String) {
      resJson = json.decode(response.data);
    } else if (response.data is Map<String, dynamic>) {
      resJson = response.data;
    } else {
      throw DioError(message: '数据解析错误');
    }
    BaseDTO base = BaseDTO.fromJson(resJson);
    if (base.errorCode == 0) {
      return base.data;
    } else {
      throw DioError(message: base.errorMsg);
    }
  }

  @override
  Future<BaseDTO> login(String username, String password) async {
    Response response = await _dio.post(Api.login,
        data: FormData.from({'username': username, 'password': password}));
    Map<String, dynamic> resJson;
    if (response.data is String) {
      resJson = json.decode(response.data);
    } else if (response.data is Map<String, dynamic>) {
      resJson = response.data;
    } else {
      throw DioError(message: '数据解析错误');
    }
    BaseDTO base = BaseDTO.fromJson(resJson);
    return base;
  }

  @override
  Future<Null> logout() async {
    var response = await _dio.get(Api.logout);
    BaseDTO base = BaseDTO.fromJson(response.data);
    return base.data;
  }

  @override
  Future<LoginDTO> register(
      String username, String password, String repassword) async {
    Response response = await _dio.post(Api.register,
        data: FormData.from({'username': username, 'password': password}));
    return LoginDTO.fromJson(_handleRes(response));
  }

  /**
   * 获取计划清单
   * @Param isFinish 是否已完成
   * @Param type 清单类型：工作1；生活2；娱乐3；所有0；
   * @Param page 页码 从1开始
   * @Param page 排序 1:完成日期顺序；2.完成日期逆序；3.创建日期顺序；4.创建日期逆序(默认)；
   */
  @override
  Future<TodoGroupEntity> getTodoList(
      bool isFinish, int type, int page, int orderby) async {
    var map = Map<String, dynamic>();
    map["status"] = (isFinish) ? 1 : 0;
    if (type != 0) {
      map["type"] = type;
    }
    if (orderby != 4) {
      map["orderby"] = orderby;
    }
    Response response =
        await _dio.get("lg/todo/v2/list/$page/json", queryParameters: map);
    return TodoGroupEntity.fromJson(_handleRes(response));
  }

  @override
  Future<Null> deleteMatter(int id) async {
    Response response = await _dio.post('lg/todo/delete/${id}/json');
    return _handleRes(response);
  }

  @override
  Future<MatterData> updateMatterStatus(int id, bool isFinished) async {
    Response response = await _dio.post('lg/todo/delete/${id}/json',
        data: {'status': (isFinished) ? 1 : 0});
    return _handleRes(response);
  }

  @override
  Future<MatterData> addTodo(
      String title, String content, String date, int type) async {
    Response response = await _dio.post(Api.addTodo,
        data: {'title': title, 'content': content, 'date': date, 'type': type});
    return _handleRes(response);
  }

  @override
  Future<MatterData> updateMatter(MatterData item) async {
    Response response = await _dio.post(Api.addTodo, data: {
      'id': item.id,
      'title': item.title,
      'content': item.content,
      'date': item.dateStr,
      'type': item.type
    });
    return _handleRes(response);
  }
}
