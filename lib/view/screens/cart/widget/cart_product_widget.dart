import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/coupon_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatefulWidget {
  final CartModel? cart;
  final int cartIndex;
  final List<AddOns>? addOns;
  final bool isAvailable;

  const CartProductWidget({
    super.key,
    this.cart,
    required this.cartIndex,
    required this.isAvailable,
    this.addOns,
  });

  @override
  State<CartProductWidget> createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget> {
  var variations = [];

  @override
  Widget build(BuildContext context) {
    String variationText = '';
    if (widget.cart?.variation != null && widget.cart!.variation!.isNotEmpty) {
      List<String> variationTypes = widget.cart!.variation!.first!.type.split('-');

      if (variationTypes.length == widget.cart!.product!.choiceOptions!.length) {
        int index = 0;
        widget.cart!.product!.choiceOptions?.forEach((choice) {
          variationText = '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
          index = index + 1;
        });
      } else {
        variationText = widget.cart!.product!.variations!.first.type;
      }
      if (variations.isEmpty) {
        for (Variation? variation in widget.cart!.variation ?? []) {
          if (variation?.values != null) {
            for (var element in variation!.values!) {
              variations.add(element);
            }
          }
        }
      }
    }

    return InkWell(
      onTap: () {
        if (!(widget.cart?.isFree ?? false) || widget.cart?.price != 0.0) {
          ResponsiveHelper.isMobile(context)
              ? showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) => CartBottomSheet(
                    product: widget.cart!.product!,
                    cart: widget.cart,
                    fromCart: true,
                  ),
                )
              : showDialog(
                  context: context,
                  builder: (con) => Dialog(
                        child: CartBottomSheet(
                          product: widget.cart!.product!,
                          cart: widget.cart,
                          fromCart: true,
                        ),
                      ));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          const Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
              Provider.of<CartProvider>(context, listen: false).removeFromCart(widget.cartIndex);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(children: [
                    const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.cart!.product!.name,
                                style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            const SizedBox(height: 5),
                            Row(children: [
                              Flexible(
                                child: Text(
                                  widget.cart!.isFree
                                      ? '${widget.cart!.points} heart points'
                                      : PriceConverter.convertPrice(
                                          context,
                                          widget.cart!.price,
                                        ),
                                  style: rubikBold,
                                ),
                              ),
                              const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              widget.cart!.discountAmount > 0
                                  ? Flexible(
                                      child: Text(
                                          PriceConverter.convertPrice(
                                              context, widget.cart!.discountedPrice + widget.cart!.discountAmount),
                                          style: rubikBold.copyWith(
                                            color: ColorResources.COLOR_GREY,
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            decoration: TextDecoration.lineThrough,
                                          )),
                                    )
                                  : const SizedBox(),
                            ]),
                            if (widget.cart?.product?.variations?.isNotEmpty ?? false)
                              Padding(
                                padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Text(
                                  compoundVariations(variations),
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                          ]),
                    ),
                    widget.cart?.isGift == true
                        ? Text(
                            'Your\nGift',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor),
                            textAlign: TextAlign.center,
                          )
                        : widget.cart?.isFree ?? false
                            ? Text(
                                'Free',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor),
                                textAlign: TextAlign.center,
                              )
                            : Container(
                                decoration:
                                    BoxDecoration(color: F.appbarHeaderColor, borderRadius: BorderRadius.circular(5)),
                                child: Row(children: [
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                                      if ((widget.cart?.quantity ?? 0) > 1) {
                                        Provider.of<CartProvider>(context, listen: false).setQuantity(
                                          isIncrement: false,
                                          cart: widget.cart,
                                        );
                                      } else {
                                        Provider.of<CartProvider>(context, listen: false)
                                            .removeFromCart(widget.cartIndex);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      child: Icon(
                                        Icons.remove,
                                        size: 20,
                                        color: Provider.of<ThemeProvider>(context, listen: false).darkTheme
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    (widget.cart?.quantity ?? 0).toString(),
                                    style: rubikMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                      color: Provider.of<ThemeProvider>(context, listen: false).darkTheme
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                                      Provider.of<CartProvider>(context, listen: false).setQuantity(
                                        isIncrement: true,
                                        cart: widget.cart,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Provider.of<ThemeProvider>(context, listen: false).darkTheme
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                  ]),
                  widget.addOns?.isNotEmpty ?? false
                      ? SizedBox(
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                            itemCount: widget.addOns!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                child: Row(children: [
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CartProvider>(context, listen: false)
                                          .removeAddOn(widget.cartIndex, index);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                                    ),
                                  ),
                                  Text(widget.addOns![index].name, style: rubikRegular),
                                  const SizedBox(width: 2),
                                  Text(PriceConverter.convertPrice(context, widget.addOns![index].price),
                                      style: rubikMedium),
                                  const SizedBox(width: 2),
                                  Text('(${widget.cart!.addOnIds![index].quantity})', style: rubikRegular),
                                ]),
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  String compoundVariations(List<dynamic> variations) {
    if (variations.isEmpty) return '';
    String init = '';
    for (var variation in variations) {
      init += '${variation.label}${variation.optionPrice == '0' ? ',' : '(${variation.optionPrice}),'}';
    }
    return init.substring(0, init.length - 1);
  }
}

class CartOfferWidget extends StatelessWidget {
  final CateringCartModel cateringCartModel;
  final int cartIndex;

  const CartOfferWidget({
    super.key,
    required this.cartIndex,
    required this.cateringCartModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
      child: Stack(children: [
        const Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
        ),
        Dismissible(
          key: UniqueKey(),
          onDismissed: (DismissDirection direction) {
            Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
            Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              children: [
                Row(children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder_image,
                          height: 70,
                          width: 85,
                          fit: BoxFit.cover,
                          image:
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${cateringCartModel.catering!.offerProduct!.image}',
                          imageErrorBuilder: (c, o, s) =>
                              Image.asset(Images.placeholder_image, height: 70, width: 85, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cateringCartModel.catering!.name,
                              style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Tray Quantity : ${cateringCartModel.catering?.offerProduct?.itemQuantity ?? 0}',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(children: [
                            Flexible(
                              child: Text(
                                PriceConverter.convertPrice(
                                  context,
                                  cateringCartModel.discountAmount ?? 0.0,
                                ),
                              ),
                            ),
                          ]),
                        ]),
                  ),
                  Container(
                    decoration: BoxDecoration(color: F.appbarHeaderColor, borderRadius: BorderRadius.circular(5)),
                    child: Row(children: [
                      InkWell(
                        onTap: () {
                          Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                          if (cateringCartModel.quantity > 1) {
                            Provider.of<CartProvider>(context, listen: false).setQuantity(
                              isIncrement: false,
                              isCatering: true,
                              isCart: false,
                              catering: cateringCartModel,
                            );
                          } else {
                            Provider.of<CartProvider>(context, listen: false)
                                .removeFromCart(cartIndex, isCatering: true, isCart: false);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.remove, size: 20),
                        ),
                      ),
                      Text(cateringCartModel.quantity.toString(),
                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                      InkWell(
                        onTap: () {
                          Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                          Provider.of<CartProvider>(context, listen: false).setQuantity(
                            isIncrement: true,
                            isCatering: true,
                            isCart: false,
                            catering: cateringCartModel,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.add, size: 20),
                        ),
                      ),
                    ]),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class CartHappyHourWidget extends StatelessWidget {
  final HappyHoursCartModel happyHoursCartModel;
  final int cartIndex;

  const CartHappyHourWidget({
    super.key,
    required this.cartIndex,
    required this.happyHoursCartModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
      child: Stack(children: [
        const Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
        ),
        Dismissible(
          key: UniqueKey(),
          onDismissed: (DismissDirection direction) {
            Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
            Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              children: [
                Row(children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder_image,
                          height: 70,
                          width: 85,
                          fit: BoxFit.cover,
                          image:
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${happyHoursCartModel.happyHours!.image}',
                          imageErrorBuilder: (c, o, s) =>
                              Image.asset(Images.placeholder_image, height: 70, width: 85, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(happyHoursCartModel.happyHours!.name,
                              style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          const SizedBox(height: 5),
                          Text(
                            'Actual Price : ${happyHoursCartModel.price}',
                          ),
                          const SizedBox(height: 5),
                          Row(children: [
                            Flexible(
                              child: Text(
                                'Happy Price : ${happyHoursCartModel.discountAmount}',
                              ),
                            ),
                          ]),
                        ]),
                  ),
                  Container(
                    decoration: BoxDecoration(color: F.appbarHeaderColor, borderRadius: BorderRadius.circular(5)),
                    child: Row(children: [
                      InkWell(
                        onTap: () {
                          Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                          if (happyHoursCartModel.quantity > 1) {
                            Provider.of<CartProvider>(context, listen: false).setQuantity(
                              isIncrement: false,
                              isCart: false,
                              isHappyHours: true,
                              happyHours: happyHoursCartModel,
                            );
                          } else {
                            Provider.of<CartProvider>(context, listen: false)
                                .removeFromCart(cartIndex, isCatering: false, isCart: false, isHappyHours: true);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.remove, size: 20),
                        ),
                      ),
                      Text(happyHoursCartModel.quantity.toString(),
                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                      InkWell(
                        onTap: () {
                          Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                          Provider.of<CartProvider>(context, listen: false).setQuantity(
                            isIncrement: true,
                            isCart: false,
                            isHappyHours: true,
                            happyHours: happyHoursCartModel,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.add, size: 20),
                        ),
                      ),
                    ]),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
