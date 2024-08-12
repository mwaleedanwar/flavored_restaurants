// ignore_for_file: use_build_context_synchronously

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
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String resetToken;
  final String email;
  const CreateNewPasswordScreen({
    super.key,
    required this.resetToken,
    required this.email,
  });

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context, title: getTranslated('create_new_password', context)),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return Center(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width > 700 ? 700 : MediaQuery.of(context).size.width,
                    padding: MediaQuery.of(context).size.width > 700
                        ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                        : null,
                    decoration: MediaQuery.of(context).size.width > 700
                        ? BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 1)],
                          )
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 55),
                        Center(
                          child: Image.asset(
                            Images.open_lock,
                            width: 142,
                            height: 142,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                            child: Text(
                          getTranslated('enter_password_to_create', context),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: ColorResources.getHintColor(context)),
                        )),
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 60),
                              Text(
                                getTranslated('new_password', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              CustomTextField(
                                hintText: getTranslated('password_hint', context),
                                isShowBorder: true,
                                isPassword: true,
                                focusNode: _passwordFocus,
                                nextFocus: _confirmPasswordFocus,
                                isShowSuffixIcon: true,
                                inputAction: TextInputAction.next,
                                controller: _passwordController,
                              ),
                              const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                              // for confirm password section
                              Text(
                                getTranslated('confirm_password', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              CustomTextField(
                                hintText: getTranslated('password_hint', context),
                                isShowBorder: true,
                                isPassword: true,
                                isShowSuffixIcon: true,
                                focusNode: _confirmPasswordFocus,
                                controller: _confirmPasswordController,
                                inputAction: TextInputAction.done,
                              ),

                              const SizedBox(height: 24),
                              !auth.isForgotPasswordLoading
                                  ? CustomButton(
                                      btnTxt: getTranslated('save', context),
                                      onTap: () {
                                        if (_passwordController.text.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_password', context), context);
                                        } else if (_passwordController.text.length < 6) {
                                          showCustomSnackBar(getTranslated('password_should_be', context), context);
                                        } else if (_confirmPasswordController.text.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_confirm_password', context), context);
                                        } else if (_passwordController.text != _confirmPasswordController.text) {
                                          showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                                        } else {
                                          String mail = Provider.of<SplashProvider>(context, listen: false)
                                                      .configModel
                                                      ?.phoneVerification ??
                                                  false
                                              ? '+${widget.email.trim()}'
                                              : widget.email;
                                          auth
                                              .resetPassword(mail, widget.resetToken, _passwordController.text,
                                                  _confirmPasswordController.text)
                                              .then((value) {
                                            if (value.isSuccess) {
                                              showCustomSnackBar('Password changed successfully', context,
                                                  isError: false);
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context, Routes.getLoginRoute(), (route) => false);
                                            } else {
                                              showCustomSnackBar('Failed to reset password', context);
                                            }
                                          });
                                        }
                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
