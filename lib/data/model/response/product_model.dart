import 'package:flutter/foundation.dart';

class ProductModel {
  int totalSize;
  String limit;
  String offset;
  List<Product>? products;

  ProductModel({
    required this.totalSize,
    required this.limit,
    required this.offset,
    this.products,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final pm = ProductModel(
      totalSize: json['total_size'],
      limit: json['limit'].toString(),
      offset: json['offset'].toString(),
    );
    if (json['products'] != null) {
      final products = <Product>[];
      json['products'].forEach((v) {
        products.add(Product.fromJson(v));
      });
      pm.products = products;
    }
    return pm;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['products'] = products?.map((v) => v.toJson()).toList();
    return data;
  }
}

class Product {
  int id;
  String name;
  String description;
  String image;
  double price;
  double tax;
  String? availableTimeStarts;
  String? availableTimeEnds;
  int status;
  String createdAt;
  String updatedAt;
  double discount;
  String discountType;
  String isRecommended;
  String taxType;
  String loyaltyPoints;
  int setMenu;
  String? productType;
  List<String> attributes;
  List<Variation>? variations;
  List<AddOns>? addOns;
  List<CategoryId>? categoryIds;
  List<ChoiceOption>? choiceOptions;
  List<ChoiceOption>? removalOption;
  List<Rating>? rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.tax,
    this.availableTimeStarts,
    this.availableTimeEnds,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.discount,
    required this.discountType,
    required this.taxType,
    required this.isRecommended,
    required this.loyaltyPoints,
    required this.setMenu,
    required this.attributes,
    this.productType,
    this.variations,
    this.addOns,
    this.categoryIds,
    this.choiceOptions,
    this.removalOption,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final product = Product(
      id: json['id'] ?? '',
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
      tax: json['tax'].toDouble(),
      availableTimeStarts: json['available_time_starts'] ?? '',
      availableTimeEnds: json['available_time_ends'] ?? '',
      status: json['status'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isRecommended: json['is_recomended'],
      attributes: json['attributes'].cast<String>(),
      discount: json['discount'].toDouble(),
      discountType: json['discount_type'],
      taxType: json['tax_type'],
      loyaltyPoints: json['loyalty_points'] ?? '0',
      setMenu: json['set_menu'],
      productType: json["product_type"],
    );
    if (json['variations'] != null) {
      final variations = <Variation>[];
      json['variations'].forEach((v) {
        variations.add(Variation.fromJson(v));
      });
      product.variations = variations;
    }
    if (json['add_ons'] != null) {
      final addOns = <AddOns>[];
      json['add_ons'].forEach((v) {
        addOns.add(AddOns.fromJson(v));
      });
      product.addOns = addOns;
    }
    if (json['category_ids'] != null) {
      final categoryIds = <CategoryId>[];
      json['category_ids'].forEach((v) {
        categoryIds.add(CategoryId.fromJson(v));
      });
      product.categoryIds = categoryIds;
    }
    if (json['choice_options'] != null) {
      final choiceOptions = <ChoiceOption>[];
      json['choice_options'].forEach((v) {
        choiceOptions.add(ChoiceOption.fromJson(v));
      });
      product.choiceOptions = choiceOptions;
    }
    if (json['removal_options'] != null) {
      final removalOption = <ChoiceOption>[];
      json['removal_options'].forEach((v) {
        removalOption.add(ChoiceOption.fromJson(v));
      });
      product.removalOption = removalOption;
    }
    if (json['rating'] != null) {
      final rating = <Rating>[];
      json['rating'].forEach((v) {
        rating.add(Rating.fromJson(v));
      });
      product.rating = rating;
    }
    return product;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    data['tax'] = tax;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['attributes'] = attributes;
    data['is_recomended'] = isRecommended;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['tax_type'] = taxType;
    data['loyalty_points'] = loyaltyPoints;
    data['set_menu'] = setMenu;
    data['variations'] = variations?.map((v) => v.toJson()).toList();
    data['variations'] = variations?.map((v) => v.toJson()).toList();
    data['add_ons'] = addOns?.map((v) => v.toJson()).toList();
    data['category_ids'] = categoryIds?.map((v) => v.toJson()).toList();
    data['choice_options'] = choiceOptions?.map((v) => v.toJson()).toList();
    data['removal_options'] = removalOption?.map((v) => v.toJson()).toList();
    data['rating'] = rating?.map((v) => v.toJson()).toList();
    return data;
  }
}

class AddOns {
  int id;
  String name;
  double price;
  String createdAt;
  String updatedAt;

