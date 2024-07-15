// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/social_login_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginWidget extends StatefulWidget {
  const SocialLoginWidget({super.key});

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  SocialLoginModel? socialLogin;

  void route(
    bool isRoute,
    String? token,
    String? temporaryToken,
    String errorMessage,
  ) async {
    if (isRoute) {
      if (token != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.getDashboardRoute('home'),
          (route) => false,
        );
      } else if (temporaryToken != null && temporaryToken.isNotEmpty) {
        if (Provider.of<SplashProvider>(context, listen: false).configModel!.emailVerification) {
          Provider.of<AuthProvider>(context, listen: false).checkEmail(socialLogin?.email ?? '').then((value) async {
            if (value.isSuccess) {
              Provider.of<AuthProvider>(context, listen: false).updateEmail((socialLogin?.email).toString());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => VerificationScreen(
                            emailAddress: socialLogin!.email,
                            fromSignUp: true,
                          )),
                  (route) => false);
            }
          });
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => const VerificationScreen(
                      emailAddress: '',
                      fromSignUp: true,
                    )),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final socialStatus = Provider.of<SplashProvider>(context, listen: false).configModel!.socialLoginStatus;
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Column(children: [
        Center(
            child: Text(getTranslated('sign_in_with', context),
                style: poppinsRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                    fontSize: Dimensions.FONT_SIZE_SMALL))),
        const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (socialStatus?.isGoogle ?? false)
            InkWell(
              onTap: () async {
                try {
                  GoogleSignInAuthentication? auth = await authProvider.googleLogin();
                  GoogleSignInAccount? googleAccount = authProvider.googleAccount;

                  debugPrint('---------------google ----------- ${googleAccount?.email}');
                  debugPrint('---------------display name ----------- ${googleAccount?.displayName}');
                  debugPrint('---------------photoUrl ----------- ${googleAccount?.photoUrl}');
                  debugPrint('---------------token ----------- ${auth?.idToken}');
                  debugPrint('---------------uniq id ----------- ${googleAccount?.id}');

                  Provider.of<AuthProvider>(context, listen: false).socialLogin(
                      SocialLoginModel(
                          email: googleAccount!.email,
                          token: auth!.idToken!,
                          uniqueId: googleAccount.id,
                          medium: 'google',
                          firstName: googleAccount.displayName!.split(' ')[0],
                          lastName: googleAccount.displayName!.split(' ')[1],
                          restaurantId: F.restaurantId.toString()),
                      route);
                } catch (er) {
                  debugPrint('access token error is : $er');
                }
              },
              child: Container(
                height: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                width: ResponsiveHelper.isDesktop(context)
                    ? 130
                    : ResponsiveHelper.isTab(context)
                        ? 110
                        : 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.RADIUS_DEFAULT)),
                ),
                child: Image.asset(
                  Images.google,
                  height: ResponsiveHelper.isDesktop(context)
                      ? 30
                      : ResponsiveHelper.isTab(context)
                          ? 25
                          : 20,
                  width: ResponsiveHelper.isDesktop(context)
                      ? 30
                      : ResponsiveHelper.isTab(context)
                          ? 25
                          : 20,
                ),
              ),
            ),
        ]),
        const SizedBox(
          height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
        ),
      ]);
    });
  }
}
