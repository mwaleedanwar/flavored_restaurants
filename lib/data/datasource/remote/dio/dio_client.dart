import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../di_container.dart';
import '../../../../helper/responsive_helper.dart';

import 'package:http/http.dart' as http;

class HttpClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio dio;
  String? token;

  HttpClient(
    this.baseUrl,
    Dio dioC, {
    required this.loggingInterceptor,
    required this.sharedPreferences,
  }) {
    token = sharedPreferences.getString(AppConstants.TOKEN);
    //print(token);
  }

  Future<void> updateHeader({required String getToken}) async {
    dio = sl() ?? Dio();
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = ResponsiveHelper.isMobilePhone() ? 30000 : 60 * 30000
      ..options.receiveTimeout = ResponsiveHelper.isMobilePhone() ? 30000 : 60 * 30000
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'branch-id': '${sharedPreferences.getInt(AppConstants.BRANCH)}',
        'X-localization':
            sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ?? AppConstants.languages[0].languageCode,
        'Authorization': 'Bearer ${getToken ?? token}',
      };
    dio.interceptors.add(loggingInterceptor);
  }

  Future<http.Response> get(
    String uri, {
    var queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var url = Uri.parse(F.BASE_URL + uri);
      debugPrint('=====$uri :$url');
      debugPrint('====token: $token');

      var response = await http.get(url,

          // headers: {
          //   'Content-Type': 'application/json; charset=UTF-8',
          //   'Authorization': 'Bearer $token'
          // }
          //
          headers: {"Authorization": "Bearer $token"});

      debugPrint('=====$uri :${response.body}');

      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('Unknown Error: $e');
      rethrow;
    }
  }

  Future<http.Response> post(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    var url = Uri.parse(F.BASE_URL + uri);
    debugPrint('=====$uri :$url');
    debugPrint('=====$uri body :${data.toString()}');
    debugPrint('=====bareer :$token');

    try {
      var response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
      );
      debugPrint('=====$uri response :${response.body}');
      debugPrint('=====$uri response :${response.statusCode}');
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('Unknown error :$e');
      rethrow;
    }
  }

  Future<http.Response> put(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    var url = Uri.parse(F.BASE_URL + uri);
    debugPrint('=====$uri :$url');

    try {
      var response = await http.put(
        url,
        body: data,
        headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('Unknown error :$e');
      rethrow;
    }
  }

  Future<http.Response> delete(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) async {
    var url = Uri.parse(F.BASE_URL + uri);
    debugPrint('=====$uri :$url');

    try {
      var response = await http.delete(
        url,
        body: data,
        // headers: {
        //   'Content-Type': 'application/json; charset=UTF-8',
        //   'Authorization': 'Bearer $token'
        // },
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('Unknown error :$e');
      rethrow;
    }
  }
}

///old code

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio dio;
  String token;

  DioClient(
    this.baseUrl,
    Dio dioC, {
    this.loggingInterceptor,
    this.sharedPreferences,
  }) {
    token = sharedPreferences.getString(AppConstants.TOKEN);
    //print(token);
    dio = dioC ?? Dio();
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = ResponsiveHelper.isMobilePhone() ? 30000 : 60 * 30000
      ..options.receiveTimeout = ResponsiveHelper.isMobilePhone() ? 30000 : 60 * 30000
      ..httpClientAdapter
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};
    dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('Unknown error :$e');
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('Unknown error :$e');
      rethrow;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('Unknown error :$e');
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) async {
    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      debugPrint('Unknown error :$e');
      rethrow;
    }
  }
}
