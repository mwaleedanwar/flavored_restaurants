import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';

class ThanksFeedbackScreen extends StatelessWidget {
  const ThanksFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: Center(
        child: SizedBox(
          width: 1170,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Images.done_with_full_background,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 60),
                Text(
                  'Thanks for your Feedback',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: ColorResources.getGreyBunkerColor(context),
                      ),
                ),
                const SizedBox(height: 23),
                Text(
                  getTranslated('it_will_helps_to_improve', context),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: ColorResources.getGreyBunkerColor(context).withOpacity(.75),
                      ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: CustomButton(
                    btnTxt: getTranslated('back_home', context),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routes.getMainRoute());
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
