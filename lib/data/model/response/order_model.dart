import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';

class OrderModel {
  int id;
  int userId;
  double orderAmount;
  double couponDiscountAmount;
  String? couponDiscountTitle;
  String paymentStatus;
  String orderStatus;
  double totalTaxAmount;
  double orderTip;
  String paymentMethod;
  String? transactionReference;
  int? deliveryAddressId;
  String createdAt;
  String updatedAt;
  int? deliveryManId;
  double deliveryCharge;
  String? orderNote;
  List<int>? addOnIds;
  List<Details>? details;
  DeliveryMan? deliveryMan;
  int? detailsCount;
  String orderType;
  String? deliveryTime;
  String deliveryDate;
  double? extraDiscount;
  DeliveryAddress? deliveryAddress;
  String preparationTime;
  bool isProductAvailable;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderAmount,
    required this.couponDiscountAmount,
    this.couponDiscountTitle,
    required this.paymentStatus,
    required this.orderStatus,
    required this.totalTaxAmount,
    required this.orderTip,
    required this.paymentMethod,
    this.transactionReference,
    this.deliveryAddressId,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryManId,
    required this.deliveryCharge,
    this.orderNote,
    this.detailsCount,
    this.deliveryTime,
    required this.deliveryDate,
    required this.orderType,
    required this.preparationTime,
    required this.isProductAvailable,
    this.addOnIds,
    this.details,
    this.deliveryMan,
    this.extraDiscount,
    this.deliveryAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final om = OrderModel(
      id: json['id'],
      userId: json['user_id'],
      orderAmount: json['order_amount'].toDouble(),
      couponDiscountAmount: json['coupon_discount_amount'].toDouble(),
      couponDiscountTitle: json['coupon_discount_title'],
      paymentStatus: json['payment_status'],
      orderStatus:
          json['order_status'] == 'cooking' || json['order_status'] == 'done' ? 'processing' : json['order_status'],
      totalTaxAmount: json['total_tax_amount'].toDouble(),
      orderTip: json['order_tip_amount'] == null ? 0.0 : double.parse(json['order_tip_amount'].toString()),
      paymentMethod: json['payment_method'],
      transactionReference: json['transaction_reference'],
      deliveryAddressId: json['delivery_address_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deliveryManId: json['delivery_man_id'],
      deliveryCharge: json['delivery_charge'].toDouble(),
      orderNote: json['order_note'],
      detailsCount: json['details_count'],
      addOnIds: json['add_on_ids']?.cast<int>(),
      deliveryMan: json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man']) : null,
      orderType: json['order_type'],
      deliveryTime: json['delivery_time'],
      deliveryDate: json['delivery_date'],
      extraDiscount: double.tryParse(json['extra_discount'] ?? ''),
      deliveryAddress: json['delivery_address'] != null ? DeliveryAddress.fromJson(json['delivery_address']) : null,
      preparationTime: json['preparation_time']?.toString() ?? '0',
      isProductAvailable: int.tryParse('${json['is_product_available']}') == 1 ? true : false,
    );

    if (json['details'] != null) {
      final details = <Details>[];
      json['details'].forEach((v) {
        details.add(Details.fromJson(v));
      });
      om.details = details;
    }
    return om;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_amount'] = orderAmount;
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['coupon_discount_title'] = couponDiscountTitle;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['total_tax_amount'] = totalTaxAmount;
    data['payment_method'] = paymentMethod;
    data['transaction_reference'] = transactionReference;
    data['delivery_address_id'] = deliveryAddressId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_man_id'] = deliveryManId;
    data['delivery_charge'] = deliveryCharge;
    data['order_note'] = orderNote;
    data['add_on_ids'] = addOnIds;
    data['details_count'] = detailsCount;
    data['order_type'] = orderType;
    data['delivery_time'] = deliveryTime;
    data['delivery_date'] = deliveryDate;
    data['extra_discount'] = extraDiscount;
    data['order_tip_amount'] = orderTip.toString();
    data['delivery_man'] = deliveryMan?.toJson();
    data['delivery_address'] = deliveryAddress?.toJson();
    data['details'] = details?.map((v) => v.toJson()).toList();
    return data;
  }
}

class DeliveryAddress {
  int id;
  String addressType;
  String contactPersonNumber;
  String address;
  String latitude;
  String longitude;
  String createdAt;
  String updatedAt;
  int userId;
  String contactPersonName;

  DeliveryAddress({
    required this.id,
    required this.addressType,
    required this.contactPersonNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.contactPersonName,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'],
      addressType: json['address_type'],
      contactPersonNumber: json['contact_person_number'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      contactPersonName: json['contact_person_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_type'] = addressType;
    data['contact_person_number'] = contactPersonNumber;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    data['contact_person_name'] = contactPersonName;
    return data;
  }
}

class Details {
  int? id;
  int? productId;
  int? orderId;
  double? price;
  double? discountOnProduct;
  String? discountType;
  int? quantity;
  double? taxAmount;
  String? createdAt;
  String? updatedAt;

  Details({
    this.id,
    this.productId,
    this.orderId,
    this.price,
    this.discountOnProduct,
    this.discountType,
    this.quantity,
    this.taxAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      id: json['id'],
      productId: json['product_id'],
      orderId: json['order_id'],
      price: json['price'].toDouble(),
      discountOnProduct: json['discount_on_product']?.toDouble(),
      discountType: json['discount_type'],
      quantity: json['quantity'],
      taxAmount: json['tax_amount']?.toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['order_id'] = orderId;
    data['price'] = price;
    data['discount_on_product'] = discountOnProduct;
    data['discount_type'] = discountType;
    data['quantity'] = quantity;
    data['tax_amount'] = taxAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DeliveryMan {
  int id;
  String fName;
  String lName;
  String phone;
  String email;
  String identityNumber;
  String identityType;
  String identityImage;
  String image;
  String password;
  String createdAt;
  String updatedAt;
  String authToken;
  String fcmToken;
  List<Rating>? rating;

  DeliveryMan({
    required this.id,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.email,
    required this.identityNumber,
    required this.identityType,
    required this.identityImage,
    required this.image,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    required this.authToken,
    required this.fcmToken,
    this.rating,
  });

  factory DeliveryMan.fromJson(Map<String, dynamic> json) {
    final dm = DeliveryMan(
      id: json['id'],
      fName: json['f_name'],
      lName: json['l_name'],
      phone: json['phone'],
      email: json['email'],
      identityNumber: json['identity_number'],
      identityType: json['identity_type'],
      identityImage: json['identity_image'],
      image: json['image'],
      password: json['password'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      authToken: json['auth_token'],
      fcmToken: json['fcm_token'],
    );
    if (json['rating'] != null) {
      final rating = <Rating>[];
      json['rating'].forEach((v) {
        rating.add(Rating.fromJson(v));
      });
      dm.rating = rating;
    }
    return dm;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['identity_number'] = identityNumber;
    data['identity_type'] = identityType;
    data['identity_image'] = identityImage;
    data['image'] = image;
    data['password'] = password;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['auth_token'] = authToken;
    data['fcm_token'] = fcmToken;
    data['rating'] = rating?.map((v) => v.toJson()).toList();
    return data;
  }
}
