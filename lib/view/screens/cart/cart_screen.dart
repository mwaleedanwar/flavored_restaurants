// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/provider_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/tip_controller.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/product_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/product_type.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_divider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/no_data_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/cart/widget/cart_product_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/cart/widget/delivery_option_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Value;
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/address_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/title_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/address/widget/permission_dialog.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/tip_view/tip_view.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController controller = TextEditingController();
  bool isNotTip = false;
  final tipController = Get.put(TipController());

  @override
  void initState() {
    super.initState();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType(
      Provider.of<SplashProvider>(context, listen: false).configModel!.homeDelivery ? 'delivery' : 'take_away',
      notify: false,
    );
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: _scaffoldKey,
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
            : CustomAppBar(
                context: context,
                title: getTranslated('my_cart', context),
                isBackButtonExist: !ResponsiveHelper.isMobile(context)),
        body: Consumer4<SplashProvider, OrderProvider, ProductProvider, CartProvider>(
            builder: (context, splash, order, productProvider, cart, _) {
          double deliveryCharge = 0;
          double taxFee = 0.0;

          (order.orderType == 'delivery' && splash.configModel!.deliveryManagement?.status == 0)
              ? deliveryCharge = splash.configModel!.deliveryCharge
              : deliveryCharge = 0;
          List<List<AddOns>> addOnsList = [];
          List<bool> availableList = [];
          double itemPrice = 0;
          double discount = 0;
          double tax = 0;
          double addOns = 0;
          for (var cartModel in cart.cartList) {
            List<AddOns> addOnList = [];
            for (var addOnId in cartModel.addOnIds ?? []) {
              for (AddOns addOns in cartModel.product?.addOns ?? []) {
                if (addOns.id == addOnId.id) {
                  addOnList.add(addOns);
                  break;
                }
              }
            }
            addOnsList.add(addOnList);

            availableList.add(DateConverter.isAvailable(
                cartModel.product!.availableTimeStarts!, cartModel.product!.availableTimeEnds!, context));

            for (int index = 0; index < addOnList.length; index++) {
              addOns = addOns + (addOnList[index].price * cartModel.addOnIds![index].quantity);
            }
            itemPrice = itemPrice + (cartModel.price * cartModel.quantity);
            discount = discount + (cartModel.discountAmount * cartModel.quantity);
            tax = tax + (cartModel.taxAmount * cartModel.quantity);
          }
          for (var element in cart.cateringList) {
            itemPrice = itemPrice + ((element.discountAmount ?? 1) * element.quantity);
          }
          for (var element in cart.happyHoursList) {
            itemPrice = itemPrice + (element.discountAmount * element.quantity);
          }
          for (var element in cart.dealsList) {
            itemPrice = itemPrice + (element.price * element.quantity);
          }
          for (var element in cart.cartList) {
            for (var variation in element.variation ?? []) {
              if (variation.values != null) {
                for (var value in variation.values) {
                  itemPrice += double.parse(value.optionPrice) * element.quantity;
                }
              }
            }
          }
          double subTotal = itemPrice + tax + addOns;
          double total = subTotal - discount - Provider.of<CouponProvider>(context).discount + deliveryCharge;
          debugPrint('==tax fee:${splash.configModel!.taxFee}');

          taxFee = (splash.configModel!.taxFee / 100) * total;
          cart.taxFee = taxFee;

          cart.deliveryCharge = deliveryCharge;

          double orderAmount = itemPrice + addOns;

          bool kmWiseCharge = splash.configModel!.deliveryManagement?.status == 1;
          total = total + taxFee;

          return cart.cartList.isNotEmpty ||
                  cart.cateringList.isNotEmpty ||
                  cart.happyHoursList.isNotEmpty ||
                  cart.dealsList.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: !ResponsiveHelper.isDesktop(context) && height < 600
                                            ? height
                                            : height - 400),
                                    child: SizedBox(
                                      width: 1170,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // DESKTOP VIEW
                                          if (ResponsiveHelper.isDesktop(context))
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: Dimensions.PADDING_SIZE_LARGE,
                                                  horizontal: Dimensions.PADDING_SIZE_LARGE,
                                                ),
                                                child: Wrap(
                                                  children: [
                                                    CartListWidget(
                                                      cart: cart,
                                                      addOns: addOnsList,
                                                      availableList: availableList,
                                                    ),
                                                    CartListWidget(
                                                      cart: cart,
                                                      isFromCatering: true,
                                                      addOns: addOnsList,
                                                      availableList: availableList,
                                                    ),
                                                    CartListWidget(
                                                      cart: cart,
                                                      isFromHappyHour: true,
                                                      addOns: addOnsList,
                                                      availableList: availableList,
                                                    ),
                                                    CartListWidget(
                                                      cart: cart,
                                                      isDeal: true,
                                                      addOns: addOnsList,
                                                      availableList: availableList,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (ResponsiveHelper.isDesktop(context))
                                            const SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                                          Expanded(
                                            child: Container(
                                              decoration: ResponsiveHelper.isDesktop(context)
                                                  ? BoxDecoration(
                                                      color: Theme.of(context).cardColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                          BoxShadow(
                                                            color: ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
                                                            blurRadius: 10,
                                                          )
                                                        ])
                                                  : null,
                                              margin: ResponsiveHelper.isDesktop(context)
                                                  ? const EdgeInsets.symmetric(
                                                      horizontal: Dimensions.PADDING_SIZE_SMALL,
                                                      vertical: Dimensions.PADDING_SIZE_LARGE)
                                                  : const EdgeInsets.all(0),
                                              padding: ResponsiveHelper.isDesktop(context)
                                                  ? const EdgeInsets.symmetric(
                                                      horizontal: Dimensions.PADDING_SIZE_LARGE,
                                                      vertical: Dimensions.PADDING_SIZE_LARGE)
                                                  : const EdgeInsets.all(0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if (!ResponsiveHelper.isDesktop(context)) ...[
                                                    CartListWidget(
                                                      cart: cart,
                                                      addOns: addOnsList,
                                                      availableList: availableList,
                                                    ),
                                                    CartListWidget(
                                                      cart: cart,
                                                      isFromCatering: true,
                                                      addOns: addOnsList,
                                                      availableList: availableList,
                                                    ),
                                                    CartListWidget(
                                                      cart: cart,
                                                      isFromHappyHour: true,
                                                      addOns: addOnsList,
                                                      availableList: availableList,
                                                    ),
                                                    CartListWidget(
                                                      cart: cart,
                                                      isDeal: true,
                                                      addOns: addOnsList,
                                                      availableList: availableList,
                                                    ),
                                                  ],
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ResponsiveHelper.isDesktop(context)
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 20),
                                                              child: Text(
                                                                'People also like',
                                                                style: rubikMedium.copyWith(
                                                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : const TitleWidget(
                                                          title: 'People also like',
                                                        ),
                                                  //PEOPLE ALSO LIKE
                                                  const ProductView(
                                                    productType: ProductType.POPULAR_PRODUCT,
                                                    isFromCart: true,
                                                  ),
                                                  // Order type
                                                  const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                                  //PROMO CODE FIELD
                                                  Consumer<CouponProvider>(
                                                    builder: (context, coupon, child) {
                                                      return Row(children: [
                                                        Expanded(
                                                          child: TextField(
                                                            controller: _couponController,
                                                            style: rubikRegular,
                                                            decoration: InputDecoration(
                                                              hintText: getTranslated('enter_promo_code', context),
                                                              hintStyle: rubikRegular.copyWith(
                                                                  color: ColorResources.getHintColor(context)),
                                                              isDense: true,
                                                              filled: true,
                                                              enabled: coupon.discount == 0,
                                                              fillColor: Theme.of(context).cardColor,
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.horizontal(
                                                                  left: Radius.circular(
                                                                      Provider.of<LocalizationProvider>(context,
                                                                                  listen: false)
                                                                              .isLtr
                                                                          ? 10
                                                                          : 0),
                                                                  right: Radius.circular(
                                                                      Provider.of<LocalizationProvider>(context,
                                                                                  listen: false)
                                                                              .isLtr
                                                                          ? 0
                                                                          : 10),
                                                                ),
                                                                borderSide: BorderSide.none,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (_couponController.text.isNotEmpty &&
                                                                !coupon.isLoading) {
                                                              if (coupon.discount < 1) {
                                                                coupon
                                                                    .applyCoupon(_couponController.text, total, context)
                                                                    .then((discount) {
                                                                  if (discount > 0) {
                                                                    showCustomSnackBar(
                                                                        'You got ${PriceConverter.convertPrice(context, discount)} discount',
                                                                        context,
                                                                        isError: false);
                                                                  } else {
                                                                    showCustomSnackBar(
                                                                        getTranslated('invalid_code_or', context),
                                                                        context,
                                                                        isError: true);
                                                                  }
                                                                });
                                                              } else {
                                                                coupon.removeCouponData(true);
                                                              }
                                                            } else if (_couponController.text.isEmpty) {
                                                              showCustomSnackBar(
                                                                  getTranslated('enter_a_Coupon_code', context),
                                                                  context);
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 50,
                                                            width: 100,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context).primaryColor,
                                                              borderRadius: BorderRadius.horizontal(
                                                                left: Radius.circular(Provider.of<LocalizationProvider>(
                                                                            context,
                                                                            listen: false)
                                                                        .isLtr
                                                                    ? 0
                                                                    : 10),
                                                                right: Radius.circular(
                                                                    Provider.of<LocalizationProvider>(context,
                                                                                listen: false)
                                                                            .isLtr
                                                                        ? 10
                                                                        : 0),
                                                              ),
                                                            ),
                                                            child: coupon.discount <= 0
                                                                ? !coupon.isLoading
                                                                    ? Text(
                                                                        getTranslated('apply', context),
                                                                        style:
                                                                            rubikMedium.copyWith(color: Colors.white),
                                                                      )
                                                                    : const CircularProgressIndicator(
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(Colors.white))
                                                                : const Icon(Icons.clear, color: Colors.white),
                                                          ),
                                                        ),
                                                      ]);
                                                    },
                                                  ),
                                                  const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                                  TipView(
                                                    isFromCart: true,
                                                    orderAmount: total,
                                                  ),
                                                  Text(getTranslated('delivery_option', context),
                                                      style:
                                                          rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                  splash.configModel!.homeDelivery
                                                      ? Row(
                                                          children: [
                                                            splash.configModel!.homeDelivery
                                                                ? DeliveryOptionButton(
                                                                    value: 'delivery',
                                                                    title: getTranslated('delivery', context),
                                                                    kmWiseFee: kmWiseCharge)
                                                                : Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        left: Dimensions.PADDING_SIZE_SMALL,
                                                                        top: Dimensions.PADDING_SIZE_LARGE),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.remove_circle_outline_sharp,
                                                                          color: Theme.of(context).hintColor,
                                                                        ),
                                                                        const SizedBox(
                                                                            width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                                        Text(
                                                                            getTranslated(
                                                                                'home_delivery_not_available', context),
                                                                            style: TextStyle(
                                                                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                                                color: Theme.of(context).primaryColor)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            splash.configModel!.selfPickup
                                                                ? DeliveryOptionButton(
                                                                    value: 'take_away',
                                                                    title: 'Pickup',
                                                                    kmWiseFee: kmWiseCharge,
                                                                  )
                                                                : Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        left: Dimensions.PADDING_SIZE_SMALL,
                                                                        bottom: Dimensions.PADDING_SIZE_LARGE),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.remove_circle_outline_sharp,
                                                                          color: Theme.of(context).hintColor,
                                                                        ),
                                                                        const SizedBox(
                                                                            width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                                        Text(
                                                                            getTranslated(
                                                                                'self_pickup_not_available', context),
                                                                            style: TextStyle(
                                                                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                                                color: Theme.of(context).primaryColor)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                          ],
                                                        )
                                                      : Column(
                                                          children: [
                                                            splash.configModel!.homeDelivery
                                                                ? DeliveryOptionButton(
                                                                    value: 'delivery',
                                                                    title: getTranslated('delivery', context),
                                                                    kmWiseFee: kmWiseCharge)
                                                                : Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        left: Dimensions.PADDING_SIZE_SMALL,
                                                                        top: Dimensions.PADDING_SIZE_LARGE),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.remove_circle_outline_sharp,
                                                                          color: Theme.of(context).hintColor,
                                                                        ),
                                                                        const SizedBox(
                                                                            width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                                        Text(
                                                                            getTranslated(
                                                                                'home_delivery_not_available', context),
                                                                            style: TextStyle(
                                                                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                                                color: Theme.of(context).primaryColor)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            splash.configModel!.selfPickup
                                                                ? DeliveryOptionButton(
                                                                    value: 'take_away',
                                                                    title: getTranslated('take_away', context),
                                                                    kmWiseFee: kmWiseCharge)
                                                                : Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        left: Dimensions.PADDING_SIZE_SMALL,
                                                                        bottom: Dimensions.PADDING_SIZE_LARGE),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.remove_circle_outline_sharp,
                                                                          color: Theme.of(context).hintColor,
                                                                        ),
                                                                        const SizedBox(
                                                                            width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                                        Text(
                                                                            getTranslated(
                                                                                'self_pickup_not_available', context),
                                                                            style: TextStyle(
                                                                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                                                color: Theme.of(context).primaryColor)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),

                                                  // Total
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        getTranslated('items_price', context),
                                                        style: rubikRegular.copyWith(
                                                          fontSize: Dimensions.FONT_SIZE_LARGE,
                                                        ),
                                                      ),
                                                      Text(
                                                        PriceConverter.convertPrice(context, itemPrice),
                                                        style: rubikRegular.copyWith(
                                                          fontSize: Dimensions.FONT_SIZE_LARGE,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),

                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    Text('Fee & Estimated Tax',
                                                        style: rubikRegular.copyWith(
                                                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                    Text(' ${PriceConverter.convertPrice(context, taxFee)}',
                                                        style: rubikRegular.copyWith(
                                                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                  ]),
                                                  const SizedBox(height: 10),
                                                  Obx(
                                                    () => tipController.isNotTip.value
                                                        ? const SizedBox()
                                                        : Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text(
                                                                  'Staff Tip',
                                                                  style: rubikRegular.copyWith(
                                                                      fontSize: Dimensions.FONT_SIZE_LARGE),
                                                                ),
                                                                Obx(
                                                                  () => Text(
                                                                    '\$${tipController.tip.value.toStringAsFixed(2)}',
                                                                    style: rubikRegular.copyWith(
                                                                        fontSize: Dimensions.FONT_SIZE_LARGE),
                                                                  ),
                                                                )
                                                              ]).marginOnly(bottom: 10),
                                                  ),
                                                  kmWiseCharge
                                                      ? const SizedBox()
                                                      : Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                              Text(
                                                                getTranslated('delivery_fee', context),
                                                                style: rubikRegular.copyWith(
                                                                    fontSize: Dimensions.FONT_SIZE_LARGE),
                                                              ),
                                                              Text(
                                                                deliveryCharge == 0
                                                                    ? '\$0.00'
                                                                    : PriceConverter.convertPrice(
                                                                        context, deliveryCharge),
                                                                style: rubikRegular.copyWith(
                                                                    fontSize: Dimensions.FONT_SIZE_LARGE),
                                                              ),
                                                            ]),

                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                                                    child: CustomDivider(),
                                                  ),

                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    Text(
                                                        getTranslated(
                                                            kmWiseCharge ? 'subtotal' : 'total_amount', context),
                                                        style: rubikMedium.copyWith(
                                                          fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                                          color: Theme.of(context).primaryColor,
                                                        )),
                                                    Obx(
                                                      () => Text(
                                                        PriceConverter.convertPrice(context,
                                                            total + double.parse(tipController.tip.value.toString())),
                                                        style: rubikMedium.copyWith(
                                                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                                            color: Theme.of(context).primaryColor),
                                                      ),
                                                    )
                                                  ]),
                                                  if (ResponsiveHelper.isDesktop(context))
                                                    const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                                  if (ResponsiveHelper.isDesktop(context))
                                                    Container(
                                                      width: 1170,
                                                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                      child: CustomButton(
                                                        btnTxt: getTranslated('continue_checkout', context),
                                                        onTap: () {
                                                          if (orderAmount < splash.configModel!.minimumOrderValue) {
                                                            showCustomSnackBar(
                                                                'Minimum order amount is ${PriceConverter.convertPrice(context, splash.configModel!.minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, orderAmount)} in your cart, please add more item.',
                                                                context);
                                                          } else {
                                                            if ((Provider.of<LocationProvider>(context, listen: false)
                                                                            .addressList ??
                                                                        [])
                                                                    .isEmpty &&
                                                                Provider.of<OrderProvider>(context, listen: false)
                                                                        .orderType ==
                                                                    'delivery') {
                                                              debugPrint(
                                                                  '===order type1:${Provider.of<OrderProvider>(context, listen: false).orderType}');
                                                              _checkPermission(
                                                                  context,
                                                                  Routes.getAddAddressRoute(
                                                                      'cart', 'add', AddressModel(),
                                                                      amount: total +
                                                                          double.parse(
                                                                              tipController.tip.value.toString())));
                                                            } else {
                                                              debugPrint(
                                                                  '===order type:${Provider.of<OrderProvider>(context, listen: false).orderType}');
                                                              Navigator.pushNamed(
                                                                context,
                                                                Routes.getCheckoutRoute(
                                                                  total +
                                                                      double.parse(tipController.tip.value.toString()),
                                                                  'cart',
                                                                  Provider.of<OrderProvider>(context, listen: false)
                                                                      .orderType,
                                                                  Provider.of<CouponProvider>(context, listen: false)
                                                                      .code,
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!ResponsiveHelper.isDesktop(context))
                      Container(
                        width: 1170,
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: CustomButton(
                            btnTxt: getTranslated('continue_checkout', context),
                            onTap: () {
                              if (orderAmount < splash.configModel!.minimumOrderValue) {
                                showCustomSnackBar(
                                    'Minimum order amount is ${PriceConverter.convertPrice(context, splash.configModel!.minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, orderAmount)} in your cart, please add more item.',
                                    context);
                              } else {
                                Navigator.pushNamed(
                                    context,
                                    Routes.getCheckoutRoute(
                                      total + double.parse(tipController.tip.value.toString()),
                                      'cart',
                                      Provider.of<OrderProvider>(context, listen: false).orderType,
                                      Provider.of<CouponProvider>(context, listen: false).code,
                                    ));
                              }
                            }),
                      ),
                  ],
                )
              : const NoDataScreen(isCart: true);
        }));
  }

  void _checkPermission(BuildContext context, String navigateTo) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar(getTranslated('you_have_to_allow', context), context);
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => const PermissionDialog());
    } else {
      Navigator.pushNamed(context, navigateTo);
    }
  }
}

class CartListWidget extends StatelessWidget {
  final CartProvider cart;
  final List<List<AddOns>> addOns;
  final List<bool> availableList;
  final bool isFromCatering;
  final bool isFromHappyHour;
  final bool isDeal;

  const CartListWidget({
    super.key,
    required this.cart,
    required this.addOns,
    required this.availableList,
    this.isFromCatering = false,
    this.isFromHappyHour = false,
    this.isDeal = false,
  });

  @override
  Widget build(BuildContext context) {
    return isDeal
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cart.dealsList.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: ExpansionTile(
                  textColor: Theme.of(context).primaryColor,
                  iconColor: Theme.of(context).primaryColor,
                  childrenPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder_image,
                      height: 70,
                      width: 85,
                      fit: BoxFit.cover,
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.offerUrl}/${cart.dealsList[index].dealsDataModel!.image}',
                      imageErrorBuilder: (c, o, s) =>
                          Image.asset(Images.placeholder_image, height: 70, width: 85, fit: BoxFit.cover),
                    ),
                  ),
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cart.dealsList[index].dealsDataModel!.name,
                            style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 7),
                        Flexible(
                          child: Text(
                            PriceConverter.convertPrice(
                              context,
                              cart.dealsList[index].price,
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        ),
                      ]),
                  trailing: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface, borderRadius: BorderRadius.circular(5)),
                    child: Row(children: [
                      InkWell(
                        onTap: () {
                          Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                          if (cart.dealsList[index].quantity > 1) {
                            Provider.of<CartProvider>(context, listen: false).setQuantity(
                              isIncrement: false,
                              isCart: false,
                              isHappyHours: false,
                              isDeal: true,
                              dealCartModel: cart.dealsList[index],
                            );
                          } else {
                            Provider.of<CartProvider>(context, listen: false).removeFromCart(index,
                                isCatering: false, isCart: false, isDeal: true, isHappyHours: false);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.remove, size: 20),
                        ),
                      ),
                      Text(cart.dealsList[index].quantity.toString(),
                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                      InkWell(
                        onTap: () {
                          Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                          Provider.of<CartProvider>(context, listen: false).setQuantity(
                            isIncrement: true,
                            isCart: false,
                            isHappyHours: false,
                            isDeal: true,
                            dealCartModel: cart.dealsList[index],
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.add, size: 20),
                        ),
                      ),
                    ]),
                  ),
                  children: [
                    for (var deal in (cart.dealsList[index].dealsDataModel?.dealItems ?? []))
                      Container(
                        margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        child: Stack(children: [
                          const Positioned(
                            top: 0,
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Provider.of<ThemeProvider>(context).darkTheme
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder_image,
                                          height: 50,
                                          width: 65,
                                          fit: BoxFit.cover,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${deal.image}',
                                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,
                                              height: 50, width: 65, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(deal.name,
                                              style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 7),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'Quantity : ${deal.itemQuantity}',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                        ]),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ]),
                      )
                  ],
                ),
              );
            },
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: isFromCatering
                ? cart.cateringList.length
                : isFromHappyHour
                    ? cart.happyHoursList.length
                    : cart.cartList.length,
            itemBuilder: (context, index) {
              return isFromCatering
                  ? CartOfferWidget(
                      cartIndex: index,
                      cateringCartModel: cart.cateringList[index],
                    )
                  : isFromHappyHour
                      ? CartHappyHourWidget(
                          cartIndex: index,
                          happyHoursCartModel: cart.happyHoursList[index],
                        )
                      : CartProductWidget(
                          cart: isFromCatering ? null : cart.cartList[index],
                          cartIndex: index,
                          addOns: isFromCatering ? null : addOns[index],
                          isAvailable: availableList[index]);
            },
          );
  }
}
