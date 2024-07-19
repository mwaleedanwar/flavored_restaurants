import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/provider_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/rating_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/title_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SetMenuView extends StatelessWidget {
  const SetMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SetMenuProvider>(
      builder: (context, setMenu, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TitleWidget(
                  title: getTranslated('set_menu', context),
                  onTap: () {
                    // Navigator.pushNamed(context, Routes.getSetMenuRoute());
                  }),
            ),
            SizedBox(
              height: 220,
              child: setMenu.setMenuList != null
                  ? setMenu.setMenuList!.isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                          itemCount: setMenu.setMenuList!.length > 5 ? 5 : setMenu.setMenuList!.length,
                          itemBuilder: (context, index) {
                            double startingPrice;
                            double? endingPrice;
                            if ((setMenu.setMenuList![index].choiceOptions ?? []).isNotEmpty) {
                              List<double> priceList = [];
                              for (var variation in setMenu.setMenuList![index].variations ?? []) {
                                for (var value in variation.values) {
                                  priceList.add(double.parse(value.optionPrice));
                                }
                              }
                              priceList.sort((a, b) => a.compareTo(b));
                              startingPrice = priceList[0];
                              if (priceList[0] < priceList[priceList.length - 1]) {
                                endingPrice = priceList[priceList.length - 1];
                              }
                            } else {
                              startingPrice = setMenu.setMenuList![index].price;
                            }

                            double discount = setMenu.setMenuList![index].price -
                                PriceConverter.convertWithDiscount(context, setMenu.setMenuList![index].price,
                                    setMenu.setMenuList![index].discount, setMenu.setMenuList![index].discountType);

                            bool isAvailable = DateConverter.isAvailable(
                                setMenu.setMenuList![index].availableTimeStarts!,
                                setMenu.setMenuList![index].availableTimeEnds!,
                                context);

                            return Consumer<CartProvider>(builder: (context, cartProvider, child) {
                              int? cartIndex = cartProvider.getCartIndex(setMenu.setMenuList![index]);
                              return Padding(
                                padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
                                child: InkWell(
                                  onTap: () {
                                    ResponsiveHelper.isMobile(context)
                                        ? showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (con) => CartBottomSheet(
                                                  product: setMenu.setMenuList![index],
                                                  fromSetMenu: true,
                                                  cart: cartIndex != null ? cartProvider.cartList[cartIndex] : null,
                                                ))
                                        : showDialog(
                                            context: context,
                                            builder: (con) => Dialog(
                                                  child: CartBottomSheet(
                                                    product: setMenu.setMenuList![index],
                                                    fromSetMenu: true,
                                                    cart: cartIndex != null ? cartProvider.cartList[cartIndex] : null,
                                                  ),
                                                ));
                                  },
                                  child: Container(
                                    height: 220,
                                    width: 170,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Provider.of<ThemeProvider>(context).darkTheme
                                                ? Colors.grey.shade900
                                                : Colors.grey.shade300,
                                            blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                                            spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                                          )
                                        ]),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder: Images.placeholder_rectangle,
                                                  height: 110,
                                                  width: 170,
                                                  fit: BoxFit.cover,
                                                  image:
                                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${setMenu.setMenuList![index].image}',
                                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                                      Images.placeholder_rectangle,
                                                      height: 110,
                                                      width: 170,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              isAvailable
                                                  ? const SizedBox()
                                                  : Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      bottom: 0,
                                                      right: 0,
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius.vertical(top: Radius.circular(10)),
                                                          color: Colors.black.withOpacity(0.6),
                                                        ),
                                                        child: Text(getTranslated('not_available_now', context),
                                                            textAlign: TextAlign.center,
                                                            style: rubikRegular.copyWith(
                                                              color: Colors.white,
                                                              fontSize: Dimensions.FONT_SIZE_SMALL,
                                                            )),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      setMenu.setMenuList![index].name,
                                                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                    RatingBar(
                                                      rating: (setMenu.setMenuList![index].rating ?? []).isNotEmpty
                                                          ? double.parse(
                                                              setMenu.setMenuList![index].rating!.first.average)
                                                          : 0.0,
                                                      size: 12,
                                                    ),
                                                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            '${PriceConverter.convertPrice(context, startingPrice, discount: setMenu.setMenuList![index].discount, discountType: setMenu.setMenuList![index].discountType)}'
                                                            '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice, discount: setMenu.setMenuList![index].discount, discountType: setMenu.setMenuList![index].discountType)}' : ''}',
                                                            style: rubikBold.copyWith(
                                                                fontSize: Dimensions.FONT_SIZE_SMALL),
                                                          ),
                                                        ),
                                                        discount > 0
                                                            ? const SizedBox()
                                                            : Icon(Icons.add,
                                                                color: Theme.of(context).textTheme.bodyLarge?.color),
                                                      ],
                                                    ),
                                                    discount > 0
                                                        ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    '${PriceConverter.convertPrice(context, startingPrice)}'
                                                                    '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice)}' : ''}',
                                                                    style: rubikBold.copyWith(
                                                                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                                      color: ColorResources.COLOR_GREY,
                                                                      decoration: TextDecoration.lineThrough,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Icon(Icons.add,
                                                                    color:
                                                                        Theme.of(context).textTheme.bodyLarge?.color),
                                                              ])
                                                        : const SizedBox(),
                                                  ]),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              );
                            });
                          },
                        )
                      : Center(child: Text(getTranslated('no_set_menu_available', context)))
                  : const SetMenuShimmer(),
            ),
          ],
        );
      },
    );
  }
}

class SetMenuShimmer extends StatelessWidget {
  const SetMenuShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          width: 150,
          margin: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, spreadRadius: 1)]),
          child: Shimmer(
            duration: const Duration(seconds: 1),
            interval: const Duration(seconds: 1),
            enabled: Provider.of<SetMenuProvider>(context).setMenuList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 110,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)), color: Colors.grey.shade300),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 15, width: 130, color: Colors.grey.shade300),
                        const Align(alignment: Alignment.centerRight, child: RatingBar(rating: 0.0, size: 12)),
                        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Container(height: 10, width: 50, color: Colors.grey.shade300),
                          const Icon(Icons.add, color: ColorResources.COLOR_BLACK),
                        ]),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
