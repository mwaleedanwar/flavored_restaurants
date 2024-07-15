// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/banner_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/banner_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';
import 'package:provider/provider.dart';

import 'localization_provider.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;
  List<BannerModel>? bannerList;
  BannerProvider({required this.bannerRepo});

  final productList = <Product>[];

  Future<void> getBannerList(BuildContext context, bool reload) async {
    if (bannerList == null || reload) {
      ApiResponse apiResponse = await bannerRepo.getBannerList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        bannerList = [];

        jsonDecode(apiResponse.response!.body).forEach((category) {
          BannerModel bannerModel = BannerModel.fromJson(category);
          debugPrint('===getting details:${bannerModel.productId}');

          if (bannerModel.productId != null) {
            debugPrint('===getting details');
            getProductDetails(
              context,
              bannerModel.productId.toString(),
              Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
            );
          }
          bannerList!.add(bannerModel);
          debugPrint('==banes: list:${bannerList!.length}');
        });
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
  }

  void getProductDetails(BuildContext context, String productID, String languageCode) async {
    debugPrint('---getProductDetails#');
    ApiResponse apiResponse = await bannerRepo.getProductDetails(productID, languageCode);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      productList.add(Product.fromJson(jsonDecode(apiResponse.response!.body)));
    }
  }
}
