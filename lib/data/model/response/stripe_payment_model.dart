// To parse this JSON data, do
//
//     final stripeIntentModel = stripeIntentModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

StripeIntentModel stripeIntentModelFromJson(String str) => StripeIntentModel.fromJson(json.decode(str));

String stripeIntentModelToJson(StripeIntentModel data) => json.encode(data.toJson());

class StripeIntentModel {
  final String id;
  final String object;
  final int amount;
  final int amountCapturable;
  final AmountDetails amountDetails;
  final int amountReceived;
  final String application;
  final int applicationFeeAmount;
  final dynamic automaticPaymentMethods;
  final dynamic canceledAt;
  final dynamic cancellationReason;
  final String captureMethod;
  final String clientSecret;
  final String confirmationMethod;
  final int created;
  final String currency;
  final String customer;
  final dynamic description;
  final dynamic invoice;
  final dynamic lastPaymentError;
  final String latestCharge;
  final bool livemode;
  final List<dynamic> metadata;
  final dynamic nextAction;
  final dynamic onBehalfOf;
  final String paymentMethod;
  final dynamic paymentMethodConfigurationDetails;
  final PaymentMethodOptions paymentMethodOptions;
  final List<String> paymentMethodTypes;
  final dynamic processing;
  final dynamic receiptEmail;
  final dynamic review;
  final dynamic setupFutureUsage;
  final dynamic shipping;
  final dynamic source;
  final dynamic statementDescriptor;
  final dynamic statementDescriptorSuffix;
  final String status;
  final dynamic transferData;
  final dynamic transferGroup;

  StripeIntentModel({
     this.id,
     this.object,
     this.amount,
     this.amountCapturable,
     this.amountDetails,
     this.amountReceived,
     this.application,
     this.applicationFeeAmount,
     this.automaticPaymentMethods,
     this.canceledAt,
     this.cancellationReason,
     this.captureMethod,
     this.clientSecret,
     this.confirmationMethod,
     this.created,
     this.currency,
     this.customer,
     this.description,
     this.invoice,
     this.lastPaymentError,
     this.latestCharge,
     this.livemode,
     this.metadata,
     this.nextAction,
     this.onBehalfOf,
     this.paymentMethod,
     this.paymentMethodConfigurationDetails,
     this.paymentMethodOptions,
     this.paymentMethodTypes,
     this.processing,
     this.receiptEmail,
     this.review,
     this.setupFutureUsage,
     this.shipping,
     this.source,
     this.statementDescriptor,
     this.statementDescriptorSuffix,
     this.status,
     this.transferData,
     this.transferGroup,
  });

  StripeIntentModel copyWith({
    String id,
    String object,
    int  amount,
    int  amountCapturable,
    AmountDetails amountDetails,
    int amountReceived,
    String application,
    int applicationFeeAmount,
    dynamic automaticPaymentMethods,
    dynamic canceledAt,
    dynamic cancellationReason,
    String captureMethod,
    String clientSecret,
    String confirmationMethod,
    int created,
    String currency,
    String customer,
    dynamic description,
    dynamic invoice,
    dynamic lastPaymentError,
    String latestCharge,
    bool livemode,
    List<dynamic> metadata,
    dynamic nextAction,
    dynamic onBehalfOf,
    String paymentMethod,
    dynamic paymentMethodConfigurationDetails,
    PaymentMethodOptions paymentMethodOptions,
    List<String> paymentMethodTypes,
    dynamic processing,
    dynamic receiptEmail,
    dynamic review,
    dynamic setupFutureUsage,
    dynamic shipping,
    dynamic source,
    dynamic statementDescriptor,
    dynamic statementDescriptorSuffix,
    String status,
    dynamic transferData,
    dynamic transferGroup,
  }) =>
      StripeIntentModel(
        id: id ?? this.id,
        object: object ?? this.object,
        amount: amount ?? this.amount,
        amountCapturable: amountCapturable ?? this.amountCapturable,
        amountDetails: amountDetails ?? this.amountDetails,
        amountReceived: amountReceived ?? this.amountReceived,
        application: application ?? this.application,
        applicationFeeAmount: applicationFeeAmount ?? this.applicationFeeAmount,
        automaticPaymentMethods: automaticPaymentMethods ?? this.automaticPaymentMethods,
        canceledAt: canceledAt ?? this.canceledAt,
        cancellationReason: cancellationReason ?? this.cancellationReason,
        captureMethod: captureMethod ?? this.captureMethod,
        clientSecret: clientSecret ?? this.clientSecret,
        confirmationMethod: confirmationMethod ?? this.confirmationMethod,
        created: created ?? this.created,
        currency: currency ?? this.currency,
        customer: customer ?? this.customer,
        description: description ?? this.description,
        invoice: invoice ?? this.invoice,
        lastPaymentError: lastPaymentError ?? this.lastPaymentError,
        latestCharge: latestCharge ?? this.latestCharge,
        livemode: livemode ?? this.livemode,
        metadata: metadata ?? this.metadata,
        nextAction: nextAction ?? this.nextAction,
        onBehalfOf: onBehalfOf ?? this.onBehalfOf,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentMethodConfigurationDetails: paymentMethodConfigurationDetails ?? this.paymentMethodConfigurationDetails,
        paymentMethodOptions: paymentMethodOptions ?? this.paymentMethodOptions,
        paymentMethodTypes: paymentMethodTypes ?? this.paymentMethodTypes,
        processing: processing ?? this.processing,
        receiptEmail: receiptEmail ?? this.receiptEmail,
        review: review ?? this.review,
        setupFutureUsage: setupFutureUsage ?? this.setupFutureUsage,
        shipping: shipping ?? this.shipping,
        source: source ?? this.source,
        statementDescriptor: statementDescriptor ?? this.statementDescriptor,
        statementDescriptorSuffix: statementDescriptorSuffix ?? this.statementDescriptorSuffix,
        status: status ?? this.status,
        transferData: transferData ?? this.transferData,
        transferGroup: transferGroup ?? this.transferGroup,
      );

