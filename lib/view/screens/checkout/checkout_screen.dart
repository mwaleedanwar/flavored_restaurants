import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/place_order_body.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/config_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/userinfo_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/branch_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/coupon_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/location_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/paymet_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
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
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/address/widget/location_search_dialog.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/checkout/widget/slot_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final double amount;
  final String orderType;
  final List<CartModel> cartList;
  final bool fromCart;
  final String couponCode;

  const CheckoutScreen({
    Key key,
    @required this.amount,
    @required this.orderType,
    @required this.fromCart,
    @required this.cartList,
    @required this.couponCode,
  }) : super(key: key);

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final _noteController = TextEditingController();
  final _floorController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final controller = CardFormEditController();
  final _houseNode = FocusNode();
  final _floorNode = FocusNode();

  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneNumberFocus = FocusNode();

  bool _isCashOnDeliveryActive;
  bool _isLoggedIn;
  List<CartModel> _cartList;
  String _latitude = '';
  String _longitude = '';
  Branches currentBranch;

  Map<String, dynamic> paymentIntent;

  void update() => setState(() {});

  @override
  void initState() {
    super.initState();
    debugPrint('The total amount is : ${widget.amount}');
    controller.addListener(update);

    currentBranch = Provider.of<BranchProvider>(context, listen: false).getBranch();
    Provider.of<LocationProvider>(context, listen: false).currentBranch = currentBranch;
    debugPrint('===currentBranch: ${currentBranch.address}');

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context).then((value) {
        debugPrint('=====new data=====');

        if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
          UserInfoModel userInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
          _lastNameController.text = userInfoModel.lName ?? '';
          _phoneNumberController.text = userInfoModel.phone.replaceAll('+1', '') ?? '';
          _emailController.text = userInfoModel.email ?? '';
        }
      });

      Provider.of<PaymentProvider>(context, listen: false).getCardsList(context);

      Provider.of<OrderProvider>(context, listen: false).initializeTimeSlot(context).then((value) {
        Provider.of<OrderProvider>(context, listen: false).sortTime();
      });
      if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel == null) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      } else {
        _lastNameController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName;
        _emailController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.email;
      }

      Provider.of<OrderProvider>(context, listen: false).clearPrevData();
      _isCashOnDeliveryActive =
          Provider.of<SplashProvider>(context, listen: false).configModel.cashOnDelivery == 'false';
      _cartList = [];
      widget.fromCart
          ? _cartList.addAll(Provider.of<CartProvider>(context, listen: false).cartList)
          : _cartList.addAll(widget.cartList);
    }

    Provider.of<LocationProvider>(context, listen: false).checkPermission(
      () => Provider.of<LocationProvider>(context, listen: false)
          .getCurrentLocation(context, false)
          .then((currentPosition) {
        Provider.of<LocationProvider>(context, listen: false).checkRadius();
      }),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final height = MediaQuery.of(context).size.height;
    bool kmWiseCharge = configModel.deliveryManagement.status == 1;
    bool takeAway = widget.orderType == 'take_away';

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(preferredSize: const Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(context: context, title: getTranslated('checkout', context)),
      body: _isLoggedIn
          ? Consumer<OrderProvider>(
              builder: (context, order, child) {
                double deliveryCharge = 0;

                if (!takeAway && kmWiseCharge) {
                  deliveryCharge = order.distance * configModel.deliveryManagement.shippingPerKm;
                  if (deliveryCharge < configModel.deliveryManagement.minShippingCharge) {
                    deliveryCharge = configModel.deliveryManagement.minShippingCharge;
                  }
                } else if (!takeAway && !kmWiseCharge) {
                  deliveryCharge = configModel.deliveryCharge;
                }

                return Consumer<LocationProvider>(
                  builder: (context, address, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minHeight: !ResponsiveHelper.isDesktop(context) && height < 600
                                              ? height
                                              : height - 400),
                                      child: Center(
                                        child: SizedBox(
                                          width: 1170,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 6,
                                                child: Container(
                                                  decoration: const BoxDecoration(),
                                                  child:
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('Choose Store',
                                                                style: rubikMedium.copyWith(
                                                                    fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                            Container(
                                                              padding: const EdgeInsets.all(8),
                                                              decoration: BoxDecoration(
                                                                color: Theme.of(context).primaryColor,
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: const BranchButtonView(isRow: true),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                    // Address
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: Dimensions.PADDING_SIZE_SMALL),
                                                      child: Text(getTranslated('preference_time', context),
                                                          style: rubikMedium),
                                                    ),
                                                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                                    SizedBox(
                                                      height: 50,
                                                      child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        shrinkWrap: true,
                                                        physics: const BouncingScrollPhysics(),
                                                        padding:
                                                            const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
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
                                                    SizedBox(
                                                      height: 50,
                                                      child: order.timeSlots != null
                                                          ? order.timeSlots.isNotEmpty
                                                              ? ListView.builder(
                                                                  scrollDirection: Axis.horizontal,
                                                                  shrinkWrap: true,
                                                                  physics: const BouncingScrollPhysics(),
                                                                  padding: const EdgeInsets.only(
                                                                      left: Dimensions.PADDING_SIZE_SMALL),
                                                                  itemCount: order.timeSlots.length,
                                                                  itemBuilder: (context, index) {
                                                                    return SlotWidget(
                                                                      title: (index == 0 &&
                                                                              order.selectDateSlot == 0 &&
                                                                              Provider.of<SplashProvider>(context,
                                                                                      listen: false)
                                                                                  .isRestaurantOpenNow(context))
                                                                          ? getTranslated('now', context)
                                                                          : '${DateConverter.dateToTimeOnly(order.timeSlots[index].startTime, context)} '
                                                                              '- ${DateConverter.dateToTimeOnly(order.timeSlots[index].endTime, context)}',
                                                                      isSelected: order.selectTimeSlot == index,
                                                                      onTap: () => order.updateTimeSlot(index),
                                                                    );
                                                                  },
                                                                )
                                                              : Center(
                                                                  child:
                                                                      Text(getTranslated('no_slot_available', context)))
                                                          : const Center(child: CircularProgressIndicator()),
                                                    ),
                                                    !takeAway
                                                        ? const SizedBox.shrink()
                                                        : const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                                    !takeAway
                                                        ? const SizedBox.shrink()
                                                        : Text(
                                                            'Pickup Instructions (Optional)',
                                                            style: poppinsRegular.copyWith(
                                                                color: ColorResources.getHintColor(context)),
                                                          ),
                                                    !takeAway
                                                        ? const SizedBox.shrink()
                                                        : const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                                    !takeAway
                                                        ? const SizedBox.shrink()
                                                        : CustomTextField(
                                                            controller: _noteController,
                                                            hintText: 'Additional instructions for Pickup',
                                                            maxLines: 2,
                                                            inputType: TextInputType.multiline,
                                                            inputAction: TextInputAction.newline,
                                                            capitalization: TextCapitalization.sentences,
                                                          ),

                                                    takeAway
                                                        ? const SizedBox(height: Dimensions.PADDING_SIZE_SMALL)
                                                        : const SizedBox.shrink(),

                                                    !takeAway
                                                        ? detailsWidget(context)
                                                        : CardFormField(
                                                            controller: controller,
                                                            // enablePostalCode: false,
                                                            style: CardFormStyle(
                                                                borderColor: Colors.transparent,
                                                                textColor: ColorResources.COLOR_BLACK,
                                                                placeholderColor: ColorResources.COLOR_BLACK),
                                                            onCardChanged: (card) {
                                                              debugPrint(card.toString());
                                                            },
                                                          ),
                                                  ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          confirmButtonWidget(order, takeAway, address, kmWiseCharge, deliveryCharge, context),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          : NotLoggedInScreen(),
    );
  }

  Container confirmButtonWidget(OrderProvider order, bool takeAway, LocationProvider address, bool kmWiseCharge,
      double deliveryCharge, BuildContext context) {
    return Container(
      width: 1170,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: !order.isLoading
          ? Builder(
              builder: (context) => CustomButton(
                  btnTxt: 'Pay with Delivery',
                  onTap: () async {
                    String lastName = _lastNameController.text.trim();
                    String email = _emailController.text.trim();
                    if (lastName.isEmpty) {
                      showCustomSnackBar('enter user name', context);
                    } else if (email.isEmpty) {
                      showCustomSnackBar('enter your email', context);
                    } else {
                      if (controller.details.complete) {
                        if (!address.isAvailable && !takeAway) {
                          debugPrint('===no service');
                        } else if (takeAway) {
                          createCardToken(context, order, takeAway, lastName, email);
                        } else {
                          debugPrint('===service available');
                          createCardToken(context, order, takeAway, lastName, email);
                        }
                      } else {
                        createCardToken(context, order, takeAway, lastName, email);
                        debugPrint('===complete card');
                      }
                    }
                  }),
            )
          : Center(
              child:
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
    );
  }

  void _openSearchDialog(
    BuildContext context,
  ) async {
    showDialog(context: context, builder: (context) => LocationSearchDialog());
  }

  Widget detailsWidget(BuildContext context) {
    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {
      return Container(
        decoration: const BoxDecoration(),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ? 0 : 24.0),
              child: Text(
                'Personnel Info',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
            ),

            Text(
              'User Name',
              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
            ),

            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            CustomTextField(
              hintText: 'Doe',
              isShowBorder: true,
              controller: _lastNameController,
              focusNode: _lastNameFocus,
              inputType: TextInputType.name,
              capitalization: TextCapitalization.words,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            // for email section
            Text(
              getTranslated('email', context),
              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            CustomTextField(
              hintText: 'Enter your email',
              isShowBorder: true,
              controller: _emailController,
              focusNode: _emailFocus,
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            // for phone Number section
            Text(
              getTranslated('mobile_number', context),
              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            MaskedTextField(
              mask: AppConstants.phone_form,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE),
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
                hintStyle: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.COLOR_GREY_CHATEAU),
                filled: true,
                prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ? 0 : 24.0),
              child: Text(
                getTranslated('delivery_address', context),
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
            ),

            // for Address Field
            Text(
              getTranslated('address_line_01', context),
              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            locationProvider.pickAddress != null
                ? InkWell(
                    onTap: () => _openSearchDialog(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 18.0),
                      margin: const EdgeInsets.only(top: 23.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border:
                            Border.all(color: locationProvider.isAvailable ? Theme.of(context).cardColor : Colors.red),
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                      ),
                      child: Builder(builder: (context) {
                        _latitude = locationProvider.pickPosition.latitude.toString();
                        _longitude = locationProvider.pickPosition.latitude.toString();

                        return Row(children: [
                          Expanded(
                              child: Text(
                                  locationProvider.pickAddress == null || locationProvider.pickAddress == ''
                                      ? locationProvider.address == '' || locationProvider.address == ''
                                          ? 'Enter address Manually'
                                          : locationProvider.address
                                      : locationProvider.pickAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)),
                          const Icon(Icons.search, size: 20),
                        ]);
                      }),
                    ),
                  )
                : const SizedBox.shrink(),
            locationProvider.isAvailable
                ? const SizedBox.shrink()
                : Text(
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
              controller: _floorController ?? '',
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

            Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ? 0 : 24.0),
              child: Text(
                'Payment Info',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
            ),

            CardFormField(
              controller: controller,

              dangerouslyGetFullCardDetails: true,

              // enablePostalCode: false,
              style: CardFormStyle(
                  cursorColor: Theme.of(context).textTheme.bodyText1.color,
                  textColor: Theme.of(context).textTheme.bodyText1.color,
                  placeholderColor: ColorResources.getHintColor(context)),
              onCardChanged: (card) {
                print(card);
              },
            ),
            // AppText(text: "${data12.body}"),

            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          ],
        ),
      );
    });
  }

  Future<void> createCardToken(
      BuildContext context, OrderProvider order, bool takeAway, String name, String email) async {
    print('==called createCardToken');
    try {
      BillingDetails billingDetails = BillingDetails(
        email: email,
        phone: Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone,
      );
      final token = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
              billingDetails: billingDetails,
              mandateData: const MandateData(customerAcceptance: MandateDataCustomerAcceptance())),
        ),
      );
      print('Token created: ${token.id}');
      print('Token created: ${token.card}');

      Provider.of<OrderProvider>(context, listen: false)
          .makePayment(token.id, widget.amount, name, email)
          .then((value) {
        if (value.isSuccess) {
          placeOrder(order, takeAway, name, email);
        }
      });

      // Send this token to your backend for further processing
    } on StripeException catch (e) {
      order.stopLoader();

      // Handle error
      showCustomSnackBar(e.error.message, context);
    }
  }

  void _callback(bool isSuccess, String message, String orderID, int addressID) async {
    if (isSuccess) {
      if (widget.fromCart) {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
      if (_isCashOnDeliveryActive && Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {
        Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/success');
      } else {
        Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/success');
      }
    } else {
      showCustomSnackBar(message, context);
    }
  }

  placeOrder(OrderProvider order, bool takeAway, String name, String email) async {
    try {
      bool isAvailable = true;

      DateTime scheduleStartDate = DateTime.now();
      DateTime scheduleEndDate = DateTime.now();
      if (order.timeSlots == null || order.timeSlots.length == 0) {
        isAvailable = false;
      } else {
        DateTime date = order.selectDateSlot == 0 ? DateTime.now() : DateTime.now().add(const Duration(days: 1));
        DateTime startTime = order.timeSlots[order.selectTimeSlot].startTime;
        DateTime endTime = order.timeSlots[order.selectTimeSlot].endTime;
        scheduleStartDate = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute + 1);
        scheduleEndDate = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute + 1);
        for (CartModel cart in _cartList) {
          if (!DateConverter.isAvailable(
                cart.product.availableTimeStarts,
                cart.product.availableTimeEnds,
                context,
                time: scheduleStartDate ?? null,
              ) &&
              !DateConverter.isAvailable(cart.product.availableTimeStarts, cart.product.availableTimeEnds, context,
                  time: scheduleEndDate ?? null)) {
            isAvailable = false;
            break;
          }
        }
      }

      if (2 != 2) {
      } else {
        List<Cart> carts = [];
        for (int index = 0; index < _cartList.length; index++) {
          CartModel cart = _cartList[index];
          List<int> addOnIdList = [];
          List<int> addOnQtyList = [];
          cart.addOnIds.forEach((addOn) {
            addOnIdList.add(addOn.id);
            addOnQtyList.add(addOn.quantity);
          });
          carts.add(Cart(
            cart.product.id.toString(),
            cart.discountedPrice.toString(),
            null,
            null,
            null,
            null,
            cart.variation,
            cart.discountAmount,
            cart.quantity,
            cart.taxAmount,
            addOnIdList,
            addOnQtyList,
          ));
        }
        for (int index = 0; index < Provider.of<CartProvider>(context, listen: false).cateringList.length; index++) {
          CateringCartModel cartModel = Provider.of<CartProvider>(context, listen: false).cateringList[index];
          List<int> addOnIdList = [];
          List<int> addOnQtyList = [];

          carts.add(Cart(null, cartModel.discountAmount.toString(), cartModel.catering.id.toString() ?? '', null, null,
              null, [], cartModel.discountedPrice, cartModel.quantity, 0.0, [], []));
        }
        for (int index = 0; index < Provider.of<CartProvider>(context, listen: false).happyHoursList.length; index++) {
          HappyHoursCartModel happyHoursCartModel =
              Provider.of<CartProvider>(context, listen: false).happyHoursList[index];
          List<int> addOnIdList = [];
          List<int> addOnQtyList = [];

          carts.add(Cart(
              null,
              happyHoursCartModel.discountAmount.toString(),
              null,
              happyHoursCartModel.happyHours.id.toString() ?? '',
              null,
              null,
              [],
              happyHoursCartModel.discountAmount,
              happyHoursCartModel.quantity,
              0.0,
              [],
              []));
        }
        for (int index = 0; index < Provider.of<CartProvider>(context, listen: false).dealsList.length; index++) {
          DealCartModel dealsList = Provider.of<CartProvider>(context, listen: false).dealsList[index];
          List<int> addOnIdList = [];
          List<int> addOnQtyList = [];

          carts.add(Cart(null, dealsList.price.toString(), null, null, dealsList.dealsDataModel.id.toString(), null, [],
              dealsList.discountAmount, dealsList.quantity, 0.0, [], []));
        }
        carts.forEach((element) {
          print('==cart List:${element.toJson()}');
        });

        PlaceOrderBody placeOrderBody = PlaceOrderBody(
          cart: carts,
          couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount,
          couponDiscountTitle: widget.couponCode.isNotEmpty ? widget.couponCode : null,
          restaurantId: F.restaurantId,
          orderAmount: double.parse('${(widget.amount).toStringAsFixed(2)}'),
          orderNote: _noteController.text ?? '',
          orderType: widget.orderType,
          orderTip: double.parse(Get.put(TipController()).tip.value.toStringAsFixed(2)),
          taxFee: double.parse(Provider.of<CartProvider>(context, listen: false).taxFee.toStringAsFixed(2)),
          paymentMethod: _isCashOnDeliveryActive
              ? order.paymentMethodIndex == 0
                  ? 'cash_on_delivery'
                  : 'stripe'
              : 'stripe',

          couponCode: widget.couponCode.isNotEmpty ? widget.couponCode : null,
          distance: takeAway ? 0 : order.distance,
          branchId: currentBranch.id,
          deliveryDate: DateFormat('yyyy-MM-dd').format(scheduleStartDate),
          deliveryTime: (order.selectTimeSlot == 0 && order.selectDateSlot == 0)
              ? 'now'
              : DateFormat('HH:mm').format(scheduleStartDate),
          platform: kIsWeb
              ? 'Web'
              : Platform.isAndroid
                  ? 'Android'
                  : 'iOS',
          paymentId: order.stripeModel.id,
          chargeId: order.stripeModel.latestCharge,
          address: Provider.of<LocationProvider>(context, listen: false).pickAddress,
          latitude: _latitude,
          longitude: _longitude,
          floor: _floorController.text,
          // cardNo: '4242424242424242',
          // ccv: '123',
          addressType: 'home',
          // expiryMonth: '12',
          // expYear: '25',
          email: email,
          phone: Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone,
          firstName: name,
          lastName: '',
          userId: Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id.toString(),
          cardHolder: 'ali',
          contactName: name,
          contactPhone: Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone,
        );

        order.placeOrder(placeOrderBody, _callback);
      }
    } catch (e) {
      print('Error initializing PaymentSheet: $e');
      return false;
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'name': Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName ?? 'guest',
        'email': Provider.of<ProfileProvider>(context, listen: false).userInfoModel.email ?? 'guest@gmail.com',
        'account_owner': Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName ?? 'guest'
      };

      var response = await http.post(
        Uri.parse('https://cafescale.site/api/v1/stripe/createPaymentIntent'),
        headers: {
          'Authorization':
              'Bearer sk_test_51MvRunJdXQeau2q1YkTvnJkyC1taaWq8zpgRGhfaN9FFeW76yrGHKqKCZtOBcxl1CRlRcDGjhgWiiB7MBg8DhVCd00P4eXT6c8',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('=======${response.body}');
      return json.decode(response.body);
    } catch (err) {
      print('Error initializing PaymentSheet: $err');
    }
  }
}
