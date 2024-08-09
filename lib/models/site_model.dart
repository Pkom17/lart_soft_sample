import 'dart:convert';

SiteModel siteModelFromJson(String str) => SiteModel.fromJson(json.decode(str));

String siteModelToJson(SiteModel data) => json.encode(data.toJson());

class SiteModel {
  final int? id;
  final String? name;
  final String? dhisCode;
  final int? circuitId;

  SiteModel({
    this.id,
    this.name,
    this.dhisCode,
    this.circuitId,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) => SiteModel(
        id: json["id"],
        name: json["name"],
        dhisCode: json["dhisCode"],
        circuitId: json["circuitId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dhisCode": dhisCode,
        "circuitId": circuitId,
      };
}
