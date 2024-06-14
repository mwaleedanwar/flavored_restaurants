import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';

import '../response/offer_model.dart';

class PlaceOrderBody {
  List<Cart> _cart;
  List<SpecialOfferModel> _catering;
  List<OfferProduct> _happyHours;
  double _couponDiscountAmount;
  String _couponDiscountTitle;
  double _orderAmount;
  String _orderType;
  int _restaurantId;
  String _paymentMethod;
  String _userId;
  String _paymentId;
  String _chargeId;
  String _tipChargeId;
  String _orderNote;
  String _couponCode;
  String _deliveryTime;
  String _deliveryDate;
  int _branchId;
  double _distance;
  double _orderTip;
  double _taxFee;
  String _transactionReference;
  String _platform;
  String _address;
  String _floor;

  String _cardNo;
  String _firstName;
  String _expiryMonth;
  String _lastName;
  String _email;
  String _expYear;
  String _phone;
  String _latitude;
  String _longitude;
  String _ccv;
  String _cardHolder;
  String _contactName;
  String _contactPhone;
  String _addressType;
  PlaceOrderBody copyWith({String paymentMethod, String transactionReference}) {
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    return this;
  }

  PlaceOrderBody(
      {@required List<Cart> cart,
      @required List<SpecialOfferModel> catering,
      @required List<OfferProduct> happyHours,
      @required double couponDiscountAmount,
      @required String couponDiscountTitle,
      @required String couponCode,
      @required double orderAmount,
      @required int restaurantId,
      @required String orderType,
      @required String paymentMethod,
      @required int branchId,
      @required String deliveryTime,
      @required String deliveryDate,
      @required String orderNote,
      @required double distance,
      double orderTip,
      double taxFee,
      @required String userId,
      @required String paymentId,
      @required String chargeId,
      @required String tipChargeId,
      String transactionReference,
      String platform,
      String address,
      String cardNo,
      String expiryMonth,
      String firstName,
      String lastName,
      String email,
      String expYear,
      String phone,
      String floor,
      String latitude,
      String longitude,
      String ccv,
      String cardHolder,
      String contactName,
      String contactPhone,
      String addressType}) {
    this._cart = cart;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._orderAmount = orderAmount;
    this._orderType = orderType;
    this._restaurantId = restaurantId;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
    this._deliveryTime = deliveryTime;
    this._deliveryDate = deliveryDate;
    this._branchId = branchId;
    this._distance = distance;
    this._orderTip = orderTip;
    this._taxFee = taxFee;
    this._userId = userId;
    this._chargeId = chargeId;
    this._tipChargeId = tipChargeId;
    this._paymentId = paymentId;
    this._catering = catering;
    this._happyHours = happyHours;

    this._transactionReference = transactionReference;
    this._platform = platform;
    this._address = address;
    this._floor = _floor;
    this._cardNo = cardNo;
    this._expiryMonth = expiryMonth;
    this._firstName = firstName;
    this._lastName = lastName;
    this._email = email;
    this._expYear = expYear;
    this._phone = phone;
    this._latitude = latitude;
    this._longitude = longitude;
    this._ccv = ccv;
    this._cardHolder = cardHolder;
    this._contactName = contactName;
    this._contactPhone = contactPhone;
    this._addressType = addressType;
  }

