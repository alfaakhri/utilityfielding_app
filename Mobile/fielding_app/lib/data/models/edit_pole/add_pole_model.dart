import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';

class AddPoleModel {
  String? token;
  String? id;
  String? layerId;
  String? street;
  String? vAPTerminal;
  String? poleNumber;
  String? osmose;
  String? latitude;
  String? longitude;
  int? poleHeight;
  String? groundCircumference;
  int? poleClass;
  String? poleYear;
  int? poleSpecies;
  int? poleCondition;
  String? otherNumber;
  bool? poleStamp;
  String? notes;
  bool? isRadioAntenna;
  List<HOAList>? hOAList;
  List<TransformerList>? transformerList;
  List<SpanDirectionList>? spanDirectionList;
  List<AnchorList>? anchorList;
  List<RiserAndVGRList>? riserAndVGRList;
  int? fieldingType;
  List<AnchorFences>? anchorFences;
  List<AnchorFences>? anchorStreets;
  List<AnchorFences>? riserFences;
  String? poleSequence;
  bool? isFAPUnknown;
  bool? isOsmoseUnknown;
  bool? isOtherNumberUnknown;
  bool? isPoleLengthUnknown;
  bool? isPoleLengthEstimated;
  bool? isPoleClassUnknown;
  bool? isPoleClassEstimated;
  bool? isGroundLineUnknown;
  bool? isGroundLineEstimated;
  bool? isYearUnknown;
  bool? isYearEstimated;
  bool? isSpeciesUnknown;
  bool? isSpeciesEstimated;
  bool? isPoleNumberUnknown;
  int? poleType;

  AddPoleModel(
      {this.token,
      this.id,
      this.layerId,
      this.street,
      this.vAPTerminal,
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
      this.poleStamp,
      this.notes,
      this.isRadioAntenna,
      this.hOAList,
      this.transformerList,
      this.spanDirectionList,
      this.anchorList,
      this.riserAndVGRList,
      this.fieldingType,
      this.anchorFences,
      this.anchorStreets,
      this.riserFences,
      this.poleSequence,
      this.isFAPUnknown,
      this.isOsmoseUnknown,
      this.isOtherNumberUnknown,
      this.isPoleLengthUnknown,
      this.isPoleLengthEstimated,
      this.isPoleClassUnknown,
      this.isPoleClassEstimated,
      this.isGroundLineUnknown,
      this.isGroundLineEstimated,
      this.isYearUnknown,
      this.isYearEstimated,
      this.isSpeciesUnknown,
      this.isSpeciesEstimated,
      this.isPoleNumberUnknown,
      this.poleType});

