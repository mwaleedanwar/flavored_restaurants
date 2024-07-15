// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:geolocator/geolocator.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: SizedBox(
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_location_alt_rounded, color: Theme.of(context).primaryColor, size: 100),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Text(
              getTranslated('you_denied_location_permission', context),
              textAlign: TextAlign.justify,
              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                    minimumSize: const Size(1, 50),
                  ),
                  child: Text(getTranslated('no', context)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                  child: CustomButton(
                      btnTxt: getTranslated('yes', context),
                      onTap: () async {
                        if (ResponsiveHelper.isMobilePhone()) {
                          await Geolocator.openAppSettings();
                        }
                        Navigator.pop(context);
                      })),
            ]),
          ]),
        ),
      ),
    );
  }
}
