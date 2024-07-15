import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/localization_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/set_menu_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/no_data_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/rating_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SetMenuScreen extends StatelessWidget {
  const SetMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(
      context,
      true,
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );

    return Scaffold(
      appBar: CustomAppBar(context: context, title: getTranslated('set_menu', context)),
      body: Consumer<SetMenuProvider>(
        builder: (context, setMenu, child) {
          return setMenu.setMenuList != null
              ? setMenu.setMenuList!.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(
                          context,
                          true,
                          Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                        );
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Center(
                            child: SizedBox(
                              width: 1170,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: setMenu.setMenuList!.length,
                                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 13,
                                    mainAxisSpacing: 13,
                                    childAspectRatio: 1 / 1.2,
                                    crossAxisCount: ResponsiveHelper.isDesktop(context)
                                        ? 6
                                        : ResponsiveHelper.isTab(context)
                                            ? 4
                                            : 2),
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
                                      PriceConverter.convertWithDiscount(
                                          context,
                                          setMenu.setMenuList![index].price,
                                          setMenu.setMenuList![index].discount,
                                          setMenu.setMenuList![index].discountType);

                                  bool isAvailable = DateConverter.isAvailable(
                                      setMenu.setMenuList![index].availableTimeStarts,
                                      setMenu.setMenuList![index].availableTimeEnds,
                                      context);

                                  return Consumer<CartProvider>(builder: (context, cartProvider, child) {
                                    int? cartIndex = cartProvider.getCartIndex(setMenu.setMenuList![index]);
                                    return InkWell(
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
                                                        cart:
                                                            cartIndex != null ? cartProvider.cartList[cartIndex] : null,
                                                      ),
                                                    ));
                                      },
                                      child: Container(
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
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder: Images.placeholder_rectangle,
                                                  height: 110,
                                                  width: MediaQuery.of(context).size.width / 2,
                                                  fit: BoxFit.cover,
                                                  image:
                                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${setMenu.setMenuList![index].image}',
                                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                                      Images.placeholder_rectangle,
                                                      height: 110,
                                                      width: MediaQuery.of(context).size.width / 2,
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
                                                        Text(
                                                          '${PriceConverter.convertPrice(context, startingPrice, discount: setMenu.setMenuList![index].discount, discountType: setMenu.setMenuList![index].discountType)}'
                                                          '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice, discount: setMenu.setMenuList![index].discount, discountType: setMenu.setMenuList![index].discountType)}' : ''}',
                                                          style:
                                                              rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
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
                                                                Text(
                                                                  '${PriceConverter.convertPrice(context, startingPrice)}'
                                                                  '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice)}' : ''}',
                                                                  style: rubikBold.copyWith(
                                                                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                                    color: ColorResources.getGreyColor(context),
                                                                    decoration: TextDecoration.lineThrough,
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
                                    );
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const NoDataScreen()
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
