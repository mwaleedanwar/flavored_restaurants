import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'dart:convert';

import 'offer_model.dart';
import 'order_model.dart';

List<OrderDetailsModel> orderDetailsModelFromJson(String str) =>
    List<OrderDetailsModel>.from(json.decode(str).map((x) => OrderDetailsModel.fromJson(x)));

String orderDetailsModelToJson(List<OrderDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderDetailsModel {
  int id;
  int productId;
  int orderId;
  double price;
  Product? productDetails;
  int discountOnProduct;
  String discountType;
  String? loyaltyPoints;
  int quantity;
  int taxAmount;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic addOnIds;
  List<Variation>? variant;
  dynamic addOnQtys;
  String restaurantId;
  dynamic happyHourId;
  String? cateringId;
  SpecialOfferModel? offerDetail;
  String reviewsCount;
  int isProductAvailable;
  OrderModel order;

  OrderDetailsModel({
    required this.id,
    required this.productId,
    required this.orderId,
    required this.price,
    required this.productDetails,
    required this.discountOnProduct,
    required this.discountType,
    required this.quantity,
    required this.taxAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.restaurantId,
    required this.cateringId,
    required this.reviewsCount,
    required this.isProductAvailable,
    required this.order,
    required this.loyaltyPoints,
    this.addOnIds,
    this.variant,
    this.addOnQtys,
    this.happyHourId,
    this.offerDetail,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
        id: json["id"],
        productId: json["product_id"],
        orderId: json["order_id"],
        price: json["price"].toDouble(),
        discountOnProduct: json["discount_on_product"],
        discountType: json["discount_type"],
        quantity: json["quantity"],
        taxAmount: json["tax_amount"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        addOnIds: json["add_on_ids"],
        addOnQtys: json["add_on_qtys"],
        restaurantId: json["restaurant_id"].toString(),
        happyHourId: json["happy_hour_id"],
        cateringId: json["catering_id"],
        reviewsCount: json["reviews_count"].toString(),
        isProductAvailable: json["is_product_available"],
        loyaltyPoints: json["loyalty_points"],
        order: OrderModel.fromJson(json["order"]),
        productDetails: json["product_details"] == null ? null : Product.fromJson(json["product_details"]),
        variant: json["variations"] == null ? null : List<Variation>.from(json["variations"].map((x) => x)),
        offerDetail: json["offer_detail"] == null ? null : SpecialOfferModel.fromJson(json["offer_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "order_id": orderId,
        "price": price,
        "product_details": productDetails?.toJson(),
        "discount_on_product": discountOnProduct,
        "discount_type": discountType,
        "quantity": quantity,
        "tax_amount": taxAmount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "add_on_ids": addOnIds,
        "variations": variant == null ? null : List<Variation>.from(variant!.map((x) => x)),
        "add_on_qtys": addOnQtys,
        "restaurant_id": restaurantId,
        "happy_hour_id": happyHourId,
        "catering_id": cateringId,
        "offer_detail": offerDetail?.toJson(),
        "reviews_count": reviewsCount,
        "is_product_available": isProductAvailable,
        "loyalty_points": loyaltyPoints,
        "order": order.toJson(),
      };
}
