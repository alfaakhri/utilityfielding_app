import 'package:fielding_app/data/models/models.exports.dart';

class AllPolesByLayerModel {
  String? id;
  String? latitude;
  String? longitude;
  String? fieldingCompletedDate;
  String? fieldingBy;
  int? fieldingStatus;
  String? poleSequence;
  String? poleNumber;
  bool? startPolePicture;
  int? fieldingType;
  String? markerPath;
  int? poleType;
  PoleByIdModel? detailInformation;

  AllPolesByLayerModel(
      {this.id,
      this.latitude,
      this.longitude,
      this.fieldingCompletedDate,
      this.fieldingBy,
      this.fieldingStatus,
      this.poleSequence,
      this.poleNumber,
      this.startPolePicture,
      this.fieldingType,
      this.markerPath,
      this.poleType,
      this.detailInformation});

  AllPolesByLayerModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    fieldingCompletedDate = json['FieldingCompletedDate'];
    fieldingBy = json['FieldingBy'];
    fieldingStatus = json['FieldingStatus'];
    poleSequence = json['PoleSequence'];
    poleNumber = json['PoleNumber'];
    startPolePicture = json['StartPolePicture'];
    fieldingType = json['FieldingType'];
    markerPath = json['MarkerPath'];
    poleType = json['PoleType'];
    detailInformation = json['DetailInformation'] != null
        ? new PoleByIdModel.fromJson(json['DetailInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['FieldingCompletedDate'] = this.fieldingCompletedDate;
    data['FieldingBy'] = this.fieldingBy;
    data['FieldingStatus'] = this.fieldingStatus;
    data['PoleSequence'] = this.poleSequence;
    data['PoleNumber'] = this.poleNumber;
    data['StartPolePicture'] = this.startPolePicture;
    data['FieldingType'] = this.fieldingType;
    data['MarkerPath'] = this.markerPath;
    data['PoleType'] = this.poleType;
    if (this.detailInformation != null) {
      data['DetailInformation'] = this.detailInformation!.toJson();
    }
    return data;
  }

  static List<AllPolesByLayerModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllPolesByLayerModel>((obj) => AllPolesByLayerModel.fromJson(obj))
        .toList();
  }
}
