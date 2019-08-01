import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:async';
import 'service_url.dart';

Future requestPost(url, {formData, token, context}) async {
  print('$url 》》》开始请求数据');
  // 返回数据
  Response response;
  // 初始化Dio
  Dio dio;
  if (token != null && token != '') {
    dio = Dio(
      BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 100000,
        headers: {"Authorization": "Bearer $token"}
      )
    );
  } else {
    dio = Dio(
      BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 100000,
      )
    );
  }

  try {
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
  } catch (e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      showToast('10001：连接超时');
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      showToast('10002：请求超时');
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      showToast('10003：响应超时');
    } else if (e.type == DioErrorType.RESPONSE) {
      showToast('10004：请求异常');
      cleanToken();
      Navigator.pushNamedAndRemoveUntil(context, '/loginPage', (route) => route == null);
    } else if (e.type == DioErrorType.CANCEL) {
      showToast('10005：请求取消');
    } else {
      showToast('10006：未知错误');
    }
    return null;
  }
  if (response.statusCode == 200) {
    return response.data;
  } else {
    showToast('请求状态异常');
  } 
}