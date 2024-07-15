// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              Images.update,
              width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              getTranslated('your_app_is_deprecated', context),
              style: rubikRegular.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            CustomButton(
                btnTxt: getTranslated('update_now', context),
                onTap: () async {
                  String? appUrl = 'https://google.com';
                  if (Platform.isAndroid) {
                    appUrl = splashProvider.configModel?.playStoreConfig?.link;
                  } else if (Platform.isIOS) {
                    appUrl = splashProvider.configModel?.appStoreConfig?.link;
                  }
                  if (await canLaunchUrl(Uri.parse(appUrl ?? ''))) {
                    launchUrl(Uri.parse(appUrl!));
                  } else {
                    showCustomSnackBar(
                        '${getTranslated('can_not_launch', context)} $appUrl',
                        context);
                  }
                }),
          ]),
        ),
      ),
    );
  }
}
