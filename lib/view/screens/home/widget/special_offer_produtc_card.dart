import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/offer_model.dart';

import 'package:intl/intl.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/image_widget.dart';

import 'package:provider/provider.dart';

import '../../../../helper/price_converter.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/cart_provider.dart';
import '../../../../provider/coupon_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/app_toast.dart';
import '../../../../utill/routes.dart';

class SpecialOfferProductCard extends StatefulWidget {
  final bool isBuffet;
  final bool isCatering;
  final bool isHappyHours;
  final SpecialOfferModel? specialOfferModel;
  final OfferProduct? offerProduct;

  const SpecialOfferProductCard({
    super.key,
    this.isBuffet = false,
    this.isCatering = false,
    this.isHappyHours = false,
    this.specialOfferModel,
    this.offerProduct,
  });

  @override
  State<SpecialOfferProductCard> createState() => _SpecialOfferProductCardState();
}

class _SpecialOfferProductCardState extends State<SpecialOfferProductCard> {
  @override
  Widget build(BuildContext context) {
    var total = widget.specialOfferModel?.offerProduct != null
        ? (double.parse(widget.specialOfferModel!.offerProduct!.itemQuantity.toString()) *
            double.parse(widget.specialOfferModel!.offerProduct!.itemPrice))
        : 0.0;
    var discount = widget.specialOfferModel?.offerProduct != null
        ? total - double.parse(widget.specialOfferModel!.offerProduct!.itemDiscountPrice)
        : 0.0;
    var subtotal = widget.specialOfferModel?.offerProduct != null
        ? widget.specialOfferModel!.offerProduct!.itemDiscountPrice
        : '0';
    var image = widget.specialOfferModel?.offerProduct != null && widget.isCatering
        ? widget.specialOfferModel!.offerProduct!.image
        : widget.offerProduct?.image;
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      int? cartIndex = widget.isCatering
          ? cartProvider.getCartCateringIndex(widget.specialOfferModel!)
          : cartProvider.getCartHappyHoursIndex(widget.offerProduct!);

      return InkWell(
        onTap: () {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            if (widget.isCatering) {
              CateringCartModel cartModel = CateringCartModel(
                price: total,
                discountedPrice: 0.0,
                discountAmount: double.parse(subtotal),
                quantity: 1,
                catering: widget.specialOfferModel,
              );

              if (!cartProvider.cateringList.map((e) => e.catering?.id).contains(widget.specialOfferModel?.id)) {
                cartProvider.addCateringToCart(cartModel, cartIndex);
                // appToast(text: 'Item added!',toastColor: Colors.green);
              } else {
                Provider.of<CartProvider>(context, listen: false).setQuantity(
                  isIncrement: true,
                  isCatering: true,
                  isCart: false,
                  catering: cartProvider.cateringList
                      .where((element) => element.catering?.id == widget.specialOfferModel?.id)
                      .toList()[0],
                );
              }
            }

            if (widget.isHappyHours) {
              DateTime currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
              DateTime start = DateFormat('hh:mm:ss').parse('${widget.specialOfferModel!.offerAvailableTimeStarts}:00');
              DateTime end = DateFormat('hh:mm:ss').parse('${widget.specialOfferModel!.offerAvailableTimeEnds}:00');
              DateTime startTime = DateTime(
                  currentTime.year, currentTime.month, currentTime.day, start.hour, start.minute, start.second);
              DateTime endTime =
                  DateTime(currentTime.year, currentTime.month, currentTime.day, end.hour, end.minute, end.second);
              if (endTime.isBefore(startTime)) {
                endTime = endTime.add(const Duration(days: 1));
              }
              bool isAvailable = currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
              if (isAvailable) {
                HappyHoursCartModel happyHoursModel = HappyHoursCartModel(
                  price: double.parse(widget.offerProduct!.itemPrice),
                  discountAmount: double.parse(widget.offerProduct!.itemDiscountPrice),
                  quantity: 1,
                  happyHours: widget.offerProduct,
                );

                if (!cartProvider.happyHoursList.map((e) => e.happyHours?.id).contains(widget.offerProduct?.id)) {
                  cartProvider.addHappyHoursToCart(happyHoursModel, cartIndex);
                  // appToast(text: 'Item added!',toastColor: Colors.green);
                } else {
                  Provider.of<CartProvider>(context, listen: false).setQuantity(
                    isIncrement: true,
                    isHappyHours: true,
                    happyHours: cartProvider.happyHoursList
                        .where((element) => element.happyHours?.id == widget.offerProduct?.id)
                        .toList()[0],
                  );

                  //appToast(text: 'Item added ${ _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0].quantity.toString()} times!',toastColor: Colors.green);
                }
              } else {
                appToast(text: 'Not available now');
              }
            }
          } else {
            Navigator.pushNamed(context, Routes.getLoginRoute());

            //  appToast(text: 'You need to login first');
          }
        },
        child: Container(
          // height: 180 ,
          width: widget.isBuffet ? 100 : 150,
          decoration: BoxDecoration(
              color: ColorResources.getCartColor(context),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade800 : Colors.grey.shade300,
                    blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                    spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1)
              ]),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: ImageWidget(
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/$image',
                    placeholder: Images.placeholder_rectangle,
                    fit: BoxFit.cover,
                    height: 90,
                    width: 150,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.isCatering
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.specialOfferModel?.name ?? '',
                                      style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity:',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.specialOfferModel?.offerProduct?.itemQuantity ?? '',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Actual price:',
                                            style: rubikMedium.copyWith(
                                                fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          total.toStringAsFixed(2),
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Discount:',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Text(
                                          '- ${discount.toStringAsFixed(2)}',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total price:',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Text(
                                          subtotal,
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          widget.isBuffet
                              ? Column(
                                  children: [
                                    Text(widget.offerProduct?.name ?? '',
                                        style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL), maxLines: 2),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          widget.isHappyHours
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.offerProduct?.name ?? '',
                                      style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          PriceConverter.convertPrice(
                                              context, double.parse(widget.offerProduct?.itemPrice ?? '0')),
                                          style: rubikBold.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                            color: ColorResources.COLOR_GREY,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          PriceConverter.convertPrice(
                                              context, double.parse(widget.offerProduct?.itemDiscountPrice ?? '0')),
                                          style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : const SizedBox.shrink()
                        ]),
                  ),
                ),
                widget.isCatering
                    ? (cartProvider.cateringList.map((e) => e.catering!.id).contains(widget.specialOfferModel!.id)
                        ? Center(
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                              InkWell(
                                onTap: () {
                                  Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                                  if (cartProvider.cateringList
                                          .where((element) => element.catering!.id == widget.specialOfferModel!.id)
                                          .toList()[0]
                                          .quantity >
                                      1) {
                                    Provider.of<CartProvider>(context, listen: false).setQuantity(
                                      isIncrement: false,
                                      isCart: false,
                                      isCatering: true,
                                      catering: cartProvider.cateringList
                                          .where((element) => element.catering!.id == widget.specialOfferModel!.id)
                                          .toList()[0],
                                    );
                                  } else {
                                    Provider.of<CartProvider>(context, listen: false)
                                        .removeFromCart(cartIndex!, isCart: false, isCatering: true);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  child: Icon(Icons.remove, size: 20),
                                ),
                              ),
                              Text(
                                  cartProvider.cateringList
                                      .where((element) => element.catering!.id == widget.specialOfferModel!.id)
                                      .toList()[0]
                                      .quantity
                                      .toString(),
                                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                              InkWell(
                                onTap: () {
                                  Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                                  Provider.of<CartProvider>(context, listen: false).setQuantity(
                                    isIncrement: true,
                                    isCart: false,
                                    isCatering: true,
                                    catering: cartProvider.cateringList
                                        .where((element) => element.catering!.id == widget.specialOfferModel!.id)
                                        .toList()[0],
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  child: Icon(Icons.add, size: 20),
                                ),
                              ),
                            ]),
                          )
                        : Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
                              child: Text('Add to cart',
                                  style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white)),
                            ),
                          ))
                    : const SizedBox(),
                widget.isHappyHours
                    ? (cartProvider.happyHoursList.map((e) => e.happyHours!.id).contains(widget.offerProduct!.id)
                        ? Center(
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                              InkWell(
                                onTap: () {
                                  Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                                  if (cartProvider.happyHoursList
                                          .where((element) => element.happyHours!.id == widget.offerProduct!.id)
                                          .toList()[0]
                                          .quantity >
                                      1) {
                                    Provider.of<CartProvider>(context, listen: false).setQuantity(
                                      isIncrement: false,
                                      isCart: false,
                                      isHappyHours: true,
                                      happyHours: cartProvider.happyHoursList
                                          .where((element) => element.happyHours!.id == widget.offerProduct!.id)
                                          .toList()[0],
                                    );
                                  } else {
                                    Provider.of<CartProvider>(context, listen: false)
                                        .removeFromCart(cartIndex!, isCart: false, isHappyHours: true);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  child: Icon(Icons.remove, size: 20),
                                ),
                              ),
                              Text(
                                  cartProvider.happyHoursList
                                      .where((element) => element.happyHours!.id == widget.offerProduct!.id)
                                      .toList()[0]
                                      .quantity
                                      .toString(),
                                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                              InkWell(
                                onTap: () {
                                  Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                                  Provider.of<CartProvider>(context, listen: false).setQuantity(
                                    isIncrement: true,
                                    isCart: false,
                                    isHappyHours: true,
                                    happyHours: cartProvider.happyHoursList
                                        .where((element) => element.happyHours!.id == widget.offerProduct!.id)
                                        .toList()[0],
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  child: Icon(Icons.add, size: 20),
                                ),
                              ),
                            ]),
                          )
                        : Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
                              child: Text('Add to cart',
                                  style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white)),
                            ),
                          ))
                    : const SizedBox(),
                const SizedBox(
                  height: 8,
                )
              ]),
        ),
      );
    });
  }
}