  AddPoleModel.fromJson(Map<String, dynamic> json) {
    token = json['Token'];
    id = json['Id'];
    layerId = json['LayerId'];
    street = json['Street'];
    vAPTerminal = json['VAPTerminal'];
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
    notes = json['Note'];
    isRadioAntenna = json['IsRadioAntenna'];
    if (json['HOAList'] != null) {
      hOAList = <HOAList>[];
      json['HOAList'].forEach((v) {
        hOAList!.add(new HOAList.fromJson(v));
      });
    }
    if (json['TransformerList'] != null) {
      transformerList = <TransformerList>[];
      json['TransformerList'].forEach((v) {
        transformerList!.add(new TransformerList.fromJson(v));
      });
    }
    if (json['SpanDirectionList'] != null) {
      spanDirectionList = <SpanDirectionList>[];
      json['SpanDirectionList'].forEach((v) {
        spanDirectionList!.add(new SpanDirectionList.fromJson(v));
      });
    }
    if (json['AnchorList'] != null) {
      anchorList = <AnchorList>[];
      json['AnchorList'].forEach((v) {
        anchorList!.add(new AnchorList.fromJson(v));
      });
    }
    if (json['RiserAndVGRList'] != null) {
      riserAndVGRList = <RiserAndVGRList>[];
      json['RiserAndVGRList'].forEach((v) {
        riserAndVGRList!.add(new RiserAndVGRList.fromJson(v));
      });
    }
    fieldingType = json['FieldingType'];
    if (json['AnchorFenceList'] != null) {
      anchorFences = <AnchorFences>[];
      json['AnchorFenceList'].forEach((v) {
        anchorFences?.add(new AnchorFences.fromJson(v));
      });
    }
    if (json['AnchorStreetList'] != null) {
      anchorStreets = <AnchorFences>[];
      json['AnchorStreetList'].forEach((v) {
        anchorStreets?.add(new AnchorFences.fromJson(v));
      });
    }
    if (json['RiserFenceList'] != null) {
      riserFences = <AnchorFences>[];
      json['RiserFenceList'].forEach((v) {
        riserFences?.add(new AnchorFences.fromJson(v));
      });
    }
    poleSequence = json['PoleSequence'];
    isFAPUnknown = json['IsFAPUnknown'];
    isOsmoseUnknown = json['IsOsmoseUnknown'];
    isOtherNumberUnknown = json['IsOtherNumberUnknown'];
    isPoleLengthUnknown = json['IsPoleLengthUnknown'];
    isPoleLengthEstimated = json['IsPoleLengthEstimated'];
    isPoleClassUnknown = json['IsPoleClassUnknown'];
    isPoleClassEstimated = json['IsPoleClassEstimated'];
    isGroundLineUnknown = json['IsGroundLineUnknown'];
    isGroundLineEstimated = json['IsGroundLineEstimated'];
    isYearUnknown = json['IsYearUnknown'];
    isYearEstimated = json['IsYearEstimated'];
    isSpeciesUnknown = json['IsSpeciesUnknown'];
    isSpeciesEstimated = json['IsSpeciesEstimated'];
    isPoleNumberUnknown = json['IsPoleNumberUnknown'];
    poleType = json['PoleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Token'] = this.token;
    data['Id'] = this.id;
    data['LayerId'] = this.layerId;
    data['Street'] = this.street;
    data['VAPTerminal'] = this.vAPTerminal;
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
    data['Note'] = this.notes;
    data['IsRadioAntenna'] = this.isRadioAntenna;
    if (this.hOAList != null) {
      data['HOAList'] = this.hOAList!.map((v) => v.toJson()).toList();
    } else {
      data['HOAList'] = [];
    }
    if (this.transformerList != null) {
      data['TransformerList'] =
          this.transformerList!.map((v) => v.toJson()).toList();
    } else {
      data['TransformerList'] = [];
    }
    if (this.spanDirectionList != null) {
      data['SpanDirectionList'] =
          this.spanDirectionList!.map((v) => v.toJson()).toList();
    } else {
      data['SpanDirectionList'] = [];
    }
    if (this.anchorList != null) {
      data['AnchorList'] = this.anchorList!.map((v) => v.toJson()).toList();
    } else {
      data['AnchorList'] = [];
    }
    if (this.riserAndVGRList != null) {
      data['RiserAndVGRList'] =
          this.riserAndVGRList!.map((v) => v.toJson()).toList();
    } else {
      data['RiserAndVGRList'] = [];
    }
    data['FieldingType'] = this.fieldingType;
    if (this.anchorFences != null) {
      data['AnchorFenceList'] =
          this.anchorFences!.map((v) => v.toJson()).toList();
    } else {
      data['AnchorFenceList'] = [];
    }
    if (this.anchorStreets != null) {
      data['AnchorStreetList'] =
          this.anchorStreets!.map((v) => v.toJson()).toList();
    } else {
      data['AnchorStreetList'] = [];
    }
    if (this.riserFences != null) {
      data['RiserFenceList'] =
          this.riserFences!.map((v) => v.toJson()).toList();
    } else {
      data['RiserFenceList'] = [];
    }
    data['PoleSequence'] = this.poleSequence;
    data['IsFAPUnknown'] = this.isFAPUnknown;
    data['IsOsmoseUnknown'] = this.isOsmoseUnknown;
    data['IsOtherNumberUnknown'] = this.isOtherNumberUnknown;
    data['IsPoleLengthUnknown'] = this.isPoleLengthUnknown;
    data['IsPoleLengthEstimated'] = this.isPoleLengthEstimated;
    data['IsPoleClassUnknown'] = this.isPoleClassUnknown;
    data['IsPoleClassEstimated'] = this.isPoleClassEstimated;
    data['IsGroundLineUnknown'] = this.isGroundLineUnknown;
    data['IsGroundLineEstimated'] = this.isGroundLineEstimated;
    data['IsYearUnknown'] = this.isYearUnknown;
    data['IsYearEstimated'] = this.isYearEstimated;
    data['IsSpeciesUnknown'] = this.isSpeciesUnknown;
    data['IsSpeciesEstimated'] = this.isSpeciesEstimated;
    data['IsPoleNumberUnknown'] = this.isPoleNumberUnknown;
    data['PoleType'] = this.poleType;

    return data;
  }

  static List<AddPoleModel>? fromJsonList(jsonList) {
    return jsonList
        .map<AddPoleModel>((obj) => AddPoleModel.fromJson(obj))
        .toList();
  }
}

class AnchorFences {
  String? points;
  String? stroke;
  String? data;
  String? globalCompositeOperation;

  AnchorFences(
      {this.points, this.stroke, this.data, this.globalCompositeOperation});

  AnchorFences.fromJson(Map<String, dynamic> json) {
    points = json['Points'];
    stroke = json['Stroke'];
    data = json['Data'];
    globalCompositeOperation = json['GlobalCompositeOperation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Points'] = this.points;
    data['Stroke'] = this.stroke;
    data['Data'] = this.data;
    data['GlobalCompositeOperation'] = this.globalCompositeOperation;
    return data;
  }
}

class Points {
  String? id;
  String? stroke;
  String? data;
  List<int>? points;

  Points({this.id, this.stroke, this.data, this.points});

  Points.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stroke = json['stroke'];
    data = json['data'];
    points = json['points'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stroke'] = this.stroke;
    data['data'] = this.data;
    data['points'] = this.points;
    return data;
  }
}
