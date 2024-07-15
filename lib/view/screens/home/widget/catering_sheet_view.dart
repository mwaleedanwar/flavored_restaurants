import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/offer_model.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/special_offer_produtc_card.dart';

class CateringSheetView extends StatefulWidget {
  final SpecialOfferModel specialOfferModel;
  const CateringSheetView({super.key, required this.specialOfferModel});

  @override
  State<CateringSheetView> createState() => _CateringSheetViewState();
}

class _CateringSheetViewState extends State<CateringSheetView> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.isMobile(context)
              ? 0
              : Dimensions.PADDING_SIZE_EXTRA_LARGE),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Catering',
                    style: rubikMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                const SizedBox(
                  height: 8,
                ),

                Text(
                    'We provide best catering services where we provide different trays of products on special discounts',
                    style: rubikMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.FONT_SIZE_SMALL)),

                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    //   controller: scrollController,
                    itemCount: widget.specialOfferModel.catering!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 6,
                            right: 6,
                            top: 0,
                            bottom: 8),
                        child: SpecialOfferProductCard(
                          isCatering: true,
                          specialOfferModel:
                              widget.specialOfferModel.catering![index],
                        ),
                      );
                    },
                  ),
                ),
                //Product
              ]),
        ),
      ),
    );
  }
}
