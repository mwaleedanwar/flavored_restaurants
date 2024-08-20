import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/provider_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/image_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/on_hover.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/wish_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:intl/intl.dart';

class ProductWidgetWeb extends StatelessWidget {
  final bool fromPopularItem;
  final Product product;
  final int? index;
  final bool isFromCart;
  final bool isFromCartSheet;
  final bool isFromLoyaltyPoints;

  const ProductWidgetWeb({
    super.key,
    required this.product,
    this.fromPopularItem = false,
    this.isFromCart = false,
    this.isFromLoyaltyPoints = false,
    this.index,
    this.isFromCartSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    double startingPrice;
    double endingPrice = 0;

    if ((product.choiceOptions ?? []).isNotEmpty) {
      List<double> priceList = [];
      for (Variation variation in product.variations ?? []) {
        for (Value value in variation.values ?? []) {
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
    debugPrint('=====statring price ${product.name}:${product.price}');

    double priceDiscount =
        PriceConverter.convertDiscount(context, product.price, product.discount, product.discountType);

    bool isAvailable = product.availableTimeStarts != null && product.availableTimeEnds != null
        ? DateConverter.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!, context)
        : false;

    return ResponsiveHelper.isMobilePhone()
        ? _itemView(isAvailable, priceDiscount, startingPrice, endingPrice)
        : OnHover(builder: (isHover) {
            return _itemView(isAvailable, priceDiscount, startingPrice, endingPrice);
          });
  }

  void _addToCart(
    BuildContext context,
    int? cartIndex,
  ) {
    debugPrint('===show sheet');
    ResponsiveHelper.isMobile(context)
        ? showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => CartBottomSheet(
              product: product,
              cart: cartIndex != null ? Provider.of<CartProvider>(context, listen: false).cartList[cartIndex] : null,
            ),
          )
        : showDialog(
            context: context,
            builder: (con) => Dialog(
                  child: CartBottomSheet(
                    product: product,
                    fromSetMenu: true,
                    cart: cartIndex != null
                        ? Provider.of<CartProvider>(context, listen: false).cartList[cartIndex]
                        : null,
                  ),
                ));
  }

  Consumer<CartProvider> _itemView(bool isAvailable, double priceDiscount, double startingPrice, double? endingPrice) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      int? cartIndex = cartProvider.getCartIndex(product);
      debugPrint(
          '=====price ${product.name}:${PriceConverter.convertPrice(context, startingPrice, discount: product.discount, discountType: product.discountType)}');
      String productImage = '';
      try {
        productImage =
            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}';
      } catch (e) {
        debugPrint('ERROR PRODUCT WIDGET WEB $e');
      }

      return Consumer<ProductProvider>(builder: (context, productProvider, child) {
        return InkWell(
          onTap: () {
            if (isFromCart) {
              if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                debugPrint('==check list id: ${product.choiceOptions?.length}');
                if (!cartProvider.cartList.map((e) => e.product?.id).contains(product.id)) {
                  if ((product.choiceOptions ?? []).isNotEmpty) {
                    List<double> priceList = [];
                    for (Variation variation in product.variations ?? []) {
                      for (Value value in variation.values ?? []) {
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

                  List<String> variationList = [];
                  for (int index = 0; index < (product.choiceOptions ?? []).length; index++) {
                    debugPrint('===index:$index');
                    variationList.add(product.choiceOptions![index].options[productProvider.variationIndex[index]]
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

                  double price = product.price;
                  for (Variation variation in product.variations ?? []) {
                    if (variation.type == variationType) {
                      variation = variation;
                      break;
                    }
                  }
                  double priceWithDiscount =
                      PriceConverter.convertWithDiscount(context, price, product.discount, product.discountType);
                  List<AddOn> addOnIdList = [];
                  isFromCartSheet ? null : productProvider.resetQuantity();

                  DateTime currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
                  DateTime start = DateFormat('hh:mm:ss').parse(product.availableTimeStarts!);
                  DateTime end = DateFormat('hh:mm:ss').parse(product.availableTimeEnds!);
                  DateTime startTime = DateTime(
                      currentTime.year, currentTime.month, currentTime.day, start.hour, start.minute, start.second);
                  DateTime endTime =
                      DateTime(currentTime.year, currentTime.month, currentTime.day, end.hour, end.minute, end.second);
                  if (endTime.isBefore(startTime)) {
                    endTime = endTime.add(const Duration(days: 1));
                  }
                  debugPrint('===price $price');
                  CartModel cartModel = CartModel(
                    price: price,
                    points: 0.0,
                    discountedPrice: priceWithDiscount,
                    discountAmount: (price -
                        PriceConverter.convertWithDiscount(context, price, product.discount, product.discountType)),
                    quantity: 1,
                    specialInstruction: '',
                    taxAmount: price - PriceConverter.convertWithDiscount(context, price, product.tax, product.taxType),
                    addOnIds: addOnIdList,
                    product: product,
                    isGift: false,
                    isFree: isFromLoyaltyPoints,
                  );

                  cartProvider.addToCart(cartModel, cartIndex);
                } else {
                  Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
                }
              } else {
                // appToast(text: 'You need to login first');
                Navigator.pushNamed(context, Routes.getLoginRoute());
              }
            } else {
              if (isFromLoyaltyPoints) {
                debugPrint(
                    '==:${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.point! < double.parse(product.loyaltyPoints)}');
                if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.point! <
                    double.parse(product.loyaltyPoints)) {
                  showCustomSnackBar('You don\'t have enough hearts to get this product free', context);
                } else {
                  _addToCart(context, cartIndex);
                }
              } else {
                _addToCart(context, cartIndex);
              }
            }
          },
          child: Stack(
            children: [
              Container(
                height: isFromCart ? 180 : 200,
                width: isFromCart ? 100 : null,
                decoration: BoxDecoration(
                    color: ColorResources.getCartColor(context),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade800 : Colors.grey.shade300,
                        blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                        spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                      )
                    ]),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                            child: ImageWidget(
                              productImage,
                              placeholder: Images.placeholder_rectangle,
                              fit: BoxFit.cover,
                              height: isFromCart ? 80 : 105,
                              width: isFromCart ? 100 : 195,
                            ),
                          ),
                          isAvailable
                              ? const SizedBox()
                              : Positioned(
                                  top: 0,
                                  left: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        color: Colors.black.withOpacity(0.6)),
                                    child: Text(getTranslated('not_available_now', context),
                                        textAlign: TextAlign.center,
                                        style: rubikRegular.copyWith(
                                            color: Colors.white, fontSize: Dimensions.FONT_SIZE_SMALL)),
                                  ),
                                ),
                        ],
                      ),
                      isFromCart
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${PriceConverter.convertPrice(context, startingPrice, discount: product.discount, discountType: product.discountType)}'
                                              '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice ?? 0, discount: product.discount, discountType: product.discountType)}' : ''}',
                                              style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                            ),
                                          ),
                                          cartProvider.cartList.map((e) => e.product?.id).contains(product.id)
                                              ? const SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    if (Provider.of<AuthProvider>(context, listen: false)
                                                        .isLoggedIn()) {
                                                      debugPrint('==cehck listid:${product.id}');
                                                      if (!cartProvider.cartList
                                                          .map((e) => e.product?.id)
                                                          .contains(product.id)) {
                                                        if ((product.choiceOptions ?? []).isNotEmpty) {
                                                          List<double> priceList = [];
                                                          for (Variation variation in product.variations ?? []) {
                                                            for (Value value in variation.values ?? []) {
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

                                                        List<String> variationList = [];
                                                        for (int index = 0;
                                                            index < (product.choiceOptions ?? []).length;
                                                            index++) {
                                                          variationList.add(product.choiceOptions![index]
                                                              .options[productProvider.variationIndex[index]]
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

                                                        double price = product.price;
                                                        for (Variation variation in product.variations ?? []) {
                                                          if (variation.type == variationType) {
                                                            variation = variation;
                                                            break;
                                                          }
                                                        }
                                                        double priceWithDiscount = PriceConverter.convertWithDiscount(
                                                            context, price, product.discount, product.discountType);
                                                        List<AddOn> addOnIdList = [];
                                                        isFromCartSheet ? null : productProvider.resetQuantity();

                                                        DateTime currentTime =
                                                            Provider.of<SplashProvider>(context, listen: false)
                                                                .currentTime;
                                                        DateTime start =
                                                            DateFormat('hh:mm:ss').parse(product.availableTimeStarts!);
                                                        DateTime end =
                                                            DateFormat('hh:mm:ss').parse(product.availableTimeEnds!);
                                                        DateTime startTime = DateTime(
                                                            currentTime.year,
                                                            currentTime.month,
                                                            currentTime.day,
                                                            start.hour,
                                                            start.minute,
                                                            start.second);
                                                        DateTime endTime = DateTime(currentTime.year, currentTime.month,
                                                            currentTime.day, end.hour, end.minute, end.second);
                                                        if (endTime.isBefore(startTime)) {
                                                          endTime = endTime.add(const Duration(days: 1));
                                                        }

                                                        CartModel cartModel = CartModel(
                                                            price: price,
                                                            points: isFromLoyaltyPoints
                                                                ? double.parse(product.loyaltyPoints)
                                                                : 0.0,
                                                            discountedPrice: priceWithDiscount,
                                                            discountAmount: (price -
                                                                PriceConverter.convertWithDiscount(context, price,
                                                                    product.discount, product.discountType)),
                                                            quantity: 1,
                                                            specialInstruction: '',
                                                            taxAmount: price -
                                                                PriceConverter.convertWithDiscount(
                                                                    context, price, product.tax, product.taxType),
                                                            addOnIds: addOnIdList,
                                                            product: product,
                                                            isGift: false,
                                                            isFree: isFromLoyaltyPoints);

                                                        cartProvider.addToCart(cartModel, cartIndex);
                                                      } else {
                                                        Provider.of<CartProvider>(context, listen: false)
                                                            .removeFromCart(cartIndex);
                                                      }
                                                    } else {
                                                      Navigator.pushNamed(context, Routes.getLoginRoute());

                                                      //appToast(text: 'You need to login first');
                                                    }
                                                  },
                                                  child: Icon(Icons.add,
                                                      color: Theme.of(context).textTheme.bodyLarge?.color)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      cartProvider.cartList.map((e) => e.product?.id).contains(product.id)
                                          ? Row(children: [
                                              InkWell(
                                                onTap: () {
                                                  Provider.of<CouponProvider>(context, listen: false)
                                                      .removeCouponData(true);
                                                  if (cartProvider.cartList
                                                          .where((element) => element.product?.id == product.id)
                                                          .toList()[0]
                                                          .quantity >
                                                      1) {
                                                    Provider.of<CartProvider>(context, listen: false).setQuantity(
                                                      isIncrement: false,
                                                      cart: cartProvider.cartList
                                                          .where((element) => element.product?.id == product.id)
                                                          .toList()[0],
                                                    );
                                                  } else {
                                                    Provider.of<CartProvider>(context, listen: false)
                                                        .removeFromCart(cartIndex);
                                                  }
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                  child: Icon(Icons.remove, size: 20),
                                                ),
                                              ),
                                              Text(
                                                  cartProvider.cartList
                                                      .where((element) => element.product?.id == product.id)
                                                      .toList()[0]
                                                      .quantity
                                                      .toString(),
                                                  style:
                                                      rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                                              InkWell(
                                                onTap: () {
                                                  debugPrint(
                                                      '==is gift:${cartProvider.cartList.where((element) => element.product?.id == product.id).toList()[0].isFree}');

                                                  Provider.of<CouponProvider>(context, listen: false)
                                                      .removeCouponData(true);
                                                  Provider.of<CartProvider>(context, listen: false).setQuantity(
                                                    isIncrement: true,
                                                    cart: cartProvider.cartList
                                                        .where((element) => element.product?.id == product.id)
                                                        .toList()[0],
                                                  );
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                  child: Icon(Icons.add, size: 20),
                                                ),
                                              ),
                                            ])
                                          : const SizedBox()
                                    ]),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      //
                                      // RatingBar(
                                      //   rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0,
                                      //   size: 12,
                                      // ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Flexible(
                                          child: Text(
                                            '${PriceConverter.convertPrice(context, startingPrice)}'
                                            '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice ?? 0)}' : ''}',
                                            style: rubikBold.copyWith(
                                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                              color: ColorResources.COLOR_GREY,
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.add, color: Theme.of(context).textTheme.bodyLarge?.color),
                                      ])
                                    ]),
                              ),
                            ),
                    ]),
              ),
              isFromCart
                  ? const SizedBox()
                  : Positioned.fill(
                      child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WishButton(product: product),
                      ),
                    ))
            ],
          ),
        );
      });
    });
  }
}
