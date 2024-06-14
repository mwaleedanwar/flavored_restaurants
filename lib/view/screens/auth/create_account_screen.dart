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
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';

import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';

import '../../../utill/app_constants.dart';

class CreateAccountScreen extends StatefulWidget {
  final String email;
  final String referalCode;

  CreateAccountScreen({@required this.email, this.referalCode});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _referTextFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referTextController = TextEditingController();

  final upper = RegExp(r'(?=.*[A-Z])\w+');
  final number = RegExp(r'[0-9]');
  final lower = RegExp(r'(?=.*[a-z])\w+');
  bool isChecked = false;
  bool isCodeSent = false;

  @override
  void initState() {
    super.initState();

    // _numberController.text=widget.email.replaceAll('+1', '');
    _referTextController.text = widget.referalCode;

    debugPrint('number --${_numberController.text}');
    // _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          getTranslated('create_account', context),
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                        )),
                        SizedBox(height: isCodeSent ? 20 : 120),
                        Text(
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
                            focusNode: _numberFocus,
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
                                    _emailController.clear();
                                    _passwordController.clear();
                                    _passwordFocus.unfocus();
                                    // isChecked=false;
                                    isCodeSent = false;

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
                                    if (value.message == 'active') {}
                                  }
                                });
                              }
                            }),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        // Row(children: [
                        //  Expanded(child:  IntlPhoneField(
                        //
                        //    decoration: InputDecoration(
                        //      labelText: 'Phone Number',
                        //      border:InputBorder.none,
                        //      fillColor: ColorResources.COLOR_WHITE
                        //        ,filled: true
                        //    ),
                        //    initialCountryCode: 'US',
                        //    style:  Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.COLOR_BLACK),
                        //
                        //    onChanged: (phone) {
                        //      print(phone.completeNumber);
                        //      _emailController.text=phone.completeNumber;
                        //    },
                        //  ),),
                        //
                        // ]),
                        isCodeSent == true
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                  Text(
                                    'Enter the code we sent you',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(color: ColorResources.getHintColor(context)),
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  MaskedTextField(
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
                                      _passwordFocus.unfocus();
                                    },
                                  ),

                                  // CustomTextField(
                                  //   hintText: getTranslated(
                                  //       'password_hint', context),
                                  //   isShowBorder: true,
                                  //   isPassword: true,
                                  //   isShowSuffixIcon: true,
                                  //   focusNode: _passwordFocus,
                                  //
                                  //   controller: _passwordController,
                                  //   inputAction: TextInputAction.done,
                                  // ),
                                  SizedBox(height: 22),
                                  // for first name section
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
                                  Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification
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

                                  //  Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification?

                                  //             Text(
                                  //               getTranslated('mobile_number', context),
                                  //               style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                  //             ),
                                  // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  //             MaskedTextField(
                                  //               mask:AppConstants.phone_form ,
                                  //               controller: _numberController,
                                  //               style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE),
                                  //               keyboardType: TextInputType.number,
                                  //               readOnly: true,
                                  //
                                  //               decoration: InputDecoration(
                                  //                 contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                                  //                 border: OutlineInputBorder(
                                  //                   borderRadius: BorderRadius.circular(10.0),
                                  //                   borderSide: BorderSide(style: BorderStyle.none, width: 0),
                                  //                 ),
                                  //                 isDense: true,
                                  //                 hintText: AppConstants.phone_form_hint,
                                  //                 fillColor: Theme.of(context).cardColor,
                                  //
                                  //                 hintStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_GREY_CHATEAU),
                                  //                 filled: true,
                                  //
                                  //
                                  //                 prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
                                  //
                                  //
                                  //               ),
                                  //             ) ,
                                  // // Row(children: [
                                  // //               // Expanded(child:  IntlPhoneField(
                                  // //               //
                                  // //               //   decoration: InputDecoration(
                                  // //               //       labelText: 'Phone Number',
                                  // //               //       border:InputBorder.none,
                                  // //               //       fillColor: ColorResources.COLOR_WHITE
                                  // //               //       ,filled: true
                                  // //               //   ),
                                  // //               //   initialCountryCode: 'IN',
                                  // //               //   onChanged: (phone) {
                                  // //               //     print(phone.completeNumber);
                                  // //               //     _emailController.text=phone.completeNumber;
                                  // //               //   },
                                  // //               // ),),
                                  // //               Expanded(child: CustomTextField(
                                  // //                 hintText: getTranslated('number_hint', context),
                                  // //                 isShowBorder: true,
                                  // //                 isReadOnly: true,
                                  // //                 controller: _numberController,
                                  // //                 focusNode: _numberFocus,
                                  // //                 nextFocus: _passwordFocus,
                                  // //                 inputType: TextInputType.phone,
                                  // //               )),
                                  // //             ]),
                                  //
                                  // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  //             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  //               Text(
                                  //                 'Refer Code (Optional)',
                                  //                 style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                  //               ),
                                  //               SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  //
                                  //               CustomTextField(
                                  //                 hintText: 'referal code',
                                  //                 isShowBorder: true,
                                  //                 controller: _referTextController,
                                  //                 focusNode: _referTextFocus,
                                  //                 nextFocus: _passwordFocus,
                                  //                 inputType: TextInputType.text,
                                  //               ),
                                  //               SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                  //
                                  //             ],),
                                  //
                                  //             SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  //
                                  //
                                  //             // for password section
                                  //             Text(
                                  //               getTranslated('password', context),
                                  //               style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                  //             ),
                                  //             SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  //             CustomTextField(
                                  //               hintText: getTranslated('password_hint', context),
                                  //               isShowBorder: true,
                                  //               isPassword: true,
                                  //               controller: _passwordController,
                                  //               focusNode: _passwordFocus,
                                  //               nextFocus: _confirmPasswordFocus,
                                  //               isShowSuffixIcon: true,
                                  //             ),
                                  //             SizedBox(height: 22),
                                  //
                                  //             // for confirm password section
                                  //             Text(
                                  //               getTranslated('confirm_password', context),
                                  //               style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                  //             ),
                                  //             SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  //             CustomTextField(
                                  //               hintText: getTranslated('password_hint', context),
                                  //               isShowBorder: true,
                                  //               isPassword: true,
                                  //               controller: _confirmPasswordController,
                                  //               focusNode: _confirmPasswordFocus,
                                  //               isShowSuffixIcon: true,
                                  //               inputAction: TextInputAction.done,
                                  //             ),

                                  // Row(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     authProvider.registrationErrorMessage.length > 0
                                  //         ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                  //         : SizedBox.shrink(),
                                  //     SizedBox(width: 8),
                                  //     Expanded(
                                  //       child: Text(
                                  //         authProvider.registrationErrorMessage ?? "",
                                  //         style: Theme.of(context).textTheme.headline2.copyWith(
                                  //               fontSize: Dimensions.FONT_SIZE_SMALL,
                                  //               color: Theme.of(context).primaryColor,
                                  //             ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),

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
                                        text: new TextSpan(
                                          children: [
                                            new TextSpan(
                                              text: 'By creating an account, you agree to our ',
                                              style: new TextStyle(color: Theme.of(context).primaryColor),
                                            ),
                                            new TextSpan(
                                              text: 'terms & conditions',
                                              style: new TextStyle(
                                                  color: ColorResources.getHintColor(context),
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.w500),
                                              recognizer: new TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushNamed(context, Routes.getTermsRoute());

                                                  //launch('http://cafescale.com/terms-and-conditions');
                                                },
                                            ),
                                            new TextSpan(
                                              text: ' and ',
                                              style: new TextStyle(color: Theme.of(context).primaryColor),
                                            ),
                                            new TextSpan(
                                              text: 'privacy policy.',
                                              style: new TextStyle(
                                                  color: ColorResources.getHintColor(context),
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.w500),
                                              recognizer: new TapGestureRecognizer()
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
                            : SizedBox.shrink(),

                        // for signup button
                        SizedBox(height: 10),
                        !authProvider.isLoading
                            ? CustomButton(
                                btnTxt: getTranslated('signup', context),
                                onTap: () {
                                  String _firstName = _firstNameController.text.trim();
                                  String _lastName = _lastNameController.text.trim();
                                  String _number = _numberController.text.trim();
                                  String _email = _emailController.text.trim();
                                  String _password = _passwordController.text.trim();

                                  if (_firstName.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_first_name', context), context);
                                  } else if (_lastName.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_last_name', context), context);
                                  } else if (_number.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                  } else if (_email.isEmpty) {
                                    showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                  } else if (_password.isEmpty) {
                                    showCustomSnackBar('Enter otp', context);
                                  } else if (isChecked == false) {
                                    debugPrint('-=not');
                                    showCustomSnackBar('Accept terms and conditions', context);
                                  } else {
                                    SignUpModel signUpModel = SignUpModel(
                                        fName: _firstName,
                                        lName: _lastName,
                                        email: _email,
                                        restaurantId: F.restaurantId,
                                        referralCode: _referTextController.text,
                                        platform: kIsWeb
                                            ? 'Web'
                                            : Platform.isAndroid
                                                ? 'Android'
                                                : 'iOS',
                                        phone: AppConstants.country_code + _number.replaceAll(RegExp('[()\\-\\s]'), ''),
                                        token: _password,
                                        isMobile: 'true');
                                    authProvider.verifyOtp(signUpModel, context).then((status) async {
                                      if (status.isSuccess) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            Provider.of<SplashProvider>(context, listen: false)
                                                        .configModel
                                                        .branches
                                                        .length ==
                                                    1
                                                ? Routes.getMainRoute()
                                                : Routes.getBranchListScreen(),
                                            (route) => false);
                                      }
                                    });
                                  }
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                              )),

                        // for already an account
                        SizedBox(height: 11),
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
                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: ColorResources.getGreyColor(context)),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Text(
                                  getTranslated('login', context),
                                  style: Theme.of(context).textTheme.headline3.copyWith(
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
