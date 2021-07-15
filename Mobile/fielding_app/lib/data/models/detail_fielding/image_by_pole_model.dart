class ImageByPoleModel {
  String? id;
  String? poleId;
  String? fileName;
  String? filePath;

  ImageByPoleModel({this.id, this.poleId, this.fileName, this.filePath});

  ImageByPoleModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    poleId = json['PoleId'];
    fileName = json['FileName'];
    filePath = json['FilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['PoleId'] = this.poleId;
    data['FileName'] = this.fileName;
    data['FilePath'] = this.filePath;
    return data;
  }

  static List<ImageByPoleModel>? fromJsonList(jsonList) {
    return jsonList
        .map<ImageByPoleModel>((obj) => ImageByPoleModel.fromJson(obj))
        .toList();
  }
}
