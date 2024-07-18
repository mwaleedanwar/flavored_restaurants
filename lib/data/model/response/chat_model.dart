class ChatModel {
  int totalSize;
  int limit;
  int offset;
  List<Messages>? messages;

  ChatModel({
    required this.totalSize,
    required this.limit,
    required this.offset,
    this.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final cm = ChatModel(
      totalSize: json['total_size'],
      limit: json['limit'],
      offset: json['offset'],
    );
    if (json['messages'] != null) {
      final messages = <Messages>[];
      json['messages'].forEach((v) {
        messages.add(Messages.fromJson(v));
      });
      cm.messages = messages;
    }
    return cm;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['messages'] = messages?.map((v) => v.toJson()).toList();
    return data;
  }
}

class Messages {
  int id;
  int? conversationId;
  CustomerId? customerId;
  DeliverymanId? deliverymanId;
  String? message;
  String? reply;
  List<String>? attachment;
  List<String>? image;
  bool? isReply;
  String createdAt;
  String updatedAt;

  Messages({
    required this.id,
    required this.reply,
    required this.createdAt,
    required this.updatedAt,
    this.message,
    this.isReply,
    this.conversationId,
    this.customerId,
    this.deliverymanId,
    this.attachment,
    this.image,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    final msgs = Messages(
      id: json['id'],
      conversationId: int.tryParse(json['conversation_id']),
      isReply: json['is_reply'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      message: json['message'],
      reply: json['reply'],
    );
    if (json['customer_id'] != null) {
      msgs.customerId = CustomerId.fromJson(json['customer_id']);
    }
    if (json['deliveryman_id'] != null) {
      msgs.deliverymanId = DeliverymanId.fromJson(json['deliveryman_id']);
    }

    if (json['attachment'] != null && json['attachment'].isNotEmpty) {
      msgs.attachment = json['attachment'].cast<String>();
    }
    if (json['image'] != null) {
      msgs.image = json['image'].cast<String>();
    }
    return msgs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['message'] = message;
    data['reply'] = reply;
    data['attachment'] = attachment;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['customer_id'] = customerId?.toJson();
    data['deliveryman_id'] = deliverymanId?.toJson();
    return data;
  }
}

class CustomerId {
  String name;
  String image;

  CustomerId({required this.name, required this.image});

  factory CustomerId.fromJson(Map<String, dynamic> json) => CustomerId(name: json['name'], image: json['image']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class DeliverymanId {
  String? name;
  String? image;

  DeliverymanId({this.name, this.image});

  factory DeliverymanId.fromJson(Map<String, dynamic> json) => DeliverymanId(name: json['name'], image: json['image']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
