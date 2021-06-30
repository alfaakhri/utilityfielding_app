class AllAnchorConditionModel {
  int? id;
  String? text;

  AllAnchorConditionModel({this.id, this.text});

  AllAnchorConditionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllAnchorConditionModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllAnchorConditionModel>((obj) => AllAnchorConditionModel.fromJson(obj))
        .toList();
  }
}
