class AllFieldingTypeModel {
  int? id;
  String? text;

  AllFieldingTypeModel({this.id, this.text});

  AllFieldingTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllFieldingTypeModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllFieldingTypeModel>((obj) => AllFieldingTypeModel.fromJson(obj))
        .toList();
  }
}
