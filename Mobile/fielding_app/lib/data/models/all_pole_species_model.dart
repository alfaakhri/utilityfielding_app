class AllPoleSpeciesModel {
  int id;
  String text;

  AllPoleSpeciesModel({this.id, this.text});

  AllPoleSpeciesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

  static List<AllPoleSpeciesModel> fromJsonList(jsonList) {
    return jsonList
        .map<AllPoleSpeciesModel>((obj) => AllPoleSpeciesModel.fromJson(obj))
        .toList();
  }
}
