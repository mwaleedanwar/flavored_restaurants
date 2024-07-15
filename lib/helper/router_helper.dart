import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/screen_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

//*******Handlers*********
  static final Handler _splashHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) => const SplashScreen());

  static final Handler _maintainHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const MaintenanceScreen()),
  );

  // ignore: non_constant_identifier_names, missing_required_param

  static final Handler _languageHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return ChooseLanguageScreen(fromMenu: params['page'][0] == 'menu');
  });

  static final Handler _onbordingHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const OnBoardingScreen(),
  );

  static final Handler _welcomeHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => const WelcomeScreen(),
  );

  static final Handler _loginHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const LoginScreen()),
  );

  static final Handler _signUpHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const SignUpScreen()),
  );

  static final Handler _verificationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    String email = utf8.decode(base64Decode(params['email'][0]));
    VerificationScreen? verificationScreen = ModalRoute.of(context!)?.settings.arguments as VerificationScreen?;
    return _routeHandler(
        context,
        verificationScreen ??
            VerificationScreen(
              fromSignUp: params['page'][0] == 'sign-up',
              emailAddress: email,
            ));
  });

  static final Handler _forgotPassHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const ForgotPasswordScreen()),
  );

  static final Handler _createNewPassHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    CreateNewPasswordScreen? createPassScreen = ModalRoute.of(context!)?.settings.arguments as CreateNewPasswordScreen?;
    return _routeHandler(
        context,
        createPassScreen ??
            CreateNewPasswordScreen(
              email: params['email'][0],
              resetToken: params['token'][0],
            ));
  });

  static final Handler _createAccountHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(context, const CreateAccountScreen());
  });

  static final Handler __newHomeScreenHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(context, const ModifiedHomePage());
  });

  static final Handler _searchHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const SearchScreen()),
  );

  static final Handler _searchResultHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    List<int> decode = base64Decode(params['text'][0]);
    String data = utf8.decode(decode);
    return _routeHandler(context, SearchResultScreen(searchString: data));
  });
  static final Handler _updateHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const UpdateScreen()),
  );

  static final Handler _setMenuHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const SetMenuScreen()),
  );

  static final Handler _categoryHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(context, const MyHomePage());
  });

  static final Handler _notificationHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const NotificationScreen()),
  );

  static final Handler _checkoutHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    String amount = '${jsonDecode(utf8.decode(base64Decode(params['amount'][0])))}';
    CheckoutScreen? checkoutScreen = ModalRoute.of(context!)?.settings.arguments as CheckoutScreen?;
    bool fromCart = params['page'][0] == 'cart';
    return _routeHandler(
        context,
        checkoutScreen ??
            (!fromCart
                ? const NotFound()
                : CheckoutScreen(
                    amount: double.parse(amount),
                    orderType: params['type'][0],
                    cartList: null,
                    fromCart: params['page'][0] == 'cart',
                    couponCode: params['code'][0],
                  )));
  });

  static final Handler _paymentHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool fromCheckOut = params['page'][0] == 'checkout';
    String decoded =
        fromCheckOut ? utf8.decode(base64Url.decode(params['place_order'][0].replaceAll(' ', '+'))) : 'null';

    return _routeHandler(
        context,
        PaymentScreen(
            fromCheckout: fromCheckOut,
            orderModel: null,
            url: fromCheckOut ? utf8.decode(base64Decode(params['address'][0])) : '',
            placeOrderBody: decoded != 'null' ? PlaceOrderBody.fromJson(jsonDecode(decoded)) : null));
  });

  static final Handler _orderSuccessHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    debugPrint('calling ====>>>>>');
    int status = (params['status'][0] == 'success' || params['status'][0] == 'payment-success')
        ? 0
        : params['status'][0] == 'fail'
            ? 1
            : 2;
    return _routeHandler(context, OrderSuccessfulScreen(orderID: params['id'][0], status: status));
  });

  static final Handler _orderWebPaymentHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(
        context,
        OrderWebPayment(
          token: params['token'][0],
        ));
  });

  static final Handler _orderDetailsHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    OrderDetailsScreen? orderDetailsScreen = ModalRoute.of(context!)?.settings.arguments as OrderDetailsScreen?;
    return _routeHandler(
      context,
      orderDetailsScreen ??
          OrderDetailsScreen(
            orderId: int.parse(params['id'][0]),
            orderModel: null,
          ),
    );
  });

  static final Handler _rateReviewHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    RateReviewScreen? rateReviewScreen = ModalRoute.of(context!)?.settings.arguments as RateReviewScreen?;
    return _routeHandler(context, rateReviewScreen ?? const NotFound());
  });

  static final Handler _orderTrackingHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(context, OrderTrackingScreen(orderID: params['id'][0]));
  });

  static final Handler _profileHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const ProfileScreen()),
  );

  static final Handler _addressHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const AddressScreen()),
  );
  static final Handler _cardHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const MyPaymentMethodScreen()),
  );

  static final Handler _mapHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    List<int> decode = base64Decode(params['address'][0].replaceAll(' ', '+'));
    DeliveryAddress data = DeliveryAddress.fromJson(jsonDecode(utf8.decode(decode)));
    return _routeHandler(context, MapWidget(address: data));
  });

  static final Handler _newAddressHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool isUpdate = params['action'][0] == 'update';
    debugPrint('====parameters:${params['amount'][0].runtimeType}');
    AddressModel? addressModel;
    if (isUpdate) {
      String decoded = utf8.decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
      addressModel = AddressModel.fromJson(jsonDecode(decoded));
    }
    return _routeHandler(
      context,
      AddNewAddressScreen(
          fromCheckout: params['page'][0] == 'checkout',
          isFromCart: params['page'][0] == 'cart',
          amount: params['amount'][0] != null ? double.parse(params['amount'][0]) : 0.0,
          isEnableUpdate: isUpdate,
          address: isUpdate ? addressModel : null),
    );
  });

  static final Handler _selectLocationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    SelectLocationScreen? locationScreen = ModalRoute.of(context!)?.settings.arguments as SelectLocationScreen?;
    return _routeHandler(context, locationScreen ?? const NotFound());
  });

  static final Handler _chatHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    final orderModel = jsonDecode(utf8.decode(base64Url.decode(params['order'][0].replaceAll(' ', '+'))));
    return _routeHandler(
        context,
        ChatScreen(
          orderModel: orderModel != null ? OrderModel.fromJson(orderModel) : null,
        ));
  });

  static final Handler _couponHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const CouponScreen()),
  );

  static final Handler _supportHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const SupportScreen()),
  );

  static final Handler _termsHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(context, const HtmlViewerScreen(htmlType: HtmlType.TERMS_AND_CONDITION)),
  );

  static final Handler _policyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(context, const HtmlViewerScreen(htmlType: HtmlType.PRIVACY_POLICY)),
  );

  static final Handler _aboutUsHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(context, const HtmlViewerScreen(htmlType: HtmlType.ABOUT_US)),
  );

  static final Handler _notFoundHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(context, const NotFound()),
  );

  static final Handler _returnPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(context, const HtmlViewerScreen(htmlType: HtmlType.RETURN_POLICY)),
  );

  static final Handler _refundPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(context, const HtmlViewerScreen(htmlType: HtmlType.REFUND_POLICY)),
  );

  static final Handler _cancellationPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(context, const HtmlViewerScreen(htmlType: HtmlType.CANCELLATION_POLICY)),
  );

  static final Handler _branchListHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(
            context,
            const BranchListScreen(),
          ));
  static Handler dashScreenBoardHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(context, const DashboardScreen(pageIndex: 0));
  });
