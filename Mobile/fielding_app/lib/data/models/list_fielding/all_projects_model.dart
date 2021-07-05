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
  String? fieldingProgress;

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
      this.fieldingProgress});

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
    fieldingProgress = json['FieldingProgress'];
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
    data['FieldingProgress'] = this.fieldingProgress;
    return data;
  }

  static List<AllProjectsModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllProjectsModel>((obj) => AllProjectsModel.fromJson(obj))
        .toList();
  }
}
