// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_details_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';

import '../order_details_screen.dart';

class OrderItem extends StatelessWidget {
  final OrderModel orderItem;
  final bool isRunning;
  final OrderProvider orderProvider;
  const OrderItem({
    super.key,
    required this.orderProvider,
    required this.isRunning,
    required this.orderItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.grey.shade700
                : Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              Images.placeholder_image,
              height: 70,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('${getTranslated('order_id', context)}:',
                    style: rubikRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL)),
                const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(orderItem.id.toString(),
                    style: rubikMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL)),
                const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Expanded(
                    child: orderItem.orderType == 'take_away' ||
                            orderItem.orderType == 'dine_in'
                        ? Text(
                            '(${getTranslated(orderItem.orderType, context)})',
                            style: rubikMedium.copyWith(
                                color: Theme.of(context).primaryColor),
                          )
                        : const SizedBox()),
              ]),
              const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(
                '${orderItem.detailsCount} ${getTranslated(orderItem.detailsCount > 1 ? 'items' : 'item', context)}',
                style: rubikRegular.copyWith(color: ColorResources.COLOR_GREY),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(children: [
                Icon(Icons.check_circle,
                    color: Theme.of(context).primaryColor, size: 15),
                const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(getTranslated(orderItem.orderStatus, context),
                    style: rubikRegular.copyWith(
                        color: Theme.of(context).primaryColor)),
              ]),
            ]),
          ),
        ]),
        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        SizedBox(
          height: 50,
          child: Row(children: [
            Expanded(
                child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      width: 2, color: ColorResources.DISABLE_COLOR),
                ),
                minimumSize: const Size(1, 50),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.getOrderDetailsRoute(orderItem.id),
                  arguments: OrderDetailsScreen(
                      orderModel: orderItem, orderId: orderItem.id),
                );
              },
              child: Text(getTranslated('details', context),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: ColorResources.DISABLE_COLOR,
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      )),
            )),
            SizedBox(width: isRunning ? 20 : 0),
            isRunning
                ? Expanded(
                    child: orderItem.orderType != 'pos' &&
                            orderItem.orderType != 'take_away'
                        ? CustomButton(
                            btnTxt: getTranslated(
                                isRunning ? 'track_order' : 'reorder', context),
                            onTap: () async {
                              if (isRunning) {
                                Navigator.pushNamed(context,
                                    Routes.getOrderTrackingRoute(orderItem.id));
                              } else {
                                List<OrderDetailsModel>? orderDetails =
                                    await orderProvider.getOrderDetails(
                                        orderItem.id.toString(), context);
                                List<CartModel> cartList = [];
                                List<bool> availableList = [];
                                orderDetails?.forEach((orderDetail) {
                                  List<AddOn> addOnList = [];
                                  List<Variation> variationList = [];

                                  cartList.add(CartModel(
                                      price: orderDetail.price,
                                      points: 0.0,
                                      discountedPrice:
                                          PriceConverter.convertWithDiscount(
                                              context,
                                              orderDetail.price,
                                              double.parse(orderDetail
                                                  .discountOnProduct
                                                  .toString()),
                                              'amount'),
                                      variation: variationList,
                                      discountAmount: double.parse(orderDetail
                                          .discountOnProduct
                                          .toString()),
                                      quantity: orderDetail.quantity,
                                      specialInstruction: '',
                                      taxAmount: double.parse(
                                          orderDetail.taxAmount.toString()),
                                      addOnIds: addOnList,
                                      product: orderDetail.productDetails,
                                      isGift: false,
                                      isFree: false));
                                });
                                if (availableList.contains(false)) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'one_or_more_product_unavailable',
                                          context),
                                      context);
                                } else {
                                  if (orderItem.isProductAvailable) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.getCheckoutRoute(
                                        orderItem.orderAmount,
                                        'reorder',
                                        orderItem.orderType,
                                        orderItem.couponDiscountTitle ?? '',
                                      ),
                                      arguments: CheckoutScreen(
                                        cartList: cartList,
                                        fromCart: false,
                                        amount: orderItem.orderAmount,
                                        orderType: orderItem.orderType,
                                        couponCode:
                                            orderItem.couponDiscountTitle ?? '',
                                      ),
                                    );
                                  } else {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'one_or_more_product_unavailable',
                                            context),
                                        context);
                                  }
                                }
                              }
                            },
                          )
                        : const SizedBox.shrink())
                : const SizedBox.shrink(),
          ]),
        ),
      ]),
    );
  }
}
