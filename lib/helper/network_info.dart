import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  static void checkConnectivity(GlobalKey<ScaffoldMessengerState> globalKey) {
    bool firstTime = true;
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      if (!firstTime) {
        bool isNotConnected = result.first != ConnectivityResult.wifi && result.first != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : globalKey.currentState?.hideCurrentSnackBar();
        globalKey.currentState?.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', globalKey.currentContext!)
                : getTranslated('connected', globalKey.currentContext!),
            textAlign: TextAlign.center,
          ),
        ));
      }
      firstTime = false;
    });
  }
}
