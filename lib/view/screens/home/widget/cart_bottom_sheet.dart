import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/read_more_text.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/product_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/product_type.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/title_widget.dart';

import '../../../../utill/app_toast.dart';

class CartBottomSheet extends StatefulWidget {
  final Product product;
  final bool fromSetMenu;
  final CartModel? cart;
  final bool fromCart;
  final bool fromPoints;

  const CartBottomSheet({
    super.key,
    required this.product,
    this.fromSetMenu = false,
    this.cart,
    this.fromCart = false,
    this.fromPoints = false,
  });

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  final TextEditingController _specilInstructionController = TextEditingController();
  int _cartIndex = -1;
  bool loading = true;
  final selectedVariations = <Variation?>[];
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).initData(widget.product, widget.cart, context);
    Provider.of<ProductProvider>(context, listen: false).getRecommendedSideList(context);
    Provider.of<ProductProvider>(context, listen: false).getRecommendedBeveragesList(context);

    debugPrint('==is recommended${widget.product.isRecommended}');

    for (Variation _ in widget.product.variations ?? []) {
      selectedVariations.add(null);
    }
    if (widget.fromCart) {
      synchVariationsFromCart();
    }

    super.initState();
  }

  void synchVariationsFromCart() {
    for (int i = 0; i < (widget.product.variations ?? []).length; i++) {
      for (Variation? variation in widget.cart?.variation ?? []) {
        if (widget.product.variations![i].name == variation?.name) {
          selectedVariations[i] = variation;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      cartProvider.setCartUpdate(false);
      return Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: ResponsiveHelper.isMobile(context)
                  ? const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  : const BorderRadius.all(Radius.circular(20)),
            ),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final startingPrice = widget.product.price;
                const endingPrice = 0.0;

                double price = widget.product.price;
                double priceWithDiscount = PriceConverter.convertWithDiscount(
                    context, price, widget.product.discount, widget.product.discountType);
                double addonsCost = 0;
                List<AddOn> addOnIdList = [];
                for (int index = 0; index < (widget.product.addOns ?? []).length; index++) {
                  if (productProvider.addOnActiveList[index]) {
                    addonsCost =
                        addonsCost + (widget.product.addOns![index].price * productProvider.addOnQtyList[index]!);
                    addOnIdList.add(
                        AddOn(id: widget.product.addOns![index].id, quantity: productProvider.addOnQtyList[index]!));
                  }
                }

                DateTime currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
                DateTime start = DateFormat('hh:mm:ss').parse(widget.product.availableTimeStarts!);
                DateTime end = DateFormat('hh:mm:ss').parse(widget.product.availableTimeEnds!);
                DateTime startTime = DateTime(
                    currentTime.year, currentTime.month, currentTime.day, start.hour, start.minute, start.second);
                DateTime endTime =
                    DateTime(currentTime.year, currentTime.month, currentTime.day, end.hour, end.minute, end.second);
                if (endTime.isBefore(startTime)) {
                  endTime = endTime.add(const Duration(days: 1));
                }
                bool isAvailable = currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
                CartModel cartModel = CartModel(
                    price: !widget.fromPoints ? price : 0.0,
                    points: widget.fromPoints ? double.parse(widget.product.loyaltyPoints) : 0.0,
                    discountedPrice: priceWithDiscount,
                    variation: List.from(selectedVariations),
                    discountAmount: !widget.fromPoints
                        ? (price -
                            PriceConverter.convertWithDiscount(
                                context, price, widget.product.discount, widget.product.discountType))
                        : 0,
                    quantity: productProvider.quantity,
                    specialInstruction: _specilInstructionController.text,
                    taxAmount: !widget.fromPoints
                        ? price -
                            PriceConverter.convertWithDiscount(
                                context, price, widget.product.tax, widget.product.taxType)
                        : 0,
                    addOnIds: addOnIdList,
                    product: widget.product,
                    isGift: false,
                    isFree: widget.fromPoints);

                _cartIndex = cartProvider.isExistInCart(widget.product.id, [...selectedVariations]);
                debugPrint('is exit : $_cartIndex');
                debugPrint('is null : ${productProvider.relatedProducts.isEmpty}');

                double priceWithQuantity = priceWithDiscount * productProvider.quantity;
                double priceWithAddons = priceWithQuantity + addonsCost;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ResponsiveHelper.isMobile(context)
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            height: 5,
                            width: 80,
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                          )
                        : const SizedBox(),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(
                              ResponsiveHelper.isMobile(context) ? 0 : Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _productView(context, startingPrice, endingPrice, price, priceWithDiscount, cartModel),
                                const SizedBox(
                                  height: 5,
                                ),
                                _description(context),
                                const TitleWidget(
                                  title: 'Special Instructions',
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  hintText: 'Instructions..',
                                  isShowBorder: true,
                                  isBorderStyle: true,
                                  controller: _specilInstructionController,
                                  inputType: TextInputType.emailAddress,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                widget.product.variations?.isNotEmpty ?? false
                                    ? _variationView(productProvider, widget.product.variations!)
                                    : const SizedBox.shrink(),
                                (widget.product.choiceOptions ?? []).isNotEmpty
                                    ? const SizedBox(height: Dimensions.PADDING_SIZE_LARGE)
                                    : const SizedBox(),
                                widget.product.isRecommended == '1'
                                    ? Column(
                                        children: [
                                          productProvider.recommendedSidesList.isNotEmpty
                                              ? ResponsiveHelper.isDesktop(context)
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                          child: Text('Recommended Sides',
                                                              style: rubikRegular.copyWith(
                                                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE)),
                                                        ),
                                                      ],
                                                    )
                                                  : const TitleWidget(
                                                      title: 'Recommended Sides',
                                                    )
                                              : const SizedBox(),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          productProvider.isLoading
                                              ? Center(
                                                  child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                                ))
                                              : productProvider.recommendedSidesList.isNotEmpty
                                                  ? const ProductView(
                                                      productType: ProductType.RECOMMENDED_SIDES,
                                                      isFromCart: true,
                                                      isFromCartSheet: true,
                                                    )
                                                  : const SizedBox(),
                                          productProvider.recommendedBeveragesList.isNotEmpty
                                              ? ResponsiveHelper.isDesktop(context)
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                          child: Text('Recommended Beverages',
                                                              style: rubikRegular.copyWith(
                                                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE)),
                                                        ),
                                                      ],
                                                    )
                                                  : const TitleWidget(
                                                      title: 'Recommended Beverages',
                                                    )
                                              : const SizedBox(),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          productProvider.isLoading
                                              ? Center(
                                                  child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                                ))
                                              : productProvider.recommendedBeveragesList.isNotEmpty
                                                  ? const ProductView(
                                                      productType: ProductType.RECOMMENDED_BEVERAGES,
                                                      isFromCart: true,
                                                      isFromCartSheet: true,
                                                    )
                                                  : const SizedBox(),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                Row(children: [
                                  Text('${getTranslated('total_amount', context)}:',
                                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(PriceConverter.convertPrice(context, priceWithAddons),
                                      style: rubikBold.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                      )),
                                ]),
                                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                              ]),
                        ),
                      ),
                    ),
                    _cartButton(isAvailable, context, cartModel),
                  ],
                );
              },
            ),
          ),
          ResponsiveHelper.isMobile(context)
              ? const SizedBox()
              : Positioned(
                  right: 10,
                  top: 5,
                  child: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.close)),
                ),
        ],
      );
    });
  }

  double _variationPrice(List<Variation?> variationsIn) {
    double extra = 0;
    for (Variation? variation in variationsIn) {
      if (variation != null) {
        for (Value value in variation.values ?? []) {
          extra += double.parse(value.optionPrice);
        }
      }
    }
    return extra;
  }

  Widget _quantityView(
    BuildContext context,
    CartModel cartModel,
  ) {
    return Row(children: [
      Text(getTranslated('quantity', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      const Expanded(child: SizedBox()),
      _quantityButton(context, cartModel),
    ]);
  }

  Widget _variationView(ProductProvider productProvider, List<Variation> variations) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: variations.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "${variations[index].name}${variations[index].required ? "  (REQUIRED)" : ""}",
            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          variations[index].type == "multi"
              ? variationChecklist(variations[index], index)
              : variationRadio(variations[index], index),
        ]);
      },
    );
  }

  Widget variationRadio(Variation variation, int x) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variation.values!.length,
      itemBuilder: (context, i) {
        return RadioListTile<Variation>(
          value: variation.copyWith(values: [variation.values![i]]),
          groupValue: selectedVariations[x],
          toggleable: true,
          onChanged: (ind) {
            selectedVariations[x] = ind;
            setState(() {});
          },
          title: Text(parseVariationPrice(
            variation.values![i].label,
            double.parse(variation.values![i].optionPrice),
          )),
        );
      },
    );
  }

  Widget variationChecklist(Variation variation, int x) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variation.values!.length,
      itemBuilder: (context, i) {
        return CheckboxListTile(
          value: selectedVariations[x]?.values?.contains(variation.values![i]) ?? false,
          onChanged: (selected) {
            final currentVariation = selectedVariations[x];
            if ((selected ?? false) && currentVariation == null) {
              selectedVariations[x] = variation.copyWith(values: [variation.values![i]]);
            } else if (selected ?? false) {
              selectedVariations[x]!.values!.add(variation.values![i]);
            } else if (!(selected ?? false) && selectedVariations[x]!.values!.contains(variation.values![i])) {
              selectedVariations[x]!.values!.remove(variation.values![i]);
              if (selectedVariations[x]!.values!.isEmpty) {
                selectedVariations[x] = null;
              }
            }
            setState(() {});
          },
          title: Text(parseVariationPrice(
            variation.values![i].label,
            double.parse(variation.values![i].optionPrice),
          )),
        );
      },
    );
  }

  String parseVariationPrice(String label, double optionPrice) {
    return "${label.trim()}   ${optionPrice == 0 ? "" : ("${optionPrice > 0 ? "+" : ""}$optionPrice")}";
  }

  Widget _description(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('description', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      Align(
        alignment: Alignment.topLeft,
        child: ReadMoreText(
          widget.product.description,
          trimLines: 2,
          trimCollapsedText: getTranslated('show_more', context),
          trimExpandedText: getTranslated('show_less', context),
          moreStyle: robotoRegular.copyWith(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
          ),
          lessStyle: robotoRegular.copyWith(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
          ),
        ),
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
    ]);
  }

  Widget _cartButton(bool isAvailable, BuildContext context, CartModel cartModel) {
    cartModel.variation?.removeWhere((element) => element == null);
    return Column(children: [
      isAvailable
          ? const SizedBox()
          : Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(children: [
                Text(getTranslated('not_available_now', context),
                    style: rubikMedium.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                Text(
                  '${getTranslated('available_will_be', context)} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts!, context)} '
                  '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds!, context)}',
                  style: rubikRegular,
                ),
              ]),
            ),
      CustomButton(
          btnTxt: getTranslated(
            _cartIndex != -1 ? 'update_in_cart' : 'add_to_cart',
            context,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            if (requiredVariantsSelected()) {
              if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                if (widget.fromPoints) {
                  debugPrint('=from1');

                  Provider.of<ProductProvider>(context, listen: false).updateLoyaltyPoints(cartModel.points, context);
                  setState(() {});
                }
                Navigator.pop(context);
                Provider.of<CartProvider>(context, listen: false).addToCart(cartModel, _cartIndex);
              } else {
                Navigator.pushNamed(context, Routes.getLoginRoute());

                // showCustomSnackBar(
                //     getTranslated('now_you_are_in_guest_mode', context), context);
                // debugPrint('need to login first');
              }
            } else {
              appToast(text: 'select the required variant(s)', toastColor: Colors.red);
            }
          }),
    ]);
  }

  bool requiredVariantsSelected() {
    bool returnal = true;
    for (int i = 0; i < (widget.product.variations ?? []).length; i++) {
      if (widget.product.variations![i].required && selectedVariations[i] == null) {
        returnal = false;
        break;
      }
    }
    return returnal;
  }

  Widget _productView(
    BuildContext context,
    double startingPrice,
    double endingPrice,
    double price,
    double priceWithDiscount,
    CartModel cartModel,
  ) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: Images.placeholder_rectangle,
          image:
              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${widget.product.image}',
          width: ResponsiveHelper.isMobile(context)
              ? 100
              : ResponsiveHelper.isTab(context)
                  ? 140
                  : ResponsiveHelper.isDesktop(context)
                      ? 140
                      : null,
          height: ResponsiveHelper.isMobile(context)
              ? 100
              : ResponsiveHelper.isTab(context)
                  ? 140
                  : ResponsiveHelper.isDesktop(context)
                      ? 140
                      : null,
          fit: BoxFit.cover,
          imageErrorBuilder: (c, o, s) => Image.asset(
            Images.placeholder_rectangle,
            width: ResponsiveHelper.isMobile(context)
                ? 100
                : ResponsiveHelper.isTab(context)
                    ? 140
                    : ResponsiveHelper.isDesktop(context)
                        ? 140
                        : null,
            height: ResponsiveHelper.isMobile(context)
                ? 100
                : ResponsiveHelper.isTab(context)
                    ? 140
                    : ResponsiveHelper.isDesktop(context)
                        ? 140
                        : null,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                FittedBox(
                  child: Text(
                    PriceConverter.convertPrice(context, startingPrice + _variationPrice(selectedVariations),
                            discount: widget.product.discount, discountType: widget.product.discountType) +
                        (endingPrice != 0
                            ? PriceConverter.convertPrice(
                                      context,
                                      endingPrice,
                                      discount: widget.product.discount,
                                      discountType: widget.product.discountType,
                                    ) ==
                                    ''
                                ? ''
                                : " - ${PriceConverter.convertPrice(
                                    context,
                                    endingPrice,
                                    discount: widget.product.discount,
                                    discountType: widget.product.discountType,
                                  )}"
                            : ''),
                    style: rubikMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      overflow: TextOverflow.ellipsis,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 1,
                  ),
                ),
                price > priceWithDiscount
                    ? FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            '${PriceConverter.convertPrice(context, startingPrice)}'
                            '${endingPrice == 0 ? ' - ${PriceConverter.convertPrice(context, endingPrice)}' : ''}',
                            style: rubikMedium.copyWith(
                                color: ColorResources.COLOR_GREY,
                                decoration: TextDecoration.lineThrough,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ]),
            ),
          ]),
          if (!ResponsiveHelper.isMobile(context)) _quantityView(context, cartModel)
        ]),
      ),
    ]);
  }

  Widget _quantityButton(BuildContext context, CartModel cartModel) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        InkWell(
          onTap: () => productProvider.quantity > 1 ? productProvider.setQuantity(false) : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.remove, size: 20),
          ),
        ),
        Text(productProvider.quantity.toString(),
            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
        InkWell(
          onTap: () => productProvider.setQuantity(true),
          child: const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.add, size: 20),
          ),
        ),
      ]),
    );
  }
}
