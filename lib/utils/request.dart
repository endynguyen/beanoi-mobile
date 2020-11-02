import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import '../constraints.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class ExpiredException extends AppException {
  ExpiredException([String message]) : super(message, "Token Expired: ");
}

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    print(
        "REQUEST[${options?.method}] => PATH: ${options?.path} HEADER: ${options.headers.toString()}");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    print(
        "RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    return super.onError(err);
  }
}

// or new Dio with a BaseOptions instance.

class MyRequest {
  static BaseOptions options = new BaseOptions(
      baseUrl: 'http://api.dominos.reso.vn/api/v2',
      // baseUrl: 'https://192.168.1.199:45455/api/v2',
      headers: {
        Headers.contentTypeHeader: "application/json",
      },
      receiveTimeout: 5000);
  Dio _inner;
  MyRequest() {
    _inner = new Dio(options);
    _inner.interceptors.add(CustomInterceptors());
    _inner.interceptors.add(InterceptorsWrapper(
      onResponse: (Response response) async {
        // Do something with response data
        return response; // continue
      },
      onError: (DioError e) async {
        // Do something with response error
        if (e.response.statusCode == 401) {
          await showStatusDialog("assets/images/global_error.png", "Lỗi",
              "Vui lòng đang nhập lại");
          Get.offAllNamed(RouteHandler.LOGIN);
        } else
          throw e; //continue
      },
    ));
  }

  Dio get request {
    return _inner;
  }

  set setToken(token) {
    options.headers["Authorization"] = "Bearer $token";
  }
}

final requestObj = new MyRequest();
final request = requestObj.request;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
