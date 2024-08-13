import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/signup_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';

import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';

class CreateAccountScreen extends StatefulWidget {
  final String? referalCode;

  const CreateAccountScreen({super.key, this.referalCode});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referTextController = TextEditingController();

  final upper = RegExp(r'(?=.*[A-Z])\w+');
  final number = RegExp(r'[0-9]');
  final lower = RegExp(r'(?=.*[a-z])\w+');
  bool isChecked = true;
  bool isCodeSent = false;
  bool isAlreadyExist=true;
  String button='Sign Up';

  @override
  void initState() {
    super.initState();
    _referTextController.text = widget.referalCode ?? '';
    debugPrint('number --${_numberController.text}');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: WebAppBar(),
            )
          : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                child: Center(
                  child: Container(
                    width: width > 700 ? 700 : width,
                    padding: width > 700 ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                    decoration: width > 700
                        ? BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                spreadRadius: 1,
                              )
                            ],
                          )
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          getTranslated('create_account', context),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 24,
                                color: ColorResources.getGreyBunkerColor(context),
                              ),
                        )),
                        SizedBox(height: isCodeSent ? 20 : 120),
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
                            focusNode: _numberFocus,
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
                                  fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.COLOR_GREY_CHATEAU),
                              filled: true,
                              prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    _emailController.clear();
                                    _numberController.clear();
                                    button='Sign Up';

                                    isCodeSent = false;

                                    FocusScope.of(context).requestFocus(_numberFocus);
                                    setState(() {

                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: ColorResources.getGreyBunkerColor(context),
                                  )),
                            ),
                            onChanged: (number) {
                              if (_numberController.text.trim().length == 14) {
                                _numberFocus.unfocus();
                                FocusScope.of(context).requestFocus(_passwordFocus);
                                isCodeSent = true;

                                authProvider
                                    .checkPhone(
                                        AppConstants.country_code +
                                            _numberController.text.replaceAll(RegExp('[()\\-\\s]'), ''),
                                        context)
                                    .then((value) async {
                                  if (value.isSuccess) {
                                    if (value.message == 'active') {
                                      if(value.isExist==true){
                                        button='Login';
                                      }
                                      isAlreadyExist=value.isExist;

                                    }
                                  }
                                });
                              }
                            }),
                        SizedBox(height: isCodeSent == true ? Dimensions.PADDING_SIZE_SMALL : 0),
                        isCodeSent == true
                            ? MaskedTextField(
                            maxLength: 4,
                            controller: _passwordController,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                fontSize: Dimensions.FONT_SIZE_LARGE),
                            keyboardType: TextInputType.number,
                            focusNode: _passwordFocus,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                              ),
                              isDense: true,
                              hintText: '0000',
                              fillColor: Theme.of(context).cardColor,
                              hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: ColorResources.COLOR_GREY_CHATEAU),
                              filled: true,
                              prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
                            ),
                            onChanged: (otp) {

                              if(_passwordController.text.length == 4&& isAlreadyExist == true){



                                SignUpModel signupModel = SignUpModel(
                                  phone: AppConstants.country_code +
                                      _numberController.text.replaceAll(RegExp('[()\\-\\s]'), ''),
                                  token: _passwordController.text,
                                  restaurantId: F.restaurantId,

                                  isMobile: 'true',
                                );
                                authProvider.verifyOtp(signupModel, context).then((value) {
                                  if (value.isSuccess) {
                                    _passwordFocus.unfocus();
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, Routes.getMainRoute(), (route) => false);
                                  }
                                });


                              }}

                        )
                            : const SizedBox.shrink(),

                        isCodeSent == true
                            ? Center(
                            child: Text(
                              'A one-time verification code was sent to your phone and should arrive shortly. Didn\'t receive a code yet?',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: ColorResources.getGreyBunkerColor(context),
                              ),
                            ))
                            : const SizedBox.shrink(),

                        isCodeSent == true
                            ? InkWell(
                          onTap: () {},
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(
                              'Resend verification code',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: ColorResources.getGreyBunkerColor(context),
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        )
                            : const SizedBox.shrink(),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        isAlreadyExist == false&&isCodeSent
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated('first_name', context),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: 'first name',
                              isShowBorder: true,
                              controller: _firstNameController,
                              focusNode: _firstNameFocus,
                              nextFocus: _lastNameFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // for last name section
                            Text(
                              getTranslated('last_name', context),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                ?.emailVerification ??
                                false
                                ? CustomTextField(
                              hintText: 'first name',
                              isShowBorder: true,
                              controller: _lastNameController,
                              focusNode: _lastNameFocus,
                              nextFocus: _emailFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            )
                                : CustomTextField(
                              hintText: 'last name',
                              isShowBorder: true,
                              controller: _lastNameController,
                              focusNode: _lastNameFocus,
                              nextFocus: _emailFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // for email section

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
                              focusNode: _emailFocus,
                              nextFocus: _passwordFocus,
                              inputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              activeColor: Theme.of(context).primaryColor,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: isChecked,
                              onChanged: (val) {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                              title: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'By creating an account, you agree to our ',
                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                      ),
                                      TextSpan(
                                        text: 'terms & conditions',
                                        style: TextStyle(
                                            color: ColorResources.getHintColor(context),
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.w500),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(context, Routes.getTermsRoute());
                                          },
                                      ),
                                      TextSpan(
                                        text: ' and ',
                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                      ),
                                      TextSpan(
                                        text: 'privacy policy.',
                                        style: TextStyle(
                                            color: ColorResources.getHintColor(context),
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.w500),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(context, Routes.getPolicyRoute());
                                            // launch('http://cafescale.com/privacy-policy');
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )
                            : const SizedBox.shrink(),

                        // for signup button
                        const SizedBox(height: 10),
                        !authProvider.isLoading
                            ? CustomButton(
                                btnTxt:button,
                                onTap: () {
                                  String firstName = _firstNameController.text.trim();
                                  String lastName = _lastNameController.text.trim();
                                  String number = _numberController.text.trim();
                                  String email = _emailController.text.trim();
                                  String password = _passwordController.text.trim();

                                  if (firstName.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_first_name', context), context);
                                  } else if (lastName.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_last_name', context), context);
                                  } else if (number.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                  } else if (email.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                  } else if (password.isEmpty) {
                                    showCustomSnackBar('Enter otp', context);
                                  } else if (isChecked == false) {
                                    debugPrint('-=not');
                                    showCustomSnackBar('Accept terms and conditions', context);
                                  } else {
                                    SignUpModel signUpModel = SignUpModel(
                                        fName: firstName,
                                        lName: lastName,
                                        email: email,
                                        restaurantId: F.restaurantId,
                                        referralCode: _referTextController.text,
                                        password: _passwordController.text,
                                        platform: kIsWeb
                                            ? 'Web'
                                            : Platform.isAndroid
                                                ? 'Android'
                                                : 'iOS',
                                        phone: AppConstants.country_code + number.replaceAll(RegExp('[()\\-\\s]'), ''),
                                        token: password,
                                        isMobile: 'true');
                                    authProvider.verifyOtp(signUpModel, context).then((status) async {
                                      if (status.isSuccess) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Provider.of<SplashProvider>(context, listen: false)
                                                        .configModel
                                                        ?.branches
                                                        ?.length ==
                                                    1
                                                ? Routes.getMainRoute()
                                                : Routes.getBranchListScreen(true),
                                            (route) => false);
                                      }
                                    });
                                  }
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                              )),

                        // for already an account
                        const SizedBox(height: 11),
                     isCodeSent?const SizedBox.shrink():   InkWell(
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
          ),
        ),
      ),
    );
  }
}
