// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/email_checker.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: WebAppBar(),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Center(
                      child: Container(
                        width: width > 700 ? 700 : width,
                        padding: width > 700 ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                        decoration: width > 700
                            ? BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 1)],
                              )
                            : null,
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: ResponsiveHelper.isWeb()
                                      ? Consumer<SplashProvider>(
                                          builder: (context, splash, child) => FadeInImage.assetNetwork(
                                            placeholder: Images.placeholder_rectangle,
                                            height: MediaQuery.of(context).size.height / 4.5,
                                            image: splash.baseUrls != null
                                                ? '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}'
                                                : '',
                                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle,
                                                height: MediaQuery.of(context).size.height / 4.5),
                                          ),
                                        )
                                      : Image.asset(
                                          F.logo,
                                          matchTextDirection: true,
                                          height: MediaQuery.of(context).size.height / 4.5,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                  child: Text(
                                getTranslated('signup', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                              )),
                              const SizedBox(height: 35),

                              Text(
                                getTranslated('mobile_number', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              MaskedTextField(
                                mask: AppConstants.phone_form,
                                controller: _numberController,
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                    fontSize: Dimensions.FONT_SIZE_LARGE),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                                  ),
                                  isDense: true,
                                  hintText: AppConstants.phone_form_hint,
                                  fillColor: Theme.of(context).cardColor,
                                  hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_GREY_CHATEAU),
                                  filled: true,
                                  prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.verificationMessage?.isNotEmpty ?? false
                                      ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                      : const SizedBox.shrink(),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.verificationMessage ?? "",
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  )
                                ],
                              ),
                              // for continue button
                              const SizedBox(height: 12),
                              !authProvider.isPhoneNumberVerificationButtonLoading
                                  ? CustomButton(
                                      btnTxt: getTranslated('continue', context),
                                      onTap: () {
                                        if (Provider.of<SplashProvider>(context, listen: false)
                                            .configModel!
                                            .emailVerification) {
                                          // String countryCode;
                                          String email = _emailController.text.trim();

                                          if (email.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                          } else if (EmailChecker.isNotValid(email)) {
                                            showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                                          } else {
                                            authProvider.checkEmail(email).then((value) async {
                                              if (value.isSuccess) {
                                                authProvider.updateEmail(email);
                                                if (value.message == 'active') {
                                                  Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', email));
                                                } else {
                                                  Navigator.pushNamed(context, Routes.getCreateAccountRoute());
                                                }
                                              }
                                            });
                                          }
                                        } else {
                                          // String countryCode;
                                          String numberChk = _numberController.text.trim();

                                          if (numberChk.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                          } else {
                                            // authProvider.verifyOtp(phone, otp, context)
                                          }
                                        }
                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    )),

                              // for create an account
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated('already_have_account', context),
                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.getGreyColor(context)),
                                      ),
                                      const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                      Text(
                                        getTranslated('login', context),
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.getGreyBunkerColor(context)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