  factory StripeIntentModel.fromJson(Map<String, dynamic> json) => StripeIntentModel(
    id: json["id"],
    object: json["object"],
    amount: json["amount"],
    amountCapturable: json["amount_capturable"],
    amountDetails: AmountDetails.fromJson(json["amount_details"]),
    amountReceived: json["amount_received"],
    application: json["application"],
    applicationFeeAmount: json["application_fee_amount"],
    automaticPaymentMethods: json["automatic_payment_methods"],
    canceledAt: json["canceled_at"],
    cancellationReason: json["cancellation_reason"],
    captureMethod: json["capture_method"],
    clientSecret: json["client_secret"],
    confirmationMethod: json["confirmation_method"],
    created: json["created"],
    currency: json["currency"],
    customer: json["customer"],
    description: json["description"],
    invoice: json["invoice"],
    lastPaymentError: json["last_payment_error"],
    latestCharge: json["latest_charge"],
    livemode: json["livemode"],
    metadata: List<dynamic>.from(json["metadata"].map((x) => x)),
    nextAction: json["next_action"],
    onBehalfOf: json["on_behalf_of"],
    paymentMethod: json["payment_method"],
    paymentMethodConfigurationDetails: json["payment_method_configuration_details"],
    paymentMethodOptions: PaymentMethodOptions.fromJson(json["payment_method_options"]),
    paymentMethodTypes: List<String>.from(json["payment_method_types"].map((x) => x)),
    processing: json["processing"],
    receiptEmail: json["receipt_email"],
    review: json["review"],
    setupFutureUsage: json["setup_future_usage"],
    shipping: json["shipping"],
    source: json["source"],
    statementDescriptor: json["statement_descriptor"],
    statementDescriptorSuffix: json["statement_descriptor_suffix"],
    status: json["status"],
    transferData: json["transfer_data"],
    transferGroup: json["transfer_group"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "object": object,
    "amount": amount,
    "amount_capturable": amountCapturable,
    "amount_details": amountDetails.toJson(),
    "amount_received": amountReceived,
    "application": application,
    "application_fee_amount": applicationFeeAmount,
    "automatic_payment_methods": automaticPaymentMethods,
    "canceled_at": canceledAt,
    "cancellation_reason": cancellationReason,
    "capture_method": captureMethod,
    "client_secret": clientSecret,
    "confirmation_method": confirmationMethod,
    "created": created,
    "currency": currency,
    "customer": customer,
    "description": description,
    "invoice": invoice,
    "last_payment_error": lastPaymentError,
    "latest_charge": latestCharge,
    "livemode": livemode,
    "metadata": List<dynamic>.from(metadata.map((x) => x)),
    "next_action": nextAction,
    "on_behalf_of": onBehalfOf,
    "payment_method": paymentMethod,
    "payment_method_configuration_details": paymentMethodConfigurationDetails,
    "payment_method_options": paymentMethodOptions.toJson(),
    "payment_method_types": List<dynamic>.from(paymentMethodTypes.map((x) => x)),
    "processing": processing,
    "receipt_email": receiptEmail,
    "review": review,
    "setup_future_usage": setupFutureUsage,
    "shipping": shipping,
    "source": source,
    "statement_descriptor": statementDescriptor,
    "statement_descriptor_suffix": statementDescriptorSuffix,
    "status": status,
    "transfer_data": transferData,
    "transfer_group": transferGroup,
  };
}

class AmountDetails {
  final List<dynamic> tip;

  AmountDetails({
     this.tip,
  });

  AmountDetails copyWith({
    List<dynamic> tip,
  }) =>
      AmountDetails(
        tip: tip ?? this.tip,
      );

  factory AmountDetails.fromJson(Map<String, dynamic> json) => AmountDetails(
    tip: List<dynamic>.from(json["tip"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "tip": List<dynamic>.from(tip.map((x) => x)),
  };
}

class PaymentMethodOptions {
  final Card card;

  PaymentMethodOptions({
     this.card,
  });

  PaymentMethodOptions copyWith({
    Card card,
  }) =>
      PaymentMethodOptions(
        card: card ?? this.card,
      );

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) => PaymentMethodOptions(
    card: Card.fromJson(json["card"]),
  );

  Map<String, dynamic> toJson() => {
    "card": card.toJson(),
  };
}

class Card {
  final dynamic installments;
  final dynamic mandateOptions;
  final dynamic network;
  final String requestThreeDSecure;

  Card({
     this.installments,
     this.mandateOptions,
     this.network,
     this.requestThreeDSecure,
  });

  Card copyWith({
    dynamic installments,
    dynamic mandateOptions,
    dynamic network,
    String requestThreeDSecure,
  }) =>
      Card(
        installments: installments ?? this.installments,
        mandateOptions: mandateOptions ?? this.mandateOptions,
        network: network ?? this.network,
        requestThreeDSecure: requestThreeDSecure ?? this.requestThreeDSecure,
      );

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    installments: json["installments"],
    mandateOptions: json["mandate_options"],
    network: json["network"],
    requestThreeDSecure: json["request_three_d_secure"],
  );

  Map<String, dynamic> toJson() => {
    "installments": installments,
    "mandate_options": mandateOptions,
    "network": network,
    "request_three_d_secure": requestThreeDSecure,
  };
}
