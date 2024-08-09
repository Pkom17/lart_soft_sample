import 'dart:convert';

CircuitModel circuitModelFromJson(String str) => CircuitModel.fromJson(json.decode(str));

String circuitModelToJson(CircuitModel data) => json.encode(data.toJson());

class CircuitModel {
    final int? id;
    final String? name;

    CircuitModel({
        this.id,
        this.name,
    });

    factory CircuitModel.fromJson(Map<String, dynamic> json) => CircuitModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}