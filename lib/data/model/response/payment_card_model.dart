// To parse this JSON data, do
//
//     final PaymentCardModel = PaymentCardModelFromJson(jsonString);

import 'dart:convert';

// ignore: non_constant_identifier_names
List<PaymentCardModel> PaymentCardModelFromJson(String str) =>
    List<PaymentCardModel>.from(json.decode(str).map((x) => PaymentCardModel.fromJson(x)));

// ignore: non_constant_identifier_names
String PaymentCardModelToJson(List<PaymentCardModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentCardModel {
  PaymentCardModel({
    this.id,
    this.userId,
    this.paymentId,
    this.customerAccount,
    this.cardNo,
    this.expMonth,
    this.expYear,
    this.paymentType,
    this.paymentIcon,
    this.status,
    this.defaultCard,
    this.createdAt,
    this.cvc,
    this.cardholder,
    this.updatedAt,
  });

  int id;
  String userId;
  String cardholder;
  String paymentId;
  String customerAccount;
  String cardNo;
  String expMonth;
  String expYear;
  String paymentType;
  String cvc;
  dynamic paymentIcon;
  String status;
  String defaultCard;
  String createdAt;
  String updatedAt;

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) => PaymentCardModel(
        id: json["id"],
        userId: json["user_id"],
        paymentId: json["payment_id"],
        customerAccount: json["customer_account"],
        cardNo: json["card_no"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        paymentType: json["payment_type"],
        paymentIcon: json["payment_icon"],
        status: json["status"],
        defaultCard: json["default_card"],
        cardholder: json["card_holder_name"],
        cvc: json["cvc"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "payment_id": paymentId,
        "customer_account": customerAccount,
        "card_no": cardNo,
        "exp_month": expMonth,
        "exp_year": expYear,
        "payment_type": paymentType,
        "payment_icon": paymentIcon,
        "status": status,
        "default_card": defaultCard,
        "cvc": cvc,
        "card_holder_name": cardholder,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
