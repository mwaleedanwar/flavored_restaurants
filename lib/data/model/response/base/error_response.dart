class ErrorResponse {
  List<Errors>? errors;

  ErrorResponse({this.errors});

  ErrorResponse.fromJson(dynamic errorJson) {
    Map<String, dynamic> json;
    if (errorJson.runtimeType == ErrorResponse) {
      json = errorJson.toJson();
    } else {
      json = errorJson ?? {};
    }

    if (json["errors"] != null) {
      errors = [];
      json["errors"].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["errors"] = errors?.map((v) => v.toJson()).toList();
    return map;
  }
}

class Errors {
  String code;
  String message;

  Errors({required this.code, required this.message});

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["code"] = code;
    map["message"] = message;
    return map;
  }
}
