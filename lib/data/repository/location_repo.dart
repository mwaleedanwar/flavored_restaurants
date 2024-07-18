import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/dio_client.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/address_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LocationRepo {
  final HttpClient httpClient;
  final SharedPreferences sharedPreferences;

  LocationRepo({required this.httpClient, required this.sharedPreferences});

  Future<ApiResponse> getAllAddress() async {
    debugPrint('-----getAllAddress Api');
    try {
      final response = await httpClient.get(AppConstants.ADDRESS_LIST_URI);
      debugPrint('-----getAllAddress Api response:${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeAddressByID(int id) async {
    debugPrint('-----removeAddressByID Api by id $id ');

    try {
      final response = await httpClient.post('${AppConstants.REMOVE_ADDRESS_URI}$id', data: {"_method": "delete"});

      debugPrint('-----removeAddressByID Api response:$response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addAddress(AddressModel addressModel) async {
    debugPrint('-----removeAddressByID Api ');

    try {
      http.Response response = await httpClient.post(
        AppConstants.ADD_ADDRESS_URI,
        data: addressModel.toJson(),
      );
      debugPrint('-----Add address Api response:$response');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateAddress(
    AddressModel addressModel,
    int addressId,
  ) async {
    debugPrint('-----update address Api ');

    try {
      http.Response response = await httpClient.post(
        '${AppConstants.UPDATE_ADDRESS_URI}$addressId',
        data: addressModel.toJson(),
      );
      debugPrint('-----update address Api response:$response');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String> getAllAddressType() {
    return [
      'Home',
      'Workplace',
      'Other',
    ];
  }

  Future<ApiResponse> getAddressFromGeocode(LatLng latLng) async {
    debugPrint('-----getAddressFromGeocode');

    try {
      http.Response response =
          await httpClient.get('${AppConstants.GEOCODE_URI}?lat=${latLng.latitude}&lng=${latLng.longitude}');
      debugPrint('-----getAddressFromGeocode Api response:$response');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchLocation(String text) async {
    debugPrint('------search api');
    try {
      http.Response response =
          await httpClient.get('${AppConstants.SEARCH_LOCATION_URI}?search_text=$text&restaurant_id=${F.restaurantId}');
      debugPrint('------search api response:$response');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPlaceDetails(String placeID) async {
    debugPrint('------places details api  for ID:$placeID');

    try {
      http.Response response =
          await httpClient.get('${AppConstants.PLACE_DETAILS_URI}?placeid=$placeID&restaurant_id=${F.restaurantId}');
      debugPrint('------places details api response:$response');

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
