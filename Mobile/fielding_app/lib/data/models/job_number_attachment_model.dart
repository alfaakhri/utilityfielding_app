class JobNumberAttachModel {
  String? fileName;
  String? filePath;

  JobNumberAttachModel({this.fileName, this.filePath});

  JobNumberAttachModel.fromJson(Map<String, dynamic> json) {
    fileName = json['FileName'];
    filePath = json['FilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileName'] = this.fileName;
    data['FilePath'] = this.filePath;
    return data;
  }

  static List<JobNumberAttachModel>? fromJsonList(jsonList) {
    return jsonList
        .map<JobNumberAttachModel>((obj) => JobNumberAttachModel.fromJson(obj))
        .toList();
  }
}
