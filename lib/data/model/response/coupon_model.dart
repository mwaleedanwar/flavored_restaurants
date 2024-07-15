// To parse this JSON data, do
//
//     final couponModel = couponModelFromJson(jsonString);

import 'dart:convert';

import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';

CouponModel couponModelFromJson(String str) =>
    CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  int id;
  String title;
  String code;
  String startDate;
  String expireDate;
  int? minPurchase;
  int? maxDiscount;
  double discount;
  String discountType;
  int status;
  String createdAt;
  String updatedAt;
  String couponType;
  String limit;
  String restaurantId;
  String userId;
  String userPhone;
  String userEmail;
  String productId;
  bool isExpired;
  Product? product;

  CouponModel({
    required this.id,
    required this.title,
    required this.code,
    required this.startDate,
    required this.expireDate,
    this.minPurchase,
    this.maxDiscount,
    required this.discount,
    required this.discountType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.couponType,
    required this.limit,
    required this.restaurantId,
    required this.userId,
    required this.userPhone,
    required this.userEmail,
    required this.isExpired,
    required this.productId,
    this.product,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json["id"],
      title: json["title"],
      code: json["code"],
      startDate: json["start_date"],
      expireDate: json["expire_date"],
      minPurchase: json["min_purchase"],
      maxDiscount: json["max_discount"],
      discount: double.parse(json["discount"].toString()),
      discountType: json["discount_type"],
      status: json["status"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      couponType: json["coupon_type"],
      limit: json["limit"],
      restaurantId: json["restaurant_id"],
      userId: json["user_id"],
      userPhone: json["user_phone"],
      isExpired: json["is_expired"],
      userEmail: json["user_email"],
      productId: json["product_id"],
      product:
          json["product"] == null ? null : Product.fromJson(json["product"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "code": code,
        "start_date": startDate,
        "expire_date": expireDate,
        "min_purchase": minPurchase,
        "max_discount": maxDiscount,
        "discount": discount,
        "discount_type": discountType,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "coupon_type": couponType,
        "limit": limit,
        "restaurant_id": restaurantId,
        "user_id": userId,
        "user_phone": userPhone,
        "user_email": userEmail,
        "is_expired": isExpired,
        "product_id": productId,
        "product": product?.toJson(),
      };
}
