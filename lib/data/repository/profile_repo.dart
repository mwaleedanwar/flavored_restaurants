import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/dio_client.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/userinfo_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final HttpClient httpClient;
  final SharedPreferences sharedPreferences;
  ProfileRepo({required this.httpClient, required this.sharedPreferences});

  List<String> getAddressTypeList() {
    return <String>[
      'Select Address type',
      'Home',
      'Office',
      'Other',
    ];
  }

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await httpClient.get(AppConstants.CUSTOMER_INFO_URI);
      debugPrint('--get info response:${response.body}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(
    UserInfoModel userInfoModel,
    String password,
    File? file,
    XFile? data,
    String token,
  ) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse(F.BASE_URL + AppConstants.UPDATE_PROFILE_URI));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (file != null) {
      debugPrint(
          '----------------${file.readAsBytes().asStream()}/${file.lengthSync()}/${file.path.split('/').last}');
      request.files.add(http.MultipartFile(
          'image', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    } else if (data != null) {
      Uint8List list = await data.readAsBytes();
      var part = http.MultipartFile(
          'image', data.readAsBytes().asStream(), list.length,
          filename: basename(data.path),
          contentType: MediaType('image', 'jpg'));
      request.files.add(part);
      debugPrint('----------------${list.length}/${basename(data.path)}');
    }
    final fields = <String, String>{};
    if (password.isEmpty) {
      fields.addAll(<String, String>{
        '_method': 'put',
        'f_name': userInfoModel.fName ?? '',
        'l_name': userInfoModel.lName ?? '',
        'phone': userInfoModel.phone ?? '',
        'email': userInfoModel.email ?? '',
      });
    } else {
      fields.addAll(<String, String>{
        '_method': 'put',
        'f_name': userInfoModel.fName ?? '',
        'l_name': userInfoModel.lName ?? '',
        'email': userInfoModel.email ?? '',
        'phone': userInfoModel.phone ?? '',
        'password': password
      });
    }
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
}
