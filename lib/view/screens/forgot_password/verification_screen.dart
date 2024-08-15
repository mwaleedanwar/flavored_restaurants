// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  final String emailAddress;
  final bool fromSignUp;
  const VerificationScreen({super.key, required this.emailAddress, this.fromSignUp = false});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // ignore: unused_field
  Timer _timer = Timer(const Duration(seconds: 0), () {});
  int _start = 60;
  void startTimer() {
    _start = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
              () {
                if (_start < 1) {
                  timer.cancel();
                } else {
                  _start = _start - 1;
                }
              },
            ));
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: Provider.of<SplashProvider>(context).configModel!.phoneVerification
            ? getTranslated('verify_phone', context)
            : getTranslated('verify_email', context),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 55),
                      Provider.of<SplashProvider>(context, listen: false).configModel!.emailVerification
                          ? Image.asset(
                              Images.email_with_background,
                              width: 142,
                              height: 142,
                            )
                          : Icon(
                              Icons.phone_android_outlined,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                          '${getTranslated('please_enter_4_digit_code', context)}\n ${widget.emailAddress.replaceAll('+1', '')}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: ColorResources.getHintColor(context)),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 35),
                        child: SizedBox(
                          width: 400,
                          child: PinCodeTextField(
                            length: 4,
                            appContext: context,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              fieldHeight: 63,
                              fieldWidth: 55,
                              borderWidth: 1,
                              borderRadius: BorderRadius.circular(10),
                              selectedColor: ColorResources.colorMap[200],
                              selectedFillColor: Colors.white,
                              inactiveFillColor: ColorResources.getSearchBg(context),
                              inactiveColor: ColorResources.colorMap[200],
                              activeColor: ColorResources.colorMap[400],
                              activeFillColor: ColorResources.getSearchBg(context),
                            ),
                            animationDuration: const Duration(milliseconds: 300),
                            backgroundColor: Colors.transparent,
                            enableActiveFill: true,
                            onChanged: authProvider.updateVerificationCode,
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        _start != 0 ? 'If you did\'t receive the code in $_start seconds' : 'I did\'t receive the code',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: ColorResources.getGreyBunkerColor(context),
                            ),
                      )),
                      Center(
                        child: InkWell(
                          onTap: () {
                            if (_start != 0) {
                            } else {
                              if (widget.fromSignUp) {
                                Provider.of<SplashProvider>(context, listen: false).configModel!.emailVerification
                                    ? Provider.of<AuthProvider>(context, listen: false)
                                        .checkEmail(widget.emailAddress)
                                        .then((value) {
                                        if (value.isSuccess) {
                                          startTimer();

                                          showCustomSnackBar('Resent code successful', context, isError: false);
                                        } else {
                                          showCustomSnackBar(value.message, context);
                                        }
                                      })
                                    : Provider.of<AuthProvider>(context, listen: false)
                                        .checkPhone(widget.emailAddress.replaceAll(RegExp('[()\\-\\s]'), ''), context)
                                        .then((value) {
                                        if (value.isSuccess) {
                                          startTimer();

                                          showCustomSnackBar('Resent code successful', context, isError: false);
                                        } else {
                                          showCustomSnackBar(value.message, context);
                                        }
                                      });
                              } else {
                                Provider.of<AuthProvider>(context, listen: false)
                                    .forgetPassword(widget.emailAddress)
                                    .then((value) {
                                  if (value.isSuccess) {
                                    startTimer();

                                    showCustomSnackBar('Resent code successful', context, isError: false);
                                  } else {
                                    showCustomSnackBar(value.message, context);
                                  }
                                });
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(
                              getTranslated('resend_code', context),
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: _start != 0 ? Colors.grey : ColorResources.getGreyBunkerColor(context),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      authProvider.isEnableVerificationCode
                          ? !authProvider.isPhoneNumberVerificationButtonLoading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                  child: CustomButton(
                                    btnTxt: getTranslated('verify', context),
                                    onTap: () {
                                      String mail = Provider.of<SplashProvider>(context, listen: false)
                                              .configModel!
                                              .phoneVerification
                                          ? widget.emailAddress.contains('+')
                                              ? widget.emailAddress
                                              : '+${widget.emailAddress.trim()}'
                                          : widget.emailAddress;
                                      debugPrint('number is : ${widget.emailAddress}');
                                      if (widget.fromSignUp) {
                                        debugPrint('--from signup ');

                                        Provider.of<SplashProvider>(context, listen: false)
                                                .configModel!
                                                .emailVerification
                                            ? Provider.of<AuthProvider>(context, listen: false)
                                                .verifyEmail(mail)
                                                .then((value) {
                                                if (value.isSuccess) {
                                                  debugPrint('--value success ');
                                                  Navigator.pushNamed(context, Routes.getCreateAccountRoute());
                                                } else {
                                                  debugPrint('--value failure ');

                                                  showCustomSnackBar(value.message, context);
                                                }
                                              })
                                            : Provider.of<AuthProvider>(context, listen: false)
                                                .verifyPhone(mail)
                                                .then((value) {
                                                if (value.isSuccess) {
                                                  debugPrint('--value success 2 ${value.message}   $mail');
                                                  debugPrint('number here is${widget.emailAddress}   $mail');
                                                  Navigator.pushNamed(context, Routes.getCreateAccountRoute());
                                                } else {
                                                  debugPrint('--value failure 2 ');
                                                  showCustomSnackBar(value.message, context);
                                                }
                                              });
                                      } else {
                                        debugPrint('mail num is : $mail');
                                        Provider.of<AuthProvider>(context, listen: false)
                                            .verifyToken(mail)
                                            .then((value) {
                                          if (value.isSuccess) {
                                            Navigator.pushNamed(
                                                context, Routes.getNewPassRoute(mail, authProvider.verificationCode));
                                          } else {
                                            showCustomSnackBar(value.message, context);
                                          }
                                        });
                                      }
                                    },
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                          : const SizedBox.shrink()
                    ],
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
