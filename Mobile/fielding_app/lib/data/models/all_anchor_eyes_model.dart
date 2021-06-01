class AllAnchorEyesModel {
  int? id;
  String? text;

  AllAnchorEyesModel({this.id, this.text});

  AllAnchorEyesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllAnchorEyesModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllAnchorEyesModel>((obj) => AllAnchorEyesModel.fromJson(obj))
        .toList();
  }
}