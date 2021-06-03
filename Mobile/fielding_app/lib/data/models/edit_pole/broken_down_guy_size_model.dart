class BrokenDownGuySizeModel {
  int? id;
  String? text;

  BrokenDownGuySizeModel({this.id, this.text});

  BrokenDownGuySizeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<BrokenDownGuySizeModel>? fromJsonList(jsonList) {
    return jsonList
        .map<BrokenDownGuySizeModel>((obj) => BrokenDownGuySizeModel.fromJson(obj))
        .toList();
  }
}
