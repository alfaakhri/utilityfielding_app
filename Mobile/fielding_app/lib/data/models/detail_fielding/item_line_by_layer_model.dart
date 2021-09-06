class ItemLineByLayerModel {
  String? iD;
  String? itemTypeID;
  String? layerID;
  String? position;
  String? color;
  String? note;
  String? createDate;
  bool? isActive;
  String? latitude;
  String? longitude;

  ItemLineByLayerModel(
      {this.iD,
      this.itemTypeID,
      this.layerID,
      this.position,
      this.color,
      this.note,
      this.createDate,
      this.isActive,
      this.latitude,
      this.longitude});

  ItemLineByLayerModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    itemTypeID = json['ItemTypeID'];
    layerID = json['LayerID'];
    position = json['Position'];
    color = json['Color'];
    note = json['Note'];
    createDate = json['CreateDate'];
    isActive = json['IsActive'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ItemTypeID'] = this.itemTypeID;
    data['LayerID'] = this.layerID;
    data['Position'] = this.position;
    data['Color'] = this.color;
    data['Note'] = this.note;
    data['CreateDate'] = this.createDate;
    data['IsActive'] = this.isActive;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    return data;
  }

  static List<ItemLineByLayerModel>? fromJsonList(jsonList) {
    return jsonList
        .map<ItemLineByLayerModel>((obj) => ItemLineByLayerModel.fromJson(obj))
        .toList();
  }
}
