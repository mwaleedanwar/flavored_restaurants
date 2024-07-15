import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class PriceConverter {
  static String convertPrice(BuildContext context, double price,
      {double? discount, String? discountType}) {
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel;
    if (discount != null && discountType != null) {
      if (discountType == 'amount') {
        price = price - discount;
      } else if (discountType == 'percent') {
        price = price - ((discount / 100) * price);
      }
    }
    return price == 0
        ? ""
        : configModel!.currencySymbolPosition == 'left'
            ? '${configModel.currencySymbol}'
                '${(price).toStringAsFixed(configModel.decimalPointSettings).replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    )}'
            : price == 0
                ? ""
                : '${(price).toStringAsFixed(configModel.decimalPointSettings).replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}'
                    ' ${configModel.currencySymbol}';
  }

  static double convertWithDiscount(BuildContext context, double price,
      double discount, String discountType) {
    if (discountType == 'amount') {
      price = price - discount;
    } else if (discountType == 'percent') {
      price = price - ((discount / 100) * price);
    }
    return price;
  }

  static double convertDiscount(BuildContext context, double price,
      double discount, String discountType) {
    if (discountType == 'amount') {
      price = discount;
    } else if (discountType == 'percent') {
      price = (discount / 100) * price;
    }
    return price;
  }

  static double calculation(
      double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if (type == 'amount') {
      calculatedAmount = discount * quantity;
    } else if (type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(BuildContext context, String price,
      String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol} OFF';
  }
}
