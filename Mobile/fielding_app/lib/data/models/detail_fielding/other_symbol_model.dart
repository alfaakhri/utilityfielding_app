import 'package:fielding_app/data/models/detail_fielding/all_poles_by_layer_model.dart';

class OtherSymbolsModel {
  String? iD;
  String? markerPath;
  String? latitude;
  String? longitude;
  int? poleType;

  OtherSymbolsModel(
      {this.iD, this.markerPath, this.latitude, this.longitude, this.poleType});

  OtherSymbolsModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    markerPath = json['MarkerPath'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    poleType = json['PoleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['MarkerPath'] = this.markerPath;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['PoleType'] = this.poleType;
    return data;
  }

  static List<OtherSymbolsModel>? fromJsonList(jsonList) {
    return jsonList
        .map<OtherSymbolsModel>((obj) => OtherSymbolsModel.fromJson(obj))
        .toList();
  }
}
