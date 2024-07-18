import 'dart:convert';

PolicyModel policyModelFromJson(String str) => PolicyModel.fromJson(json.decode(str));

String policyModelToJson(PolicyModel data) => json.encode(data.toJson());

class PolicyModel {
  PolicyModel({
    required this.returnPage,
    required this.refundPage,
    required this.cancellationPage,
  });

  Pages? returnPage;
  Pages? refundPage;
  Pages? cancellationPage;

  factory PolicyModel.fromJson(Map<String, dynamic> json) => PolicyModel(
        returnPage: json["return_page"]?["status"] == null || json["return_page"]?["status"] == null
            ? null
            : Pages.fromJson(json["return_page"]),
        refundPage: json["refund_page"]?["status"] == null || json["refund_page"]?["status"] == null
            ? null
            : Pages.fromJson(json["refund_page"]),
        cancellationPage: json["cancellation_page"]?["status"] == null || json["cancellation_page"]?["status"] == null
            ? null
            : Pages.fromJson(json["cancellation_page"]),
      );

  Map<String, dynamic> toJson() => {
        "return_page": returnPage?.toJson(),
        "refund_page": refundPage?.toJson(),
        "cancellation_page": cancellationPage?.toJson(),
      };
}

class Pages {
  Pages({
    required this.status,
    required this.content,
  });

  bool status;
  String content;

  factory Pages.fromJson(Map<String, dynamic> json) {
    return Pages(
      status: int.tryParse(json["status"].toString()) == 1,
      content: json["content"],
    );
  }
  Map<String, dynamic> toJson() => {
        "status": status,
        "content": content,
      };
}
