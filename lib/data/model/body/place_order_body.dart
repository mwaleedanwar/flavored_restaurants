import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';

import '../response/offer_model.dart';

class PlaceOrderBody {
  List<Cart> cart;
  List<SpecialOfferModel> catering;
  List<OfferProduct> happyHours;
  double couponDiscountAmount;
  String couponDiscountTitle;
  double orderAmount;
  String orderType;
  int restaurantId;
  String paymentMethod;
  String userId;
  String paymentId;
  String chargeId;
  String tipChargeId;
  String orderNote;
  String couponCode;
  String deliveryTime;
  String deliveryDate;
  int branchId;
  double distance;
  double orderTip;
  double taxFee;
  String transactionReference;
  String platform;
  String address;
  String floor;

  String cardNo;
  String firstName;
  String expiryMonth;
  String lastName;
  String email;
  String expYear;
  String phone;
  String latitude;
  String longitude;
  String ccv;
  String cardHolder;
  String contactName;
  String contactPhone;
  String addressType;
  PlaceOrderBody copyWith({String paymentMethod, String transactionReference}) {
    paymentMethod = paymentMethod;
    transactionReference = transactionReference;
    return this;
  }

  PlaceOrderBody(
      {@required this.cart,
      @required this.catering,
      @required this.couponDiscountAmount,
      @required this.couponDiscountTitle,
      @required this.couponCode,
      @required this.orderAmount,
      @required this.restaurantId,
      @required this.orderType,
      @required this.paymentMethod,
      @required this.branchId,
      @required this.deliveryTime,
      @required this.deliveryDate,
      @required this.orderNote,
      @required this.distance,
      @required this.userId,
      @required this.paymentId,
      @required this.chargeId,
      @required this.tipChargeId,
      @required this.happyHours,
      this.orderTip,
      this.taxFee,
      this.transactionReference,
      this.platform,
      this.address,
      this.cardNo,
      this.expiryMonth,
      this.firstName,
      this.lastName,
      this.email,
      this.expYear,
      this.phone,
      this.floor,
      this.latitude,
      this.longitude,
      this.ccv,
      this.cardHolder,
      this.contactName,
      this.contactPhone,
      this.addressType});

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      cart = [];
      json['cart'].forEach((v) {
        cart.add(Cart.fromJson(v));
      });
    }
    if (json['catering'] != null) {
      cart = [];
      json['catering'].forEach((v) {
        catering.add(SpecialOfferModel.fromJson(v));
      });
    }
    if (json['happy_hours'] != null) {
      cart = [];
      json['happy_hours'].forEach((v) {
        catering.add(SpecialOfferModel.fromJson(v));
      });
    }
    couponDiscountAmount = json['coupon_discount_amount'];
    couponDiscountTitle = json['coupon_discount_title'];
    orderAmount = json['order_amount'];
    orderType = json['order_type'];
    restaurantId = json['delivery_address_id'];
    paymentMethod = json['payment_method'];
    userId = json['user_id'];
    chargeId = json['charge_id'];
    tipChargeId = json['tip_charge_id '];
    paymentId = json['payment_id'];
    orderNote = json['order_note'];
    couponCode = json['coupon_code'];
    deliveryTime = json['delivery_time'];
    deliveryDate = json['delivery_date'];
    branchId = json['branch_id'];
    distance = json['distance'];
    orderTip = json['order_tip_amount'];
    taxFee = json['total_tax_amount'];
    platform = json['platform '];
    address = json['address'];
    cardNo = json['card_no'];
    expiryMonth = json['exp_month'];
    firstName = json['f_name'];
    lastName = json['l_name'];
    email = json['email'];
    expYear = json['exp_year'];
    phone = json['phone'];
    floor = json['floor'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    ccv = json['cvc'];
    cardHolder = json['card_holder_name'];
    contactName = json['contact_person_name'];
    contactPhone = json['contact_person_number'];
    addressType = json['address_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (catering != null) {
      data['catering'] = catering.map((v) => v.toJson()).toList();
    }
    if (happyHours != null) {
      data['happy_hours'] = happyHours.map((v) => v.toJson()).toList();
    }
    if (cart != null) {
      data['cart'] = cart.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['coupon_discount_title'] = couponDiscountTitle;
    data['order_amount'] = orderAmount;
    data['order_type'] = orderType;
    data['restaurant_id'] = restaurantId;
    data['payment_method'] = paymentMethod;
    data['user_id'] = userId;
    data['charge_id'] = chargeId;
    data['tip_charge_id '] = tipChargeId;
    data['payment_id'] = paymentId;
    data['order_note'] = orderNote;
    data['coupon_code'] = couponCode;
    data['delivery_time'] = deliveryTime;
    data['delivery_date'] = deliveryDate;
    data['branch_id'] = branchId;
    data['distance'] = distance;
    data['order_tip_amount'] = orderTip;
    data['total_tax_amount'] = taxFee;
    data['address'] = address;
    data['card_no'] = cardNo;
    data['exp_month'] = expiryMonth;
    data['f_name'] = firstName;
    data['l_name'] = lastName;
    data['email'] = email;
    data['exp_year'] = expYear;
    data['phone'] = phone;
    data['floor'] = floor;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['cvc'] = ccv;
    data['card_holder_name'] = cardHolder;
    data['contact_person_name'] = contactName;
    data['contact_person_number'] = contactPhone;
    data['address_type'] = addressType;

    if (transactionReference != null) {
      data['transaction_reference'] = transactionReference;
    }
    if (platform != null) {
      data['platform'] = platform;
    }
    return data;
  }
}

class Cart {
  String productId;
  String cateringId;
  String happyHoursId;
  String dealId;
  String price;
  String variant;
  double discountAmount;
  int quantity;
  double taxAmount;
  List<Variation> variation;
  List<int> addOnIds;
  List<int> addOnQtys;

  Cart(
    this.productId,
    this.price,
    this.cateringId,
    this.happyHoursId,
    this.dealId,
    this.variant,
    this.variation,
    this.discountAmount,
    this.quantity,
    this.taxAmount,
    this.addOnIds,
    this.addOnQtys,
  );

  Cart.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    cateringId = json['catering_id'];
    happyHoursId = json['happy_hour_id'];
    dealId = json['deal_id'];
    price = json['price'];
    variant = json['variant'];
    if (json['variation'] != null) {
      variation = [];
      json['variation'].forEach((v) {
        variation.add(Variation.fromJson(v));
      });
    }
    discountAmount = json['discount_amount'];
    quantity = json['quantity'];
    taxAmount = json['tax_amount'];
    addOnIds = json['add_on_ids'].cast<int>();
    addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['catering_id'] = cateringId;
    data['happy_hour_id'] = happyHoursId;
    data['deal_id'] = dealId;
    data['price'] = price;
    data['variant'] = variant;
    if (variation != null) {
      data['variation'] = variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['tax_amount'] = taxAmount;
    data['add_on_ids'] = addOnIds;
    data['add_on_qtys'] = addOnQtys;
    return data;
  }
}
