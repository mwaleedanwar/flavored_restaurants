import 'dart:convert';

DistanceModel distnceModelFromJson(String str) => DistanceModel.fromJson(json.decode(str));

String distnceModelToJson(DistanceModel data) => json.encode(data.toJson());

class DistanceModel {
  List<String> destinationAddresses;
  List<String> originAddresses;
  List<Rows>? rows;
  String status;

  DistanceModel({
    required this.destinationAddresses,
    required this.originAddresses,
    required this.status,
    this.rows,
  });

  factory DistanceModel.fromJson(Map<String, dynamic> json) {
    final dm = DistanceModel(
      destinationAddresses: json['destination_addresses'].cast<String>(),
      originAddresses: json['origin_addresses'].cast<String>(),
      status: json['status'],
    );
    if (json['rows'] != null) {
      final rows = <Rows>[];
      json['rows'].forEach((v) {
        rows.add(Rows.fromJson(v));
      });
      dm.rows = rows;
    }
    return dm;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['destination_addresses'] = destinationAddresses;
    data['origin_addresses'] = originAddresses;
    data['rows'] = rows?.map((v) => v.toJson()).toList();
    data['status'] = status;
    return data;
  }
}

class Rows {
  List<Elements>? elements;

  Rows({this.elements});

  factory Rows.fromJson(Map<String, dynamic> json) {
    final r = Rows();
    if (json['elements'] != null) {
      final elements = <Elements>[];
      json['elements'].forEach((v) {
        elements.add(Elements.fromJson(v));
      });
      r.elements = elements;
    }
    return r;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (elements != null) {
      data['elements'] = elements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Elements {
  Distance? distance;
  Distance? duration;
  String status;

  Elements({
    this.distance,
    this.duration,
    required this.status,
  });

  factory Elements.fromJson(Map<String, dynamic> json) {
    return Elements(
      status: json['status'],
      distance: json['distance'] != null ? Distance.fromJson(json['distance']) : null,
      duration: json['duration'] != null ? Distance.fromJson(json['duration']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['distance'] = distance?.toJson();
    data['duration'] = duration?.toJson();
    return data;
  }
}

class Distance {
  String text;
  double value;

  Distance({required this.text, required this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      text: json['text'],
      value: json['value'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}
