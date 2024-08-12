// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/review_body_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/tip_controller.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/track/widget/delivery_man_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../tip_view/tip_view.dart';
import '../thanks_feedback_screen.dart';

class DeliveryManReviewWidget extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  final String orderID;

  const DeliveryManReviewWidget({super.key, required this.deliveryMan, required this.orderID});

  @override
  State<DeliveryManReviewWidget> createState() => _DeliveryManReviewWidgetState();
}

class _DeliveryManReviewWidgetState extends State<DeliveryManReviewWidget> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController tipController = TextEditingController();

  bool isNotTip = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: ResponsiveHelper.isDesktop(context)
                            ? MediaQuery.of(context).size.height - 400
                            : MediaQuery.of(context).size.height),
                    child: SizedBox(
                      width: 1170,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        widget.deliveryMan != null
                            ? DeliveryManWidget(deliveryMan: widget.deliveryMan!)
                            : const SizedBox(),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        Container(
                          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Provider.of<ThemeProvider>(context).darkTheme
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                                blurRadius: 5,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              getTranslated('rate_his_service', context),
                              style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                            SizedBox(
                              height: 30,
                              child: ListView.builder(
                                itemCount: 5,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    child: Icon(
                                      productProvider.deliveryManRating < (i + 1) ? Icons.star_border : Icons.star,
                                      size: 35,
                                      color: productProvider.deliveryManRating < (i + 1)
                                          ? ColorResources.getGreyColor(context)
                                          : Theme.of(context).primaryColor,
                                    ),
                                    onTap: () {
                                      if (!Provider.of<ProductProvider>(context, listen: false).isReviewSubmitted) {
                                        Provider.of<ProductProvider>(context, listen: false)
                                            .setDeliveryManRating(i + 1);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            const TipView(),

                            Text(
                              getTranslated('share_your_opinion', context),
                              style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            CustomTextField(
                              maxLines: 5,
                              capitalization: TextCapitalization.sentences,
                              controller: _controller,
                              hintText: getTranslated('write_your_review_here', context),
                              fillColor: ColorResources.getSearchBg(context),
                            ),

                            const SizedBox(height: 40),

                            // Submit button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Column(
                                children: [
                                  !productProvider.isLoading
                                      ? CustomButton(
                                          btnTxt: getTranslated(
                                              productProvider.isReviewSubmitted ? 'submitted' : 'submit', context),
                                          onTap: productProvider.isReviewSubmitted
                                              ? null
                                              : () {
                                                  if (productProvider.deliveryManRating == 0) {
                                                    showCustomSnackBar('Give a rating', context);
                                                  } else if (_controller.text.isEmpty) {
                                                    showCustomSnackBar('Write a review', context);
                                                  } else {
                                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                                    if (!currentFocus.hasPrimaryFocus) {
                                                      currentFocus.unfocus();
                                                    }
                                                    ReviewBody reviewBody = ReviewBody(
                                                        deliveryManId: widget.deliveryMan?.id.toString(),
                                                        rating: productProvider.deliveryManRating.toString(),
                                                        comment: _controller.text,
                                                        orderId: widget.orderID,
                                                        orderTip: Get.put(TipController()).tip.value == 0.0
                                                            ? null
                                                            : Get.put(TipController()).tip.value);

                                                    debugPrint('--body:${reviewBody.orderTip}');
                                                    productProvider
                                                        .submitDeliveryManReview(reviewBody, context)
                                                        .then((value) {
                                                      if (value.isSuccess) {
                                                        showCustomSnackBar(value.message, context, isError: false);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => const ThanksFeedbackScreen()));

                                                        _controller.text = '';
                                                      } else {
                                                        showCustomSnackBar(value.message, context);
                                                      }
                                                    });
                                                  }
                                                },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),
                if (ResponsiveHelper.isDesktop(context))
                  const Padding(
                    padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                    child: FooterView(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
