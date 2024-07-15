import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  final SharedPreferences sharedPreferences;
  CartRepo({required this.sharedPreferences});

  List<CartModel> getCartList() {
    debugPrint('------getCartList-----');
    List<String> carts = [];
    if (sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST) ?? [];
    }
    List<CartModel> cartList = [];
    for (var cart in carts) {
      cartList.add(CartModel.fromJson(jsonDecode(cart)));
    }
    return cartList;
  }

  void addToCartList(List<CartModel> cartProductList) {
    debugPrint('------addToCartList-----');
    List<String> carts = [];
    for (var cartModel in cartProductList) {
      carts.add(jsonEncode(cartModel));
    }
    sharedPreferences.setStringList(AppConstants.CART_LIST, carts);
  }

  void addToCateringList(List<CateringCartModel> cartCateringList) {
    debugPrint('------addToCartList-----');
    List<String> caterings = [];
    sharedPreferences.setStringList(AppConstants.CATERING_LIST, caterings);
  }

  void addToHappyHoursList(List<HappyHoursCartModel> happyHoursList) {
    debugPrint('------addToCartList-----');
    List<String> carts = [];
    sharedPreferences.setStringList(AppConstants.HAPPY_HOURS_LIST, carts);
  }

  void addToDealList(List<DealCartModel> deals) {
    debugPrint('------addToCartList-----');
    List<String> carts = [];
    sharedPreferences.setStringList(AppConstants.HAPPY_HOURS_LIST, carts);
  }
}
