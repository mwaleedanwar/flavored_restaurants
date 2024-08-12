import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/review_body_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_details_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:provider/provider.dart';

import '../thanks_feedback_screen.dart';

class ProductReviewWidget extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  const ProductReviewWidget({super.key, required this.orderDetailsList});

  @override
  State<ProductReviewWidget> createState() => _ProductReviewWidgetState();
}

class _ProductReviewWidgetState extends State<ProductReviewWidget> {
  final reviewTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scrollbar(
          child: SingleChildScrollView(
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
                      child: ListView.builder(
                        itemCount: widget.orderDetailsList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1))
                              ],
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            ),
                            child: Column(
                              children: [
                                // Product details
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder_image,
                                        height: 70,
                                        width: 85,
                                        fit: BoxFit.cover,
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${widget.orderDetailsList[index].productDetails!.image}',
                                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,
                                            height: 70, width: 85, fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(widget.orderDetailsList[index].productDetails!.name,
                                            style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 10),
                                        Text(
                                            PriceConverter.convertPrice(
                                                context, widget.orderDetailsList[index].productDetails!.price),
                                            style: rubikBold),
                                      ],
                                    )),
                                    Row(children: [
                                      Text(
                                        '${getTranslated('quantity', context)}: ',
                                        style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        widget.orderDetailsList[index].quantity.toString(),
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: Dimensions.FONT_SIZE_SMALL),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ]),
                                  ],
                                ),
                                const Divider(height: 20),

                                // Rate
                                Text(
                                  getTranslated('rate_the_food', context),
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
                                          productProvider.ratingList[index] < (i + 1) ? Icons.star_border : Icons.star,
                                          size: 25,
                                          color: productProvider.ratingList[index] < (i + 1)
                                              ? ColorResources.getGreyColor(context)
                                              : Theme.of(context).primaryColor,
                                        ),
                                        onTap: () {
                                          if (!productProvider.submitList[index]) {
                                            Provider.of<ProductProvider>(context, listen: false)
                                                .setRating(index, i + 1);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                Text(
                                  getTranslated('share_your_opinion', context),
                                  style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                CustomTextField(
                                  controller: reviewTextController,
                                  maxLines: 3,
                                  capitalization: TextCapitalization.sentences,
                                  isEnabled: !productProvider.submitList[index],
                                  hintText: getTranslated('write_your_review_here', context),
                                  fillColor: ColorResources.getSearchBg(context),
                                  onChanged: (text) {
                                    productProvider.setReview(index, text);
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Submit button
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                  child: Column(
                                    children: [
                                      !productProvider.loadingList[index]
                                          ? CustomButton(
                                              btnTxt: getTranslated(
                                                  productProvider.submitList[index] ? 'submitted' : 'submit', context),
                                              backgroundColor: productProvider.submitList[index]
                                                  ? ColorResources.getGreyColor(context)
                                                  : Theme.of(context).primaryColor,
                                              onTap: () {
                                                if (!productProvider.submitList[index]) {
                                                  if (productProvider.ratingList[index] == 0) {
                                                    showCustomSnackBar('Give a rating', context);
                                                  } else if (productProvider.reviewList[index].isEmpty) {
                                                    showCustomSnackBar('Write a review', context);
                                                  } else {
                                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                                    if (!currentFocus.hasPrimaryFocus) {
                                                      currentFocus.unfocus();
                                                    }
                                                    ReviewBody reviewBody = ReviewBody(
                                                      productId: widget.orderDetailsList[index].productId.toString(),
                                                      rating: productProvider.ratingList[index].toString(),
                                                      comment: productProvider.reviewList[index],
                                                      orderId: widget.orderDetailsList[index].orderId.toString(),
                                                    );
                                                    productProvider.submitReview(index, reviewBody).then((value) {
                                                      if (value.isSuccess) {
                                                        showCustomSnackBar(value.message, context, isError: false);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => const ThanksFeedbackScreen()));

                                                        productProvider.setReview(index, '');
                                                      } else {
                                                        showCustomSnackBar(value.message, context);
                                                      }
                                                    });
                                                  }
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
                              ],
                            ),
                          );
                        },
                      ),
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
