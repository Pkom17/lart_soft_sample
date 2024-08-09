import 'dart:convert';

SampleModel sampleModelFromJson(String str) =>
    SampleModel.fromJson(json.decode(str));

String sampleModelToJson(SampleModel data) => json.encode(data.toJson());

class SampleModel {
  int? id;
  int? userId;
  int? sampleId;
  int? circuitId;
  int? sampleRetrievingId;
  int? rejectionTypeId;
  String? rejectionComment;
  String? rejectionDate;
  int? destinationLabId;
  int? siteId;
  String? requesterSiteName;
  String? destinationLabName;
  String? analysisCompletedDate;
  String? analysisReleasedDate;
  String? analysisResultReportedDate;
  int? hubId;
  int? labId;
  String patientIdentifier;
  //String sampleIdentifier;
  String? circuitNumber;
  int? collectionStartMileage;
  int? collectionEndMileage;
  int? resultStartMileage;
  int? resultEndMileage;
  String collectionDate;
  String? deliveredAtHubDate;
  String? deliveredAtReferenceLabDate;
  String? acceptedAtHubDate;
  String? acceptedAtReferenceLabDate;
  String sampleType;
  String? labNumber;
  String? resultCollectionDate;
  String? resultDeliveryDate;
  String? status;

  SampleModel({
    this.id,
    this.userId,
    this.sampleId,
    this.circuitId,
    this.sampleRetrievingId,
    this.rejectionTypeId,
    this.rejectionComment,
    this.destinationLabId,
    required this.siteId,
    this.requesterSiteName,
    this.destinationLabName,
    this.analysisCompletedDate,
    this.analysisReleasedDate,
    this.analysisResultReportedDate,
    this.hubId,
    this.labId,
    required this.patientIdentifier,
    //required this.sampleIdentifier,
    this.circuitNumber,
    this.collectionStartMileage,
    this.collectionEndMileage,
    this.resultStartMileage,
    this.resultEndMileage,
    required this.collectionDate,
    this.deliveredAtHubDate,
    this.deliveredAtReferenceLabDate,
    this.acceptedAtHubDate,
    this.acceptedAtReferenceLabDate,
    required this.sampleType,
    this.labNumber,
    this.resultCollectionDate,
    this.resultDeliveryDate,
    this.status,
  });

  factory SampleModel.fromJson(Map<String, dynamic> json) => SampleModel(
        id: json["id"],
        userId: json["userId"],
        sampleId: json["sampleId"],
        circuitId: json["circuitId"],
        sampleRetrievingId: json["sampleRetrievingId"],
        rejectionTypeId: json["rejectionTypeId"],
        rejectionComment: json["rejectionComment"],
        destinationLabId: json["destinationLabId"],
        siteId: json["siteId"],
        requesterSiteName: json["requesterSiteName"],
        destinationLabName: json["destinationLabName"],
        analysisCompletedDate: json["analysisCompletedDate"],
        analysisReleasedDate: json["analysisReleasedDate"],
        analysisResultReportedDate: json["analysisResultReportedDate"],
        hubId: json["hubId"],
        labId: json["labId"],
        patientIdentifier: json["patientIdentifier"],
        //sampleIdentifier: json["sampleIdentifier"],
        circuitNumber: json["circuitNumber"],
        collectionStartMileage: json["collectionStartMileage"],
        collectionEndMileage: json["collectionEndMileage"],
        resultStartMileage: json["resultStartMileage"],
        resultEndMileage: json["resultEndMileage"],
        collectionDate: json["collectionDate"],
        deliveredAtHubDate: json["deliveredAtHubDate"],
        deliveredAtReferenceLabDate: json["deliveredAtReferenceLabDate"],
        acceptedAtHubDate: json["acceptedAtHubDate"],
        acceptedAtReferenceLabDate: json["acceptedAtReferenceLabDate"],
        sampleType: json["sampleType"],
        labNumber: json["labNumber"],
        resultCollectionDate: json["resultCollectionDate"],
        resultDeliveryDate: json["resultDeliveryDate"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "sampleId": sampleId,
        "circuitId": circuitId,
        "sampleRetrievingId": sampleRetrievingId,
        "rejectionTypeId": rejectionTypeId,
        "rejectionComment": rejectionComment,
        "destinationLabId": destinationLabId,
        "siteId": siteId,
        "requesterSiteName": requesterSiteName,
        "destinationLabName": destinationLabName,
        "analysisCompletedDate": analysisCompletedDate,
        "analysisReleasedDate": analysisReleasedDate,
        "analysisResultReportedDate": analysisResultReportedDate,
        "hubId": hubId,
        "labId": labId,
        "patientIdentifier": patientIdentifier,
        //"sampleIdentifier": sampleIdentifier,
        "circuitNumber": circuitNumber,
        "collectionStartMileage": collectionStartMileage,
        "collectionEndMileage": collectionEndMileage,
        "resultStartMileage": resultStartMileage,
        "resultEndMileage": resultEndMileage,
        "collectionDate": collectionDate,
        "deliveredAtHubDate": deliveredAtHubDate,
        "deliveredAtReferenceLabDate": deliveredAtReferenceLabDate,
        "acceptedAtHubDate": acceptedAtHubDate,
        "acceptedAtReferenceLabDate": acceptedAtReferenceLabDate,
        "sampleType": sampleType,
        "labNumber": labNumber,
        "resultCollectionDate": resultCollectionDate,
        "resultDeliveryDate": resultDeliveryDate,
        "status": status,
      };
}
