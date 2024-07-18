// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_details_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/review_body_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/response_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/product_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/deals_data_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/offer_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;

  ProductProvider({required this.productRepo});

  List<Product>? _popularProductList;
  List<Product> _loyaltyPointsProducts = [];
  List<Product> _recommendedSidesList = [];
  List<Product> _recommendedBeveragesList = [];
  List<SpecialOfferModel> _specialofferList = [];
  List<DealsDataModel> _dealList = [];
  List<int> checkedItems = [];
  List<String> checkedDrink = [];
  List<String> drinks = [
    'Coke',
    'Zero Coke',
    'Diet Coke',
    'Ginger Ale',
    'Orange',
    'Sprite',
  ];

  List<Product> _relatedProducts = [];
  List<Product> _latestProductList = [];
  bool _isLoading = false;
  int? _popularPageSize;
  int? _latestPageSize;
  List<String> _offsetList = [];
  List<int> _variationIndex = [0];
  int _quantity = 1;
  List<bool> _addOnActiveList = [];
  final List<bool> _addFreqBoughtActive = [];
  List<int?> _addOnQtyList = [];
  bool _seeMoreButtonVisible = true;
  int latestOffset = 1;
  int popularOffset = 1;
  int _cartIndex = -1;
  double tip = 0.0;
  bool _isReviewSubmitted = false;
  final List<String> _productTypeList = ['all', 'non_veg', 'veg'];

  List<Product>? get popularProductList => _popularProductList;

  List<Product> get relatedProducts => _relatedProducts;

  List<Product> get latestProductList => _latestProductList;

  List<Product> get recommendedSidesList => _recommendedSidesList;

  List<Product> get recommendedBeveragesList => _recommendedBeveragesList;

  List<Product> get loyaltyPointsProducts => _loyaltyPointsProducts;

  List<SpecialOfferModel> get specialofferList => _specialofferList;

  List<DealsDataModel> get dealsList => _dealList;

  bool get isLoading => _isLoading;

  int? get popularPageSize => _popularPageSize;

  int? get latestPageSize => _latestPageSize;

  List<int> get variationIndex => _variationIndex;

  int get quantity => _quantity;

  List<bool> get addOnActiveList => _addOnActiveList;

  List<bool> get addFreqBoughtActive => _addFreqBoughtActive;

  List<int?> get addOnQtyList => _addOnQtyList;

  bool get seeMoreButtonVisible => _seeMoreButtonVisible;

  int get cartIndex => _cartIndex;

  bool get isReviewSubmitted => _isReviewSubmitted;

  List<String> get productTypeList => _productTypeList;

  Future<void> getLatestProductList(
    BuildContext context,
    bool reload,
    String offset,
    String languageCode,
  ) async {
    if (reload || offset == '1') {
      latestOffset = 1;
      _offsetList = [];
    }
    if (!_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getLatestProductList(offset, languageCode);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        debugPrint('${jsonDecode(apiResponse.response!.body)}');
        if (reload || offset == '1') {
          _latestProductList = [];
        }
        _latestProductList.addAll(ProductModel.fromJson(jsonDecode(apiResponse.response!.body)).products ?? []);
        _latestPageSize = ProductModel.fromJson(jsonDecode(apiResponse.response!.body)).totalSize;
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

  Future<bool> getPopularProductList(
    BuildContext context,
    bool reload,
    String offset, {
    String type = 'all',
    bool isUpdate = false,
  }) async {
    bool apiSuccess = false;
    if (reload || offset == '1') {
      popularOffset = 1;
      _offsetList = [];
      _popularProductList = null;
    }
    if (isUpdate) {
      notifyListeners();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getPopularProductList(
        offset,
        type,
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        apiSuccess = true;
        if (reload || offset == '1') {
          _popularProductList = [];
        }
        _popularProductList?.addAll(ProductModel.fromJson(jsonDecode(apiResponse.response!.body)).products ?? []);
        _popularPageSize = ProductModel.fromJson(jsonDecode(apiResponse.response!.body)).totalSize;
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
    return apiSuccess;
  }

  Future<bool> getRelatedProductList(BuildContext context, id) async {
    bool apiSuccess = false;
    _isLoading = true;

    ApiResponse apiResponse = await productRepo.getRelatedProductList(
      id,
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
    _isLoading = false;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      apiSuccess = true;

      _relatedProducts = [];
      jsonDecode(apiResponse.response!.body).forEach((product) => _relatedProducts.add(Product.fromJson(product)));

      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
    _isLoading = false;

    return apiSuccess;
  }

  Future<bool> getSpecialOffersList(BuildContext context) async {
    debugPrint('===getSpecialOffersList');
    bool apiSuccess = false;
    _isLoading = true;

    ApiResponse apiResponse = await productRepo.getSpecialOffersList();
    _isLoading = false;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      debugPrint('===getSpecialOffersList: Response:${apiResponse.response!.body}');

      apiSuccess = true;

      _specialofferList = [];
      jsonDecode(apiResponse.response!.body)
          .forEach((product) => _specialofferList.add(SpecialOfferModel.fromJson(product)));
      debugPrint('===getSpecialOffersList length:${_specialofferList.length}');

      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
    _isLoading = false;

    return apiSuccess;
  }

  Future<bool> getDealsList(BuildContext context) async {
    debugPrint('===getDealsList');
    bool apiSuccess = false;
    _isLoading = true;
    ApiResponse apiResponse = await productRepo.getDealsList();
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      debugPrint('===getDealsList: Response:${apiResponse.response!.body}');
      apiSuccess = true;
      _dealList = [];
      jsonDecode(apiResponse.response!.body).forEach((product) => _dealList.add(DealsDataModel.fromJson(product)));
      debugPrint('===getDealsList length:${_dealList.length}');
      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
    _isLoading = false;
    return apiSuccess;
  }

  Future<void> getLoyaltyProductList(BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getPointsProductList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      debugPrint('${jsonDecode(apiResponse.response!.body)}');
      _loyaltyPointsProducts = [];
      _loyaltyPointsProducts.addAll(ProductModel.fromJson(jsonDecode(apiResponse.response!.body)).products ?? []);
      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
  }

  Future<void> getRecommendedSideList(BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getRecommendedSideList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      debugPrint('${jsonDecode(apiResponse.response!.body)}');
      _recommendedSidesList = [];
      _recommendedSidesList.addAll(ProductModel.fromJson(jsonDecode(apiResponse.response!.body)).products ?? []);
      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
    if (isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRecommendedBeveragesList(BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getRecommendedBeveragesList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      debugPrint('${jsonDecode(apiResponse.response!.body)}');
      _recommendedBeveragesList = [];
      _recommendedBeveragesList.addAll(ProductModel.fromJson(jsonDecode(apiResponse.response!.body)).products ?? []);
      _isLoading = false;
      notifyListeners();
    }

    if (isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void resetQuantity() {
    _quantity = 1;
    notifyListeners();
  }

  void initData(Product product, CartModel? cart, BuildContext context) {
    _variationIndex = [];
    _addOnQtyList = [];
    checkedItems = [];
    _addOnActiveList = [];
    _addOnActiveList = [];
    if (cart != null) {
      _quantity = cart.quantity;
      List<String> variationTypes = [];
      if (cart.variation?.length != null && cart.variation!.isNotEmpty && cart.variation?[0]?.type != null) {
        debugPrint('==choice1: ${cart.variation?[0]?.type} ');

        variationTypes.addAll(cart.variation![0]!.type.split('-'));
      }
      int varIndex = 0;

      product.choiceOptions?.forEach((choiceOption) {
        debugPrint('==choic e: ${choiceOption.options} ');
        for (int index = 0; index < choiceOption.options.length; index++) {
          if (choiceOption.options[index].trim().replaceAll(' ', '') == variationTypes[varIndex].trim()) {
            debugPrint('==choice2: $index ');

            _variationIndex.add(index);
            break;
          }
        }
        varIndex++;
      });
      List<int> addOnIdList = [];
      cart.addOnIds?.forEach((addOnId) => addOnIdList.add(addOnId.id));
      product.addOns?.forEach((addOn) {
        if (addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(cart.addOnIds?[addOnIdList.indexOf(addOn.id)].quantity);
        } else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    } else {
      _quantity = 1;
      product.choiceOptions?.forEach((element) => _variationIndex.add(0));
      product.addOns?.forEach((addOn) {
        _addOnActiveList.add(false);
        _addOnQtyList.add(1);
      });
      setExistInCart(product, context, notify: false);
    }
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index]! + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index]! - 1;
    }
    notifyListeners();
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i, Product product, String variationType, BuildContext context) {
    _variationIndex[index] = i;
    _quantity = 1;
    setExistInCart(product, context);
    notifyListeners();
  }

  int setExistInCart(Product product, BuildContext context, {bool notify = true}) {
    List<String> variationList = [];
    for (int index = 0; index < (product.choiceOptions ?? []).length; index++) {
      variationList.add(product.choiceOptions![index].options[_variationIndex[index]].replaceAll(' ', ''));
    }
    String variationType = '';
    bool isFirst = true;
    for (var variation in variationList) {
      if (isFirst) {
        variationType = '$variationType$variation';
        isFirst = false;
      } else {
        variationType = '$variationType-$variation';
      }
    }
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    _cartIndex = cartProvider.isExistInCart(product.id, product.variations);
    if (_cartIndex != -1) {
      _quantity = cartProvider.cartList[_cartIndex].quantity;
      _addOnActiveList = [];
      _addOnQtyList = [];
      List<int> addOnIdList = [];
      for (var addOnId in cartProvider.cartList[_cartIndex].addOnIds ?? []) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product.addOns ?? []) {
        if (addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(cartProvider.cartList[_cartIndex].addOnIds?[addOnIdList.indexOf(addOn.id)].quantity);
        } else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      }
    }
    return _cartIndex;
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    notifyListeners();
  }

  void addFrequently(bool isAdd, int index) {
    _addFreqBoughtActive[index] = isAdd;
    notifyListeners();
  }

  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;

  List<String> get reviewList => _reviewList;

  List<bool> get loadingList => _loadingList;

  List<bool> get submitList => _submitList;

  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    for (var _ in orderDetailsList) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    }
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    notifyListeners();

    ApiResponse response = await productRepo.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');

      notifyListeners();
    } else {
      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _loadingList[index] = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(
    ReviewBody reviewBody,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await productRepo.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      responseModel = ResponseModel(true, getTranslated('review_submitted_successfully', context));
      updateSubmitted(true);

      notifyListeners();
    } else {
      _isLoading = false;

      notifyListeners();

      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel?> updateLoyaltyPoints(
    double points,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await productRepo.updateLoyaltyPoints(points);
    ResponseModel? responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void moreProduct(BuildContext context) {
    int pageSize;
    pageSize = (latestPageSize! / 10).ceil();

    if (latestOffset < pageSize) {
      latestOffset++;
      showBottomLoader();
      getLatestProductList(
        context,
        false,
        latestOffset.toString(),
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );
    }
  }

  void seeMoreReturn() {
    latestOffset = 1;
    _seeMoreButtonVisible = true;
  }

  updateSubmitted(bool value) {
    _isReviewSubmitted = value;
  }
}
