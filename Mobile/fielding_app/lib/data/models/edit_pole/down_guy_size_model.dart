class DownGuySizeModel {
  int? id;
  String? text;

  DownGuySizeModel({this.id, this.text});

  DownGuySizeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<DownGuySizeModel>? fromJsonList(jsonList) {
    return jsonList
        .map<DownGuySizeModel>((obj) => DownGuySizeModel.fromJson(obj))
        .toList();
  }
}
