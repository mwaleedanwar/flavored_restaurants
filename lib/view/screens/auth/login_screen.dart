import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:intl_phone_field_with_validator/intl_phone_field.dart';
import 'package:masked_text/masked_text.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/auth/widget/social_login_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/signup_model.dart';
import '../../../utill/app_constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _emailNumberFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKeyLogin;
  bool isCodeSent = false;
  bool isAlreadyExsist = true;
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.text = Provider.of<AuthProvider>(context, listen: false).getUserNumber() ?? '';
    _passwordController.text = Provider.of<AuthProvider>(context, listen: false).getUserPassword() ?? '';
    // _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final _socialStatus = Provider.of<SplashProvider>(context, listen: false).configModel.socialLoginStatus;

    return Scaffold(
      // backgroundColor: Colors.white.withOpacity(0.8),

      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : null,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  child: Center(
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
                        builder: (context, authProvider, child) => Form(
                          key: _formKeyLogin,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset(
                                    F.logo,
                                    height: MediaQuery.of(context).size.height / 4.5,
                                    fit: BoxFit.scaleDown,
                                    matchTextDirection: true,
                                  ),
                                ),
                              ),
                              Center(
                                  child: Text(
                                getTranslated('login', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                              )),
                              SizedBox(height: 30),
                              Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification
                                  ? Text(
                                      getTranslated('email', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(color: ColorResources.getHintColor(context)),
                                    )
                                  : Text(
                                      getTranslated('mobile_number', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(color: ColorResources.getHintColor(context)),
                                    ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              MaskedTextField(
                                  mask: AppConstants.phone_form,
                                  controller: _numberController,
                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                      color: Theme.of(context).textTheme.bodyText1.color,
                                      fontSize: Dimensions.FONT_SIZE_LARGE),
                                  keyboardType: TextInputType.number,
                                  focusNode: _emailNumberFocus,
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
                                        fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.COLOR_GREY_CHATEAU),
                                    filled: true,
                                    prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          _numberController.clear();
                                          _passwordController.clear();
                                          _firstNameController.clear();
                                          _lastNameController.clear();
                                          _emailController.clear();
                                          _passwordController.clear();
                                          _passwordFocus.unfocus();
                                          isCodeSent = false;
                                          isAlreadyExsist = true;
                                          setState(() {});

                                          FocusScope.of(context).requestFocus(_numberFocus);
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
                                            isAlreadyExsist = value.isExist;
                                          }
                                        }
                                      });
                                    }
                                  }),

                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                              isCodeSent == true
                                  ? Text(
                                      'Enter the code we sent you',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(color: ColorResources.getHintColor(context)),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(height: isCodeSent == true ? Dimensions.PADDING_SIZE_SMALL : 0),
                              isCodeSent == true
                                  ? MaskedTextField(
                                      maxLength: 4,
                                      controller: _passwordController,
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                          color: Theme.of(context).textTheme.bodyText1.color,
                                          fontSize: Dimensions.FONT_SIZE_LARGE),
                                      keyboardType: TextInputType.number,
                                      focusNode: _passwordFocus,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide(style: BorderStyle.none, width: 0),
                                        ),
                                        isDense: true,
                                        hintText: '0000',
                                        fillColor: Theme.of(context).cardColor,
                                        hintStyle: Theme.of(context).textTheme.headline2.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.COLOR_GREY_CHATEAU),
                                        filled: true,
                                        prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
                                      ),
                                      onChanged: (otp) {
                                        if (_passwordController.text.length == 4 && isAlreadyExsist == true) {
                                          SignUpModel signupModel = SignUpModel(
                                              phone: AppConstants.country_code +
                                                  _numberController.text.replaceAll(RegExp('[()\\-\\s]'), ''),
                                              token: _passwordController.text,
                                              restaurantId: F.restaurantId,
                                              fName: _firstNameController.text,
                                              lName: _lastNameController.text,
                                              isMobile: 'true',
                                              email: _emailController.text);
                                          authProvider.verifyOtp(signupModel, context).then((value) {
                                            if (value.isSuccess) {
                                              _passwordFocus.unfocus();
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context, Routes.getMainRoute(), (route) => false);
                                            }
                                          });
                                        }
                                      },
                                    )
                                  : SizedBox.shrink(),

                              isCodeSent == true
                                  ? Center(
                                      child: Text(
                                      'A one-time verification code was sent to your phone and should arrive shortly. Didn\'t receive a code yet?',
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                            color: ColorResources.getGreyBunkerColor(context),
                                          ),
                                    ))
                                  : SizedBox.shrink(),

                              isCodeSent == true
                                  ? InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        child: Text(
                                          'Resend verification code',
                                          style: Theme.of(context).textTheme.headline3.copyWith(
                                              color: ColorResources.getGreyBunkerColor(context),
                                              decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              isAlreadyExsist == false
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTranslated('first_name', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(color: ColorResources.getHintColor(context)),
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          hintText: 'first name',
                                          isShowBorder: true,
                                          controller: _firstNameController,
                                          focusNode: _firstNameFocus,
                                          nextFocus: _lastNameFocus,
                                          inputType: TextInputType.name,
                                          capitalization: TextCapitalization.words,
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                        // for last name section
                                        Text(
                                          getTranslated('last_name', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(color: ColorResources.getHintColor(context)),
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                        Provider.of<SplashProvider>(context, listen: false)
                                                .configModel
                                                .emailVerification
                                            ? CustomTextField(
                                                hintText: 'Doe',
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
                                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                        // for email section

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
                                          focusNode: _emailFocus,
                                          nextFocus: _passwordFocus,
                                          inputType: TextInputType.emailAddress,
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                      ],
                                    )
                                  : SizedBox.shrink(),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.loginErrorMessage.length > 0
                                      ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                      : SizedBox.shrink(),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.loginErrorMessage ?? "",
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  )
                                ],
                              ),

                              // for login button

                              !authProvider.isLoading
                                  ? CustomButton(
                                      btnTxt: getTranslated('login', context),
                                      onTap: () async {
                                        if (_numberController.text.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                        } else if (_passwordController.text.isEmpty) {
                                          showCustomSnackBar('Enter otp', context);
                                        } else {
                                          SignUpModel signupModel = SignUpModel(
                                              phone: AppConstants.country_code +
                                                  _numberController.text.replaceAll(RegExp('[()\\-\\s]'), ''),
                                              token: _passwordController.text,
                                              restaurantId: F.restaurantId,
                                              fName: _firstNameController.text,
                                              lName: _lastNameController.text,
                                              email: _emailController.text,
                                              isMobile: 'true');
                                          authProvider.verifyOtp(signupModel, context).then((value) {
                                            if (value.isSuccess) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context, Routes.getMainRoute(), (route) => false);
                                            }
                                          });
                                        }
                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    )),

                              // for create an account
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.getCreateAccountRoute());
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated('create_an_account', context),
                                        style: Theme.of(context).textTheme.headline2.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.getGreyColor(context)),
                                      ),
                                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                      Text(
                                        getTranslated('signup', context),
                                        style: Theme.of(context).textTheme.headline3.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.getGreyBunkerColor(context)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              if (_socialStatus.isFacebook || _socialStatus.isGoogle)
                                Center(child: SocialLoginWidget()),

                              Center(
                                  child:
                                      Text(getTranslated('OR', context), style: poppinsRegular.copyWith(fontSize: 12))),

                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, Routes.getDashboardRoute('home'));
                                  },
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: '${getTranslated('continue_as_a', context)} ',
                                        style: poppinsRegular.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.getHintColor(context))),
                                    TextSpan(
                                        text: getTranslated('guest', context),
                                        style: poppinsRegular.copyWith(
                                            color: Theme.of(context).textTheme.bodyText1.color)),
                                  ])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (ResponsiveHelper.isDesktop(context)) FooterView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
