class AllAnchorSizeModel {
  int? id;
  String? text;

  AllAnchorSizeModel({this.id, this.text});

  AllAnchorSizeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllAnchorSizeModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllAnchorSizeModel>((obj) => AllAnchorSizeModel.fromJson(obj))
        .toList();
  }
}
