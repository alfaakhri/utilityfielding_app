class JobNumberLocModel {
  String? jobNumber;
  String? latitude;
  String? longitude;

  JobNumberLocModel({this.jobNumber, this.latitude, this.longitude});

  JobNumberLocModel.fromJson(Map<String, dynamic> json) {
    jobNumber = json['JobNumber'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobNumber'] = this.jobNumber;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    return data;
  }

  static List<JobNumberLocModel>? fromJsonList(jsonList) {
    return jsonList
        .map<JobNumberLocModel>(
            (obj) => JobNumberLocModel.fromJson(obj))
        .toList();
  }
}
