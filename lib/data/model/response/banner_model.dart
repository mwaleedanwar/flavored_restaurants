class BannerModel {
  int id;
  String title;
  String image;
  int? productId;
  String createdAt;
  String updatedAt;
  int categoryId;

  BannerModel({
    required this.id,
    required this.title,
    required this.image,
    this.productId,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      productId: json['product_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['product_id'] = productId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['category_id'] = categoryId;
    return data;
  }
}
