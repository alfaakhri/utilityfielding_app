import 'package:fielding_app/data/models/list_fielding/list_fielding.exports.dart';

class FieldingRequestByJobModel {
  String? jobNumberId;
  String? title;
  String? lastDueDate;
  int? fieldingRequestCount;
  List<AllProjectsModel>? details;
  String? notif;

  FieldingRequestByJobModel(
      {this.jobNumberId,
      this.title,
      this.lastDueDate,
      this.fieldingRequestCount,
      this.details,
      this.notif});

  FieldingRequestByJobModel.fromJson(Map<String, dynamic> json) {
    jobNumberId = json['JobNumberId'];
    title = json['Title'];
    lastDueDate = json['LastDueDate'];
    fieldingRequestCount = json['FieldingRequestCount'];
    if (json['Details'] != null) {
      details = <AllProjectsModel>[];
      json['Details'].forEach((v) {
        details!.add(new AllProjectsModel.fromJson(v));
      });
    }
    notif = json['Notif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobNumberId'] = this.jobNumberId;
    data['Title'] = this.title;
    data['LastDueDate'] = this.lastDueDate;
    data['FieldingRequestCount'] = this.fieldingRequestCount;
    if (this.details != null) {
      data['Details'] = this.details!.map((v) => v.toJson()).toList();
    }
    data['Notif'] = this.notif;
    return data;
  }

  static List<FieldingRequestByJobModel>? fromJsonList(jsonList) {
    return jsonList
        .map<FieldingRequestByJobModel>((obj) => FieldingRequestByJobModel.fromJson(obj))
        .toList();
  }
}