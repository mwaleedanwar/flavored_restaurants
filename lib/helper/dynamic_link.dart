import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:share_plus/share_plus.dart';

class DynamicLinkHelp {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  void inItDynamicLinkData(context) async {
    dynamicLinks.onLink.listen((dynamicLink) {
      if (dynamicLink.android != null || dynamicLink.ios != null) {
        handleUri(dynamicLink.link, context);
      }
    }).onError((error) {
      debugPrint('onLink error');
      debugPrint(error.message);
    });
  }

  void handleUri(Uri uri, context) async {
    List<String> separatedLink = [];
    separatedLink.addAll(uri.path.split('/'));
    Navigator.pushNamed(context, Routes.getLoginRoute());
  }

  buildDynamicLinks(
    String title,
    String code,
    String description,
  ) async {
    debugPrint('=dynamicm staet');
    String url = "http://Nopal Dos.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/$code'),
      androidParameters: const AndroidParameters(
        packageName: "com.nopal.app",
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.nopal.app",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        description: 'Use This Coupon $code: ',
        title: title,
      ),
    );
    final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);

    String desc = shortLink.shortUrl.toString();
    debugPrint('=dynamicm shet');

    await Share.share(
      'Link:$desc\n$description',
      subject: title,
    );
  }
}
