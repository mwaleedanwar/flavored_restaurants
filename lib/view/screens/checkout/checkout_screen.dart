// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masked_text/masked_text.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/provider_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/tip_controller.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/place_order_body.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/config_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/userinfo_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/branch_button_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/not_logged_in_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/address/widget/location_search_dialog.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/checkout/widget/slot_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final double amount;
  final String orderType;
  final List<CartModel>? cartList;
  final bool fromCart;
  final String couponCode;

  const CheckoutScreen({
    super.key,
    required this.amount,
    required this.orderType,
    required this.fromCart,
    required this.couponCode,
    this.cartList,
  });

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final _noteController = TextEditingController();
  final _floorController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final controller = CardFormEditController();
  final cardNode = FocusNode();
  final _houseNode = FocusNode();
  final _floorNode = FocusNode();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneNumberFocus = FocusNode();

  bool _isCashOnDeliveryActive = false;
  bool _isLoggedIn = false;
  bool loading = true;
  bool canPop = true;
  bool takeAway = false;
  List<CartModel> _cartList = [];
  String _latitude = '';
  String _longitude = '';
  Branches? currentBranch;
  bool kmWiseCharge = false;

  @override
  void initState() {
    super.initState();
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    currentBranch = Provider.of<BranchProvider>(context, listen: false).getBranch(context);
    locationProvider.currentBranch = currentBranch;
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context).then((value) {
        if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
          UserInfoModel userInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
          _nameController.text = userInfoModel.fName ?? '';
          _phoneNumberController.text = userInfoModel.phone?.replaceAll('+1', '') ?? '';
          _emailController.text = userInfoModel.email ?? '';
        }
      });

      Provider.of<OrderProvider>(context, listen: false).initializeTimeSlot(context).then((value) {
        Provider.of<OrderProvider>(context, listen: false).sortTime();
      });
      if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel == null) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      } else {
        _nameController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.fName ?? '';
        _emailController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.email ?? '';
      }

      Provider.of<OrderProvider>(context, listen: false).clearPrevData();
      _isCashOnDeliveryActive =
          Provider.of<SplashProvider>(context, listen: false).configModel!.cashOnDelivery == 'false';
      _cartList = [];
      widget.fromCart
          ? _cartList.addAll(Provider.of<CartProvider>(context, listen: false).cartList)
          : _cartList.addAll(widget.cartList ?? []);
    }
    if (locationProvider.address == null || locationProvider.address!.isEmpty) {
      locationProvider.checkPermission(
        () => locationProvider.getCurrentLocation(context, false).then((currentPosition) {
          locationProvider.checkRadius();
        }),
        context,
      );
    } else {
      locationProvider.checkRadius(notify: false);
    }
    takeAway = widget.orderType == 'take_away';
    kmWiseCharge = Provider.of<SplashProvider>(context, listen: false).configModel?.deliveryManagement?.status == 1;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (popped) {
        Provider.of<OrderProvider>(context, listen: false).stopLoader();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          context: context,
          title: getTranslated('checkout', context),
          onBackPressed: () {
            Provider.of<OrderProvider>(context, listen: false).stopLoader();
            Navigator.pop(context);
          },
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _isLoggedIn
                ? Consumer4<OrderProvider, SplashProvider, LocationProvider, BranchProvider>(
                    builder: (context, order, config, address, branchProvider, child) {
                      double deliveryCharge = 0;
                      _latitude = address.pickPosition.latitude.toString();
                      _longitude = address.pickPosition.latitude.toString();
                      if (!takeAway && kmWiseCharge) {
                        deliveryCharge = order.distance * config.configModel!.deliveryManagement!.shippingPerKm;
                        if (deliveryCharge < config.configModel!.deliveryManagement!.minShippingCharge) {
                          deliveryCharge = config.configModel!.deliveryManagement!.minShippingCharge;
                        }
                      } else if (!takeAway && !kmWiseCharge) {
                        deliveryCharge = config.configModel!.deliveryCharge;
                      }
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height < 600
                                  ? MediaQuery.of(context).size.height
                                  : MediaQuery.of(context).size.height - 400,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Choose branch
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Choose Store',
                                        style: rubikMedium.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_LARGE,
                                        ),
                                      ),
                                      if (branchProvider.getBranchId != -1)
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: BranchButtonView(
                                            branchName: branchProvider.getBranch(context)?.name ?? '',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Time Preference
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  child: Text(getTranslated('preference_time', context), style: rubikMedium),
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                //Today or Tomorrow
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                    itemCount: 2,
                                    itemBuilder: (context, index) {
                                      return SlotWidget(
                                        title: index == 0
                                            ? getTranslated('today', context)
                                            : getTranslated('tomorrow', context),
                                        isSelected: order.selectDateSlot == index,
                                        onTap: () => order.updateDateSlot(index),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                //Timeslots
                                SizedBox(
                                  height: 50,
                                  child: order.timeSlots != null
                                      ? order.timeSlots!.isNotEmpty
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              physics: const BouncingScrollPhysics(),
                                              padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                              itemCount: order.timeSlots!.length,
                                              itemBuilder: (context, index) {
                                                return SlotWidget(
                                                  title: (index == 0 &&
                                                          order.selectDateSlot == 0 &&
                                                          Provider.of<SplashProvider>(context, listen: false)
                                                              .isRestaurantOpenNow(context))
                                                      ? getTranslated('now', context)
                                                      : '${DateConverter.dateToTimeOnly(order.timeSlots![index].startTime, context)} '
                                                          '- ${DateConverter.dateToTimeOnly(order.timeSlots![index].endTime, context)}',
                                                  isSelected: order.selectTimeSlot == index,
                                                  onTap: () => order.updateTimeSlot(index),
                                                );
                                              },
                                            )
                                          : Center(
                                              child: Text(
                                                getTranslated('no_slot_available', context),
                                              ),
                                            )
                                      : const Center(child: CircularProgressIndicator()),
                                ),
                                //Delivery Instructions
                                if (takeAway) ...[
                                  const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                  Text(
                                    'Pickup Instructions (Optional)',
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.getHintColor(context),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _noteController,
                                    hintText: 'Additional instructions for Pickup',
                                    maxLines: 2,
                                    inputType: TextInputType.multiline,
                                    inputAction: TextInputAction.newline,
                                    capitalization: TextCapitalization.sentences,
                                  ),
                                  const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                ],
                                //Delivery and other things
                                if (!takeAway)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                                        child: Text(
                                          'Personal Info',
                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: ColorResources.getGreyBunkerColor(context),
                                              fontSize: Dimensions.FONT_SIZE_LARGE),
                                        ),
                                      ),
                                      Text(
                                        'Name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(color: ColorResources.getHintColor(context)),
                                      ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: 'Enter Name',
                                        isShowBorder: true,
                                        controller: _nameController,
                                        focusNode: _nameFocus,
                                        inputType: TextInputType.name,
                                        capitalization: TextCapitalization.words,
                                      ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                      Text(
                                        getTranslated('email', context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(color: ColorResources.getHintColor(context)),
                                      ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: 'Enter your email',
                                        isShowBorder: true,
                                        controller: _emailController,
                                        focusNode: _emailFocus,
                                        inputType: TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),
                                      Text(
                                        getTranslated('mobile_number', context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(color: ColorResources.getHintColor(context)),
                                      ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      MaskedTextField(
                                        mask: AppConstants.phone_form,
                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                            fontSize: Dimensions.FONT_SIZE_LARGE),
                                        controller: _phoneNumberController,
                                        readOnly: true,
                                        focusNode: _phoneNumberFocus,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                                          ),
                                          isDense: true,
                                          hintText: AppConstants.phone_form_hint,
                                          fillColor: Theme.of(context).cardColor,
                                          hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                                              fontSize: Dimensions.FONT_SIZE_SMALL,
                                              color: ColorResources.COLOR_GREY_CHATEAU),
                                          filled: true,
                                          prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                                        child: Text(
                                          getTranslated('delivery_address', context),
                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: ColorResources.getGreyBunkerColor(context),
                                              fontSize: Dimensions.FONT_SIZE_LARGE),
                                        ),
                                      ),
                                      if (address.pickAddress != null)
                                        InkWell(
                                          onTap: () async => await showDialog(
                                            context: context,
                                            builder: (context) => const LocationSearchDialog(),
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions.PADDING_SIZE_LARGE,
                                              vertical: 18.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              border: Border.all(
                                                color: address.isAvailable ? Theme.of(context).cardColor : Colors.red,
                                              ),
                                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    address.address == null || address.address == ''
                                                        ? 'Enter address Manually'
                                                        : address.address!,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const Icon(Icons.search, size: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                      if (!address.isAvailable)
                                        Text(
                                          'Service not available in that area',
                                          style: poppinsRegular.copyWith(color: Colors.red),
                                        ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                      Text(
                                        'Apt / Suite / Floor',
                                        style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                                      ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: getTranslated('ex_2', context),
                                        isShowBorder: true,
                                        inputType: TextInputType.streetAddress,
                                        inputAction: TextInputAction.next,
                                        focusNode: _houseNode,
                                        nextFocus: _floorNode,
                                        controller: _floorController,
                                      ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                      Text(
                                        'Delivery Instructions (Optional)',
                                        style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                                      ),
                                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        controller: _noteController,
                                        hintText: 'Additional instructions for delivery',
                                        maxLines: 2,
                                        inputType: TextInputType.multiline,
                                        inputAction: TextInputAction.newline,
                                        capitalization: TextCapitalization.sentences,
                                      ),
                                    ],
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  child: Text(
                                    'Payment Info',
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        color: ColorResources.getGreyBunkerColor(context),
                                        fontSize: Dimensions.FONT_SIZE_LARGE),
                                  ),
                                ),
                                CardFormField(
                                  controller: controller,
                                  style: CardFormStyle(
                                    borderColor: Colors.transparent,
                                    textErrorColor: Colors.red,
                                    textColor:
                                        Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,
                                    placeholderColor:
                                        Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,
                                  ),
                                  onCardChanged: (card) {
                                    if (kDebugMode) debugPrint(card.toString());
                                  },
                                ),
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    child: !order.isLoading
                                        ? CustomButton(
                                            btnTxt: 'Pay with Delivery',
                                            onTap: () async {
                                              String lastName = _nameController.text.trim();
                                              String email = _emailController.text.trim();
                                              if (lastName.isEmpty) {
                                                showCustomSnackBar('enter name', context);
                                              } else if (email.isEmpty) {
                                                showCustomSnackBar('enter your email', context);
                                              } else if (order.timeSlots!.isEmpty) {
                                                showCustomSnackBar('select time slot', context);
                                              } else {
                                                if (controller.details.complete) {
                                                  if (!address.isAvailable && !takeAway) {
                                                    showCustomSnackBar('Service not available in that area', context);
                                                  } else if (takeAway) {
                                                    order.startLoader();

                                                    createCardToken(context, order, takeAway, lastName, email);
                                                  } else {
                                                    order.startLoader();

                                                    createCardToken(context, order, takeAway, lastName, email);
                                                  }
                                                } else {
                                                  showCustomSnackBar('complete cad Info', context);
                                                }
                                              }
                                            })
                                        : CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const NotLoggedInScreen(),
      ),
    );
  }

  Future<void> createCardToken(
    BuildContext context,
    OrderProvider order,
    bool takeAway,
    String name,
    String email,
  ) async {
    FocusScope.of(context).unfocus();
    try {
      BillingDetails billingDetails = BillingDetails(
        email: email,
        phone: Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.phone,
      );
      final token = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
            mandateData: const MandateData(
              customerAcceptance: MandateDataCustomerAcceptance(),
            ),
          ),
        ),
      );

      Provider.of<OrderProvider>(context, listen: false)
          .makePayment(token.id, widget.amount, name, email)
          .then((value) {
        if (value?.isSuccess ?? false) {
          placeOrder(order, takeAway, name, email);
        } else {
          showCustomSnackBar('ERROR PLACING ORDER', context);
        }
      });
    } on Exception catch (e) {
      order.stopLoader();
      showCustomSnackBar(e.toString(), context);
    }
  }

  Future<void> _callback(bool isSuccess, String message, String orderID, int addressID) async {
    if (isSuccess) {
      if (widget.fromCart) {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
      Navigator.pushReplacementNamed(context, Routes.getOrderTrackingRoute(int.parse(orderID)));
    } else {
      log('Error in order $message');
      showCustomSnackBar(message, context);
    }
  }

  Future<void> placeOrder(OrderProvider order, bool takeAway, String name, String email) async {
    try {
      DateTime scheduleStartDate = DateTime.now();
      DateTime scheduleEndDate = DateTime.now();
      if (order.timeSlots != null || order.timeSlots!.isNotEmpty) {
        DateTime date = order.selectDateSlot == 0 ? DateTime.now() : DateTime.now().add(const Duration(days: 1));
        DateTime startTime = order.timeSlots![order.selectTimeSlot].startTime;
        DateTime endTime = order.timeSlots![order.selectTimeSlot].endTime;
        scheduleStartDate = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute + 1);
        scheduleEndDate = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute + 1);
        for (CartModel cart in _cartList) {
          if (!DateConverter.isAvailable(
                cart.product!.availableTimeStarts,
                cart.product!.availableTimeEnds,
                context,
                time: scheduleStartDate,
              ) &&
              !DateConverter.isAvailable(cart.product!.availableTimeStarts, cart.product!.availableTimeEnds, context,
                  time: scheduleEndDate)) {
            break;
          }
        }
      }

      List<Cart> carts = [];
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      //check all Carts
      for (int index = 0; index < _cartList.length; index++) {
        CartModel cart = _cartList[index];
        List<int> addOnIdList = [];
        List<int> addOnQtyList = [];
        cart.addOnIds?.forEach((addOn) {
          addOnIdList.add(addOn.id);
          addOnQtyList.add(addOn.quantity);
        });
        final cartVariation = <Variation>[];
        for (Variation? variation in cart.variation ?? []) {
          if (variation != null) cartVariation.add(variation);
        }
        carts.add(Cart(
          productId: (cart.product?.id).toString(),
          price: cart.discountedPrice.toString(),
          variation: cartVariation,
          discountAmount: cart.discountAmount,
          quantity: cart.quantity,
          taxAmount: cart.taxAmount,
          addOnIds: addOnIdList,
          addOnQtys: addOnQtyList,
        ));
      }
      for (int index = 0; index < cartProvider.cateringList.length; index++) {
        CateringCartModel cartModel = cartProvider.cateringList[index];

        carts.add(Cart(
          price: cartModel.discountAmount.toString(),
          cateringId: cartModel.catering?.id == null ? '' : cartModel.catering!.id.toString(),
          variation: [],
          discountAmount: cartModel.discountedPrice,
          quantity: cartModel.quantity,
          taxAmount: 0.0,
          addOnIds: [],
          addOnQtys: [],
        ));
      }
      for (int index = 0; index < cartProvider.happyHoursList.length; index++) {
        HappyHoursCartModel happyHoursCartModel = cartProvider.happyHoursList[index];

        carts.add(Cart(
          price: happyHoursCartModel.discountAmount.toString(),
          happyHoursId: happyHoursCartModel.happyHours?.id.toString() ?? '',
          variation: [],
          discountAmount: happyHoursCartModel.discountAmount,
          quantity: happyHoursCartModel.quantity,
          taxAmount: 0.0,
          addOnIds: [],
          addOnQtys: [],
        ));

        for (int index = 0; index < cartProvider.dealsList.length; index++) {
          DealCartModel dealsList = cartProvider.dealsList[index];

          carts.add(Cart(
            price: dealsList.price.toString(),
            dealId: dealsList.dealsDataModel?.id.toString() ?? '',
            variation: [],
            discountAmount: dealsList.discountAmount,
            quantity: dealsList.quantity,
            taxAmount: 0.0,
            addOnIds: [],
            addOnQtys: [],
          ));
        }
      }
      //Create order body
      PlaceOrderBody placeOrderBody = PlaceOrderBody(
        cart: carts,
        couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount,
        couponDiscountTitle: widget.couponCode.isNotEmpty ? widget.couponCode : null,
        restaurantId: F.restaurantId,
        orderAmount: double.parse((widget.amount).toStringAsFixed(2)),
        orderNote: _noteController.text,
        orderType: widget.orderType,
        orderTip: double.parse(Get.put(TipController()).tip.value.toStringAsFixed(2)),
        taxFee: double.parse(cartProvider.taxFee.toStringAsFixed(2)),
        paymentMethod: _isCashOnDeliveryActive
            ? order.paymentMethodIndex == 0
                ? 'cash_on_delivery'
                : 'stripe'
            : 'stripe',
        couponCode: widget.couponCode.isNotEmpty ? widget.couponCode : null,
        distance: takeAway ? 0 : order.distance,
        branchId: currentBranch!.id,
        deliveryDate: DateFormat('yyyy-MM-dd').format(scheduleStartDate),
        deliveryTime: (order.selectTimeSlot == 0 && order.selectDateSlot == 0)
            ? 'now'
            : DateFormat('HH:mm').format(scheduleStartDate),
        platform: kIsWeb
            ? 'Web'
            : Platform.isAndroid
                ? 'Android'
                : 'iOS',
        catering: [],
        happyHours: [],
        tipChargeId: '',
        paymentId: order.stripeModel.id,
        chargeId: order.stripeModel.latestCharge,
        address: Provider.of<LocationProvider>(context, listen: false).address,
        latitude: _latitude,
        longitude: _longitude,
        floor: _floorController.text,
        addressType: 'home',
        email: email,
        phone: Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.phone,
        firstName: name,
        lastName: '',
        userId: Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id.toString(),
        cardHolder: 'ali',
        contactName: name,
        contactPhone: Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.phone,
      );

      await order.placeOrder(placeOrderBody, _callback);
    } catch (e) {
      order.stopLoader();

      debugPrint('Error placing order: $e');
    }
  }
}
