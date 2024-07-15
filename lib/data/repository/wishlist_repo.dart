import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/dio_client.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';

class WishListRepo {
  final HttpClient httpClient;

  WishListRepo({required this.httpClient});

  Future<ApiResponse> getWishList(String languageCode) async {
    try {
      final response = await httpClient.get(
        AppConstants.WISH_LIST_GET_URI,
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addWishList(int productID) async {
    debugPrint('---add to whish');
    try {
      final response = await httpClient.post(AppConstants.ADD_WISH_LIST_URI,
          data: {'product_id': productID});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeWishList(int productID) async {
    debugPrint('---remove to whish');

    debugPrint('product id : $productID');
    try {
      final response = await httpClient.post(AppConstants.REMOVE_WISH_LIST_URI,
          data: {'product_id': productID, '_method': 'delete'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
