import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.connectionError:
            case DioExceptionType.unknown:
              errorDescription = "Connection to API server failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badCertificate:
            case DioExceptionType.badResponse:
              switch (error.response?.statusCode) {
                case 404:
                  errorDescription = 'Not available';
                  break;
                case 500:
                case 503:
                  errorDescription = error.response?.statusMessage;
                  break;
                default:
                  ErrorResponse? errorResponse;
                  try {
                    errorResponse = ErrorResponse.fromJson(error.response?.data);
                  } catch (e) {
                    debugPrint('Unknown error parsing error json: $e');
                  }
                  if (errorResponse != null && errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
                    debugPrint('error----------------== ${errorResponse.toJson()}');
                    errorDescription = errorResponse;
                  } else {
                    errorDescription = "Failed to load data - status code: ${error.response?.statusCode}";
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
          }
        } else {
          log('MASSIVE ERROR $error');
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
      debugPrint("Actual error: $error");
    }
    return errorDescription;
  }
}
