// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/loyality_points_repo.dart';

class LoyalityPointsProvider extends ChangeNotifier {
  final LoyalityPointsRepo loyalityPointsRepo;

  LoyalityPointsProvider({required this.loyalityPointsRepo});

  // Latest products
  final List<Product> _poinstProductList = [];

  bool _isLoading = false;

  List<Product> get popularProductList => _poinstProductList;

  bool get isLoading => _isLoading;

  Future<void> getLatestProductList(BuildContext context) async {
    if (5 == 5) {
      ApiResponse apiResponse = await loyalityPointsRepo.getPointsProductList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        debugPrint('${jsonDecode(apiResponse.response!.body)}');

        _poinstProductList.addAll(
            ProductModel.fromJson(jsonDecode(apiResponse.response!.body))
                    .products ??
                []);

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
