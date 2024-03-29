import '../models.exports.dart';

class PoleByIdModel {
  String? id;
  String? layerID;
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
  int? poleType;
  bool? isRadioAntenna;
  String? note;
  String? otherNumber;
  bool? poleStamp;
  String? fieldingCompletedDate;
  String? fieldingById;
  String? fieldingBy;
  int? fieldingStatus;
  String? poleSequence;
  List<HOAList>? hOAList;
  List<TransformerList>? transformerList;
  List<SpanDirectionList>? spanDirectionList;
  List<AnchorList>? anchorList;
  List<RiserAndVGRList>? riserAndVGRList;
  int? fieldingType;
  List<AnchorFences>? anchorFences;
  List<AnchorFences>? anchorStreets;
  List<AnchorFences>? riserFences;
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

  PoleByIdModel(
      {this.id,
      this.layerID,
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
      this.poleType,
      this.isRadioAntenna,
      this.note,
      this.otherNumber,
      this.poleStamp,
      this.fieldingCompletedDate,
      this.fieldingById,
      this.fieldingBy,
      this.fieldingStatus,
      this.poleSequence,
      this.hOAList,
      this.transformerList,
      this.spanDirectionList,
      this.anchorList,
      this.riserAndVGRList,
      this.fieldingType,
      this.anchorFences,
      this.anchorStreets,
      this.riserFences,
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
      this.isSpeciesEstimated, this.isPoleNumberUnknown});

  PoleByIdModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    layerID = json['LayerID'];
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
    poleType = json['PoleType'];
    isRadioAntenna = json['IsRadioAntenna'];
    note = json['Note'];
    otherNumber = json['OtherNumber'];
    poleStamp = json['PoleStamp'];
    fieldingCompletedDate = json['FieldingCompletedDate'];
    fieldingById = json['FieldingById'];
    fieldingBy = json['FieldingBy'];
    fieldingStatus = json['FieldingStatus'];
    poleSequence = json['PoleSequence'];
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
    if (json['AnchorFences'] != null) {
      anchorFences = <AnchorFences>[];
      json['AnchorFences'].forEach((v) {
        anchorFences?.add(new AnchorFences.fromJson(v));
      });
    }
    if (json['AnchorStreets'] != null) {
      anchorStreets = <AnchorFences>[];
      json['AnchorStreets'].forEach((v) {
        anchorStreets?.add(new AnchorFences.fromJson(v));
      });
    }
    if (json['RiserFences'] != null) {
      riserFences = <AnchorFences>[];
      json['RiserFences'].forEach((v) {
        riserFences?.add(new AnchorFences.fromJson(v));
      });
    }
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['LayerID'] = this.layerID;
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
    data['PoleType'] = this.poleType;
    data['IsRadioAntenna'] = this.isRadioAntenna;
    data['Note'] = this.note;
    data['OtherNumber'] = this.otherNumber;
    data['PoleStamp'] = this.poleStamp;
    data['FieldingCompletedDate'] = this.fieldingCompletedDate;
    data['FieldingById'] = this.fieldingById;
    data['FieldingBy'] = this.fieldingBy;
    data['FieldingStatus'] = this.fieldingStatus;
    data['PoleSequence'] = this.poleSequence;
    if (this.hOAList != null) {
      data['HOAList'] = this.hOAList!.map((v) => v.toJson()).toList();
    }
    if (this.transformerList != null) {
      data['TransformerList'] =
          this.transformerList!.map((v) => v.toJson()).toList();
    }
    if (this.spanDirectionList != null) {
      data['SpanDirectionList'] =
          this.spanDirectionList!.map((v) => v.toJson()).toList();
    }
    if (this.anchorList != null) {
      data['AnchorList'] = this.anchorList!.map((v) => v.toJson()).toList();
    }
    if (this.riserAndVGRList != null) {
      data['RiserAndVGRList'] =
          this.riserAndVGRList!.map((v) => v.toJson()).toList();
    }
    data['FieldingType'] = this.fieldingType;
    if (this.anchorFences != null) {
      data['AnchorFences'] = this.anchorFences!.map((v) => v.toJson()).toList();
    }
    if (this.anchorStreets != null) {
      data['AnchorStreets'] =
          this.anchorStreets!.map((v) => v.toJson()).toList();
    }
    if (this.riserFences != null) {
      data['RiserFences'] = this.riserFences!.map((v) => v.toJson()).toList();
    }
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
    return data;
  }
}

class HOAList {
  String? iD;
  int? type;
  double? poleLengthInInch;
  double? poleLengthInFeet;
  String? poleID;

  HOAList(
      {this.iD,
      this.type,
      this.poleLengthInInch,
      this.poleLengthInFeet,
      this.poleID});

  HOAList.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['Type'];
    poleLengthInInch = json['PoleLengthInInch'];
    poleLengthInFeet = json['PoleLengthInFeet'];
    poleID = json['PoleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Type'] = this.type;
    data['PoleLengthInInch'] = this.poleLengthInInch;
    data['PoleLengthInFeet'] = this.poleLengthInFeet;
    data['PoleID'] = this.poleID;
    return data;
  }
}

