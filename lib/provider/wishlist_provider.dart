// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/wishlist_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';
import '../view/base/custom_snackbar.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo wishListRepo;
  WishListProvider({required this.wishListRepo});

  List<Product> _wishList = [];
  List<int> _wishIdList = [];
  bool _isLoading = false;

  List<Product> get wishList => _wishList;

  List<int> get wishIdList => _wishIdList;

  bool get isLoading => _isLoading;

  void addToWishList(Product product, BuildContext context) async {
    _wishList.add(product);
    _wishIdList.add(product.id);
    notifyListeners();
    ApiResponse apiResponse = await wishListRepo.addWishList(product.id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = jsonDecode(apiResponse.response!.body);
      String message = map['message'];
      showCustomSnackBar(message, context, isError: false);
    } else {
      _wishList.remove(product);
      _wishIdList.remove(product.id);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void removeFromWishList(Product product, BuildContext context) async {
    _wishList.removeAt(_wishIdList.indexOf(product.id));
    _wishIdList.remove(product.id);
    notifyListeners();
    ApiResponse apiResponse = await wishListRepo.removeWishList(product.id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = jsonDecode(apiResponse.response!.body);
      String message = map['message'];
      showCustomSnackBar(message, context, isError: false);
    } else {
      _wishList.add(product);
      _wishIdList.add(product.id);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> initWishList(BuildContext context, String languageCode) async {
    _isLoading = true;
    _wishList = [];
    _wishIdList = [];
    ApiResponse apiResponse = await wishListRepo.getWishList(languageCode);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _wishList = [];
      _wishIdList = [];
      _wishList.addAll(ProductModel.fromJson(jsonDecode(apiResponse.response!.body)).products ?? []);
      for (int i = 0; i < _wishList.length; i++) {
        _wishIdList.add(_wishList[i].id);
      }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }
}
