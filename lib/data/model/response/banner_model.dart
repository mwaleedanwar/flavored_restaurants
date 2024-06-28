class BannerModel {
  int id;
  String title;
  String image;
  int productId;
  String createdAt;
  String updatedAt;
  int categoryId;

  BannerModel({
    this.id,
    this.title,
    this.image,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
  });

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryId = json['category_id'];
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
