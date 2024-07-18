import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/deals_data_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/offer_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';

class CartModel {
  double points;
  bool isFree;
  double price;
  double discountedPrice;
  String specialInstruction;
  double discountAmount;
  int quantity;
  double taxAmount;
  bool isGift;
  Product? product;
  List<Variation?>? variation;
  List<AddOn>? addOnIds;

  CartModel({
    this.price = 0,
    this.isFree = false,
    required this.points,
    required this.discountedPrice,
    required this.discountAmount,
    required this.quantity,
    required this.specialInstruction,
    required this.taxAmount,
    required this.isGift,
    this.product,
    this.variation,
    this.addOnIds,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final cart = CartModel(
      price: json['price'].toDouble(),
      points: json['points'].toDouble(),
      discountedPrice: json['discounted_price'].toDouble(),
      discountAmount: json['discount_amount'].toDouble(),
      quantity: json['quantity'],
      isGift: json['_isGift'],
      specialInstruction: json['special_instructions'],
      isFree: json['_isFree'],
      taxAmount: json['tax_amount'].toDouble(),
    );
    if (json['variation'] != null) {
      final variation = <Variation>[];
      json['variation'].forEach((v) {
        variation.add(Variation.fromJson(v));
      });
      cart.variation = variation;
    }
    if (json['add_on_ids'] != null) {
      final addOnIds = <AddOn>[];
      json['add_on_ids'].forEach((v) {
        addOnIds.add(AddOn.fromJson(v));
      });
      cart.addOnIds = addOnIds;
    }
    if (json['product'] != null) {
      cart.product = Product.fromJson(json['product']);
    }
    return cart;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['points'] = points;
    data['discounted_price'] = discountedPrice;
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['special_instructions'] = specialInstruction;
    data['_isGift'] = isGift;
    data['_isFree'] = isFree;
    data['tax_amount'] = taxAmount;
    data['product'] = product?.toJson();
    if (variation != null) {
      data['variation'] = variation?.map((v) => v?.toJson()).toList();
    }
    if (addOnIds != null) {
      data['add_on_ids'] = addOnIds?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "CART JSON: ${toJson()}";
  }
}

class AddOn {
  int id;
  int quantity;

  AddOn({required this.id, required this.quantity});

  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(id: json['id'], quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    return data;
  }
}

class CateringCartModel {
  double price;

  double discountedPrice;

  double? discountAmount;
  int quantity;

  SpecialOfferModel? catering;

  CateringCartModel({
    required this.price,
    required this.discountedPrice,
    this.discountAmount,
    required this.quantity,
    this.catering,
  });

  factory CateringCartModel.fromJson(Map<String, dynamic> json) {
    final ccm = CateringCartModel(
      price: json['price'].toDouble(),
      discountedPrice: json['discounted_price'].toDouble(),
      discountAmount: json['discount_amount'].toDouble(),
      quantity: json['quantity'],
    );
    if (json['catering'] != null) {
      ccm.catering = SpecialOfferModel.fromJson(json['catering']);
    }
    return ccm;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['catering'] = catering?.toJson();
    return data;
  }
}

class DealCartModel {
  double price;
  int quantity;
  double discountedPrice;
  double discountAmount;
  DealsDataModel? dealsDataModel;

  DealCartModel({
    required this.price,
    required this.quantity,
    required this.discountedPrice,
    required this.discountAmount,
    this.dealsDataModel,
  });

  factory DealCartModel.fromJson(Map<String, dynamic> json) {
    final dcm = DealCartModel(
      price: json['price'].toDouble(),
      discountedPrice: json['discounted_price'].toDouble(),
      discountAmount: json['discount_amount'].toDouble(),
      quantity: json['quantity'],
    );

    if (json['catering'] != null) {
      dcm.dealsDataModel = DealsDataModel.fromJson(json['deals']);
    }
    return dcm;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['deals'] = dealsDataModel?.toJson();
    return data;
  }
}

class HappyHoursCartModel {
  double price;
  double discountAmount;
  int quantity;
  OfferProduct? happyHours;

  HappyHoursCartModel({
    required this.price,
    required this.discountAmount,
    required this.quantity,
    this.happyHours,
  });

  factory HappyHoursCartModel.fromJson(Map<String, dynamic> json) {
    final hhcm = HappyHoursCartModel(
      price: json['price'].toDouble(),
      discountAmount: json['discount_amount'].toDouble(),
      quantity: json['quantity'],
    );
    if (json['happy_hours'] != null) {
      hhcm.happyHours = OfferProduct.fromJson(json['happy_hours']);
    }
    return hhcm;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['happy_hours'] = happyHours?.toJson();
    return data;
  }
}
