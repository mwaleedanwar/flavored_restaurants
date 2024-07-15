// To parse this JSON data, do
//
//     final categoryProductModel = categoryProductModelFromJson(jsonString);

import 'dart:convert';

import 'product_model.dart';

List<CategoryProductModel> categoryProductModelFromJson(String str) =>
    List<CategoryProductModel>.from(json.decode(str).map((x) => CategoryProductModel.fromJson(x)));

String categoryProductModelToJson(List<CategoryProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryProductModel {
  CategoryProductModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.position,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.bannerImage,
    required this.restaurantId,
    required this.products,
    required this.translations,
  });

  int id;
  String name;
  int parentId;
  int position;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  String bannerImage;
  String restaurantId;
  List<Product> products;
  List<dynamic> translations;

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) {
    return CategoryProductModel(
      id: json["id"],
      name: json["name"],
      parentId: json["parent_id"],
      position: json["position"],
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      image: json["image"],
      bannerImage: json["banner_image"],
      restaurantId: json["restaurant_id"],
      products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
      translations: List<dynamic>.from(json["translations"].map((x) => x)),
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "parent_id": parentId,
      "position": position,
      "status": status,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "image": image,
      "banner_image": bannerImage,
      "restaurant_id": restaurantId,
      "products": List<dynamic>.from(products.map((x) => x.toJson())),
      "translations": List<dynamic>.from(translations.map((x) => x)),
    };
  }
}
