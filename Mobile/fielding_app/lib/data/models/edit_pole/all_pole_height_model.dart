class AllPoleHeightModel {
  int? id;
  String? text;

  AllPoleHeightModel({this.id, this.text});

  AllPoleHeightModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllPoleHeightModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllPoleHeightModel>((obj) => AllPoleHeightModel.fromJson(obj))
        .toList();
  }
}