class TransformerList {
  String? iD;
  double? value;
  double? hOA;
  String? poleID;

  TransformerList({this.iD, this.value, this.hOA, this.poleID});

  TransformerList.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    value = json['Value'];
    hOA = json['HOA'];
    poleID = json['PoleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Value'] = this.value;
    data['HOA'] = this.hOA;
    data['PoleID'] = this.poleID;
    return data;
  }
}

class SpanDirectionList {
  String? iD;
  double? length;
  String? lineData;
  String? color;
  String? image;
  int? imageType;

  SpanDirectionList(
      {this.iD,
      this.length,
      this.lineData,
      this.color,
      this.image,
      this.imageType});

  SpanDirectionList.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    length = json['Length'];
    lineData = json['LineData'];
    color = json['Color'];
    image = json['Image'];
    imageType = json['ImageType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Length'] = this.length;
    data['LineData'] = this.lineData;
    data['Color'] = this.color;
    data['Image'] = this.image;
    data['ImageType'] = this.imageType;
    return data;
  }
}

class AnchorList {
  String? iD;
  double? circleX;
  double? circleY;
  double? textX;
  double? textY;
  String? text;
  double? distance;
  int? size;
  int? anchorEye;
  bool? eyesPict;
  String? poleID;
  int? imageType;
  int? anchorCondition;
  List<DownGuyList>? downGuyList;

  AnchorList(
      {this.iD,
      this.circleX,
      this.circleY,
      this.textX,
      this.textY,
      this.text,
      this.distance,
      this.size,
      this.anchorEye,
      this.eyesPict,
      this.poleID,
      this.imageType,
      this.anchorCondition,
      this.downGuyList});

  AnchorList.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    circleX = json['CircleX'];
    circleY = json['CircleY'];
    textX = json['TextX'];
    textY = json['TextY'];
    text = json['Text'];
    distance = json['Distance'];
    size = json['Size'];
    anchorEye = json['AnchorEye'];
    eyesPict = json['EyesPict'];
    poleID = json['PoleID'];
    imageType = json['ImageType'];
    anchorCondition = json['AnchorCondition'];
    if (json['DownGuyList'] != null) {
      downGuyList = <DownGuyList>[];
      json['DownGuyList'].forEach((v) {
        downGuyList!.add(new DownGuyList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CircleX'] = this.circleX;
    data['CircleY'] = this.circleY;
    data['TextX'] = this.textX;
    data['TextY'] = this.textY;
    data['Text'] = this.text;
    data['Distance'] = this.distance;
    data['Size'] = this.size;
    data['AnchorEye'] = this.anchorEye;
    data['EyesPict'] = this.eyesPict;
    data['PoleID'] = this.poleID;
    data['ImageType'] = this.imageType;
    data['AnchorCondition'] = this.anchorCondition;
    if (this.downGuyList != null) {
      data['DownGuyList'] = this.downGuyList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DownGuyList {
  String? iD;
  int? size;
  int? owner;
  bool? isInsulated;
  double? hOA;
  int? type;

  DownGuyList(
      {this.iD, this.size, this.owner, this.isInsulated, this.hOA, this.type});

  DownGuyList.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    size = json['Size'];
    owner = json['Owner'];
    isInsulated = json['IsInsulated'];
    hOA = json['HOA'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Size'] = this.size;
    data['Owner'] = this.owner;
    data['IsInsulated'] = this.isInsulated;
    data['HOA'] = this.hOA;
    data['Type'] = this.type;
    return data;
  }
}

class RiserAndVGRList {
  String? iD;
  double? shapeX;
  double? shapeY;
  double? textX;
  double? textY;
  int? sequence;
  String? name;
  int? value;
  int? type;
  int? imageType;
  int? generalRVGRSeq;

  RiserAndVGRList(
      {this.iD,
      this.shapeX,
      this.shapeY,
      this.textX,
      this.textY,
      this.sequence,
      this.name,
      this.value,
      this.type,
      this.imageType,
      this.generalRVGRSeq});

  RiserAndVGRList.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    shapeX = json['ShapeX'];
    shapeY = json['ShapeY'];
    textX = json['TextX'];
    textY = json['TextY'];
    sequence = json['Sequence'];
    name = json['Name'];
    value = json['Value'];
    type = json['Type'];
    imageType = json['ImageType'];
    generalRVGRSeq = json["generalRVGRSequence"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ShapeX'] = this.shapeX;
    data['ShapeY'] = this.shapeY;
    data['TextX'] = this.textX;
    data['TextY'] = this.textY;
    data['Sequence'] = this.sequence;
    data['Name'] = this.name;
    data['Value'] = this.value;
    data['Type'] = this.type;
    data['ImageType'] = this.imageType;
    data["generalRVGRSequence"] = this.generalRVGRSeq;
    return data;
  }
}
