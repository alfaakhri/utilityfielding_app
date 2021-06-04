import 'package:fielding_app/data/models/models.exports.dart';

class AddPoleLocal {
  String? id;
  AllProjectsModel? allProjectsModel;
  AllPolesByLayerModel? allPolesByLayerModel;
  AddPoleModel? addPoleModel;

  AddPoleLocal(
      {this.id,
      this.allProjectsModel,
      this.allPolesByLayerModel,
      this.addPoleModel});

  AddPoleLocal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addPoleModel = json['addPole'] != null
        ? new AddPoleModel.fromJson(json['addPole'])
        : null;
    allProjectsModel = json['Projects'] != null
        ? new AllProjectsModel.fromJson(json['Projects'])
        : null;
    allPolesByLayerModel = json['PolesByLayer'] != null
        ? new AllPolesByLayerModel.fromJson(json['PolesByLayer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.addPoleModel != null) {
      data['addPole'] = this.addPoleModel!.toJson();
    }
    if (this.allProjectsModel != null) {
      data['Projects'] = this.allProjectsModel!.toJson();
    }
    if (this.allPolesByLayerModel != null) {
      data['PolesByLayer'] = this.allPolesByLayerModel!.toJson();
    }
    return data;
  }

  static List<AddPoleLocal>? fromJsonList(jsonList) {
    return jsonList
        .map<AddPoleLocal>((obj) => AddPoleLocal.fromJson(obj))
        .toList();
  }
}
