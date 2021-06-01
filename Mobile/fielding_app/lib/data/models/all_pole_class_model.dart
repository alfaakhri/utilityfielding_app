class AllPoleClassModel {
  int? id;
  String? text;

  AllPoleClassModel({this.id, this.text});

  AllPoleClassModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllPoleClassModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllPoleClassModel>((obj) => AllPoleClassModel.fromJson(obj))
        .toList();
  }
}
