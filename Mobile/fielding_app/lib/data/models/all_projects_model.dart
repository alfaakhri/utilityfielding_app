class AllProjectsModel {
  String iD;
  String projectID;
  String projectName;
  String layerName;
  String note;
  int layerType;
  int totalPoles;
  String dueDate;
  int approx;

  AllProjectsModel(
      {this.iD,
      this.projectID,
      this.projectName,
      this.layerName,
      this.note,
      this.layerType,
      this.totalPoles,
      this.dueDate,
      this.approx});

  AllProjectsModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    projectID = json['ProjectID'];
    projectName = json['ProjectName'];
    layerName = json['LayerName'];
    note = json['Note'];
    layerType = json['LayerType'];
    totalPoles = json['TotalPoles'];
    dueDate = json['DueDate'];
    approx = json['Approx'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ProjectID'] = this.projectID;
    data['ProjectName'] = this.projectName;
    data['LayerName'] = this.layerName;
    data['Note'] = this.note;
    data['LayerType'] = this.layerType;
    data['TotalPoles'] = this.totalPoles;
    data['DueDate'] = this.dueDate;
    data['Approx'] = this.approx;
    return data;
  }

  static List<AllProjectsModel> fromJsonList(jsonList) {
    return jsonList
        .map<AllProjectsModel>((obj) => AllProjectsModel.fromJson(obj))
        .toList();
  }
}
