import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';

import '../../../base/custom_dialog.dart';
import '../../refer_and_earn/refer_and_earn_screen.dart';

class OptionsView extends StatelessWidget {
  const OptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final policyModel = Provider.of<SplashProvider>(context, listen: false).policyModel;

    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: SizedBox(
            width: ResponsiveHelper.isTab(context) ? null : 1170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ResponsiveHelper.isTab(context) ? 50 : 0),
                SwitchListTile(
                  value: Provider.of<ThemeProvider>(context).darkTheme,
                  onChanged: (bool isActive) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                  title: Text(getTranslated('dark_theme', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  activeColor: Theme.of(context).primaryColor,
                ),
                isLoggedIn
                    ? const SizedBox()
                    : ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.getLoginRoute());
                        },
                        leading: Image.asset(Images.login,
                            width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                        title: Text(getTranslated('login', context),
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ),
                ResponsiveHelper.isTab(context)
                    ? ListTile(
                        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('home')),
                        leading: Image.asset(Images.home,
                            width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                        title: Text(getTranslated('home', context),
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      )
                    : const SizedBox(),
                ListTile(
                  onTap: () {
                    if (isLoggedIn) {
                      Navigator.pushNamed(context, Routes.getProfileRoute());
                    } else {
                      Navigator.pushNamed(context, Routes.getLoginRoute());
                    }
                  },
                  leading: Image.asset(Images.profile,
                      width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                  title: Text(getTranslated('profile', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                isLoggedIn
                    ? ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.getBranchListScreen(false));
                        },
                        leading: Image.asset(Images.referral_icon,
                            width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                        title: Text('Choose Store', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      )
                    : const SizedBox.shrink(),
                isLoggedIn
                    ? (ResponsiveHelper.isDesktop(context)
                        ? ListTile(
                            onTap: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                            leading: Image.asset(Images.notification,
                                width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                            title: Text('Inbox', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          )
                        : ListTile(
                            onTap: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                            leading: Image.asset(Images.notification,
                                width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                            title: Text('Inbox', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ))
                    : const SizedBox.shrink(),
                isLoggedIn
                    ? ListTile(
                        onTap: () {
                          if (isLoggedIn) {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const ReferAndEarnScreen()));
                          } else {
                            Navigator.pushNamed(context, Routes.getLoginRoute());
                          }
                        },
                        leading: Image.asset(Images.referral_icon,
                            width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                        title: Text('Refer & Earn', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      )
                    : const SizedBox.shrink(),
                ListTile(
                  onTap: () {
                    if (isLoggedIn) {
                      Navigator.pushNamed(context, Routes.getCouponRoute());
                    } else {
                      Navigator.pushNamed(context, Routes.getLoginRoute());
                    }
                  },
                  leading: Image.asset(Images.coupon,
                      width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                  title: Text(getTranslated('coupon', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getSupportRoute()),
                  leading: SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        Images.help_support,
                        color: ColorResources.getWhiteAndBlack(context),
                      )),
                  title: Text('Support & Feedback', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
                  leading: SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        Images.privacy_policy,
                        color: ColorResources.getWhiteAndBlack(context),
                      )),
                  title: Text(getTranslated('privacy_policy', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
                  leading: SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        Images.terms_and_condition,
                        color: ColorResources.getWhiteAndBlack(context),
                      )),
                  title: Text(getTranslated('terms_and_condition', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                if (policyModel != null && policyModel.returnPage != null && policyModel.returnPage!.status)
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, Routes.getReturnPolicyRoute()),
                    leading: Image.asset(Images.returnPolicy,
                        width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                    title: Text(getTranslated('return_policy', context),
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                if (policyModel != null && policyModel.refundPage != null && policyModel.refundPage!.status)
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, Routes.getRefundPolicyRoute()),
                    leading: Image.asset(Images.refundPolicy,
                        width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                    title: Text(getTranslated('refund_policy', context),
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                if (policyModel != null && policyModel.cancellationPage != null && policyModel.cancellationPage!.status)
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, Routes.getCancellationPolicyRoute()),
                    leading: Image.asset(Images.cancellationPolicy,
                        width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                    title: Text(getTranslated('cancellation_policy', context),
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
                  leading: SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        Images.about_us,
                        color: ColorResources.getWhiteAndBlack(context),
                      )),
                  title: Text(getTranslated('about_us', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                isLoggedIn
                    ? ListTile(
                        onTap: () {
                          showAnimatedDialog(context, Consumer<AuthProvider>(builder: (context, authProvider, _) {
                            return WillPopScope(
                                onWillPop: () async => !authProvider.isLoading,
                                child: authProvider.isLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : CustomDialog(
                                        icon: Icons.question_mark_sharp,
                                        title: getTranslated('are_you_sure_to_delete_account', context),
                                        description: getTranslated('it_will_remove_your_all_information', context),
                                        buttonTextTrue: getTranslated('yes', context),
                                        buttonTextFalse: getTranslated('no', context),
                                        onTapTrue: () =>
                                            Provider.of<AuthProvider>(context, listen: false).deleteUser(context),
                                        onTapFalse: () => Navigator.of(context).pop(),
                                      ));
                          }), dismissible: false, isFlip: true);
                        },
                        leading:
                            Icon(Icons.delete_outline, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                        title: Text(getTranslated('delete_account', context),
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      )
                    : const SizedBox(),
                !isLoggedIn
                    ? const SizedBox()
                    : ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const SignOutConfirmationDialog());
                        },
                        leading: Icon(
                          Icons.logout,
                          size: 20,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        title: Text(
                          getTranslated('logout', context),
                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