//*******Route Define*********
  static void setupRouter() {
    router.notFoundHandler = _notFoundHandler;
    router.define(Routes.SPLASH_SCREEN, handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.LANGUAGE_SCREEN, handler: _languageHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ON_BOARDING_SCREEN, handler: _onbordingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.WELCOME_SCREEN, handler: _welcomeHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.LOGIN_SCREEN, handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SIGNUP_SCREEN, handler: _signUpHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.VERIFY, handler: _verificationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CREATE_ACCOUNT_SCREEN, handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.FORGOT_PASS_SCREEN, handler: _forgotPassHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CREATE_NEW_PASS_SCREEN, handler: _createNewPassHandler, transitionType: TransitionType.fadeIn);

    router.define(Routes.NEW_HOME,
        handler: __newHomeScreenHandler, transitionType: TransitionType.fadeIn); // ?page=home
    router.define(Routes.DASHBOARD, handler: dashScreenBoardHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SEARCH_SCREEN, handler: _searchHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SEARCH_RESULT_SCREEN, handler: _searchResultHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CATEGORY_SCREEN, handler: _categoryHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SET_MENU_SCREEN, handler: _setMenuHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.NOTIFICATION_SCREEN, handler: _notificationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CHECKOUT_SCREEN, handler: _checkoutHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PAYMENT_SCREEN, handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    router.define('${Routes.ORDER_SUCCESS_SCREEN}/:id/:status',
        handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    router.define('${Routes.ORDER_WEB_PAYMENT}/:status?:token',
        handler: _orderWebPaymentHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDER_DETAILS_SCREEN, handler: _orderDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.RATE_SCREEN, handler: _rateReviewHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDER_TRACKING_SCREEN, handler: _orderTrackingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PROFILE_SCREEN, handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ADDRESS_SCREEN, handler: _addressHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PAYMENT_METHODS_SCREEN, handler: _cardHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.MAP_SCREEN, handler: _mapHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ADD_ADDRESS_SCREEN, handler: _newAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SELECT_LOCATION_SCREEN,
        handler: _selectLocationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CHAT_SCREEN, handler: _chatHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.COUPON_SCREEN, handler: _couponHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SUPPORT_SCREEN, handler: _supportHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.TERMS_SCREEN, handler: _termsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.POLICY_SCREEN, handler: _policyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ABOUT_US_SCREEN, handler: _aboutUsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.MAINTAIN, handler: _maintainHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.UPDATE, handler: _updateHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.RETURN_POLICY_SCREEN, handler: _returnPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.REFUND_POLICY_SCREEN, handler: _refundPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CANCELLATION_POLICY_SCREEN,
        handler: _cancellationPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.BRANCH_LIST_SCREEN, handler: _branchListHandler, transitionType: TransitionType.material);
  }

  static Widget _routeHandler(BuildContext? context, Widget route) {
    return Provider.of<SplashProvider>(context!, listen: false).configModel?.maintenanceMode ?? false
        ? const MaintenanceScreen()
        : route;
  }
}