  List<Cart> get cart => _cart;
  List<OfferProduct> get happyOffers => _happyHours;
  List<SpecialOfferModel> get catering => _catering;
  double get couponDiscountAmount => _couponDiscountAmount;
  String get couponDiscountTitle => _couponDiscountTitle;
  double get orderAmount => _orderAmount;
  String get orderType => _orderType;
  int get restaurantId => _restaurantId;
  String get paymentMethod => _paymentMethod;
  String get userId => _userId;
  String get chargeId => _chargeId;
  String get tipChargeId => _tipChargeId;
  String get paymentId => _paymentId;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;
  String get deliveryTime => _deliveryTime;
  String get deliveryDate => _deliveryDate;
  int get branchId => _branchId;
  double get distance => _distance;
  double get orderTip => _orderTip;
  double get taxFee => _taxFee;
  String get transactionReference => _transactionReference;
  String get platform => _platform;
  String get address => _address;
  String get cardNo => _cardNo;
  String get expiryMonth => _expiryMonth;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get expYear => _expYear;
  String get phone => _phone;
  String get floor => _floor;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get ccv => _ccv;
  String get cardHolder => _cardHolder;
  String get contactName => _contactName;
  String get contactPhone => _contactName;
  String get addressType => _addressType;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new Cart.fromJson(v));
      });
    }
    if (json['catering'] != null) {
      _cart = [];
      json['catering'].forEach((v) {
        _catering.add(new SpecialOfferModel.fromJson(v));
      });
    }
    if (json['happy_hours'] != null) {
      _cart = [];
      json['happy_hours'].forEach((v) {
        _catering.add(new SpecialOfferModel.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'];
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'];
    _orderType = json['order_type'];
    _restaurantId = json['delivery_address_id'];
    _paymentMethod = json['payment_method'];
    _userId = json['user_id'];
    _chargeId = json['charge_id'];
    _tipChargeId = json['tip_charge_id '];
    _paymentId = json['payment_id'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _deliveryTime = json['delivery_time'];
    _deliveryDate = json['delivery_date'];
    _branchId = json['branch_id'];
    _distance = json['distance'];
    _orderTip = json['order_tip_amount'];
    _taxFee = json['total_tax_amount'];
    _platform = json['platform '];
    _address = json['address'];
    _cardNo = json['card_no'];
    _expiryMonth = json['exp_month'];
    _firstName = json['f_name'];
    _lastName = json['l_name'];
    _email = json['email'];
    _expYear = json['exp_year'];
    _phone = json['phone'];
    _floor = json['floor'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _ccv = json['cvc'];
    _cardHolder = json['card_holder_name'];
    _contactName = json['contact_person_name'];
    _contactPhone = json['contact_person_number'];
    _addressType = json['address_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._catering != null) {
      data['catering'] = this._catering.map((v) => v.toJson()).toList();
    }
    if (this._happyHours != null) {
      data['happy_hours'] = this._happyHours.map((v) => v.toJson()).toList();
    }
    if (this._cart != null) {
      data['cart'] = this._cart.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['order_amount'] = this._orderAmount;
    data['order_type'] = this._orderType;
    data['restaurant_id'] = this._restaurantId;
    data['payment_method'] = this._paymentMethod;
    data['user_id'] = this._userId;
    data['charge_id'] = this._chargeId;
    data['tip_charge_id '] = this._tipChargeId;
    data['payment_id'] = this._paymentId;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;
    data['delivery_time'] = this._deliveryTime;
    data['delivery_date'] = this._deliveryDate;
    data['branch_id'] = this._branchId;
    data['distance'] = this._distance;
    data['order_tip_amount'] = this._orderTip;
    data['total_tax_amount'] = this._taxFee;
    data['address'] = this._address;
    data['card_no'] = this._cardNo;
    data['exp_month'] = this._expiryMonth;
    data['f_name'] = this._firstName;
    data['l_name'] = this._lastName;
    data['email'] = this._email;
    data['exp_year'] = this._expYear;
    data['phone'] = this._phone;
    data['floor'] = this._floor;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['cvc'] = this._ccv;
    data['card_holder_name'] = this._cardHolder;
    data['contact_person_name'] = this._contactName;
    data['contact_person_number'] = this._contactPhone;
    data['address_type'] = this._addressType;

    if (_transactionReference != null) {
      data['transaction_reference'] = this._transactionReference;
    }
    if (platform != null) {
      data['platform'] = this._platform;
    }
    return data;
  }
}

class Cart {
  String _productId;
  String _cateringId;
  String _happyHoursId;
  String _dealId;
  String _price;
  String _variant;
  List<Variation> _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  List<int> _addOnIds;
  List<int> _addOnQtys;

  Cart(
      String productId,
      String price,
      String cateringId,
      String happyHoursId,
      String dealId,
      String variant,
      List<Variation> variation,
      double discountAmount,
      int quantity,
      double taxAmount,
      List<int> addOnIds,
      List<int> addOnQtys) {
    this._productId = productId;
    this._price = price;
    this._variant = variant;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._dealId = dealId;
    this._taxAmount = taxAmount;
    this._addOnIds = addOnIds;
    this._addOnQtys = addOnQtys;
    this._cateringId = cateringId;
    this._happyHoursId = happyHoursId;
  }

  String get productId => _productId;
  String get cateringId => _cateringId;
  String get happyHoursId => _happyHoursId;
  String get dealId => _dealId;
  String get price => _price;
  String get variant => _variant;
  List<Variation> get variation => _variation;
  double get discountAmount => _discountAmount;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;
  List<int> get addOnIds => _addOnIds;
  List<int> get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _cateringId = json['catering_id'];
    _happyHoursId = json['happy_hour_id'];
    _dealId = json['deal_id'];

    _price = json['price'];
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'];
    _addOnIds = json['add_on_ids'].cast<int>();
    _addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['catering_id'] = this._cateringId;
    data['happy_hour_id'] = this._happyHoursId;
    data['deal_id'] = this._dealId;
    data['price'] = this._price;
    data['variant'] = this._variant;
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['add_on_ids'] = this._addOnIds;
    data['add_on_qtys'] = this._addOnQtys;
    return data;
  }
}
