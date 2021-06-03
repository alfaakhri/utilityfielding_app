class AllPoleConditionModel {
  int? id;
  String? text;

  AllPoleConditionModel({this.id, this.text});

  AllPoleConditionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllPoleConditionModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllPoleConditionModel>((obj) => AllPoleConditionModel.fromJson(obj))
        .toList();
  }
}
