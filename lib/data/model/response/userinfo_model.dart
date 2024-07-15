class UserInfoModel {
  int id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  String? isPhoneVerified;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? emailVerificationToken;
  String? phone;
  String? cmFirebaseToken;
  String? loginMedium;
  String? referCode;
  double? point;

  UserInfoModel({
    required this.id,
    this.fName,
    this.lName,
    this.email,
    this.image,
    this.isPhoneVerified,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.emailVerificationToken,
    this.phone,
    this.referCode,
    this.cmFirebaseToken,
    this.loginMedium,
    this.point,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'],
      fName: json['f_name'],
      lName: json['l_name'],
      email: json['email'],
      image: json['image'],
      isPhoneVerified: json['is_phone_verified'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      emailVerificationToken: json['email_verification_token'],
      phone: json['phone'],
      cmFirebaseToken: json['cm_firebase_token'],
      point: double.tryParse(json['point']),
      loginMedium: json['login_medium'].toString(),
      referCode: json['refer_code'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    data['is_phone_verified'] = isPhoneVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['email_verification_token'] = emailVerificationToken;
    data['phone'] = phone;
    data['cm_firebase_token'] = cmFirebaseToken;
    data['point'] = point;
    data['login_medium'] = loginMedium;
    data['refer_code'] = referCode;
    return data;
  }
}
