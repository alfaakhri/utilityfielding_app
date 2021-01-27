class AllPolesByLayerModel {
  String id;
  String latitude;
  String longitude;
  String fieldingCompletedDate;
  String fieldingBy;
  int fieldingStatus;
  int poleSequence;
  String poleNumber;
  bool startPolePicture;

  AllPolesByLayerModel(
      {this.id,
      this.latitude,
      this.longitude,
      this.fieldingCompletedDate,
      this.fieldingBy,
      this.fieldingStatus,
      this.poleSequence,
      this.poleNumber,
      this.startPolePicture});

  AllPolesByLayerModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    fieldingCompletedDate = json['FieldingCompletedDate'];
    fieldingBy = json['FieldingBy'];
    fieldingStatus = json['FieldingStatus'];
    poleSequence = json['PoleSequence'];
    poleNumber = json['PoleNumber'];
    startPolePicture = json['StartPolePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['FieldingCompletedDate'] = this.fieldingCompletedDate;
    data['FieldingBy'] = this.fieldingBy;
    data['FieldingStatus'] = this.fieldingStatus;
    data['PoleSequence'] = this.poleSequence;
    data['PoleNumber'] = this.poleNumber;
    data['StartPolePicture'] = this.startPolePicture;
    return data;
  }

  static List<AllPolesByLayerModel> fromJsonList(jsonList) {
    return jsonList
        .map<AllPolesByLayerModel>((obj) => AllPolesByLayerModel.fromJson(obj))
        .toList();
  }
}
