class RiserAndVGRTypeModel {
  int? id;
  String? text;

  RiserAndVGRTypeModel({this.id, this.text});

  RiserAndVGRTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<RiserAndVGRTypeModel>? fromJsonList(jsonList) {
    return jsonList
        .map<RiserAndVGRTypeModel>((obj) => RiserAndVGRTypeModel.fromJson(obj))
        .toList();
  }
}
