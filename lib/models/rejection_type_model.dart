import 'dart:convert';

RejectionTypeModel rejectionTypeModelFromJson(String str) => RejectionTypeModel.fromJson(json.decode(str));

String rejectionTypeModelToJson(RejectionTypeModel data) => json.encode(data.toJson());

class RejectionTypeModel {
    final int? id;
    final String? name;

    RejectionTypeModel({
        this.id,
        this.name,
    });

    factory RejectionTypeModel.fromJson(Map<String, dynamic> json) => RejectionTypeModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}