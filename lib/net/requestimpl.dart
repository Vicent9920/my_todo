import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:my_todo/entity/base_dto.dart';
import 'package:my_todo/entity/login_dto.dart';
import 'package:my_todo/net/api.dart';
import 'package:my_todo/net/request.dart';
import 'package:my_todo/util/sp_store_util.dart';

class RequestImpl extends Request {
  Dio _dio;

  RequestImpl() : super.internal() {
    _dio = Dio(BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: 30 * 1000,
        receiveTimeout: 30 * 1000));
    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: onSuccess,
      onError: onError,
    ));
    _dio.interceptors.add(CookieManager(CookieJar()));
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
      // TODO 待删除 在业务代码中序列化后保存
      SpUtils.saveLoginDTO(str: response.data);
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
  Future<Null> logout() async{
    Response response = await _dio.get(Api.logout);
    Map<String, dynamic> resJson = json.decode(response.data);
    BaseDTO base = BaseDTO.fromJson(resJson);
    return base.data;
  }

  @override
  Future<LoginDTO> register(
      String username, String password, String repassword) async{
    Response response = await _dio.post(Api.register,data: FormData.from({'username': username, 'password': password}));
    if(response.data is String){
      // TODO 待删除 在业务代码中序列化后保存
      SpUtils.saveLoginDTO(str: response.data);
    }
    return LoginDTO.fromJson(_handleRes(response));
  }


}
