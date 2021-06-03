import 'package:fielding_app/data/models/models.exports.dart';

class AddPoleLocal {
  String? id;
  AddPoleModel? addPoleModel;

  AddPoleLocal({this.id, this.addPoleModel});

  AddPoleLocal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addPoleModel = json['addPole'] != null
        ? new AddPoleModel.fromJson(json['addPole'])
        : null;
  }
  static List<AddPoleLocal>? fromJsonList(jsonList) {
    return jsonList
        .map<AddPoleLocal>((obj) => AddPoleLocal.fromJson(obj))
        .toList();
  }
}
