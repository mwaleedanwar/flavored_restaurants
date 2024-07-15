import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/main_common.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/dio_client.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/branch_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';

class CategoryRepo {
  final HttpClient httpClient;

  CategoryRepo({required this.httpClient});

  Future<ApiResponse> getCategoryList(String languageCode) async {
    try {
      final response = await httpClient.get(
        AppConstants.CATEGORY_URI,
        options: Options(headers: {'X-localization': languageCode}),
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAllCategoryProductList(String languageCode) async {
    try {
      final response = await httpClient.get(
        '${AppConstants.ALL_PRODUCTS}&branch_id=${Provider.of<BranchProvider>(Get.context, listen: false).branch}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategoryList(
    String parentID,
    String languageCode,
  ) async {
    debugPrint('-----getSubCategoryList');
    try {
      final response = await httpClient.get(
        '${AppConstants.SUB_CATEGORY_URI}$parentID?restaurant_id=${F.restaurantId}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      debugPrint('-----getSubCategoryList response: $response');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryProductList(
      String categoryID, String languageCode, String type) async {
    debugPrint(
        '-----getCategoryProductList url:${F.BASE_URL + AppConstants.CATEGORY_PRODUCT_URI}$categoryID?product_type=$type');

    try {
      final response = await httpClient.get(
        '${AppConstants.CATEGORY_PRODUCT_URI}$categoryID?product_type=$type&restaurant_id=${F.restaurantId}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      debugPrint('-----getCategoryProductList response: ${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
