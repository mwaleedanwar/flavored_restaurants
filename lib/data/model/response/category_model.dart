class CategoryModel {
  int id;
  String name;
  int parentId;
  int position;
  int status;
  String createdAt;
  String updatedAt;
  String image;
  String bannerImage;

  CategoryModel({
    this.id,
    this.name,
    this.parentId,
    this.position,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.bannerImage,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    parentId = json['parent_id'] ?? 0;
    position = json['position'] ?? 0;
    status = json['status'] ?? 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'] ?? '';
    bannerImage = json['banner_image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['position'] = position;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    data['banner_image'] = bannerImage;
    return data;
  }
}
