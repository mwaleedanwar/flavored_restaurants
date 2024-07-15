import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/set_menu_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/on_hover.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/rating_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SetMenuPageView extends StatelessWidget {
  final SetMenuProvider setMenuProvider;
  final PageController pageController;
  const SetMenuPageView({super.key, required this.setMenuProvider, required this.pageController});

  @override
  Widget build(BuildContext context) {
    int totalPage = ((setMenuProvider.setMenuList ?? []).length / 4).ceil();

    return PageView.builder(
      controller: pageController,
      itemCount: totalPage,
      onPageChanged: (index) {
        setMenuProvider.updateSetMenuCurrentIndex(index, totalPage);
      },
      itemBuilder: (context, index) {
        int initialLength = 4;
        int currentIndex = 4 * index;

        initialLength = (index + 1 == totalPage) ? (setMenuProvider.setMenuList ?? []).length - (index * 4) : 4;
        return ListView.builder(
            itemCount: initialLength,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            itemBuilder: (context, item) {
              int currentIndex0 = item + currentIndex;
              String name = '';
              setMenuProvider.setMenuList![currentIndex0].name.length > 20
                  ? name = '${setMenuProvider.setMenuList![currentIndex0].name.substring(0, 20)} ...'
                  : name = setMenuProvider.setMenuList![currentIndex0].name;
              double startingPrice;
              double? endingPrice;
              if ((setMenuProvider.setMenuList![currentIndex0].choiceOptions ?? []).isNotEmpty) {
                List<double> priceList = [];
                for (Variation variation in setMenuProvider.setMenuList![currentIndex0].variations ?? []) {
                  for (Value value in variation.values ?? []) {
                    priceList.add(double.parse(value.optionPrice));
                  }
                }

                priceList.sort((a, b) => a.compareTo(b));
                startingPrice = priceList[0];
                if (priceList[0] < priceList[priceList.length - 1]) {
                  endingPrice = priceList[priceList.length - 1];
                }
              } else {
                startingPrice = setMenuProvider.setMenuList![currentIndex0].price;
              }

              double discount = setMenuProvider.setMenuList![currentIndex0].price -
                  PriceConverter.convertWithDiscount(
                      context,
                      setMenuProvider.setMenuList![currentIndex0].price,
                      setMenuProvider.setMenuList![currentIndex0].discount,
                      setMenuProvider.setMenuList![currentIndex0].discountType);

              bool isAvailable = DateConverter.isAvailable(
                  setMenuProvider.setMenuList![currentIndex0].availableTimeStarts!,
                  setMenuProvider.setMenuList![currentIndex0].availableTimeEnds!,
                  context);

              return OnHover(builder: (isHover) {
                return Consumer<CartProvider>(builder: (context, cartProvider, child) {
                  int? cartIndex = cartProvider.getCartIndex(setMenuProvider.setMenuList?[currentIndex0]);
                  return InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (con) => Dialog(
                                child: CartBottomSheet(
                                  product: setMenuProvider.setMenuList![currentIndex0],
                                  fromSetMenu: true,
                                  cart: cartIndex != null ? cartProvider.cartList[cartIndex] : null,
                                ),
                              ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Container(
                        width: 278,
                        decoration: BoxDecoration(
                            color: ColorResources.getCartColor(context),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Provider.of<ThemeProvider>(context).darkTheme
                                    ? Colors.grey.shade800
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
                                      height: 225.0,
                                      width: 368,
                                      fit: BoxFit.cover,
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${setMenuProvider.setMenuList![currentIndex0].image}',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle,
                                          height: 225.0, width: 368, fit: BoxFit.cover),
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
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
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
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(name,
                                            style: rubikRegular.copyWith(
                                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                color: ColorResources.getCartTitleColor(context)),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        RatingBar(
                                            rating: (setMenuProvider.setMenuList?[currentIndex0].rating ?? [])
                                                    .isNotEmpty
                                                ? double.parse(
                                                    setMenuProvider.setMenuList![currentIndex0].rating!.first.average)
                                                : 0.0,
                                            size: Dimensions.PADDING_SIZE_DEFAULT),
                                        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              discount > 0
                                                  ? Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                      child: Text(
                                                          '${PriceConverter.convertPrice(context, startingPrice)}'
                                                          '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice)}' : ''}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: rubikBold.copyWith(
                                                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                            decoration: TextDecoration.lineThrough,
                                                          )),
                                                    )
                                                  : const SizedBox(),
                                              Text(
                                                '${PriceConverter.convertPrice(context, startingPrice, discount: setMenuProvider.setMenuList![currentIndex0].discount, discountType: setMenuProvider.setMenuList![currentIndex0].discountType)}'
                                                '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice, discount: setMenuProvider.setMenuList![currentIndex0].discount, discountType: setMenuProvider.setMenuList![currentIndex0].discountType)}' : ''}',
                                                style: rubikBold.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                    color: F.appbarHeaderColor,
                                                    overflow: TextOverflow.ellipsis),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: F.appbarHeaderColor),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (con) => Dialog(
                                                        child: CartBottomSheet(
                                                          cart: cartIndex != null
                                                              ? cartProvider.cartList[cartIndex]
                                                              : null,
                                                          product: setMenuProvider.setMenuList![currentIndex0],
                                                          fromSetMenu: true,
                                                        ),
                                                      ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                Text(getTranslated('quick_view', context), style: robotoRegular),
                                                const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              ]),
                                            ))
                                      ]),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  );
                });
              });
            });
      },
    );
  }
}
