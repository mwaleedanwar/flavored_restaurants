import 'dart:developer';

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
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/read_more_text.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/rating_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/wish_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/product_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../helper/product_type.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../utill/app_toast.dart';
import '../../../../utill/routes.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/custom_text_field.dart';
import '../../../base/title_widget.dart';

class CartBottomSheet extends StatefulWidget {
  final Product product;
  final bool fromSetMenu;
  final Function callback;
  final CartModel cart;
  final int cartIndex;
  final bool fromCart;
  final bool fromPoints;

  CartBottomSheet(
      {@required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex,
      this.fromCart = false,
      this.fromPoints = false});

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  TextEditingController _specilInstructionController;
  int _cartIndex;
  int value;
  bool loading = true;
  final selectedVariations = <Variation>[];
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).initData(widget.product, widget.cart, context);
    Provider.of<ProductProvider>(context, listen: false).getRecommendedSideList(context);
    Provider.of<ProductProvider>(context, listen: false).getRecommendedBeveragesList(context);
    _specilInstructionController = TextEditingController();

    print('==is recommended${widget.product.isRecommended}');

    for (Variation _ in widget.product.variations) {
      selectedVariations.add(null);
    }
    if (widget.fromCart) {
      synchVariationsFromCart();
    }

    super.initState();
  }

  void synchVariationsFromCart() {
    for (int i = 0; i < widget.product.variations.length; i++) {
      for (Variation variation in widget.cart.variation) {
        if (widget.product.variations[i].name == variation.name) {
          selectedVariations[i] = variation;
          break;
        }
      }
    }
  }

  // _showDialog(Product product,ProductProvider productProvider) async {
  //   await Future.delayed(Duration(milliseconds: 50));
  //   showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (context) => Dialog(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         ListView.builder(
  //           shrinkWrap: true,
  //             itemCount:Provider.of<ProductProvider>(context, listen: false).drinks.length ,
  //             itemBuilder: (context,i){
  //           return InkWell(
  //
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       InkWell(
  //                         onTap: (){
  //                           // productProvider.checkedItems.add(productProvider
  //                           //     .recommendedBeveragesList[index].id);
  //                           // setState(() {
  //                           //
  //                           // });
  //
  //                         },
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //
  //                               color: productProvider.checkedDrink.contains(productProvider
  //                                   .drinks[i])? Theme.of(context).primaryColor: Colors.transparent,
  //                               shape: BoxShape.circle,
  //
  //                               border: Border.all(
  //                                 color:productProvider.checkedDrink.contains(productProvider
  //                                     .drinks[i])? Theme.of(context).primaryColor: Colors.black,
  //
  //                               )
  //                           ),
  //                           child: Icon(Icons.done,color: Colors.white,size: 15,),
  //                         ),
  //                       ),
  //                       SizedBox(width: 10,),
  //                       Text(productProvider.drinks[i],
  //                           style: rubikRegular.copyWith(
  //                               fontSize: Dimensions.FONT_SIZE_LARGE)),
  //                     ],
  //                   ),
  //
  //
  //                 ],
  //               ),
  //             ),
  //           );
  //         }),
  //       ],
  //     ),
  //   ));
  // }
  Map<String, bool> values = {
    'google.com': false,
    'youtube.com': false,
    'yahoo.com': false,
    'gmail.com': false,
  };

  var tmpArray = [];

  getCheckboxItems() {
    values.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      }
    });

    print(tmpArray);
    tmpArray.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, _cartProvider, child) {
      _cartProvider.setCartUpdate(false);
      return Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: ResponsiveHelper.isMobile(context)
                  ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  : BorderRadius.all(Radius.circular(20)),
            ),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final _startingPrice = widget.product.price;
                final _endingPrice = 0.0;
                // if (widget.product.choiceOptions.length != 0) {
                //   List<double> _priceList = [];
                //   for (Variation variation in widget.product.variations) {
                //     for (Value value in variation.values) {
                //       _priceList.add(double.parse(value.optionPrice));
                //     }
                //   }
                //   _priceList.sort((a, b) => a.compareTo(b));
                //   _startingPrice = _priceList[0];
                //   if (_priceList[0] < _priceList[_priceList.length - 1]) {
                //     _endingPrice = _priceList[_priceList.length - 1];
                //   }
                // } else {
                //   _startingPrice = widget.product.price;
                // }
                // for (Variation variation in widget.product.variations) {
                //   _variationList.add(variation);
                // }
                // String variationType = ''; //????
                // bool isFirst = true;
                // _variationList.forEach((variation) {
                //   if (isFirst) {
                //     variationType = '$variationType$variation';
                //     isFirst = false;
                //   } else {
                //     variationType = '$variationType-$variation';
                //   }
                // });

                double price = widget.product.price;
                double priceWithDiscount = PriceConverter.convertWithDiscount(
                    context, price, widget.product.discount, widget.product.discountType);
                double addonsCost = 0;
                List<AddOn> _addOnIdList = [];
                for (int index = 0; index < widget.product.addOns.length; index++) {
                  if (productProvider.addOnActiveList[index]) {
                    addonsCost =
                        addonsCost + (widget.product.addOns[index].price * productProvider.addOnQtyList[index]);
                    _addOnIdList
                        .add(AddOn(id: widget.product.addOns[index].id, quantity: productProvider.addOnQtyList[index]));
                  }
                }

                DateTime _currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
                DateTime _start = DateFormat('hh:mm:ss').parse(widget.product.availableTimeStarts);
                DateTime _end = DateFormat('hh:mm:ss').parse(widget.product.availableTimeEnds);
                DateTime _startTime = DateTime(
                    _currentTime.year, _currentTime.month, _currentTime.day, _start.hour, _start.minute, _start.second);
                DateTime _endTime = DateTime(
                    _currentTime.year, _currentTime.month, _currentTime.day, _end.hour, _end.minute, _end.second);
                if (_endTime.isBefore(_startTime)) {
                  _endTime = _endTime.add(Duration(days: 1));
                }
                bool _isAvailable = _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);
                print('--from poinst:${widget.fromPoints}');

                CartModel _cartModel = CartModel(
                    widget.fromPoints == false ? price : 0.0,
                    widget.fromPoints ? double.parse(widget.product.loyaltyPoints) : 0.0,
                    priceWithDiscount,
                    List.from(selectedVariations),
                    widget.fromPoints == false
                        ? (price -
                            PriceConverter.convertWithDiscount(
                                context, price, widget.product.discount, widget.product.discountType))
                        : 0,
                    productProvider.quantity,
                    _specilInstructionController.text ?? '',
                    widget.fromPoints == false
                        ? price -
                            PriceConverter.convertWithDiscount(
                                context, price, widget.product.tax, widget.product.taxType)
                        : 0,
                    _addOnIdList,
                    widget.product,
                    false,
                    widget.fromPoints);

                _cartIndex = _cartProvider.isExistInCart(widget.product.id, [...selectedVariations]);
                print('is exit : $_cartIndex');
                print('is null : ${productProvider.relatedProducts != null}');

                double priceWithQuantity = priceWithDiscount * productProvider.quantity;
                double priceWithAddons = priceWithQuantity + addonsCost;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ResponsiveHelper.isMobile(context)
                        ? Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 5,
                            width: 80,
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                          )
                        : SizedBox(),
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
                                //Product
                                _productView(
                                    context, _startingPrice, _endingPrice, price, priceWithDiscount, _cartModel),
                                SizedBox(
                                  height: 5,
                                ),
                                _description(context),
                                TitleWidget(
                                  title: 'Special Instructions',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  hintText: 'Instructions..',
                                  isShowBorder: true,
                                  isBorderStyle: true,
                                  controller: _specilInstructionController,
                                  onChanged: (v) {
                                    print('===vlue:${v}');
                                  },
                                  inputType: TextInputType.emailAddress,
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                widget.product.variations.isNotEmpty
                                    ? _variationView(productProvider, widget.product.variations)
                                    : SizedBox.shrink(),
                                // widget.product.removalOptions.isNotEmpty?      _removalView(productProvider, variationType):SizedBox.shrink(),
                                widget.product.choiceOptions.length > 0
                                    ? SizedBox(height: Dimensions.PADDING_SIZE_LARGE)
                                    : SizedBox(),
                                widget.product.isRecommended == '1'
                                    ? Column(
                                        children: [
                                          productProvider.recommendedSidesList != null &&
                                                  productProvider.recommendedSidesList.length > 0
                                              ? ResponsiveHelper.isDesktop(context)
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                          child: Text('Recommended Sides',
                                                              style: rubikRegular.copyWith(
                                                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE)),
                                                        ),
                                                      ],
                                                    )
                                                  : TitleWidget(
                                                      title: 'Recommended Sides',
                                                    )
                                              : SizedBox(),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          productProvider.isLoading
                                              ? Center(
                                                  child: CircularProgressIndicator(
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                                ))
                                              : productProvider.recommendedSidesList != null &&
                                                      productProvider.recommendedSidesList.length > 0
                                                  ? ProductView(
                                                      productType: ProductType.RECOMMENDED_SIDES,
                                                      isFromCart: true,
                                                      isFromCartSheet: true,
                                                    )
                                                  : SizedBox(),

                                          // Order type
                                          // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                          productProvider.recommendedBeveragesList != null &&
                                                  productProvider.recommendedBeveragesList.length > 0
                                              ? ResponsiveHelper.isDesktop(context)
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                          child: Text('Recommended Beverages',
                                                              style: rubikRegular.copyWith(
                                                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE)),
                                                        ),
                                                      ],
                                                    )
                                                  : TitleWidget(
                                                      title: 'Recommended Beverages',
                                                    )
                                              : SizedBox(),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          productProvider.isLoading
                                              ? Center(
                                                  child: CircularProgressIndicator(
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                                ))
                                              : productProvider.recommendedBeveragesList != null &&
                                                      productProvider.recommendedBeveragesList.length > 0
                                                  ? ProductView(
                                                      productType: ProductType.RECOMMENDED_BEVERAGES,
                                                      isFromCart: true,
                                                      isFromCartSheet: true,
                                                    )
                                                  : SizedBox(),
                                        ],
                                      )
                                    : SizedBox.shrink(),

                                // SizedBox(
                                //   height: 220,
                                //   child: ListView.separated(
                                //     itemCount: productProvider
                                //         .recommendedBeveragesList.length,
                                //     itemBuilder: (context, index) {
                                //       var product=productProvider
                                //           .recommendedBeveragesList[index];
                                //       return Padding(
                                //         padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                                //         child: InkWell(
                                //           onTap: (){
                                //             if(product.name=='Soft Drinks'){
                                //               print('==soft drink');
                                //               _showDialog(product,productProvider);
                                //             }
                                //
                                //
                                //             if(productProvider.checkedItems.contains(productProvider
                                //                 .recommendedBeveragesList[index].id)){
                                //               productProvider.checkedItems.remove(productProvider
                                //                   .recommendedBeveragesList[index].id);
                                //               var cinde=_cartProvider.cartList.indexWhere((element) => element.product.id==product.id);
                                //
                                //
                                //               Provider.of<CartProvider>(
                                //                   context,
                                //                   listen: false)
                                //                   .removeFromCart(
                                //                   cinde);
                                //
                                //               setState(() {
                                //
                                //               });
                                //             }else{
                                //               productProvider.checkedItems.add(productProvider
                                //                   .recommendedBeveragesList[index].id);
                                //               setState(() {
                                //
                                //               });
                                //
                                //               if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()){
                                //                 debugPrint(
                                //                     '==cehck listid:${product.choiceOptions
                                //                         .length}');
                                //
                                //                   if (product.choiceOptions
                                //                       .length !=
                                //                       0) {
                                //                     List<double> _priceList =
                                //                     [];
                                //                     product.variations.forEach(
                                //                             (variation) =>
                                //                             _priceList.add(
                                //                                 variation
                                //                                     .price));
                                //                     _priceList.sort((a, b) =>
                                //                         a.compareTo(b));
                                //                     _startingPrice =
                                //                     _priceList[0];
                                //                     if (_priceList[0] <
                                //                         _priceList[
                                //                         _priceList.length -
                                //                             1]) {
                                //                       _endingPrice = _priceList[
                                //                       _priceList.length -
                                //                           1];
                                //                     }
                                //                   } else {
                                //                     _startingPrice =
                                //                         product.price;
                                //                   }
                                //
                                //                   List<String> _variationList =
                                //                   [];
                                //                   for (int index = 0;
                                //                   index <
                                //                       product.choiceOptions
                                //                           .length;
                                //                   index++) {
                                //                     print('===index:${index}');
                                //                     _variationList.add(product
                                //                         .choiceOptions[index]
                                //                         .options[productProvider
                                //                         .variationIndex[
                                //                     index]]
                                //                         .replaceAll(' ', ''));
                                //                   }
                                //                   String variationType = '';
                                //                   bool isFirst = true;
                                //                   _variationList
                                //                       .forEach((variation) {
                                //                     if (isFirst) {
                                //                       variationType =
                                //                       '$variationType$variation';
                                //                       isFirst = false;
                                //                     } else {
                                //                       variationType =
                                //                       '$variationType-$variation';
                                //                     }
                                //                   });
                                //
                                //                   double price = product.price;
                                //                   for (Variation variation
                                //                   in product.variations) {
                                //                     if (variation.type ==
                                //                         variationType) {
                                //                       price = variation.price;
                                //                       _variation = variation;
                                //                       break;
                                //                     }
                                //                   }
                                //                   double priceWithDiscount =
                                //                   PriceConverter
                                //                       .convertWithDiscount(
                                //                       context,
                                //                       price,
                                //                       product.discount,
                                //                       product
                                //                           .discountType);
                                //                   double addonsCost = 0;
                                //                   List<AddOn> _addOnIdList = [];
                                //
                                //
                                //                   DateTime _currentTime =
                                //                       Provider.of<SplashProvider>(
                                //                           context,
                                //                           listen: false)
                                //                           .currentTime;
                                //                   DateTime _start = DateFormat(
                                //                       'hh:mm:ss')
                                //                       .parse(product
                                //                       .availableTimeStarts);
                                //                   DateTime _end = DateFormat(
                                //                       'hh:mm:ss')
                                //                       .parse(product
                                //                       .availableTimeEnds);
                                //                   DateTime _startTime =
                                //                   DateTime(
                                //                       _currentTime.year,
                                //                       _currentTime.month,
                                //                       _currentTime.day,
                                //                       _start.hour,
                                //                       _start.minute,
                                //                       _start.second);
                                //                   DateTime _endTime = DateTime(
                                //                       _currentTime.year,
                                //                       _currentTime.month,
                                //                       _currentTime.day,
                                //                       _end.hour,
                                //                       _end.minute,
                                //                       _end.second);
                                //                   if (_endTime
                                //                       .isBefore(_startTime)) {
                                //                     _endTime = _endTime
                                //                         .add(Duration(days: 1));
                                //                   }
                                //                   bool _isAvailable =
                                //                       _currentTime.isAfter(
                                //                           _startTime) &&
                                //                           _currentTime.isBefore(
                                //                               _endTime);
                                //
                                //
                                //                   CartModel _cartModel = CartModel(
                                //                       price,
                                //                       0.0,
                                //                       priceWithDiscount,
                                //                       [_variation],
                                //                       (price -
                                //                           PriceConverter
                                //                               .convertWithDiscount(
                                //                               context,
                                //                               price,
                                //                               product
                                //                                   .discount,
                                //                               product
                                //                                   .discountType)),
                                //                       1,
                                //                       price -
                                //                           PriceConverter
                                //                               .convertWithDiscount(
                                //                               context,
                                //                               price,
                                //                               product.tax,
                                //                               product
                                //                                   .taxType),
                                //                       _addOnIdList,
                                //                       product,
                                //                       false,false);
                                //
                                //                   _cartProvider.addToCart(
                                //                       _cartModel, _cartIndex);
                                //
                                //               }else{
                                //                 appToast(text: 'You need to login first');
                                //               }
                                //             }
                                //
                                //           },
                                //           child: Row(
                                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //             children: [
                                //               Row(
                                //                 children: [
                                //                   InkWell(
                                //                     onTap: (){
                                //                       // productProvider.checkedItems.add(productProvider
                                //                       //     .recommendedBeveragesList[index].id);
                                //                       // setState(() {
                                //                       //
                                //                       // });
                                //
                                //                     },
                                //                     child: Container(
                                //                       decoration: BoxDecoration(
                                //
                                //                           color: productProvider.checkedItems.contains(productProvider
                                //                               .recommendedBeveragesList[index].id)? Theme.of(context).primaryColor: Colors.transparent,
                                //                           borderRadius: BorderRadius.circular(5),
                                //                           border: Border.all(
                                //                             color:productProvider.checkedItems.contains(productProvider
                                //                                 .recommendedBeveragesList[index].id)? Theme.of(context).primaryColor: Colors.black,
                                //
                                //                           )
                                //                       ),
                                //                       child: Icon(Icons.done,color: Colors.white,size: 15,),
                                //                     ),
                                //                   ),
                                //                   SizedBox(width: 10,),
                                //                   Text(productProvider.recommendedBeveragesList[index].name,
                                //                       style: rubikRegular.copyWith(
                                //                           fontSize: Dimensions.FONT_SIZE_LARGE)),
                                //                 ],
                                //               ),
                                //
                                //               Text(
                                //                   '${PriceConverter.convertPrice(context, productProvider.recommendedBeveragesList[index].price)}',
                                //                   style: rubikRegular.copyWith(
                                //                       fontSize: Dimensions
                                //                           .FONT_SIZE_LARGE)),
                                //             ],
                                //           ),
                                //         ),
                                //       );
                                //
                                //
                                //     },
                                //     separatorBuilder: (context, ind) {
                                //       return Divider();
                                //     },
                                //   ),
                                // )
                                // Addons view
                                // _addonsView(context, productProvider),

                                Row(children: [
                                  Text('${getTranslated('total_amount', context)}:',
                                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(PriceConverter.convertPrice(context, priceWithAddons),
                                      style: rubikBold.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                      )),
                                ]),
                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                //Add to cart Button
                                // if (ResponsiveHelper.isDesktop(context))
                                //   _cartButton(
                                //       _isAvailable, context, _cartModel),
                              ]),
                        ),
                      ),
                    ),
                    // if (ResponsiveHelper.isDesktop(context))
                    _cartButton(_isAvailable, context, _cartModel),
                  ],
                );
              },
            ),
          ),
          ResponsiveHelper.isMobile(context)
              ? SizedBox()
              : Positioned(
                  right: 10,
                  top: 5,
                  child: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.close)),
                ),
        ],
      );
    });
  }

  double _variationPrice(List<Variation> variationsIn) {
    double extra = 0;
    for (Variation variation in variationsIn) {
      if (variation != null) {
        for (Value value in variation.values) {
          extra += double.parse(value.optionPrice);
        }
      }
    }
    return extra;
  }

  Widget _addonsView(BuildContext context, ProductProvider productProvider) {
    return widget.product.addOns.length > 0
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(getTranslated('addons', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                childAspectRatio: (1 / 1.1),
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.product.addOns.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (!productProvider.addOnActiveList[index]) {
                      productProvider.addAddOn(true, index);
                    } else if (productProvider.addOnQtyList[index] == 1) {
                      productProvider.addAddOn(false, index);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: productProvider.addOnActiveList[index] ? 2 : 20),
                    decoration: BoxDecoration(
                      color: productProvider.addOnActiveList[index]
                          ? Theme.of(context).primaryColor
                          : ColorResources.BACKGROUND_COLOR,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: productProvider.addOnActiveList[index]
                          ? [
                              BoxShadow(
                                color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                                blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                                spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                              )
                            ]
                          : null,
                    ),
                    child: Column(children: [
                      Expanded(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(widget.product.addOns[index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: rubikMedium.copyWith(
                              color: productProvider.addOnActiveList[index]
                                  ? ColorResources.COLOR_WHITE
                                  : ColorResources.COLOR_BLACK,
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                            )),
                        SizedBox(height: 5),
                        Text(
                          PriceConverter.convertPrice(context, widget.product.addOns[index].price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: rubikRegular.copyWith(
                              color: productProvider.addOnActiveList[index]
                                  ? ColorResources.COLOR_WHITE
                                  : ColorResources.COLOR_BLACK,
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                        ),
                      ])),
                      productProvider.addOnActiveList[index]
                          ? Container(
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5), color: Theme.of(context).cardColor),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (productProvider.addOnQtyList[index] > 1) {
                                        productProvider.setAddOnQuantity(false, index);
                                      } else {
                                        productProvider.addAddOn(false, index);
                                      }
                                    },
                                    child: Center(child: Icon(Icons.remove, size: 15)),
                                  ),
                                ),
                                Text(productProvider.addOnQtyList[index].toString(),
                                    style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => productProvider.setAddOnQuantity(true, index),
                                    child: Center(child: Icon(Icons.add, size: 15)),
                                  ),
                                ),
                              ]),
                            )
                          : SizedBox(),
                    ]),
                  ),
                );
              },
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          ])
        : SizedBox();
  }

  Widget _quantityView(
    BuildContext context,
    CartModel _cartModel,
  ) {
    return Row(children: [
      Text(getTranslated('quantity', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      Expanded(child: SizedBox()),
      _quantityButton(context, _cartModel),
    ]);
  }

  Widget _variationView(ProductProvider productProvider, List<Variation> variations) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: variations.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "${variations[index].name}${variations[index].required ? "  (REQUIRED)" : ""}",
            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
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
      physics: NeverScrollableScrollPhysics(),
      itemCount: variation.values.length,
      itemBuilder: (context, i) {
        return RadioListTile<Variation>(
          value: variation.copyWith(values: [variation.values[i]]),
          groupValue: selectedVariations[x],
          toggleable: true,
          onChanged: (ind) {
            selectedVariations[x] = ind;
            setState(() {});
          },
          title: Text(parseVariationPrice(
            variation.values[i].label,
            double.parse(variation.values[i].optionPrice),
          )),
        );
      },
    );
  }

  Widget variationChecklist(Variation variation, int x) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: variation.values.length,
      itemBuilder: (context, i) {
        return CheckboxListTile(
          value: selectedVariations[x]?.values?.contains(variation.values[i]) ?? false,
          onChanged: (selected) {
            final currentVariation = selectedVariations[x];
            if (selected && currentVariation == null) {
              selectedVariations[x] = variation.copyWith(values: [variation.values[i]]);
            } else if (selected) {
              selectedVariations[x].values.add(variation.values[i]);
            } else if (!selected && selectedVariations[x].values.contains(variation.values[i])) {
              selectedVariations[x].values.remove(variation.values[i]);
              if (selectedVariations[x].values.isEmpty) {
                selectedVariations[x] = null;
              }
            }
            setState(() {});
          },
          title: Text(parseVariationPrice(
            variation.values[i].label,
            double.parse(variation.values[i].optionPrice),
          )),
        );
      },
    );
  }

  String parseVariationPrice(String label, double optionPrice) {
    return "${label.trim()}   ${optionPrice == 0 ? "" : ("${optionPrice > 0 ? "+" : ""}$optionPrice")}";
  }

  Widget _removalView(ProductProvider productProvider, String variationType) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.product.removalOptions.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.product.removalOptions[index].title,
              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          ListView(
            shrinkWrap: true,
            children: widget.product.choiceOptions[index].options.map((String key) {
              return new CheckboxListTile(
                title: new Text(key),
                value: values[key],
                onChanged: (value) {
                  setState(() {
                    values[key] = value;
                  });
                },
              );
            }).toList(),
          ),
        ]);
      },
    );
  }

  Widget _description(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('description', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      Align(
        alignment: Alignment.topLeft,
        child: ReadMoreText(
          widget.product.description ?? '',
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
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
    ]);
  }

  Widget _cartButton(bool _isAvailable, BuildContext context, CartModel _cartModel) {
    _cartModel.variation.removeWhere((element) => element == null);
    return Column(children: [
      _isAvailable
          ? SizedBox()
          : Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
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
                  '${getTranslated('available_will_be', context)} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts, context)} '
                  '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds, context)}',
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

                  Provider.of<ProductProvider>(context, listen: false).updateLoyaltyPoints(_cartModel.points, context);
                  setState(() {});
                }
                Navigator.pop(context);
                Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel, _cartIndex);
              } else {
                Navigator.pushNamed(context, Routes.getLoginRoute());

                // showCustomSnackBar(
                //     getTranslated('now_you_are_in_guest_mode', context), context);
                // debugPrint('need to login first');
              }
            } else {
              showCustomSnackBar('Select the required variant(s)', context);
            }
          }),
    ]);
  }

  bool requiredVariantsSelected() {
    bool returnal = true;
    for (int i = 0; i < widget.product.variations.length; i++) {
      if (widget.product.variations[i].required && selectedVariations[i] == null) {
        returnal = false;
        break;
      }
    }
    return returnal;
  }

  Widget _productView(
    BuildContext context,
    double _startingPrice,
    double _endingPrice,
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
              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${widget.product.image}',
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
      SizedBox(
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
              // if (!ResponsiveHelper.isMobile(context)) WishButton(product: widget.product),
            ],
          ),
          // SizedBox(height: 10),
          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     RatingBar(rating: widget.product.rating.length > 0 ? double.parse(widget.product.rating[0].average) : 0.0, size: 15),
          //     widget.product.productType != null ? VegTagView(product: widget.product) : SizedBox(),
          //   ],
          // ),
          SizedBox(height: 10),

          // Row( mainAxisSize: MainAxisSize.min, children: [
          //   Expanded(
          //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,  children: [
          //       Text(
          //         widget.product.description,
          //         maxLines: 2,
          //         overflow: TextOverflow.ellipsis,
          //         style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,fontWeight: FontWeight.w400),
          //       ),
          //
          //
          //
          //
          //     ]),
          //   ),
          //
          // ]),
          //
          // SizedBox(height: 10),

          Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                FittedBox(
                  child: Text(
                    '${PriceConverter.convertPrice(context, _startingPrice + _variationPrice(selectedVariations), discount: widget.product.discount, discountType: widget.product.discountType)}' +
                        '${_endingPrice != null ? '${PriceConverter.convertPrice(
                              context,
                              _endingPrice,
                              discount: widget.product.discount,
                              discountType: widget.product.discountType,
                            ) == "" ? "" : " - " + PriceConverter.convertPrice(
                              context,
                              _endingPrice,
                              discount: widget.product.discount,
                              discountType: widget.product.discountType,
                            )}' : ''}',
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
                            '${PriceConverter.convertPrice(context, _startingPrice)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                            style: rubikMedium.copyWith(
                                color: ColorResources.COLOR_GREY,
                                decoration: TextDecoration.lineThrough,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ),
                      )
                    : SizedBox(),
              ]),
            ),
            // if (ResponsiveHelper.isMobile(context)) WishButton(product: widget.product),
          ]),
          if (!ResponsiveHelper.isMobile(context)) _quantityView(context, cartModel)
        ]),
      ),
    ]);
  }

  Widget _quantityButton(BuildContext context, CartModel _cartModel) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        InkWell(
          onTap: () => productProvider.quantity > 1 ? productProvider.setQuantity(false) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.remove, size: 20),
          ),
        ),
        Text(productProvider.quantity.toString(),
            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
        InkWell(
          onTap: () => productProvider.setQuantity(true),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.add, size: 20),
          ),
        ),
      ]),
    );
  }
}

class VegTagView extends StatelessWidget {
  final Product product;

  const VegTagView({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(blurRadius: 5, color: Theme.of(context).backgroundColor.withOpacity(0.05))],
      ),
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Image.asset(
                Images.getImageUrl(
                  '${product.productType}',
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Text(
              getTranslated('${product.productType}', context),
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          ],
        ),
      ),
    );
  }
}
