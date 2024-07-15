import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/offer_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/specialoffer_bottom_sheet.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:provider/provider.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';

class SpecialOfferCard extends StatefulWidget {
  final SpecialOfferModel specialOfferModel;

  const SpecialOfferCard({super.key, required this.specialOfferModel});

  @override
  State<SpecialOfferCard> createState() => _SpecialOfferCardState();
}

class _SpecialOfferCardState extends State<SpecialOfferCard> {
  @override
  Widget build(BuildContext context) {
    var imageUrl =
        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.offerUrl}/${widget.specialOfferModel.image}';
    debugPrint('--offer url:$imageUrl');

    return InkWell(
      onTap: () {
        _showOfferSheet(context, specialOfferModel: widget.specialOfferModel);
      },
      child: Container(
        margin: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade900 : Colors.grey.shade300,
              blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
              spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
            )
          ],
          color: ColorResources.COLOR_WHITE,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage.assetNetwork(
            placeholder: Images.placeholder_banner,
            height: 105,
            width: 195,
            fit: BoxFit.cover,
            image: imageUrl,
            imageErrorBuilder: (c, o, s) =>
                Image.asset(Images.placeholder_banner, height: 105, width: 195, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  void _showOfferSheet(BuildContext context, {required SpecialOfferModel specialOfferModel}) {
    ResponsiveHelper.isMobile(context)
        ? showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => SpecialOffersBottomSheet(
              specialOfferModel: specialOfferModel,
            ),
          )
        : showDialog(
            context: context,
            builder: (con) => Dialog(
                  child: SpecialOffersBottomSheet(
                    specialOfferModel: specialOfferModel,
                  ),
                ));
  }
}
