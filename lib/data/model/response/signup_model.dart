class SignUpModel {
  String fName;
  String lName;
  String phone;
  String email;
  String password;
  int restaurantId;
  String? referralCode;
  String? platform;
  String token;
  String isMobile;

  SignUpModel({
    required this.fName,
    required this.lName,
    required this.phone,
    this.email = '',
    required this.password,
    required this.restaurantId,
    this.referralCode,
    this.platform,
    required this.token,
    required this.isMobile,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      fName: json['f_name'],
      lName: json['l_name'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      restaurantId: json['restaurant_id'],
      referralCode: json['referral_code'],
      platform: json['platform'],
      token: json['token'],
      isMobile: json['is_mobile_app'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['restaurant_id'] = restaurantId;
    data['referral_code'] = referralCode;
    data['platform'] = platform;
    data['token'] = token;
    data['is_mobile_app'] = isMobile;

    return data;
  }
}
