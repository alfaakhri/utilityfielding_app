class AddPoleModel {
  String token;
  String id;
  String layerId;
  String street;
  String poleNumber;
  String osmose;
  String latitude;
  String longitude;
  int poleHeight;
  String groundCircumference;
  int poleClass;
  String poleYear;
  int poleSpecies;
  int poleCondition;
  String otherNumber;
  bool poleStamp;

  AddPoleModel(
      {this.token,
      this.id,
      this.layerId,
      this.street,
      this.poleNumber,
      this.osmose,
      this.latitude,
      this.longitude,
      this.poleHeight,
      this.groundCircumference,
      this.poleClass,
      this.poleYear,
      this.poleSpecies,
      this.poleCondition,
      this.otherNumber,
      this.poleStamp});

  AddPoleModel.fromJson(Map<String, dynamic> json) {
    token = json['Token'];
    id = json['Id'];
    layerId = json['LayerId'];
    street = json['Street'];
    poleNumber = json['PoleNumber'];
    osmose = json['Osmose'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    poleHeight = json['PoleHeight'];
    groundCircumference = json['GroundCircumference'];
    poleClass = json['PoleClass'];
    poleYear = json['PoleYear'];
    poleSpecies = json['PoleSpecies'];
    poleCondition = json['PoleCondition'];
    otherNumber = json['OtherNumber'];
    poleStamp = json['PoleStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Token'] = this.token;
    data['Id'] = this.id;
    data['LayerId'] = this.layerId;
    data['Street'] = this.street;
    data['PoleNumber'] = this.poleNumber;
    data['Osmose'] = this.osmose;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['PoleHeight'] = this.poleHeight;
    data['GroundCircumference'] = this.groundCircumference;
    data['PoleClass'] = this.poleClass;
    data['PoleYear'] = this.poleYear;
    data['PoleSpecies'] = this.poleSpecies;
    data['PoleCondition'] = this.poleCondition;
    data['OtherNumber'] = this.otherNumber;
    data['PoleStamp'] = this.poleStamp;
    return data;
  }
}
