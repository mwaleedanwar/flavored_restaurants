import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final String _countryDialCode = AppConstants.COUNTRY_CODE;

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
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(
              context: context,
              title: getTranslated('forgot_password', context),
            ),
      body: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
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
                        builder: (context, auth, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 55),
                              Center(
                                child: Image.asset(
                                  Images.close_lock,
                                  width: 142,
                                  height: 142,
                                ),
                              ),
                              const SizedBox(height: 40),
                              Provider.of<SplashProvider>(context, listen: false).configModel!.phoneVerification
                                  ? Center(
                                      child: Text(
                                      getTranslated('please_enter_your_mobile_number_to', context),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(color: ColorResources.getHintColor(context)),
                                    ))
                                  : Center(
                                      child: Text(
                                      getTranslated('please_enter_your_number_to', context),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(color: ColorResources.getHintColor(context)),
                                    )),
                              Provider.of<SplashProvider>(context, listen: false).configModel!.phoneVerification
                                  ? Padding(
                                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 80),
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
                                            controller: _phoneNumberController,
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
                                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                                  color: ColorResources.COLOR_GREY_CHATEAU),
                                              filled: true,
                                              prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          !auth.isForgotPasswordLoading
                                              ? CustomButton(
                                                  btnTxt: getTranslated('send', context),
                                                  onTap: () {
                                                    if (_phoneNumberController.text.isEmpty) {
                                                      showCustomSnackBar(
                                                          getTranslated('enter_phone_number', context), context);
                                                    } else {
                                                      Provider.of<AuthProvider>(context, listen: false)
                                                          .forgetPassword(AppConstants.country_code +
                                                              _phoneNumberController.text
                                                                  .replaceAll(RegExp('[()\\-\\s]'), ''))
                                                          .then((value) {
                                                        if (value.isSuccess) {
                                                          Navigator.pushNamed(
                                                              context,
                                                              Routes.getVerifyRoute(
                                                                  'forget-password',
                                                                  AppConstants.country_code +
                                                                      _phoneNumberController.text
                                                                          .replaceAll(RegExp('[()\\-\\s]'), '')));
                                                        } else {
                                                          showCustomSnackBar(value.message, context);
                                                        }
                                                      });
                                                    }
                                                  },
                                                )
                                              : Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                          Theme.of(context).primaryColor))),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 80),
                                          Text(
                                            getTranslated('email', context),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(color: ColorResources.getHintColor(context)),
                                          ),
                                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                          CustomTextField(
                                            hintText: 'Enter your email',
                                            isShowBorder: true,
                                            controller: _emailController,
                                            inputType: TextInputType.emailAddress,
                                            inputAction: TextInputAction.done,
                                          ),
                                          const SizedBox(height: 24),
                                          !auth.isForgotPasswordLoading
                                              ? CustomButton(
                                                  btnTxt: getTranslated('send', context),
                                                  onTap: () {
                                                    debugPrint(Provider.of<SplashProvider>(context, listen: false)
                                                        .configModel!
                                                        .phoneVerification
                                                        .toString());
                                                    if (Provider.of<SplashProvider>(context, listen: false)
                                                        .configModel!
                                                        .phoneVerification) {
                                                      if (_phoneNumberController.text.isEmpty) {
                                                        showCustomSnackBar(
                                                            getTranslated('enter_phone_number', context), context);
                                                      } else {
                                                        Provider.of<AuthProvider>(context, listen: false)
                                                            .forgetPassword(
                                                                _countryDialCode + _phoneNumberController.text.trim())
                                                            .then((value) {
                                                          if (value.isSuccess) {
                                                            Navigator.pushNamed(
                                                                context,
                                                                Routes.getVerifyRoute(
                                                                    'forget-password',
                                                                    _countryDialCode +
                                                                        _phoneNumberController.text.trim()));
                                                          } else {
                                                            showCustomSnackBar(value.message, context);
                                                          }
                                                        });
                                                      }
                                                    } else {
                                                      if (_emailController.text.isEmpty) {
                                                        showCustomSnackBar(
                                                            getTranslated('enter_email_address', context), context);
                                                      } else if (!_emailController.text.contains('@')) {
                                                        showCustomSnackBar(
                                                            getTranslated('enter_valid_email', context), context);
                                                      } else {
                                                        Provider.of<AuthProvider>(context, listen: false)
                                                            .forgetPassword(_emailController.text)
                                                            .then((value) {
                                                          if (value.isSuccess) {
                                                            Navigator.pushNamed(
                                                                context,
                                                                Routes.getVerifyRoute(
                                                                    'forget-password', _emailController.text));
                                                          } else {
                                                            showCustomSnackBar(
                                                                getTranslated('customer_not_found', context), context);
                                                          }
                                                        });
                                                      }
                                                    }
                                                  },
                                                )
                                              : Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                          Theme.of(context).primaryColor))),
                                        ],
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (ResponsiveHelper.isDesktop(context)) const FooterView()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
