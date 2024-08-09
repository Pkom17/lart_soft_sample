import 'dart:convert';

LabModel labModelFromJson(String str) => LabModel.fromJson(json.decode(str));

String labModelToJson(LabModel data) => json.encode(data.toJson());

class LabModel {
    final int? id;
    final String? name;
    final String? labType;

    LabModel({
        this.id,
        this.name,
        this.labType,
    });

    factory LabModel.fromJson(Map<String, dynamic> json) => LabModel(
        id: json["id"],
        name: json["name"],
        labType: json["labType"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "labType": labType,
    };
}
