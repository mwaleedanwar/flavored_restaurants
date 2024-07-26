// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/place_order_body.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/address_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_model.dart';

class Routes {
  static const String SPLASH_SCREEN = '/splash';
  static const String LANGUAGE_SCREEN = '/select-language';
  static const String ON_BOARDING_SCREEN = '/on_boarding';
  static const String WELCOME_SCREEN = '/welcome';
  static const String LOGIN_SCREEN = '/login';
  static const String SIGNUP_SCREEN = '/sign-up';
  static const String VERIFY = '/verify';
  static const String CREATE_NEW_PASS_SCREEN = '/create-new-password';
  static const String CREATE_ACCOUNT_SCREEN = '/create-account';
  static const String DASHBOARD = '/';
  static const String MAINTAIN = '/maintain';
  static const String DASHBOARD_SCREEN = '/main';

  static const String CATEGORY_SCREEN = '/category';
  static const String NOTIFICATION_SCREEN = '/notification';
  static const String CHECKOUT_SCREEN = '/checkout';
  static const String PAYMENT_SCREEN = '/payment';
  static const String ORDER_SUCCESS_SCREEN = '/order-successful';
  static const String ORDER_DETAILS_SCREEN = '/order-details';
  static const String RATE_SCREEN = '/rate-review';
  static const String ORDER_TRACKING_SCREEN = '/order-tracking';
  static const String PROFILE_SCREEN = '/profile';
  static const String ADDRESS_SCREEN = '/address';
  static const String PAYMENT_METHODS_SCREEN = '/payment-screen';
  static const String MAP_SCREEN = '/map';
  static const String ADD_ADDRESS_SCREEN = '/add-address';
  static const String SELECT_LOCATION_SCREEN = '/select-location';
  static const String CHAT_SCREEN = '/messages';
  static const String COUPON_SCREEN = '/coupons';
  static const String SUPPORT_SCREEN = '/support';
  static const String TERMS_SCREEN = '/terms';
  static const String POLICY_SCREEN = '/privacy-policy';
  static const String ABOUT_US_SCREEN = '/about-us';
  static const String IMAGE_DIALOG = '/image-dialog';
  static const String MENU_SCREEN_WEB = '/menu_screen_web';
  static const String HOME_SCREEN = '/home';
  static const String NEW_HOME = '/new_home';
  static const String MENU_SCREEN = '/food_menu';
  static const String ORDER_WEB_PAYMENT = '/order-web-payment';
  static const String POPULAR_ITEM_ROUTE = '/POPULAR_ITEM_ROUTE';
  static const String RETURN_POLICY_SCREEN = '/return-policy';
  static const String REFUND_POLICY_SCREEN = '/refund-policy';
  static const String CANCELLATION_POLICY_SCREEN = '/cancellation-policy';
  static const String BRANCH_LIST_SCREEN = '/branch-list';

  static String getSplashRoute() => SPLASH_SCREEN;
  static String getOnBoardingRoute() => ON_BOARDING_SCREEN;
  static String getWelcomeRoute() => WELCOME_SCREEN;
  static String getLoginRoute() => LOGIN_SCREEN;
  static String getSignUpRoute() => SIGNUP_SCREEN;
  static String getCreateAccountRoute() => CREATE_ACCOUNT_SCREEN;
  static String getMainRoute() => DASHBOARD;
  static String getMaintainRoute() => MAINTAIN;
  // static String getUpdateRoute() => UPDATE;
  static String getNotificationRoute() => NOTIFICATION_SCREEN;
  static String getProfileRoute() => PROFILE_SCREEN;
  static String getAddressRoute() => ADDRESS_SCREEN;
  static String getPaymentsRoute() => PAYMENT_METHODS_SCREEN;
  static String getCouponRoute() => COUPON_SCREEN;
  static String getSupportRoute() => SUPPORT_SCREEN;
  static String getTermsRoute() => TERMS_SCREEN;
  static String getPolicyRoute() => POLICY_SCREEN;
  static String getAboutUsRoute() => ABOUT_US_SCREEN;
  static String getPopularItemScreen() => POPULAR_ITEM_ROUTE;
  static String getReturnPolicyRoute() => RETURN_POLICY_SCREEN;
  static String getCancellationPolicyRoute() => CANCELLATION_POLICY_SCREEN;
  static String getRefundPolicyRoute() => REFUND_POLICY_SCREEN;
  static String getBranchListScreen() => BRANCH_LIST_SCREEN;

  static String getLanguageRoute(String page) => '$LANGUAGE_SCREEN?page=$page';
  static String getNewPassRoute(String email, String token) => '$CREATE_NEW_PASS_SCREEN?email=$email&token=$token';
  static String getVerifyRoute(String page, String email) {
    String email0 = base64Encode(utf8.encode(email));
    return '$VERIFY?page=$page&email=$email0';
  }

  static String getHomeRoute({required String? fromAppBar}) {
    String appBar = fromAppBar ?? 'false';
    return '$HOME_SCREEN?from=$appBar';
  }

  static String getDashboardRoute(String page) => '$DASHBOARD_SCREEN?page=$page';

  static String getCategoryRoute(index) => '$CATEGORY_SCREEN?selectedIndex=$index';
  static String getCheckoutRoute(double amount, String page, String type, String code) {
    String amount0 = base64Url.encode(utf8.encode(amount.toString()));
    return '$CHECKOUT_SCREEN?amount=$amount0&page=$page&type=$type&code=$code';
  }

  static String getPaymentRoute({
    required String page,
    String? id,
    int? user,
    String? selectAddress,
    PlaceOrderBody? placeOrderBody,
  }) {
    String address = selectAddress != null ? base64Encode(utf8.encode(selectAddress)) : 'null';
    String data = placeOrderBody != null ? base64Url.encode(utf8.encode(jsonEncode(placeOrderBody.toJson()))) : 'null';
    return '$PAYMENT_SCREEN?page=$page&id=$id&user=$user&address=$address&place_order=$data';
  }

  static String getOrderDetailsRoute(int id) => '$ORDER_DETAILS_SCREEN?id=$id';
  static String getRateReviewRoute() => RATE_SCREEN;
  static String getOrderTrackingRoute(int id) => '$ORDER_TRACKING_SCREEN?id=$id';
  static String getMapRoute(AddressModel addressModel) {
    List<int> encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String data = base64Encode(encoded);
    return '$MAP_SCREEN?address=$data';
  }

  static String getAddAddressRoute(String page, String action, AddressModel addressModel, {double? amount}) {
    String data = base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$ADD_ADDRESS_SCREEN?page=$page&action=$action&address=$data&amount=$amount';
  }

  static String getSelectLocationRoute() => SELECT_LOCATION_SCREEN;
  static String getChatRoute({OrderModel? orderModel}) {
    String orderModel0 = base64Encode(utf8.encode(jsonEncode(orderModel)));
    return '$CHAT_SCREEN?order=$orderModel0';
  }
}
