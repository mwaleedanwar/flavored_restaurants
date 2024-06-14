import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/category_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/deals_data_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/banner_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/category_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/title_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'deals_bottom_sheet.dart';

class BannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: TitleWidget(title: 'DEALS'),
        ),
        SizedBox(
          height: 85,
          child: Consumer<ProductProvider>(
            builder: (context, product, child) {
              return product.dealsList != null
                  ? product.dealsList.length > 0
                      ? ListView.builder(
                          itemCount: product.dealsList.length,
                          padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Consumer<CartProvider>(builder: (context, _cartProvider, child) {
                              print(
                                  '==images:${Provider.of<SplashProvider>(context, listen: false).baseUrls.offerUrl}/${product.dealsList[index].image}');
                              return InkWell(
                                  onTap: () {
                                    _showOfferSheet(context, dealsDataModel: product.dealsList[index]);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
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
                                        width: 250,
                                        height: 85,
                                        fit: BoxFit.cover,
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.offerUrl}/${product.dealsList[index].image}',
                                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_banner,
                                            width: 250, height: 85, fit: BoxFit.cover),
                                      ),
                                    ),
                                  ));
                            });
                          },
                        )
                      : Center(child: Text(getTranslated('no_banner_available', context)))
                  : BannerShimmer();
            },
          ),
        ),
      ],
    );
  }

  void _showOfferSheet(BuildContext context, {DealsDataModel dealsDataModel}) {
    ResponsiveHelper.isMobile(context)
        ? showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => DealsBottomSheet(
              dealsDataModel: dealsDataModel,
            ),
          )
        : showDialog(
            context: context,
            builder: (con) => Dialog(
                  child: DealsBottomSheet(
                    dealsDataModel: dealsDataModel,
                  ),
                ));
  }
}

class BannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child: Container(
            width: 250,
            height: 85,
            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                  blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                  spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                )
              ],
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
