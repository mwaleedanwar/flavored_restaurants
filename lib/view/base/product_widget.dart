import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/wish_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/cart_bottom_sheet.dart';

import 'package:get/get.dart' hide Value;

import 'package:provider/provider.dart';
import '../../provider/profile_provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final bool isFromPoinst;
  final bool isLined;
  final bool isLast;
  ProductWidget({@required this.product, this.isFromPoinst = false, this.isLined = false, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    double _startingPrice;
    double _endingPrice;
    if (product.choiceOptions.length != 0) {
      List<double> _priceList = [];
      // product.variations.forEach((variation) => _priceList.add(variation.price));
      for (Variation variation in product.variations) {
        for (Value value in variation.values) {
          _priceList.add(double.parse(value.optionPrice));
        }
      }
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = product.price;
    }

    double _discountedPrice =
        PriceConverter.convertWithDiscount(context, product.price, product.discount, product.discountType);

    bool _isAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds, context);

    return Consumer<CartProvider>(builder: (context, _cartProvider, child) {
      String _productImage = '';
      try {
        _productImage =
            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}';
      } catch (e) {}
      int _cartIndex = _cartProvider.getCartIndex(product);
      print('---image${_productImage}');
      return Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: InkWell(
            onTap: () {
              print('----here tap');
              if (isFromPoinst) {
                debugPrint(
                    '==:${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.point < double.parse(product.loyaltyPoints)}');
                if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel.point <
                    double.parse(product.loyaltyPoints)) {
                  showCustomSnackBar('You don\'t have enough hearts to get this product free', context);
                } else {
                  _addToCart(context, _cartIndex);
                }
              } else {
                _addToCart(context, _cartIndex);
              }
            },
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Provider.of<ThemeProvider>(context).darkTheme && ResponsiveHelper.isDesktop(context)
                        ? Colors.black38
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(isLined ? 0 : 10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                        blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                        spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                      )
                    ],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              product.name,
                              style: rubikMedium.copyWith(fontSize: 16),
                              maxLines: 2,
                            ),
                            Text(
                              product.description,
                              style: rubikMedium.copyWith(fontSize: 12),
                              maxLines: 2,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline_outlined,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  product.price == 0.0
                                      ? '${product.loyaltyPoints} hearts'
                                      : '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}'
                                          '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType)}' : ''}',
                                  style: rubikMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.COLOR_GREY_CHATEAU),
                                ),
                                // WishButton(product: product, edgeInset: EdgeInsets.all(5)),
                              ],
                            ),
                            product.price > _discountedPrice
                                ? Text(
                                    '${PriceConverter.convertPrice(context, _startingPrice)}'
                                    '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                    style: rubikMedium.copyWith(
                                      color: ColorResources.COLOR_GREY,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                    ))
                                : SizedBox(),
                          ]),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder_image,
                        height: ResponsiveHelper.isMobile(context) ? 110 : 80,
                        width: ResponsiveHelper.isMobile(context) ? 105 : 95,
                        fit: BoxFit.cover,
                        image: _productImage,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,
                            height: ResponsiveHelper.isMobile(context) ? 110 : 80,
                            width: ResponsiveHelper.isMobile(context) ? 105 : 95,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ]),
                ),
                isLined
                    ? Container(
                        height: 1.5,
                        width: Get.width,
                        color: isLast ? Colors.transparent : Colors.black,
                      )
                    : SizedBox(
                        height: 2,
                      )
              ],
            ),
          ));
    });
  }

  void _addToCart(
    BuildContext context,
    int _cartIndex,
  ) {
    print('===show sheet:${isFromPoinst}');
    ResponsiveHelper.isMobile(context)
        ? showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => CartBottomSheet(
              product: product,
              cart: _cartIndex != null ? Provider.of<CartProvider>(context, listen: false).cartList[_cartIndex] : null,
              fromPoints: isFromPoinst,
              callback: (CartModel cartModel) {
                showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
              },
            ),
          )
        : showDialog(
            context: context,
            builder: (con) => Dialog(
              child: CartBottomSheet(
                product: product,
                fromSetMenu: true,
                cart:
                    _cartIndex != null ? Provider.of<CartProvider>(context, listen: false).cartList[_cartIndex] : null,
                fromPoints: isFromPoinst,
                callback: (CartModel cartModel) {
                  showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                },
              ),
            ),
          );
  }
}
