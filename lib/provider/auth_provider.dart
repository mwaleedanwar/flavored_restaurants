import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
import '../helper/api_checker.dart';
import '../localization/language_constrants.dart';
import '../utill/app_toast.dart';
import '../view/base/custom_snackbar.dart';
import '../view/screens/auth/login_screen.dart';
import 'coupon_provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({@required this.authRepo});

  // for registration section
  bool _isLoading = false;
  bool _isSignUp = false;

  bool get isLoading => _isLoading;
  bool get isSignUp => _isSignUp;
  String _registrationErrorMessage = '';

  String get registrationErrorMessage => _registrationErrorMessage;
  resetSignUp() {
    _isSignUp = false;
  }

  setSignUp() {
    _isSignUp = true;
  }

  updateRegistrationErrorMessage(String message) {
    _registrationErrorMessage = message;
    notifyListeners();
  }

  Future<ResponseModel> registration(SignUpModel signUpModel, context) async {
    _isLoading = true;
    _registrationErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.registration(signUpModel, context);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      Map map = jsonDecode(apiResponse.response.body);
      String token;
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
        print('====coupon data:${CouponModel.fromJson(map['coupon'])}');
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
        errorMessage = errorResponse.errors[0].message;
      }
      print(errorMessage);
      _registrationErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  // for login section
  String _loginErrorMessage = '';

  String get loginErrorMessage => _loginErrorMessage;

  Future<ResponseModel> login(String email, String password, context) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.login(email: email, password: password);
    debugPrint('after repnose:${apiResponse.response.body}');
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      debugPrint('after repnose 200}');

      Map map = jsonDecode(apiResponse.response.body);
      String token = map["token"];

      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      if (apiResponse.response.statusCode == 401) {
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
      print(errorMessage);
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
    debugPrint('after repnose:${apiResponse.response.body}');
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      debugPrint('after repnose 200}');

      Map map = jsonDecode(apiResponse.response.body);
      String token = map["token"];

      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      if (apiResponse.response.statusCode == 401) {
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
      print(errorMessage);
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  // for forgot password
  bool _isForgotPasswordLoading = false;

  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  Future<ResponseModel> forgetPassword(String email) async {
    print('====forgetPassword');
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.forgetPassword(email);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response.body)['message']);
      // appToast(text: 'Code sent successfully');
    } else {
      if (apiResponse.response.statusCode == 404) {
        appToast(text: 'Please enter a valid number');
      }
      String errorMessage;
      if (apiResponse.error is String) {
        print('forgetError S: ${apiResponse.error.toString()}');
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print('forgetError: ${errorResponse.errors[0].message}');
        errorMessage = errorResponse.errors[1].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<void> updateToken() async {
    ApiResponse apiResponse = await authRepo.updateToken();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error;
      }
      print(errorMessage);
    }
  }

  Future<ResponseModel> verifyToken(String email) async {
    print('varify number : $email');
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyToken(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response.body)["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
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
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response.body)["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;

  bool get isPhoneNumberVerificationButtonLoading => _isPhoneNumberVerificationButtonLoading;
  String _verificationMsg = '';

  String get verificationMessage => _verificationMsg;
  String _email = '';
  String _phone = '';

  String get email => _email;

  String get phone => _phone;

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
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response.body)["token"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
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
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(true, jsonDecode(apiResponse.response.body)["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  //phone
  Future<OTPResponseModel> checkPhone(String phone, context) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.sendOTp(phone: phone);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    OTPResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      if (jsonDecode(apiResponse.response.body)['coupon'] != null) {
        print('====coupon data:${CouponModel.fromJson(jsonDecode(apiResponse.response.body)['coupon'])}');
        Provider.of<CouponProvider>(context, listen: false)
            .giftCoupon(CouponModel.fromJson(jsonDecode(apiResponse.response.body)['coupon']));
      }
      responseModel = OTPResponseModel(
          true, jsonDecode(apiResponse.response.body)["token"], jsonDecode(apiResponse.response.body)["user_exists"]);
    } else {
      if (apiResponse.response.statusCode == 403) {
        // appToast(text: 'The phone has already been taken.',toastColor: Colors.red);
        showCustomSnackBar('The phone has already been taken.', Get.context, isError: true);
      }
      //print('==check phone esle${responseModel.message}');

      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        //   print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = OTPResponseModel(false, errorMessage, false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<OTPResponseModel> verifyPhone(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    String _phoneNumber = phone;
    if (phone.contains('++')) {
      _phoneNumber = phone.replaceAll('++', '+');
    }
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyPhone(_phoneNumber, _verificationCode);
    print('phone verify : $_phoneNumber || $_verificationCode');
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    OTPResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = OTPResponseModel(
          true, jsonDecode(apiResponse.response.body)["message"], jsonDecode(apiResponse.response.body)["user_exists"]);
    } else {
      print('=chec phone esle');

      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = OTPResponseModel(false, errorMessage, false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for verification Code
  String _verificationCode = '';

  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;

  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  // for Remember Me Section

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

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
    bool _isSuccess = await authRepo.clearSharedData();
    await Provider.of<AuthProvider>(Get.context, listen: false).socialLogout();

    _isLoading = false;
    notifyListeners();
    return _isSuccess;
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  String getUserNumber() {
    return authRepo.getUserNumber() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  Future deleteUser(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await authRepo.deleteUser();
    _isLoading = false;
    print('status code is : ${response.response.statusCode}');
    if (response.response.statusCode == 200) {
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      showCustomSnackBar(getTranslated('your_account_remove_successfully', context), context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
    } else {
      Navigator.of(context).pop();
      ApiChecker.checkApi(context, response);
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount googleAccount;

  Future<GoogleSignInAuthentication> googleLogin() async {
    GoogleSignInAuthentication auth;
    googleAccount = await _googleSignIn.signIn();
    auth = await googleAccount.authentication;
    return auth;
  }

  Future socialLogin(SocialLoginModel socialLogin, Function callback) async {
    print('============== start social login ==========');
    print(socialLogin.token);
    print(socialLogin.email);
    print(socialLogin.uniqueId);
    print(socialLogin.medium);
    print('============== token ==========');

    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.socialLogin(socialLogin);
    print('============== social login ==========${apiResponse}');

    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      Map map = jsonDecode(apiResponse.response.body);
      String message = '';
      String token = '';
      String temporaryToken = '';
      try {
        message = map['error_message'];
      } catch (e) {}
      try {
        token = map['token'];
      } catch (e) {}
      try {
        temporaryToken = map['temporary_token'];
      } catch (e) {}

      if (token != null) {
        authRepo.saveUserToken(token);
        await authRepo.updateToken();
      }
      callback(true, token, temporaryToken, message);
      notifyListeners();
    } else {
      print('error======================== ${apiResponse.error}');
      String errorMessage = ErrorResponse.fromJson(apiResponse.error).errors[0].message;
      callback(false, '', '', errorMessage);
      notifyListeners();
    }
  }

  Future<void> socialLogout() async {
    final _user = Provider.of<ProfileProvider>(Get.context, listen: false).userInfoModel;
    if (_user.loginMedium.toLowerCase() == 'google') {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      _googleSignIn.disconnect();
    } else if (_user.loginMedium.toLowerCase() == 'facebook') {
      // await FacebookAuth.instance.logOut();
    }
  }
}
