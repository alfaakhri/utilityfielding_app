class AssignedJobNumberModel {
  String? jobNumberId;
  String? title;
  String? lastDueDate;
  int? fieldingRequestCount;
  String? notif;

  AssignedJobNumberModel(
      {this.jobNumberId,
      this.title,
      this.lastDueDate,
      this.fieldingRequestCount,
      this.notif});

  AssignedJobNumberModel.fromJson(Map<String, dynamic> json) {
    jobNumberId = json['JobNumberId'];
    title = json['Title'];
    lastDueDate = json['LastDueDate'];
    fieldingRequestCount = json['FieldingRequestCount'];
    notif = json['Notif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobNumberId'] = this.jobNumberId;
    data['Title'] = this.title;
    data['LastDueDate'] = this.lastDueDate;
    data['FieldingRequestCount'] = this.fieldingRequestCount;
    data['Notif'] = this.notif;
    return data;
  }

  static List<AssignedJobNumberModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AssignedJobNumberModel>((obj) => AssignedJobNumberModel.fromJson(obj))
        .toList();
  }
}