  AddOns({
    required this.id,
    required this.name,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddOns.fromJson(Map<String, dynamic> json) {
    return AddOns(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CategoryId {
  String id;

  CategoryId({required this.id});

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(id: json['id'].toString());

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class ChoiceOption {
  String name;
  String title;
  List<String> options;

  ChoiceOption({
    required this.name,
    required this.title,
    required this.options,
  });

  factory ChoiceOption.fromJson(Map<String, dynamic> json) {
    return ChoiceOption(
      name: json['name'],
      title: json['title'],
      options: json['options'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['options'] = options;
    return data;
  }
}

class Rating {
  String average;
  int productId;

  Rating({required this.average, required this.productId});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      average: json['average'],
      productId: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average'] = average;
    data['product_id'] = productId;
    return data;
  }
}

class Variation {
  String name;
  String type;
  int min;
  int max;
  bool required;
  List<Value>? values;

  Variation({
    required this.name,
    required this.type,
    required this.min,
    required this.max,
    required this.required,
    this.values,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        name: json["name"],
        type: json["type"],
        min: json["type"] == 'multi' ? int.parse((json["min"] ?? '0').toString()) : json["min"],
        max: json["type"] == 'multi' ? int.parse((json["max"] ?? '0').toString()) : json["max"],
        required: json["required"] == "on",
        values: json["values"] != null ? List<Value>.from(json["values"].map((x) => Value.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "min": min,
        "max": max,
        "required": required == true ? "on" : "off",
        "values": values != null ? List<dynamic>.from(values!.map((x) => x.toJson())) : [],
      };

  Variation copyWith({
    String? name,
    String? type,
    int? min,
    int? max,
    bool? required,
    List<Value>? values,
  }) {
    return Variation(
      name: name ?? this.name,
      type: type ?? this.type,
      min: min ?? this.min,
      max: max ?? this.max,
      required: required ?? this.required,
      values: values ?? this.values,
    );
  }

  @override
  String toString() {
    return 'Variation(name: $name, type: $type, min: $min, max: $max, required: $required, values: $values)';
  }

  @override
  bool operator ==(covariant Variation other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.type == type &&
        other.min == min &&
        other.max == max &&
        other.required == required &&
        other.values != null &&
        values != null &&
        setEquals(
          Set.from(other.values!),
          Set.from(values!),
        );
  }

  @override
  int get hashCode {
    return name.hashCode ^ type.hashCode ^ min.hashCode ^ max.hashCode ^ required.hashCode ^ values.hashCode;
  }
}

class Value {
  String label;
  String optionPrice;

  Value({
    required this.label,
    required this.optionPrice,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        label: json["label"],
        optionPrice: json["optionPrice"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "optionPrice": optionPrice,
      };

  Value copyWith({
    String? label,
    String? optionPrice,
  }) {
    return Value(
      label: label ?? this.label,
      optionPrice: optionPrice ?? this.optionPrice,
    );
  }

  @override
  String toString() => 'Value(label: $label, optionPrice: $optionPrice)';

  @override
  bool operator ==(covariant Value other) {
    if (identical(this, other)) return true;

    return other.label == label && other.optionPrice == optionPrice;
  }

  @override
  int get hashCode => label.hashCode ^ optionPrice.hashCode;
}
