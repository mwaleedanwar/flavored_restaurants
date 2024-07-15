import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/offer_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/special_offer_produtc_card.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';

class BuffeeSheetView extends StatefulWidget {
  final SpecialOfferModel specialOfferModel;

  const BuffeeSheetView({super.key, required this.specialOfferModel});

  @override
  State<BuffeeSheetView> createState() => _BuffeeSheetViewState();
}

class _BuffeeSheetViewState extends State<BuffeeSheetView> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 0 : Dimensions.PADDING_SIZE_EXTRA_LARGE),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${F.appName} Buffet', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              const SizedBox(
                height: 8,
              ),
              Text('We provide best Buffet service onsite',
                  style: rubikMedium.copyWith(fontWeight: FontWeight.w500, fontSize: Dimensions.FONT_SIZE_SMALL)),
              const SizedBox(
                height: 8,
              ),
              ListView.builder(
                  itemCount: widget.specialOfferModel.buffet?.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buffetDetailsView(context, index);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buffetDetailsView(BuildContext context, index) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.specialOfferModel.buffet![index].subType == 'lunch' ? 'Lunch' : 'Dinner'} Buffet',
              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                'Start Time:',
                style: rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                '${DateConverter.getTime(widget.specialOfferModel.buffet![index].offerAvailableTimeStarts)}',
                style: rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
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
                style: rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                '${DateConverter.getTime(widget.specialOfferModel.buffet![index].offerAvailableTimeEnds)}',
                style: rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
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
                'Price per person',
                style: rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                PriceConverter.convertPrice(
                    context, double.parse(widget.specialOfferModel.buffet![index].price.toString())),
                style: rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: widget.specialOfferModel.buffet?[index].allItems?.length,
              itemBuilder: (context, subIndex) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.0, left: subIndex == 0 ? 0 : 8, right: 6, bottom: 8),
                  child: SpecialOfferProductCard(
                    isBuffet: true,
                    offerProduct: widget.specialOfferModel.buffet![index].allItems![subIndex],
                    specialOfferModel: widget.specialOfferModel.buffet![index],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ]);
  }
}
