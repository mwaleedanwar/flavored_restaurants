import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/error_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    String _message;
    if (apiResponse.error is String) {
      _message = apiResponse.error;
    } else {
      _message = ErrorResponse.fromJson(apiResponse.error).errors[0].message;
    }

    if (_message == 'Unauthorized.' ||
        _message == 'Unauthenticated.' && ModalRoute.of(context).settings.name != Routes.getLoginRoute()) {
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      if (ModalRoute.of(context).settings.name != Routes.getLoginRoute()) {
        Navigator.pushNamedAndRemoveUntil(context, Routes.getLoginRoute(), (route) => false);
      }
    } else {
      showCustomSnackBar(_message, context);
    }
  }
}
