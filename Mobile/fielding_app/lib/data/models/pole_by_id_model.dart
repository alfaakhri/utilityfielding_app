class PoleByIdModel {
  String id;
  String layerID;
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
  int poleType;
  String otherNumber;
  bool poleStamp;
  String fieldingCompletedDate;
  String fieldingById;
  String fieldingBy;
  int fieldingStatus;
  int poleSequence;
  String message;

  PoleByIdModel(
      {this.id,
      this.layerID,
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
      this.poleType,
      this.otherNumber,
      this.poleStamp,
      this.fieldingCompletedDate,
      this.fieldingById,
      this.fieldingBy,
      this.fieldingStatus,
      this.poleSequence,
      this.message});

  PoleByIdModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    layerID = json['LayerID'];
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
    poleType = json['PoleType'];
    otherNumber = json['OtherNumber'];
    poleStamp = json['PoleStamp'];
    fieldingCompletedDate = json['FieldingCompletedDate'];
    fieldingById = json['FieldingById'];
    fieldingBy = json['FieldingBy'];
    fieldingStatus = json['FieldingStatus'];
    poleSequence = json['PoleSequence'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['LayerID'] = this.layerID;
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
    data['PoleType'] = this.poleType;
    data['OtherNumber'] = this.otherNumber;
    data['PoleStamp'] = this.poleStamp;
    data['FieldingCompletedDate'] = this.fieldingCompletedDate;
    data['FieldingById'] = this.fieldingById;
    data['FieldingBy'] = this.fieldingBy;
    data['FieldingStatus'] = this.fieldingStatus;
    data['PoleSequence'] = this.poleSequence;
    data['Message'] = this.message;
    return data;
  }
}
