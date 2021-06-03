class AllDownGuyOwnerModel {
  int? id;
  String? text;

  AllDownGuyOwnerModel({this.id, this.text});

  AllDownGuyOwnerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllDownGuyOwnerModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AllDownGuyOwnerModel>((obj) => AllDownGuyOwnerModel.fromJson(obj))
        .toList();
  }
}
