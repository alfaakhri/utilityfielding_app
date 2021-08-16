import 'package:fielding_app/data/models/detail_fielding/detail_fielding.exports.dart';

class AllProjectsModel {
  String? iD;
  String? projectID;
  String? projectName;
  String? jobNumber;
  String? layerName;
  String? note;
  int? layerType;
  String? dueDate;
  int? approx;
  int? totalPoles;
  String? referenceLayerId;
  String? parentFieldingRequestId;
  String? parentJobNumberId;
  int? layerStatus;
  int? jobStatus;
  int? fieldingProgressStatus;
  String? fieldingProgress;
  List<AllPolesByLayerModel>? allPolesByLayer;

  AllProjectsModel(
      {this.iD,
      this.projectID,
      this.projectName,
      this.jobNumber,
      this.layerName,
      this.note,
      this.layerType,
      this.dueDate,
      this.approx,
      this.totalPoles,
      this.referenceLayerId,
      this.parentFieldingRequestId,
      this.parentJobNumberId,
      this.layerStatus,
      this.jobStatus,
      this.fieldingProgressStatus,
      this.fieldingProgress,
      this.allPolesByLayer});

  AllProjectsModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    projectID = json['ProjectID'];
    projectName = json['ProjectName'];
    jobNumber = json['JobNumber'];
    layerName = json['LayerName'];
    note = json['Note'];
    layerType = json['LayerType'];
    dueDate = json['DueDate'];
    approx = json['Approx'];
    totalPoles = json['TotalPoles'];
    referenceLayerId = json['ReferenceLayerId'];
    parentFieldingRequestId = json['ParentFieldingRequestId'];
    parentJobNumberId = json['ParentJobNumberId'];
    layerStatus = json['LayerStatus'];
    jobStatus = json['JobStatus'];
    fieldingProgressStatus = json['FieldingProgressStatus'];
    fieldingProgress = json['FieldingProgress'];
    if (json['AllPolesByLayer'] != null) {
      allPolesByLayer = <AllPolesByLayerModel>[];
      json['AllPolesByLayer'].forEach((v) {
        allPolesByLayer!.add(new AllPolesByLayerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ProjectID'] = this.projectID;
    data['ProjectName'] = this.projectName;
    data['JobNumber'] = this.jobNumber;
    data['LayerName'] = this.layerName;
    data['Note'] = this.note;
    data['LayerType'] = this.layerType;
    data['DueDate'] = this.dueDate;
    data['Approx'] = this.approx;
    data['TotalPoles'] = this.totalPoles;
    data['ReferenceLayerId'] = this.referenceLayerId;
    data['ParentFieldingRequestId'] = this.parentFieldingRequestId;
    data['ParentJobNumberId'] = this.parentJobNumberId;
    data['LayerStatus'] = this.layerStatus;
    data['JobStatus'] = this.jobStatus;
    data['FieldingProgressStatus'] = this.fieldingProgressStatus;
    data['FieldingProgress'] = this.fieldingProgress;
    if (this.allPolesByLayer != null) {
      data['AllPolesByLayer'] = this.allPolesByLayer!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<AllProjectsModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllProjectsModel>((obj) => AllProjectsModel.fromJson(obj))
        .toList();
  }
}
