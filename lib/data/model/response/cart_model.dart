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
  Product product;
  bool isGift;
  List<Variation> variation;
  List<AddOn> addOnIds;

  CartModel({
    this.price = 0,
    this.points,
    this.discountedPrice,
    this.discountAmount,
    this.quantity,
    this.specialInstruction,
    this.taxAmount,
    this.product,
    this.isGift,
    this.isFree = false,
    this.variation,
    this.addOnIds,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    points = json['points'].toDouble();
    discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      variation = [];
      json['variation'].forEach((v) {
        variation.add(Variation.fromJson(v));
      });
    }
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];
    isGift = json['_isGift'];
    specialInstruction = json['special_instructions'];
    isFree = json['_isFree'];
    taxAmount = json['tax_amount'].toDouble();
    if (json['add_on_ids'] != null) {
      addOnIds = [];
      json['add_on_ids'].forEach((v) {
        addOnIds.add(AddOn.fromJson(v));
      });
    }
    if (json['product'] != null) {
      product = Product.fromJson(json['product']);
    }
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
    data['product'] = product.toJson();
    if (variation != null) {
      data['variation'] = variation.map((v) => v.toJson()).toList();
    }
    if (addOnIds != null) {
      data['add_on_ids'] = addOnIds.map((v) => v.toJson()).toList();
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

  AddOn({this.id, this.quantity});

  AddOn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
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

  double discountAmount;
  int quantity;

  SpecialOfferModel catering;

  CateringCartModel({
    this.price,
    this.discountedPrice,
    this.discountAmount,
    this.quantity,
    this.catering,
  });

  CateringCartModel.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    discountedPrice = json['discounted_price'].toDouble();
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];
    if (json['catering'] != null) {
      catering = SpecialOfferModel.fromJson(json['catering']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['catering'] = catering.toJson();
    return data;
  }
}

class DealCartModel {
  double price;
  int quantity;
  double discountedPrice;
  double discountAmount;
  DealsDataModel dealsDataModel;

  DealCartModel({
    this.price,
    this.quantity,
    this.discountedPrice,
    this.discountAmount,
    this.dealsDataModel,
  });

  DealCartModel.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    discountedPrice = json['discounted_price'].toDouble();
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];

    if (json['catering'] != null) {
      dealsDataModel = DealsDataModel.fromJson(json['deals']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['deals'] = dealsDataModel.toJson();
    return data;
  }
}

class HappyHoursCartModel {
  double price;
  double discountAmount;
  int quantity;
  OfferProduct happyHours;

  HappyHoursCartModel({
    this.price,
    this.discountAmount,
    this.quantity,
    this.happyHours,
  });

  HappyHoursCartModel.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];
    if (json['happy_hours'] != null) {
      happyHours = OfferProduct.fromJson(json['happy_hours']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['happy_hours'] = happyHours.toJson();
    return data;
  }
}
