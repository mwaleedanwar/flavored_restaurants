import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/dio_client.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/place_order_body.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderRepo {
  final HttpClient httpClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({required this.httpClient, required this.sharedPreferences});

  Future<ApiResponse> getOrderList() async {
    try {
      final response = await httpClient.get(AppConstants.ORDER_LIST_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderDetails(String orderID) async {
    try {
      final response = await httpClient.get('${AppConstants.ORDER_DETAILS_URI}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> cancelOrder(String orderID) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['order_id'] = orderID;
      data['_method'] = 'put';
      final response = await httpClient.post(AppConstants.ORDER_CANCEL_URI, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updatePaymentMethod(String orderID) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['order_id'] = orderID;
      data['_method'] = 'put';
      data['payment_method'] = 'cash_on_delivery';
      final response = await httpClient.post(AppConstants.UPDATE_METHOD_URI, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> trackOrder(String orderID) async {
    debugPrint('url for order track :${AppConstants.TRACK_URI}$orderID');

    try {
      final response = await httpClient.get('${AppConstants.TRACK_URI}$orderID');
      debugPrint('response for order track :${response.body}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> placeOrder(PlaceOrderBody orderBody) async {
    debugPrint('--place order APi:$orderBody ');
    try {
      final response = await httpClient.post(AppConstants.NEW_WEB_URL, data: orderBody);
      debugPrint('--place order APi  response: ${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> makePayment(String token, double amount, String name, String email) async {
    var data = {
      'source': token,
      'amount': amount.toStringAsFixed(2),
      'connectedAccountId': 'acct_1OiBwrQplGq89xUZ',
      'customer_name': name,
      'customer_email': email,
    };
    debugPrint('==payment model: $data');
    try {
      final response = await httpClient.post(AppConstants.STRIPE_PAYMENT_URI, data: data);
      debugPrint('--makePayment APi  response: ${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryManData(String orderID) async {
    try {
      final response = await httpClient.get('${AppConstants.LAST_LOCATION_URI}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    try {
      http.Response response = await httpClient.get('${AppConstants.DISTANCE_MATRIX_URI}'
          '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
          '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}&restaurant_id=${F.restaurantId}');

      debugPrint('======== getDistanceInMeter response:$response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
