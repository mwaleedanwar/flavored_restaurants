class DeliveryManModel {
  int id;
  int orderId;
  int deliverymanId;
  String time;
  String longitude;
  String latitude;
  String location;
  String createdAt;
  String updatedAt;

  DeliveryManModel({
    required this.id,
    required this.orderId,
    required this.deliverymanId,
    required this.time,
    required this.longitude,
    required this.latitude,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryManModel.fromJson(Map<String, dynamic> json) {
    return DeliveryManModel(
      id: json['id'],
      orderId: json['order_id'],
      deliverymanId: json['deliveryman_id'],
      time: json['time'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      location: json['location'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['deliveryman_id'] = deliverymanId;
    data['time'] = time;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['location'] = location;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
