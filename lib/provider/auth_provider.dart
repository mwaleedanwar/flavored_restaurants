// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/error_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/coupon_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/response_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/signup_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/social_login_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/auth_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/main_common.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_toast.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/auth/login_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/coupon_provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  GoogleSignInAccount? googleAccount;
  AuthProvider({required this.authRepo});

  final _googleSignIn = GoogleSignIn();

  String _loginErrorMessage = '';
  bool _isForgotPasswordLoading = false;
  String _email = '';
  String _phone = '';
  bool _isLoading = false;
  bool _isSignUp = false;
  String? _verificationMsg = '';
  String _registrationErrorMessage = '';
  String _verificationCode = '';
  bool _isEnableVerificationCode = false;
  bool _isActiveRememberMe = false;

  bool get isLoading => _isLoading;

  bool get isSignUp => _isSignUp;

  String get registrationErrorMessage => _registrationErrorMessage;

  String get loginErrorMessage => _loginErrorMessage;

  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  bool _isPhoneNumberVerificationButtonLoading = false;

  bool get isPhoneNumberVerificationButtonLoading => _isPhoneNumberVerificationButtonLoading;

  String? get verificationMessage => _verificationMsg;

  String get email => _email;

  String get phone => _phone;

  String get verificationCode => _verificationCode;

  bool get isEnableVerificationCode => _isEnableVerificationCode;

  bool get isActiveRememberMe => _isActiveRememberMe;

  void resetSignUp() {
    _isSignUp = false;
  }

  void setSignUp() {
    _isSignUp = true;
  }

  void updateRegistrationErrorMessage(String message) {
    _registrationErrorMessage = message;
    notifyListeners();
  }

  Future<ResponseModel> registration(SignUpModel signUpModel, context) async {
    _isLoading = true;
    _registrationErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.registration(signUpModel, context);
    ResponseModel responseModel;
    if (apiResponse.response?.statusCode != null && apiResponse.response!.statusCode == 200) {
      Map map = jsonDecode(apiResponse.response!.body);
      String? token;
      try {
        token = map["token"];

        debugPrint('===coupon:${map['coupon']}');
      } catch (e) {
        debugPrint('===register login');

        login(signUpModel.email, signUpModel.password, context);
      }

      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      _isLoading = false;
      if (map['coupon'] != null) {
        debugPrint('====coupon data:${CouponModel.fromJson(map['coupon'])}');
        Provider.of<CouponProvider>(context, listen: false).giftCoupon(CouponModel.fromJson(map['coupon']));
      }
      setSignUp();

      responseModel = ResponseModel(true, 'successful');
    } else {
      _isLoading = false;

      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint('==is string');
        errorMessage = apiResponse.error;
      } else {
        debugPrint('==is not string');

        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors?.first.message ?? 'UNKOWN ERROR REGISTRATION';
      }
      debugPrint(errorMessage);
      _registrationErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> login(String email, String password, context) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.login(email: email, password: password);
    debugPrint('after repnose:${apiResponse.response?.body}');
    ResponseModel responseModel;
    if (apiResponse.response?.statusCode != null && apiResponse.response!.statusCode == 200) {
      debugPrint('after repnose 200}');

      Map map = jsonDecode(apiResponse.response!.body);
      String token = map["token"];

      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      if (apiResponse.response?.statusCode == 401) {
        showCustomSnackBar('Invalid credentials', context);
      }
      _isLoading = false;
      notifyListeners();

      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      debugPrint(errorMessage);
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyOtp(SignUpModel signUpModel, context) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyOtp(signUpModel: signUpModel);
    debugPrint('after repnose:${apiResponse.response?.body}');
    ResponseModel responseModel;
    if (apiResponse.response?.statusCode != null && apiResponse.response!.statusCode == 200) {
      debugPrint('after repnose 200}');

      Map map = jsonDecode(apiResponse.response!.body);
      String token = map["token"];

      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      if (apiResponse.response!.statusCode == 401) {
        showCustomSnackBar('Invalid credentials', context);
      }
      _isLoading = false;
      notifyListeners();

      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      debugPrint(errorMessage);
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> forgetPassword(String email) async {
    debugPrint('====forgetPassword');
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.forgetPassword(email);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response!.body)['message']);
    } else {
      if (apiResponse.response!.statusCode == 404) {
        appToast(text: 'Please enter a valid number');
      }
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint('forgetError S: ${apiResponse.error.toString()}');
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint('forgetError: ${errorResponse.errors?[0].message}');
        errorMessage = errorResponse.errors?[1].message ?? 'UNKOWN ERROR FORGET PASSWORD';
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<void> updateToken() async {
    ApiResponse apiResponse = await authRepo.updateToken();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error ?? 'UNKNOWN ERROR';
      }
      debugPrint(errorMessage);
    }
  }

  Future<ResponseModel> verifyToken(String email) async {
    debugPrint('verify number : $email');
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyToken(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response!.body)["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint(errorResponse.errors?[0].message);
        errorMessage = errorResponse.errors?[0].message ?? 'UNKNOWN ERROR VERIFYING TOKEN';
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String mail, String resetToken, String password, String confirmPassword) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.resetPassword(mail, resetToken, password, confirmPassword);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response!.body)["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint(errorResponse.errors?[0].message);
        errorMessage = errorResponse.errors?[0].message ?? 'UNKNOWN ERROR RESETTING PASSWORD';
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  Future<ResponseModel> checkEmail(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.checkEmail(email);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response!.body)["token"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint(errorResponse.errors?[0].message);
        errorMessage = errorResponse.errors?[0].message ?? 'UNKOWN ERROR CHECKING EMAIL';
      }
      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyEmail(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response!.body)["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint(errorResponse.errors?[0].message);
        errorMessage = errorResponse.errors?[0].message ?? 'UNKOWN ERROR VERIFYING EMAIL';
      }
      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<OTPResponseModel> checkPhone(String phone, context) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.sendOTp(phone: phone);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    OTPResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (jsonDecode(apiResponse.response!.body)['coupon'] != null) {
        Provider.of<CouponProvider>(context, listen: false).giftCoupon(
          CouponModel.fromJson(jsonDecode(apiResponse.response!.body)['coupon']),
        );
      }
      responseModel = OTPResponseModel(
        true,
        jsonDecode(apiResponse.response!.body)["token"],
        jsonDecode(apiResponse.response!.body)["user_exists"],
      );
    } else {
      if (apiResponse.response!.statusCode == 403) {
        showCustomSnackBar(
          'The phone has already been taken.',
          Get.context,
          isError: true,
        );
      }
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint(errorResponse.errors?[0].message);
        errorMessage = errorResponse.errors?[0].message ?? 'UNKOWN ERROR CHECKING PHONE';
      }
      responseModel = OTPResponseModel(false, errorMessage, false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<OTPResponseModel> verifyPhone(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    String phoneNumber = phone;
    if (phone.contains('++')) {
      phoneNumber = phone.replaceAll('++', '+');
    }
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyPhone(phoneNumber, _verificationCode);
    debugPrint('phone verify : $phoneNumber || $_verificationCode');
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    OTPResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = OTPResponseModel(true, jsonDecode(apiResponse.response!.body)["message"],
          jsonDecode(apiResponse.response!.body)["user_exists"]);
    } else {
      debugPrint('=chec phone esle');

      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint(errorResponse.errors?[0].message);
        errorMessage = errorResponse.errors?[0].message ?? 'UNKNOWN ERROR VERIFYING PHONE';
      }
      responseModel = OTPResponseModel(false, errorMessage, false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    _isLoading = true;
    notifyListeners();
    bool isSuccess = await authRepo.clearSharedData();
    await Provider.of<AuthProvider>(Get.context, listen: false).socialLogout();

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  String getUserNumber() {
    return authRepo.getUserNumber();
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  Future<void> deleteUser(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await authRepo.deleteUser();
    _isLoading = false;
    debugPrint('status code is : ${response.response?.statusCode}');
    if (response.response != null && response.response!.statusCode == 200) {
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      showCustomSnackBar(getTranslated('your_account_remove_successfully', context), context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    } else {
      Navigator.of(context).pop();
      ApiChecker.checkApi(context, response);
    }
  }

  Future<GoogleSignInAuthentication?> googleLogin() async {
    googleAccount = await _googleSignIn.signIn();
    return await googleAccount?.authentication;
  }

  Future<void> socialLogin(SocialLoginModel socialLogin, Function callback) async {
    debugPrint('============== start social login ==========');
    debugPrint(socialLogin.token);
    debugPrint(socialLogin.email);
    debugPrint(socialLogin.uniqueId);
    debugPrint(socialLogin.medium);
    debugPrint('============== token ==========');

    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.socialLogin(socialLogin);
    debugPrint('============== social login ==========$apiResponse');

    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = jsonDecode(apiResponse.response!.body);
      String message = '';
      String? token = '';
      String temporaryToken = '';
      try {
        message = map['error_message'];
      } catch (e) {
        debugPrint('ERROR SOCIAL LOGIN');
      }
      try {
        token = map['token'];
      } catch (e) {
        debugPrint('ERROR SOCIAL LOGIN');
      }
      try {
        temporaryToken = map['temporary_token'];
      } catch (e) {
        debugPrint('ERROR SOCIAL LOGIN');
      }

      if (token != null) {
        authRepo.saveUserToken(token);
        await authRepo.updateToken();
      }
      callback(true, token, temporaryToken, message);
      notifyListeners();
    } else {
      debugPrint('error======================== ${apiResponse.error}');
      String errorMessage =
          ErrorResponse.fromJson(apiResponse.error).errors?[0].message ?? 'UNKOWN ERROR WITH SOCIAL LOGIN';
      callback(false, '', '', errorMessage);
      notifyListeners();
    }
  }

  Future<void> socialLogout() async {
    final user = Provider.of<ProfileProvider>(Get.context, listen: false).userInfoModel;
    if (user?.loginMedium?.toLowerCase() == 'google') {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.disconnect();
    }
  }
}
