// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/coupon_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/coupon_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepo couponRepo;

  CouponProvider({required this.couponRepo});

  List<CouponModel>? _couponList;
  CouponModel? _coupon;
  CouponModel? gift;
  double _discount = 0.0;
  String _code = '';
  bool _isLoading = false;

  CouponModel get coupon => _coupon!;

  double get discount => _discount;

  String get code => _code;

  bool get isLoading => _isLoading;

  List<CouponModel> get couponList => _couponList!;

  Future<void> getCouponList(BuildContext context) async {
    ApiResponse apiResponse = await couponRepo.getCouponList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _couponList = [];
      jsonDecode(apiResponse.response!.body).forEach((category) => _couponList!.add(CouponModel.fromJson(category)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<double> applyCoupon(String coupon, double order, context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await couponRepo.applyCoupon(coupon);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _coupon = CouponModel.fromJson(jsonDecode(apiResponse.response!.body));
      _code = _coupon!.code;
      if (_coupon?.product?.choiceOptions != null && _coupon!.discountType == 'product') {
        Variation? variation;

        if (_coupon!.product!.choiceOptions!.isNotEmpty) {
          List<double> priceList = [];
          for (var variation in _coupon!.product!.variations ?? []) {
            for (var value in variation.values) {
              priceList.add(double.parse(value.optionPrice));
            }
          }
          priceList.sort((a, b) => a.compareTo(b));
        }
        List<String> variationList = [];
        for (int index = 0; index < _coupon!.product!.choiceOptions!.length; index++) {
          variationList.add(_coupon!.product!.choiceOptions![index]
              .options[Provider.of<ProductProvider>(context, listen: false).variationIndex[index]]
              .replaceAll(' ', ''));
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

        double price = _coupon!.product!.price;
        for (Variation variation in _coupon!.product?.variations ?? []) {
          if (variation.type == variationType) {
            variation = variation;
            break;
          }
        }
        int? cartIndex = Provider.of<CartProvider>(context, listen: false).getCartIndex(_coupon!.product);

        double priceWithDiscount = PriceConverter.convertWithDiscount(
            context, price, _coupon!.product!.discount, _coupon!.product!.discountType);
        List<AddOn> addOnIdList = [];

        DateTime currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
        DateTime start = DateFormat('hh:mm:ss').parse(_coupon!.product!.availableTimeStarts!);
        DateTime end = DateFormat('hh:mm:ss').parse(_coupon!.product!.availableTimeEnds!);
        DateTime startTime =
            DateTime(currentTime.year, currentTime.month, currentTime.day, start.hour, start.minute, start.second);
        DateTime endTime =
            DateTime(currentTime.year, currentTime.month, currentTime.day, end.hour, end.minute, end.second);
        if (endTime.isBefore(startTime)) {
          endTime = endTime.add(const Duration(days: 1));
        }

        CartModel cartModel = CartModel(
          price: 0.0,
          points: 0.0,
          discountedPrice: priceWithDiscount,
          variation: [variation],
          discountAmount: 0.0,
          quantity: Provider.of<ProductProvider>(context, listen: false).quantity,
          specialInstruction: '',
          taxAmount: price -
              PriceConverter.convertWithDiscount(context, price, _coupon!.product!.tax, _coupon!.product!.taxType),
          addOnIds: addOnIdList,
          product: _coupon!.product,
          isGift: true,
          isFree: false,
        );
        debugPrint('==cart add:${cartModel.discountAmount}');
        debugPrint('==cart add:${cartModel.discountedPrice}');

        Provider.of<CartProvider>(context, listen: false).addToCart(cartModel, cartIndex);

        _discount = _coupon!.product!.price;
      } else {
        if (_coupon!.minPurchase != null && _coupon!.minPurchase! <= order) {
          if (_coupon!.discountType == 'percent') {
            if (_coupon!.maxDiscount != null && _coupon!.maxDiscount != 0) {
              _discount = (_coupon!.discount * order / 100) < _coupon!.maxDiscount!
                  ? (_coupon!.discount * order / 100)
                  : _coupon!.maxDiscount!.toDouble();
            } else {
              _discount = _coupon!.discount * order / 100;
            }
          } else {
            if (_coupon!.maxDiscount != null) {
              _discount = _coupon!.discount.toDouble();
            }
            _discount = _coupon!.discount.toDouble();
          }
        } else {
          _discount = 0.0;
        }
      }
    } else {
      debugPrint(apiResponse.error.toString());
      _discount = 0.0;
    }
    _isLoading = false;
    notifyListeners();
    return _discount;
  }

  giftCoupon(CouponModel couponModel) async {
    debugPrint('===gift');
    gift = couponModel;
    debugPrint('===gift here: $gift');
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    _code = '';
    if (notify) {
      notifyListeners();
    }
  }
}
