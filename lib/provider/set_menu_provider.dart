// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/set_menu_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';

class SetMenuProvider extends ChangeNotifier {
  final SetMenuRepo setMenuRepo;

  SetMenuProvider({required this.setMenuRepo});

  List<Product>? _setMenuList;
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;

  bool get pageFirstIndex => _pageFirstIndex;
  bool get pageLastIndex => _pageLastIndex;

  List<Product>? get setMenuList => _setMenuList;

  Future<void> getSetMenuList(
      BuildContext context, bool reload, String languageCode) async {
    if (setMenuList == null || reload) {
      ApiResponse apiResponse = await setMenuRepo.getSetMenuList(languageCode);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _setMenuList = [];
        jsonDecode(apiResponse.response!.body)
            .forEach((setMenu) => _setMenuList!.add(Product.fromJson(setMenu)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  updateSetMenuCurrentIndex(int index, int totalLength) {
    if (index > 0) {
      _pageFirstIndex = false;
      notifyListeners();
    } else {
      _pageFirstIndex = true;
      notifyListeners();
    }
    if (index + 1 == totalLength) {
      _pageLastIndex = true;
      notifyListeners();
    } else {
      _pageLastIndex = false;
      notifyListeners();
    }
  }
}
