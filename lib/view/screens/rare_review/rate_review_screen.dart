import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_details_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/rare_review/widget/deliver_man_review_widget.dart';
import 'package:provider/provider.dart';

class RateReviewScreen extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  final DeliveryMan deliveryMan;
  const RateReviewScreen(
      {super.key, required this.orderDetailsList, required this.deliveryMan});

  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<ProductProvider>(context, listen: false)
        .initRatingData(widget.orderDetailsList);
    Provider.of<ProductProvider>(context, listen: false).updateSubmitted(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(
              context: context, title: getTranslated('rate_review', context)),
      body: DeliveryManReviewWidget(
          deliveryMan: widget.deliveryMan,
          orderID: widget.orderDetailsList[0].orderId.toString()),
    );
  }
}
