// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/address_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/location_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/time_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/track/widget/custom_stepper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/track/widget/delivery_man_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/track/widget/tracking_map_widget.dart';
import 'package:provider/provider.dart';

import 'widget/timer_view.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderID;
  const OrderTrackingScreen({
    super.key,
    required this.orderID,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false).getDeliveryManData(widget.orderID, context);
    Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderID, null, context, true).whenComplete(
        () => Provider.of<TimerProvider>(context, listen: false)
            .countDownTimer(Provider.of<OrderProvider>(context, listen: false).trackModel!, context));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final List<String> statusList = [
      'pending',
      'confirmed',
      'processing',
      'out_for_delivery',
      'delivered',
      'returned',
      'failed',
      'canceled'
    ];

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(context: context, title: getTranslated('order_tracking', context)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
              child: Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.PADDING_SIZE_LARGE,
                    right: Dimensions.PADDING_SIZE_LARGE,
                    bottom: Dimensions.PADDING_SIZE_LARGE,
                    top: ResponsiveHelper.isMobile(context) ? 0 : Dimensions.PADDING_SIZE_LARGE),
                child: Center(
                  child: Consumer<OrderProvider>(
                    builder: (context, order, child) {
                      String? status;
                      if (order.trackModel != null) {
                        status = order.trackModel!.orderStatus;
                      }

                      if (status != null && status == statusList[5] ||
                          status == statusList[6] ||
                          status == statusList[7]) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(status!),
                            const SizedBox(height: 50),
                            CustomButton(
                                btnTxt: getTranslated('back_home', context),
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                }),
                          ],
                        );
                      } else if (order.responseModel != null && !order.responseModel!.isSuccess) {
                        return Center(child: Text(order.responseModel!.message));
                      }

                      return status != null
                          ? RefreshIndicator(
                              onRefresh: () async {
                                await Provider.of<OrderProvider>(context, listen: false)
                                    .getDeliveryManData(widget.orderID, context);
                                await Provider.of<OrderProvider>(context, listen: false)
                                    .trackOrder(widget.orderID, null, context, true);
                              },
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  child: Center(
                                    child: Container(
                                      // width: _width > 700 ? 700 : _width,
                                      padding:
                                          width > 700 ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                                      decoration: width > 700
                                          ? BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 1)
                                              ],
                                            )
                                          : null,
                                      child: SizedBox(
                                        width: 1170,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (status == statusList[0] ||
                                                status == statusList[1] ||
                                                status == statusList[2] ||
                                                status == statusList[3])
                                              const TimerView(),
                                            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                                            order.trackModel?.deliveryMan != null
                                                ? DeliveryManWidget(deliveryMan: order.trackModel!.deliveryMan!)
                                                : const SizedBox(),

                                            order.trackModel?.deliveryMan != null
                                                ? const SizedBox(height: 30)
                                                : const SizedBox(),

                                            CustomStepper(
                                              title: getTranslated('order_placed', context),
                                              isActive: true,
                                              haveTopBar: false,
                                            ),

                                            CustomStepper(
                                              title: getTranslated('preparing_food', context),
                                              isActive: status != statusList[0],
                                            ),
                                            order.trackModel?.orderType != 'take_away'
                                                ? CustomStepper(
                                                    title: getTranslated('food_in_the_way', context),
                                                    isActive: status != statusList[0] &&
                                                        status != statusList[1] &&
                                                        status != statusList[2],
                                                  )
                                                : const SizedBox(),

                                            /// make it happen

                                            order.trackModel?.orderType != 'take_away'
                                                ? CustomStepper(
                                                    title: getTranslated('delivered_the_food', context),
                                                    isActive: status == statusList[4],
                                                    height: status == statusList[3] ? 240 : 30,
                                                    child: status == statusList[3]
                                                        ? Builder(builder: (context) {
                                                            AddressModel? address;
                                                            for (int i = 0;
                                                                i <
                                                                    (Provider.of<LocationProvider>(context,
                                                                                    listen: false)
                                                                                .addressList ??
                                                                            [])
                                                                        .length;
                                                                i++) {
                                                              if (Provider.of<LocationProvider>(context, listen: false)
                                                                      .addressList![i]
                                                                      .id ==
                                                                  order.trackModel!.deliveryAddressId) {
                                                                address = Provider.of<LocationProvider>(context,
                                                                        listen: false)
                                                                    .addressList![i];
                                                              }
                                                            }
                                                            return TrackingMapWidget(
                                                              deliveryManModel: order.deliveryManModel,
                                                              orderID: widget.orderID,
                                                              addressModel: address,
                                                            );
                                                          })
                                                        : null,
                                                  )
                                                : CustomStepper(
                                                    title: 'Ready for pickup',
                                                    isActive: status == statusList[4],
                                                    height: status == statusList[3] ? 240 : 30,
                                                    child: status == statusList[3]
                                                        ? Builder(builder: (context) {
                                                            AddressModel? address;
                                                            for (int i = 0;
                                                                i <
                                                                    (Provider.of<LocationProvider>(context,
                                                                                    listen: false)
                                                                                .addressList ??
                                                                            [])
                                                                        .length;
                                                                i++) {
                                                              if (Provider.of<LocationProvider>(context, listen: false)
                                                                      .addressList![i]
                                                                      .id ==
                                                                  order.trackModel!.deliveryAddressId) {
                                                                address = Provider.of<LocationProvider>(context,
                                                                        listen: false)
                                                                    .addressList![i];
                                                              }
                                                            }
                                                            return TrackingMapWidget(
                                                              deliveryManModel: order.deliveryManModel,
                                                              orderID: widget.orderID,
                                                              addressModel: address,
                                                            );
                                                          })
                                                        : null,
                                                  ),
                                            const SizedBox(height: 50),

                                            ResponsiveHelper.isDesktop(context)
                                                ? Center(
                                                    child: SizedBox(
                                                      width: 400,
                                                      child: CustomButton(
                                                          btnTxt: getTranslated('back_home', context),
                                                          onTap: () {
                                                            Navigator.pushNamedAndRemoveUntil(
                                                                context, Routes.getMainRoute(), (route) => false);
                                                          }),
                                                    ),
                                                  )
                                                : CustomButton(
                                                    btnTxt: getTranslated('back_home', context),
                                                    onTap: () {
                                                      Navigator.pushNamedAndRemoveUntil(
                                                          context, Routes.getMainRoute(), (route) => false);
                                                    }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                    },
                  ),
                ),
              ),
            ),
            if (ResponsiveHelper.isDesktop(context)) const FooterView(),
          ],
        ),
      ),
    );
  }
}
