import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/offer_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/special_offer_produtc_card.dart';

import '../../../../helper/date_converter.dart';

class HapyyHoursSheetView extends StatefulWidget {
  final SpecialOfferModel specialOfferModel;

  const HapyyHoursSheetView({super.key, required this.specialOfferModel});

  @override
  State<HapyyHoursSheetView> createState() => _HapyyHoursSheetViewState();
}

class _HapyyHoursSheetViewState extends State<HapyyHoursSheetView> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 0 : Dimensions.PADDING_SIZE_EXTRA_LARGE),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${F.appName} Happy Hours', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              const SizedBox(
                height: 8,
              ),
              Text('Come and Avail the deal at your convenience',
                  style: rubikMedium.copyWith(fontWeight: FontWeight.w500, fontSize: Dimensions.FONT_SIZE_SMALL)),
              const SizedBox(
                height: 8,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Start Time:',
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          '${DateConverter.getTime(widget.specialOfferModel.offerAvailableTimeStarts)}',
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'End Time:',
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          '${DateConverter.getTime(widget.specialOfferModel.offerAvailableTimeEnds)}',
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        //   controller: scrollController,
                        itemCount: widget.specialOfferModel.happyhour?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.0, left: index == 0 ? 0 : 8, right: 6, bottom: 8),
                            child: SpecialOfferProductCard(
                              isHappyHours: true,
                              specialOfferModel: widget.specialOfferModel,
                              offerProduct: widget.specialOfferModel.happyhour![index],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
