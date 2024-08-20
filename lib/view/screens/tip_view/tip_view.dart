import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/tip_controller.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';

class TipView extends StatefulWidget {
  final bool isFromCart;
  final double orderAmount;
  const TipView({super.key, this.isFromCart = false, this.orderAmount = 0.0});

  @override
  State<TipView> createState() => _TipViewState();
}

class _TipViewState extends State<TipView> {
  final tipController = Get.put(TipController());

  final controller = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 100)).then((value) {
      tipController.initializeData(widget.isFromCart, orderAmount: widget.orderAmount);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, productProvider, child) {
      return Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isFromCart ? 'Tip the crew' : 'Rider Tip',
              style: widget.isFromCart
                  ? rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)
                  : rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            SizedBox(
              height: ResponsiveHelper.isMobile(context) ? 45 : 70,
              child: ListView.builder(
                itemCount:
                    widget.isFromCart ? tipController.tipPercentList.length : tipController.tipsAmountList.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      tipController.isNotTip.value = false;

                      tipController.updateTip(i, widget.isFromCart, orderAmount: widget.orderAmount);
                    },
                    child: Container(
                      width: ResponsiveHelper.isMobile(context) ? 70 : 100,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: ColorResources.getSearchBg(context),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: tipController.selectedTip.contains(tipController.tipsAmountList[i]) ||
                                      tipController.selectedTip.contains(tipController.tipPercentList[i])
                                  ? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.transparent
                                  : Colors.transparent)),
                      child: widget.isFromCart
                          ? Text(
                              i != 3 ? '${tipController.tipPercentList[i]}%' : '${tipController.tipPercentList[i]}',
                              style: rubikMedium.copyWith(
                                  color: ColorResources.getGreyBunkerColor(context),
                                  fontSize: ResponsiveHelper.isMobile(context)
                                      ? Dimensions.FONT_SIZE_DEFAULT
                                      : Dimensions.FONT_SIZE_EXTRA_LARGE),
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              i != 3 ? '${tipController.tipsAmountList[i]}\$' : '${tipController.tipsAmountList[i]}',
                              style: rubikMedium.copyWith(
                                  color: ColorResources.getGreyBunkerColor(context),
                                  fontSize: ResponsiveHelper.isMobile(context)
                                      ? Dimensions.FONT_SIZE_DEFAULT
                                      : Dimensions.FONT_SIZE_EXTRA_LARGE),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  );
                },
              ),
            ),
            if (tipController.selectedTip.contains('Other'))
              Row(
                children: [
                  Text(
                    'Enter amount in \$ : ',
                    style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  ResponsiveHelper.isMobile(context)
                      ? Expanded(
                          child: CustomTextField(
                            maxLines: 1,
                            capitalization: TextCapitalization.sentences,
                            controller: controller,
                            inputType: TextInputType.number,
                            onChanged: (val) {
                              if (val == '') {
                                tipController.tip.value = 0.0;
                              } else {
                                tipController.tip.value = double.parse(val);
                              }
                            },
                            hintText: '0',
                            inputDecoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(color: Colors.black)),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 100,
                          child: CustomTextField(
                            maxLines: 1,
                            capitalization: TextCapitalization.sentences,
                            controller: controller,
                            inputType: TextInputType.number,
                            onChanged: (val) {
                              if (val == '') {
                                tipController.tip.value = 0.0;
                              } else {
                                tipController.tip.value = double.parse(val);
                              }
                            },
                            hintText: '0',
                            inputDecoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(color: Colors.black)),
                            ),
                          ),
                        )
                ],
              ),
            const SizedBox(height: 5),
          ],
        ),
      );
    });
  }
}
