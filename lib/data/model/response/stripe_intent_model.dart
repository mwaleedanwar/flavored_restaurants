import 'dart:convert';

StripeIntentModel stripeIntentModelFromJson(String str) => StripeIntentModel.fromJson(json.decode(str));

String stripeIntentModelToJson(StripeIntentModel data) => json.encode(data.toJson());

class StripeIntentModel {
  final String id;

  final String latestCharge;

  StripeIntentModel({
    required this.id,
    required this.latestCharge,
  });

  factory StripeIntentModel.fromJson(Map<String, dynamic> json) => StripeIntentModel(
        id: json["id"],
        latestCharge: json["latest_charge"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latest_charge": latestCharge,
      };
}
