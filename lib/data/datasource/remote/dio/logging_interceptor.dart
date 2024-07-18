import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    debugPrint("<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");
    String responseAsString = response.data.toString();
    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
      }
    }
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    return super.onError(err, handler);
  }
}
