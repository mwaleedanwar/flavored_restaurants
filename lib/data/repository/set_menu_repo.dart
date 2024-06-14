import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/dio_client.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';

class SetMenuRepo {
  final HttpClient httpClient;
  SetMenuRepo({@required this.httpClient});

  Future<ApiResponse> getSetMenuList(String languageCode) async {
    debugPrint('---getSetMenuList----');
    try {
      final response = await httpClient.get(
        AppConstants.SET_MENU_URI,
        options: Options(headers: {'X-localization': languageCode}),
      );
      debugPrint('---getSetMenuList response"${response}--');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
