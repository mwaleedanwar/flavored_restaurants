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
    required this.id,
    required this.name,
    required this.parentId,
    required this.position,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.bannerImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      parentId: json['parent_id'] ?? 0,
      position: json['position'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: json['image'] ?? '',
      bannerImage: json['banner_image'] ?? '',
    );
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
