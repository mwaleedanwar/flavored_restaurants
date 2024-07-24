// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/category_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/category_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/category_product_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({required this.categoryRepo});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? _subCategoryList;
  List<Product>? _categoryProductList;
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;
  bool _isLoading = false;
  String? _selectedSubCategoryId;
  int _selectCategory = -1;

  List<CategoryModel> get categoryList => _categoryList ?? [];

  List<CategoryModel> get subCategoryList => _subCategoryList ?? [];

  List<Product> get categoryProductList => _categoryProductList ?? [];

  bool get pageFirstIndex => _pageFirstIndex;

  bool get pageLastIndex => _pageLastIndex;

  bool get isLoading => _isLoading;

  String get selectedSubCategoryId => _selectedSubCategoryId ?? '';

  int get selectCategory => _selectCategory;

  Future<void> getCategoryList(BuildContext context, bool reload, String languageCode) async {
    _subCategoryList = null;
    if (_categoryList == null || reload) {
      _isLoading = true;
      ApiResponse apiResponse = await categoryRepo.getCategoryList(languageCode);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList = [];
        jsonDecode(apiResponse.response!.body)
            .forEach((category) => _categoryList!.add(CategoryModel.fromJson(category)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void getSubCategoryList(BuildContext context, String categoryID, String languageCode) async {
    _subCategoryList = null;
    _isLoading = true;
    ApiResponse apiResponse = await categoryRepo.getSubCategoryList(categoryID, languageCode);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _subCategoryList = [];
      jsonDecode(apiResponse.response!.body)
          .forEach((category) => _subCategoryList!.add(CategoryModel.fromJson(category)));
      getCategoryProductList(context, categoryID, languageCode);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  void getCategoryProductList(BuildContext context, String categoryID, String languageCode,
      {String type = 'all'}) async {
    _categoryProductList = null;
    _selectedSubCategoryId = categoryID;
    notifyListeners();
    ApiResponse apiResponse = await categoryRepo.getCategoryProductList(categoryID, languageCode, type);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _categoryProductList = [];
      jsonDecode(apiResponse.response!.body)
          .forEach((category) => _categoryProductList!.add(Product.fromJson(category)));
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
  }

  updateSelectCategory(int index) {
    _selectCategory = index;
    notifyListeners();
  }

  updateProductCurrentIndex(int index, int totalLength) {
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

class AllCategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;
  double catHeight = 110.0;
  double proHeight = 55.0;
  List<TabCat> tabs = [];
  ScrollController scrollController = ScrollController();

  AllCategoryProvider({required this.categoryRepo});

  List<CategoryProductModel> categoryList = [];

  List<ProductItem> categoryProductList = [];
  final bool _pageFirstIndex = true;
  final bool _pageLastIndex = false;
  bool _isLoading = false;
  bool get pageFirstIndex => _pageFirstIndex;

  bool get pageLastIndex => _pageLastIndex;

  bool get isLoading => _isLoading;

  Future<void> getCategoryList(BuildContext context, bool reload, String languageCode) async {
    if (categoryList.isEmpty || reload) {
      _isLoading = true;
      ApiResponse apiResponse = await categoryRepo.getAllCategoryProductList(languageCode);
      if (categoryList.isEmpty && apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        debugPrint('====new response:${apiResponse.response!.body}');
        jsonDecode(apiResponse.response!.body).forEach((category) {
          debugPrint(
              '====new response:${CategoryProductModel.fromJson(category).name}:${CategoryProductModel.fromJson(category).products.length}');
          if (CategoryProductModel.fromJson(category).products.isNotEmpty) {
            categoryList.add(CategoryProductModel.fromJson(category));
          }
        });

        debugPrint('==new list:$categoryList');
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void init(TickerProvider tickerProvider) {
    debugPrint('==tabs init ');
    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < categoryList.length; i++) {
      final category = categoryList[i];
      if (offsetFrom > 0) {
        offsetFrom += categoryList[i - 1].products.length * proHeight;
      }

      if (i < categoryList.length - 1) {
        offsetTo = offsetFrom + categoryList[i + 1].products.length * proHeight;
      } else {
        offsetTo = double.infinity;
      }
      tabs.add(
        TabCat(
          categoryProductModel: category,
          selected: (i == 0),
          offset: catHeight * i + offsetFrom,
          offsetTo: offsetTo,
        ),
      );
      for (int j = 0; j < category.products.length; j++) {
        final product = category.products[j];
        categoryProductList.add(ProductItem(
          product: product,
          categoryProductModel: category,
        ));
      }
    }
  }

  void onCategorySelected(int index, {animationRequired = true}) async {
    debugPrint('==selected index:$index');
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.categoryProductModel.name == tabs[i].categoryProductModel.name;
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();
    if (animationRequired) {
      await scrollController.animateTo(
        selected.offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }
}

class TabCat {
  CategoryProductModel categoryProductModel;
  bool selected;
  double offset;
  double offsetTo;

  TabCat({
    required this.categoryProductModel,
    required this.selected,
    required this.offset,
    required this.offsetTo,
  });

  TabCat copyWith(bool selected) =>
      TabCat(categoryProductModel: categoryProductModel, selected: selected, offset: offset, offsetTo: offsetTo);
}

class ProductItem {
  CategoryProductModel? categoryProductModel;
  Product? product;

  ProductItem({this.categoryProductModel, this.product});

  bool get isCategory => categoryProductModel != null;
}
