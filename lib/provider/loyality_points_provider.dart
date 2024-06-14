import 'dart:convert';

import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_details_model.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/review_body_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/response_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/product_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../data/repository/loyality_points_repo.dart';
import 'localization_provider.dart';

class LoyalityPointsProvider extends ChangeNotifier {
  final LoyalityPointsRepo loyalityPointsRepo;

  LoyalityPointsProvider({@required this.loyalityPointsRepo});

  // Latest products
  List<Product> _poinstProductList;

  bool _isLoading = false;

  List<Product> get popularProductList => _poinstProductList;

  bool get isLoading => _isLoading;

  Future<void> getLatestProductList(BuildContext context) async {
    if (5 == 5) {
      ApiResponse apiResponse = await loyalityPointsRepo.getPointsProductList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        print('${jsonDecode(apiResponse.response.body)}');

        _poinstProductList.addAll(ProductModel.fromJson(jsonDecode(apiResponse.response.body)).products);

        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString(), context);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
