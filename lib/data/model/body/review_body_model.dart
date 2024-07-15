class ReviewBody {
  String? productId;
  String? deliveryManId;
  String comment;
  String rating;
  String orderId;
  double? orderTip;
  List<String>? fileUpload;

  ReviewBody({
    required this.comment,
    required this.rating,
    required this.orderId,
    this.productId,
    this.deliveryManId,
    this.orderTip,
    this.fileUpload,
  });

  factory ReviewBody.fromJson(Map<String, dynamic> json) {
    return ReviewBody(
      productId: json['product_id'],
      deliveryManId: json['delivery_man_id'],
      comment: json['comment'],
      orderId: json['order_id'],
      rating: json['rating'],
      orderTip: json['delivery_tip_amount'],
      fileUpload: json['attachment'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['delivery_man_id'] = deliveryManId;
    data['comment'] = comment;
    data['order_id'] = orderId;
    data['rating'] = rating;
    data['delivery_tip_amount'] = orderTip;
    data['attachment'] = fileUpload;
    return data;
  }
}
