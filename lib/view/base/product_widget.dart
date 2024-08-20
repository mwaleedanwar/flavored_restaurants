import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/image_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final bool isFromPoinst;
  final bool isLined;
  final bool isLast;
  const ProductWidget({
    super.key,
    required this.product,
    this.isFromPoinst = false,
    this.isLined = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    double startingPrice;
    double? endingPrice;
    if (product.choiceOptions?.isNotEmpty ?? false) {
      List<double> priceList = [];
      for (Variation variation in (product.variations ?? [])) {
        for (Value value in (variation.values ?? [])) {
          priceList.add(double.parse(value.optionPrice));
        }
      }
      priceList.sort((a, b) => a.compareTo(b));
      startingPrice = priceList[0];
      if (priceList[0] < priceList[priceList.length - 1]) {
        endingPrice = priceList[priceList.length - 1];
      }
    } else {
      startingPrice = product.price;
    }

    double discountedPrice =
        PriceConverter.convertWithDiscount(context, product.price, product.discount, product.discountType);

    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      int cartIndex = cartProvider.getCartIndex(product) ?? -1;

      return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            onTap: () {
              if (isFromPoinst) {
                debugPrint(
                    '==:${Provider.of<ProfileProvider>(context, listen: false).userInfoModel?.point ?? 0 < double.parse(product.loyaltyPoints)}');
                if ((Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.point ?? 0) <
                    double.parse(product.loyaltyPoints)) {
                  showCustomSnackBar('You don\'t have enough hearts to get this product free', context);
                } else {
                  _addToCart(context, cartIndex);
                }
              } else {
                _addToCart(context, cartIndex);
              }
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Provider.of<ThemeProvider>(context).darkTheme && ResponsiveHelper.isDesktop(context)
                        ? Colors.black38
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(isLined ? 0 : 10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade900 : Colors.grey.shade300,
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
                            const SizedBox(height: 10),
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
                                const Icon(
                                  Icons.add_circle_outline_outlined,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  product.price == 0.0
                                      ? '${product.loyaltyPoints} hearts'
                                      : '${PriceConverter.convertPrice(context, startingPrice, discount: product.discount, discountType: product.discountType)}'
                                          '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice, discount: product.discount, discountType: product.discountType)}' : ''}',
                                  style: rubikMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.COLOR_GREY_CHATEAU),
                                ),
                              ],
                            ),
                            product.price > discountedPrice
                                ? Text(
                                    '${PriceConverter.convertPrice(context, startingPrice)}'
                                    '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice)}' : ''}',
                                    style: rubikMedium.copyWith(
                                      color: ColorResources.COLOR_GREY,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                    ))
                                : const SizedBox(),
                          ]),
                    ),
                    const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageWidget(
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}',
                        height: ResponsiveHelper.isMobile(context) ? 110 : 80,
                        width: ResponsiveHelper.isMobile(context) ? 105 : 95,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ]),
                ),
                isLined
                    ? Container(
                        height: 1.5,
                        width: MediaQuery.of(context).size.width,
                        color: isLast ? Colors.transparent : Colors.black,
                      )
                    : const SizedBox(
                        height: 2,
                      )
              ],
            ),
          ));
    });
  }

  void _addToCart(
    BuildContext context,
    int? cartIndex,
  ) {
    debugPrint('===show sheet:$isFromPoinst');
    ResponsiveHelper.isMobile(context)
        ? showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => CartBottomSheet(
              product: product,
              cart: cartIndex != null && cartIndex >= 0
                  ? Provider.of<CartProvider>(context, listen: false).cartList[cartIndex]
                  : null,
              fromPoints: isFromPoinst,
            ),
          )
        : showDialog(
            context: context,
            builder: (con) => Dialog(
              child: CartBottomSheet(
                product: product,
                fromSetMenu: true,
                cart: cartIndex != null ? Provider.of<CartProvider>(context, listen: false).cartList[cartIndex] : null,
                fromPoints: isFromPoinst,
              ),
            ),
          );
  }
}
