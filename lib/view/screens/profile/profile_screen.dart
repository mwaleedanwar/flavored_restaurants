// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/response_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/userinfo_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/not_logged_in_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:masked_text/masked_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneNumberFocus = FocusNode();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? file;
  XFile? data;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool _isLoggedIn = false;

  void _choose() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    });
  }

  _pickImage() async {
    data = await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }

    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
      UserInfoModel userInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
      _firstNameController.text = userInfoModel.fName ?? '';
      _lastNameController.text = userInfoModel.lName ?? '';
      _phoneNumberController.text = userInfoModel.phone?.replaceAll('+1', '') ?? '';
      _emailController.text = userInfoModel.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(context: context, title: getTranslated('my_profile', context)),
      body: _isLoggedIn
          ? Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return profileProvider.userInfoModel != null
                    ? Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                child: Center(
                                  child: Container(
                                    width: width > 700 ? 700 : width,
                                    padding: width > 700
                                        ? const EdgeInsets.symmetric(
                                            horizontal: Dimensions.PADDING_SIZE_LARGE,
                                            vertical: Dimensions.PADDING_SIZE_SMALL)
                                        : null,
                                    decoration: width > 700
                                        ? BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 1)
                                            ],
                                          )
                                        : null,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // for profile image
                                        InkWell(
                                          onTap: ResponsiveHelper.isMobilePhone() ? _choose : _pickImage,
                                          child: Center(
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(25),
                                                  child: file != null
                                                      ? Image.file(
                                                          file!,
                                                          width: 80,
                                                          height: 80,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : data != null
                                                          ? Image.network(
                                                              data!.path,
                                                              width: 80,
                                                              height: 80,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : FadeInImage.assetNetwork(
                                                              placeholder: Images.placeholder_user,
                                                              width: 80,
                                                              height: 80,
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.image}',
                                                              imageErrorBuilder: (c, o, s) {
                                                                log('Link => ${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.image}');
                                                                log(o.toString());
                                                                return Image.asset(
                                                                  Images.placeholder_user,
                                                                  width: 80,
                                                                  height: 80,
                                                                  fit: BoxFit.cover,
                                                                );
                                                              },
                                                            ),
                                                ),
                                                Positioned(
                                                  bottom: 15,
                                                  right: -10,
                                                  child: InkWell(
                                                      onTap: ResponsiveHelper.isMobilePhone() ? _pickImage : _choose,
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: ColorResources.BORDER_COLOR,
                                                          border: Border.all(
                                                              width: 2, color: ColorResources.COLOR_GREY_CHATEAU),
                                                        ),
                                                        child: const Icon(Icons.edit, size: 13),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // for name
                                        Center(
                                            child: Text(
                                          '${profileProvider.userInfoModel?.fName ?? ''} ${profileProvider.userInfoModel?.lName ?? ''}',
                                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                        )),

                                        const SizedBox(height: 28),
                                        // for first name section
                                        Text(
                                          getTranslated('first_name', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(color: ColorResources.getHintColor(context)),
                                        ),
                                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          hintText: 'John',
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
                                        CustomTextField(
                                          hintText: 'Doe',
                                          isShowBorder: true,
                                          controller: _lastNameController,
                                          focusNode: _lastNameFocus,
                                          nextFocus: _phoneNumberFocus,
                                          inputType: TextInputType.name,
                                          capitalization: TextCapitalization.words,
                                        ),
                                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
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
                                          nextFocus: _phoneNumberFocus,
                                          inputType: TextInputType.emailAddress,
                                        ),
                                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                        // for phone Number section
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
                                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                              color: Theme.of(context).textTheme.bodyLarge?.color,
                                              fontSize: Dimensions.FONT_SIZE_LARGE),
                                          controller: _phoneNumberController,
                                          readOnly: true,
                                          focusNode: _phoneNumberFocus,
                                          keyboardType: TextInputType.phone,
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

                                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          !profileProvider.isLoading
                              ? Center(
                                  child: Container(
                                    width: width > 700 ? 700 : width,
                                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    margin: ResponsiveHelper.isDesktop(context)
                                        ? const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL)
                                        : EdgeInsets.zero,
                                    child: CustomButton(
                                      btnTxt: getTranslated('update_profile', context),
                                      onTap: () async {
                                        String firstName = _firstNameController.text.trim();
                                        String lastName = _lastNameController.text.trim();
                                        String email = _emailController.text.trim();
                                        String phoneNumber = _phoneNumberController.text.trim();
                                        String password = _passwordController.text.trim();
                                        String confirmPassword = _confirmPasswordController.text.trim();
                                        if (profileProvider.userInfoModel?.fName == firstName &&
                                            profileProvider.userInfoModel?.lName == lastName &&
                                            profileProvider.userInfoModel?.phone == phoneNumber &&
                                            profileProvider.userInfoModel?.email == _emailController.text &&
                                            file == null &&
                                            data == null &&
                                            password.isEmpty &&
                                            confirmPassword.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated('change_something_to_update', context), context);
                                        } else if (firstName.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_first_name', context), context);
                                        } else if (lastName.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_last_name', context), context);
                                        } else if (phoneNumber.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                        } else if ((password.isNotEmpty && password.length < 6) ||
                                            (confirmPassword.isNotEmpty && confirmPassword.length < 6)) {
                                          showCustomSnackBar(getTranslated('password_should_be', context), context);
                                        } else if (password != confirmPassword) {
                                          showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                                        } else {
                                          debugPrint('===email: $email');

                                          UserInfoModel updateUserInfoModel = UserInfoModel(
                                              id: 0,
                                              fName: firstName,
                                              lName: lastName,
                                              emailVerificationToken: _emailController.text,
                                              phone: AppConstants.country_code +
                                                  phoneNumber.replaceAll(RegExp('[()\\-\\s]'), ''));

                                          String pass = password;
                                          debugPrint('=====emil:${updateUserInfoModel.email}');

                                          ResponseModel responseModel = await profileProvider.updateUserInfo(
                                            updateUserInfoModel,
                                            pass,
                                            file,
                                            data,
                                            Provider.of<AuthProvider>(context, listen: false).getUserToken,
                                          );

                                          if (responseModel.isSuccess) {
                                            profileProvider.getUserInfo(context);
                                            showCustomSnackBar(getTranslated('updated_successfully', context), context,
                                                isError: false);
                                          } else {
                                            showCustomSnackBar(responseModel.message, context);
                                          }
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
              },
            )
          : const NotLoggedInScreen(),
    );
  }
}
