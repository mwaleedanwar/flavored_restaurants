import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_details_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/order/widget/order_cancel_dialog.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/rare_review/rate_review_screen.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class ButtonView extends StatelessWidget {
  const ButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<OrderProvider>(builder: (context, order, _) {
      return Column(
        children: [
          !order.showCancelled
              ? Center(
                  child: SizedBox(
                    width: width > 700 ? 700 : width,
                    child: Row(children: [
                      order.trackModel?.orderStatus == 'pending'
                          ? Expanded(
                              child: Padding(
                              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(1, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(width: 2, color: ColorResources.DISABLE_COLOR),
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => OrderCancelDialog(
                                      orderID: (order.trackModel?.id ?? '').toString(),
                                      callback: (String message, bool isSuccess, String orderID) {
                                        if (isSuccess) {
                                          showCustomSnackBar('$message. Order ID: $orderID', context, isError: false);
                                        } else {
                                          showCustomSnackBar(message, context, isError: false);
                                        }
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  getTranslated('cancel_order', context),
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        color: ColorResources.DISABLE_COLOR,
                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                      ),
                                ),
                              ),
                            ))
                          : const SizedBox(),
                      (order.trackModel?.paymentStatus == 'unpaid' &&
                              order.trackModel?.paymentMethod != 'cash_on_delivery' &&
                              order.trackModel?.orderStatus != 'delivered')
                          ? Expanded(
                              child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: CustomButton(
                                btnTxt: getTranslated('pay_now', context),
                                onTap: () async {
                                  if (ResponsiveHelper.isWeb()) {
                                    String hostname = html.window.location.hostname ?? '';
                                    String selectedUrl =
                                        '${F.BASE_URL}/payment-mobile?order_id=${order.trackModel!.id}&&customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id}'
                                        '&&callback=http://$hostname${Routes.ORDER_SUCCESS_SCREEN}/${order.trackModel!.id}';
                                    html.window.open(selectedUrl, "_self");
                                  } else {
                                    Navigator.pushReplacementNamed(
                                        context,
                                        Routes.getPaymentRoute(
                                            page: 'order',
                                            id: order.trackModel!.id.toString(),
                                            user: order.trackModel!.userId));
                                  }
                                },
                              ),
                            ))
                          : const SizedBox(),
                    ]),
                  ),
                )
              : Center(
                  child: Container(
                    width: width > 700 ? 700 : width,
                    height: 50,
                    margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      getTranslated('order_cancelled', context),
                      style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
          (order.trackModel?.orderStatus == 'confirmed' ||
                  order.trackModel?.orderStatus == 'processing' ||
                  order.trackModel?.orderStatus == 'out_for_delivery')
              ? Center(
                  child: Container(
                    width: width > 700 ? 700 : width,
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: CustomButton(
                      btnTxt: getTranslated('track_order', context),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.getOrderTrackingRoute(order.trackModel!.id));
                      },
                    ),
                  ),
                )
              : const SizedBox(),
          order.trackModel?.orderStatus == 'delivered'
              ? Center(
                  child: Container(
                    width: width > 700 ? 700 : width,
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: CustomButton(
                      btnTxt: getTranslated('review', context),
                      onTap: () {
                        List<OrderDetailsModel> orderDetailsList = [];
                        for (var orderDetails in order.orderDetails!) {
                          orderDetailsList.add(orderDetails);
                        }
                        Navigator.pushNamed(context, Routes.getRateReviewRoute(),
                            arguments: RateReviewScreen(
                              orderDetailsList: orderDetailsList,
                              deliveryMan: order.trackModel!.deliveryMan!,
                            ));
                      },
                    ),
                  ),
                )
              : const SizedBox(),
          if (order.trackModel?.deliveryMan != null && (order.trackModel!.orderStatus != 'delivered'))
            Center(
              child: Container(
                width: width > 700 ? 700 : width,
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(
                    btnTxt: getTranslated('chat_with_delivery_man', context),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.getChatRoute(orderModel: order.trackModel));
                    }),
              ),
            ),
        ],
      );
    });
  }
}
