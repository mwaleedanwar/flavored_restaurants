class SocialLoginModel {
  String token;
  String uniqueId;
  String medium;
  String email;
  String restaurantId;
  String firstName;
  String lastName;

  SocialLoginModel({
    required this.token,
    required this.uniqueId,
    required this.medium,
    required this.email,
    required this.restaurantId,
    required this.firstName,
    required this.lastName,
  });

  factory SocialLoginModel.fromJson(Map<String, dynamic> json) {
    return SocialLoginModel(
      token: json['token'],
      uniqueId: json['unique_id'],
      medium: json['medium'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      restaurantId: json['restaurant_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['unique_id'] = uniqueId;
    data['medium'] = medium;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['restaurant_id'] = restaurantId;
    return data;
  }
}
