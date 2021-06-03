class AllHoaTypeModel {
  int? id;
  String? text;

  AllHoaTypeModel({this.id, this.text});

  AllHoaTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllHoaTypeModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllHoaTypeModel>((obj) => AllHoaTypeModel.fromJson(obj))
        .toList();
  }
}
