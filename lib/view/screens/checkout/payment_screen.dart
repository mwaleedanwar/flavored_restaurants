import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/place_order_body.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/checkout/widget/cancel_dialog.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final bool fromCheckout;
  final String url;
  final PlaceOrderBody? placeOrderBody;
  const PaymentScreen({
    super.key,
    this.orderModel,
    required this.fromCheckout,
    required this.url,
    this.placeOrderBody,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;
  late PullToRefreshController pullToRefreshController;
  late MyInAppBrowser browser;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    selectedUrl = widget.fromCheckout
        ? '${F.BASE_URL}/payment-mobile?token=${widget.url}'
        : '${F.BASE_URL}/payment-mobile?customer_id=${widget.orderModel!.userId}&order_id=${widget.orderModel!.id}';

    _initData();
  }

  void _initData() async {
    // browser = MyInAppBrowser(context, widget.placeOrderBody,
    //     orderModel: widget.orderModel);
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      bool swAvailable =
          await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable =
          await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController = AndroidServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            debugPrint(request.toString());
            return null;
          },
        ));
      }
    }

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          browser.webViewController.reload();
        } else if (Platform.isIOS) {
          browser.webViewController.loadUrl(urlRequest: URLRequest(url: await browser.webViewController.getUrl()));
        }
      },
    );
    browser.pullToRefreshController = pullToRefreshController;

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: Uri.parse(selectedUrl)),
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
        ),
      ),
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => showDialog(
        context: context,
        builder: (context) => CancelDialog(orderID: widget.orderModel!.id),
      ),
      child: Scaffold(
        appBar: CustomAppBar(
            context: context,
            title: getTranslated('PAYMENT', context),
            onBackPressed: () => CancelDialog(orderID: widget.orderModel!.id)),
        body: Center(
          child: loading
              ? const CircularProgressIndicator.adaptive()
              : Stack(
                  children: [
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  final OrderModel orderModel;
  final bool fromCheckout;
  final BuildContext context;
  final PlaceOrderBody placeOrderBody;
  MyInAppBrowser(
    this.context,
    this.placeOrderBody, {
    required this.orderModel,
    super.windowId,
    super.initialUserScripts,
    required this.fromCheckout,
  });

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    debugPrint("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {
    debugPrint("===\n\nStarted: $url\n\n");
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    debugPrint("\n\nStopped: $url\n\n");
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    debugPrint("Can't load [$url] Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    debugPrint("Progress: $progress");
  }

  @override
  void onExit() {
    if (_canRedirect) {
      Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${orderModel.id}/payment-fail');
    }

    debugPrint("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    debugPrint("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onConsoleMessage(consoleMessage) {
    debugPrint("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
  }

  void _pageRedirect(String url) {
    if (_canRedirect) {
      bool isSuccess = url.contains('success') && url.contains('${F.BASE_URL}${Routes.ORDER_SUCCESS_SCREEN}');
      bool isFailed = url.contains('fail') && url.contains('${F.BASE_URL}${Routes.ORDER_SUCCESS_SCREEN}');
      bool isCancel = url.contains('cancel') && url.contains('${F.BASE_URL}${Routes.ORDER_SUCCESS_SCREEN}');
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }
      if (isSuccess) {
        String? token = url.replaceAll('${F.BASE_URL}${Routes.ORDER_SUCCESS_SCREEN}/success?token=', '');
        if (token.isNotEmpty) {
          String decodeValue = utf8.decode(base64Url.decode(token.replaceAll(' ', '+')));
          String paymentMethod = decodeValue.substring(0, decodeValue.indexOf('&&'));
          String transactionReference =
              decodeValue.substring(decodeValue.indexOf('&&') + '&&'.length, decodeValue.length);
          PlaceOrderBody tempPlaceOrderBody = placeOrderBody.copyWith(
            paymentMethod: paymentMethod.replaceAll('payment_method=', ''),
            transactionReference: transactionReference.replaceAll('transaction_reference=', ''),
          );
          Provider.of<OrderProvider>(context, listen: false).placeOrder(tempPlaceOrderBody, _callback);
        } else {
          Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${orderModel.id}/payment-fail');
        }
      } else if (isFailed) {
        Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${orderModel.id}/payment-fail');
      } else if (isCancel) {
        Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${orderModel.id}/payment-cancel');
      }
    }
  }

  void _callback(bool isSuccess, String message, String orderID, int addressID) async {
    Provider.of<CartProvider>(context, listen: false).clearCartList();
    Provider.of<OrderProvider>(context, listen: false).stopLoader();
    if (isSuccess) {
      Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/success');
    } else {
      showCustomSnackBar(message, context);
    }
  }
}
