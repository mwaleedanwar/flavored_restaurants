import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBody {
  String id;
  int orderId;
  String senderId;
  String receiverId;
  String message;
  DateTime time;
  List<String> imageUrls;

  MessageBody({this.id, this.orderId, this.senderId, this.receiverId, this.message, this.time, this.imageUrls});

  MessageBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    time = json['time'] != null ? json['time'].toDate() : DateTime.now();
    imageUrls = json['image_urls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['message'] = message;
    data['time'] = FieldValue.serverTimestamp();
    data['image_urls'] = imageUrls;
    return data;
  }
}
