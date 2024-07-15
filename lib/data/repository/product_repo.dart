import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/dio_client.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/review_body_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/branch_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/main_common.dart';

class ProductRepo {
  final HttpClient httpClient;

  ProductRepo({required this.httpClient});

  Future<ApiResponse> getLatestProductList(String offset, String languageCode) async {
    debugPrint('----getLatestProductList--');
    try {
      final response = await httpClient.get(
        '${AppConstants.LATEST_PRODUCT_URI}?limit=12&&offset=$offset&&restaurant_id=${F.restaurantId}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      debugPrint(languageCode);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getLatestProductList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPointsProductList() async {
    debugPrint('----getPointsProductList--');
    try {
      final response = await httpClient.get(
        AppConstants.LOYALTY_POINTS_PRODUCTS,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getPointsProductList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSpecialOffersList() async {
    debugPrint('----getPointsProductList--');
    try {
      final response = await httpClient.get(
        AppConstants.SPECIAL_OFFER_URL,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getPointsProductList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDealsList() async {
    debugPrint('----getDealsList--');
    try {
      final response = await httpClient.get(
        AppConstants.DEALS_URL,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getDealsList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRecommendedSideList() async {
    debugPrint('----getRecommendedSideList--');
    try {
      final response = await httpClient.get(
        '${AppConstants.RECOMMENDED_SIDES_URL}&branch_id=${Provider.of<BranchProvider>(Get.context, listen: false).branch}',
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getRecommendedSideList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRecommendedBeveragesList() async {
    debugPrint('----getRecommendedSideList--');
    try {
      final response = await httpClient.get(
        '${AppConstants.RECOMMENDED_BARVAGES_URL}&branch_id=${Provider.of<BranchProvider>(Get.context, listen: false).branch}',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getRecommendedSideList error :$e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPopularProductList(String offset, String type, String languageCode) async {
    debugPrint('----getPopularProductList--');

    try {
      final response = await httpClient.get(
        '${AppConstants.ALL_POPULAR_PRODUCT_URI}&branch_id=${Provider.of<BranchProvider>(Get.context, listen: false).branch}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRelatedProductList(int id, String languageCode) async {
    debugPrint('----getRelatedProductList--');

    try {
      final response = await httpClient.get(
        '${AppConstants.RELATED_PRODUCTS}$id?restaurant_id=${F.restaurantId}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitReview(ReviewBody reviewBody) async {
    try {
      final response = await httpClient.post(AppConstants.REVIEW_URI, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitDeliveryManReview(ReviewBody reviewBody) async {
    try {
      final response = await httpClient.post(AppConstants.DELIVER_MAN_REVIEW_URI, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateLoyaltyPoints(double points) async {
    try {
      final response = await httpClient.post(AppConstants.USE_LOYALTY_URI, data: {'point': points});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
