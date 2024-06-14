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
import '../../heart_points/heart_points.dart';
import '../../refer_and_earn/refer_and_earn_screen.dart';

class OptionsView extends StatelessWidget {
  final Function onTap;

  OptionsView({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final _policyModel = Provider.of<SplashProvider>(context, listen: false).policyModel;

    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
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
                _isLoggedIn
                    ? SizedBox()
                    : ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.getLoginRoute());
                        },
                        leading: Image.asset(Images.login,
                            width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                        title: Text(getTranslated('login', context),
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ),
                ResponsiveHelper.isTab(context)
                    ? ListTile(
                        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('home')),
                        leading: Image.asset(Images.home,
                            width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                        title: Text(getTranslated('home', context),
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      )
                    : SizedBox(),

                // ListTile(
                //   onTap: () => ResponsiveHelper.isMobilePhone() ? onTap(2) : Navigator.pushNamed(context, Routes.getDashboardRoute('order')),
                //   leading: Image.asset(Images.order, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                //   title: Text('Orders', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                // ),
                ListTile(
                  onTap: () {
                    if (_isLoggedIn) {
                      Navigator.pushNamed(context, Routes.getProfileRoute());
                    } else {
                      Navigator.pushNamed(context, Routes.getLoginRoute());
                    }
                  },
                  leading: Image.asset(Images.profile,
                      width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('profile', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                // ListTile(
                //   onTap: (){
                //     if (_isLoggedIn) {
                //       Navigator.pushNamed(context, Routes.getAddressRoute());
                //     } else {
                //       Navigator.pushNamed(
                //           context, Routes.getLoginRoute());
                //     }
                //   }
                //      ,
                //   leading: Image.asset(Images.location,
                //       width: 20,
                //       height: 20,
                //       color: Theme.of(context).textTheme.bodyText1.color),
                //   title: Text(getTranslated('address', context),
                //       style: rubikMedium.copyWith(
                //           fontSize: Dimensions.FONT_SIZE_LARGE)),
                // ),
                _isLoggedIn
                    ? ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.getBranchListScreen());
                        },
                        leading: Image.asset(Images.referral_icon,
                            width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                        title: Text('Choose Store', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      )
                    : SizedBox.shrink(),
                _isLoggedIn
                    ? (ResponsiveHelper.isDesktop(context)
                        ? ListTile(
                            onTap: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                            leading: Image.asset(Images.notification,
                                width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                            title: Text('Inbox', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          )
                        : ListTile(
                            onTap: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                            leading: Image.asset(Images.notification,
                                width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                            title: Text('Inbox', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ))
                    : SizedBox.shrink(),
//                 ListTile(
//                   onTap: () {
//                     if (_isLoggedIn) {
//                       Navigator.pushNamed(context, Routes.getPaymentsRoute());
//
//                     } else {
//                       Navigator.pushNamed(
//                           context, Routes.getLoginRoute());
//                     }
//                   }
// ,                  leading: Image.asset(Images.credit,
//                       width: 20,
//                       height: 20,
//                       color: Theme.of(context).textTheme.bodyText1.color),
//                   title: Text('Wallet',
//                       style: rubikMedium.copyWith(
//                           fontSize: Dimensions.FONT_SIZE_LARGE)),
//                 ),

                // ListTile(
                //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>HeartPointScreen())),
                //   leading: Image.asset(Images.trophy, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                //   title: Text('Loyalty Points', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                // ),
                _isLoggedIn
                    ? ListTile(
                        onTap: () {
                          if (_isLoggedIn) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ReferAndEarnScreen()));
                          } else {
                            Navigator.pushNamed(context, Routes.getLoginRoute());
                          }
                        },
                        leading: Image.asset(Images.referral_icon,
                            width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                        title: Text('Refer & Earn', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      )
                    : SizedBox.shrink(),
                ListTile(
                  onTap: () {
                    if (_isLoggedIn) {
                      Navigator.pushNamed(context, Routes.getCouponRoute());
                    } else {
                      Navigator.pushNamed(context, Routes.getLoginRoute());
                    }
                  },
                  leading: Image.asset(Images.coupon,
                      width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                  title: Text(getTranslated('coupon', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),

                // ListTile(
                //   onTap: () => Navigator.pushNamed(context, Routes.getLanguageRoute('menu')),
                //   leading: Image.asset(Images.language, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                //   title: Text(getTranslated('language', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                // ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getSupportRoute()),
                  leading: Container(
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
                  leading: Container(
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
                  leading: Container(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        Images.terms_and_condition,
                        color: ColorResources.getWhiteAndBlack(context),
                      )),
                  title: Text(getTranslated('terms_and_condition', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),

                if (_policyModel != null && _policyModel.returnPage != null && _policyModel.returnPage.status)
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, Routes.getReturnPolicyRoute()),
                    leading: Image.asset(Images.returnPolicy,
                        width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                    title: Text(getTranslated('return_policy', context),
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),

                if (_policyModel != null && _policyModel.refundPage != null && _policyModel.refundPage.status)
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, Routes.getRefundPolicyRoute()),
                    leading: Image.asset(Images.refundPolicy,
                        width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                    title: Text(getTranslated('refund_policy', context),
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                if (_policyModel != null &&
                    _policyModel.cancellationPage != null &&
                    _policyModel.cancellationPage.status)
                  ListTile(
                    onTap: () => Navigator.pushNamed(context, Routes.getCancellationPolicyRoute()),
                    leading: Image.asset(Images.cancellationPolicy,
                        width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                    title: Text(getTranslated('cancellation_policy', context),
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),

                ListTile(
                  onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
                  leading: Container(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        Images.about_us,
                        color: ColorResources.getWhiteAndBlack(context),
                      )),
                  title: Text(getTranslated('about_us', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
                //
                // ListTile(
                //   leading: Image.asset(Images.version, width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                //   title: Text('${getTranslated('version', context)}', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                //   trailing: Text('${Provider.of<SplashProvider>(context, listen: false).configModel.softwareVersion ?? ''}', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                //   //
                // ),

                _isLoggedIn
                    ? ListTile(
                        onTap: () {
                          showAnimatedDialog(context, Consumer<AuthProvider>(builder: (context, authProvider, _) {
                            return WillPopScope(
                                onWillPop: () async => !authProvider.isLoading,
                                child: authProvider.isLoading
                                    ? Center(child: CircularProgressIndicator())
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
                            Icon(Icons.delete_outline, size: 20, color: Theme.of(context).textTheme.bodyText1.color),
                        title: Text(getTranslated('delete_account', context),
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      )
                    : SizedBox(),

                !_isLoggedIn
                    ? SizedBox()
                    : ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => SignOutConfirmationDialog());
                        },
                        leading: Image.asset(Images.log_out,
                            width: 20, height: 20, color: Theme.of(context).textTheme.bodyText1.color),
                        title: Text(getTranslated('logout', context),
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
