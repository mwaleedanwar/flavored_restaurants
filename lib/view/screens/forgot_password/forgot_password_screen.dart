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
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/auth/widget/code_picker_widget.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  String _countryDialCode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
    // _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : CustomAppBar(context: context, title: getTranslated('forgot_password', context)),
      body: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Container(
                      width: _width > 700 ? 700 : _width,
                      padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                      decoration: _width > 700
                          ? BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                            )
                          : null,
                      child: Consumer<AuthProvider>(
                        builder: (context, auth, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 55),
                              Center(
                                child: Image.asset(
                                  Images.close_lock,
                                  width: 142,
                                  height: 142,
                                ),
                              ),
                              SizedBox(height: 40),
                              Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification
                                  ? Center(
                                      child: Text(
                                      getTranslated('please_enter_your_mobile_number_to', context),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(color: ColorResources.getHintColor(context)),
                                    ))
                                  : Center(
                                      child: Text(
                                      getTranslated('please_enter_your_number_to', context),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(color: ColorResources.getHintColor(context)),
                                    )),
                              Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification
                                  ? Padding(
                                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 80),
                                          Text(
                                            getTranslated('mobile_number', context),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(color: ColorResources.getHintColor(context)),
                                          ),
                                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                          // Row(children: [
                                          //   // CodePickerWidget(
                                          //   //   onChanged: (CountryCode countryCode) {
                                          //   //     _countryDialCode = countryCode.dialCode;
                                          //   //   },
                                          //   //   initialSelection: _countryDialCode,
                                          //   //   favorite: [_countryDialCode],
                                          //   //   showDropDownButton: true,
                                          //   //   padding: EdgeInsets.zero,
                                          //   //   textStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),
                                          //   //   showFlagMain: true,
                                          //   //
                                          //   // ),
                                          //   Expanded(child: CustomTextField(
                                          //     hintText: getTranslated('number_hint', context),
                                          //     isShowBorder: true,
                                          //     controller: _phoneNumberController,
                                          //     inputType: TextInputType.phone,
                                          //     inputAction: TextInputAction.done,
                                          //   ),),
                                          // ]),
                                          MaskedTextField(
                                            mask: AppConstants.phone_form,
                                            controller: _phoneNumberController,
                                            style: Theme.of(context).textTheme.headline2.copyWith(
                                                color: Theme.of(context).textTheme.bodyText1.color,
                                                fontSize: Dimensions.FONT_SIZE_LARGE),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: BorderSide(style: BorderStyle.none, width: 0),
                                              ),
                                              isDense: true,
                                              hintText: AppConstants.phone_form_hint,
                                              fillColor: Theme.of(context).cardColor,
                                              hintStyle: Theme.of(context).textTheme.headline2.copyWith(
                                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                                  color: ColorResources.COLOR_GREY_CHATEAU),
                                              filled: true,
                                              prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
                                            ),
                                          ),

                                          SizedBox(height: 24),
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
                                          SizedBox(height: 80),
                                          Text(
                                            getTranslated('email', context),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(color: ColorResources.getHintColor(context)),
                                          ),
                                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                          CustomTextField(
                                            hintText: 'Enter your email',
                                            isShowBorder: true,
                                            controller: _emailController,
                                            inputType: TextInputType.emailAddress,
                                            inputAction: TextInputAction.done,
                                          ),
                                          SizedBox(height: 24),
                                          !auth.isForgotPasswordLoading
                                              ? CustomButton(
                                                  btnTxt: getTranslated('send', context),
                                                  onTap: () {
                                                    print(Provider.of<SplashProvider>(context, listen: false)
                                                        .configModel
                                                        .phoneVerification);
                                                    if (Provider.of<SplashProvider>(context, listen: false)
                                                        .configModel
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
                if (ResponsiveHelper.isDesktop(context)) FooterView()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
