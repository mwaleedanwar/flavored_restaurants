import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../../../provider/coupon_provider.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  const SignOutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Consumer<AuthProvider>(builder: (context, auth, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Center(
                  child: Icon(
                Icons.contact_support,
                size: 50,
                color: Colors.white,
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Text(getTranslated('want_to_sign_out', context),
                  style: rubikBold, textAlign: TextAlign.center),
            ),
            Container(height: 0.5, color: Theme.of(context).hintColor),
            !auth.isLoading
                ? Row(children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .clearSharedData()
                            .then((condition) {
                          Provider.of<CouponProvider>(context, listen: false)
                              .gift = null;
                          if (ResponsiveHelper.isWeb()) {
                            Navigator.pushNamedAndRemoveUntil(context,
                                Routes.getLoginRoute(), (route) => false);
                          } else {
                            Navigator.pushNamedAndRemoveUntil(context,
                                Routes.getLoginRoute(), (route) => false);
                          }
                        });
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10))),
                        child: Text(getTranslated('yes', context),
                            style: rubikBold.copyWith(
                                color: Theme.of(context).primaryColor)),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding:
                            const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(getTranslated('no', context),
                            style: rubikBold.copyWith(color: Colors.white)),
                      ),
                    )),
                  ])
                : Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)),
                  ),
          ]);
        }),
      ),
    );
  }
}
