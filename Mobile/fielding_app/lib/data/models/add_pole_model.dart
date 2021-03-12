class AddPoleModel {
  String token;
  String id;
  String layerId;
  String street;
  String vAPTerminal;
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
  RadioAntena radioAntena;
  List<HOAList> hOAList;
  List<TransformerList> transformerList;
  List<SpanDirectionList> spanDirectionList;
  List<AnchorList> anchorList;
  List<RiserAndVGRList> riserAndVGRList;

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
      this.radioAntena,
      this.hOAList,
      this.transformerList,
      this.spanDirectionList,
      this.anchorList,
      this.riserAndVGRList});

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
    radioAntena = json['RadioAntena'] != null
        ? new RadioAntena.fromJson(json['RadioAntena'])
        : null;
    if (json['HOAList'] != null) {
      hOAList = new List<HOAList>();
      json['HOAList'].forEach((v) {
        hOAList.add(new HOAList.fromJson(v));
      });
    }
    if (json['TransformerList'] != null) {
      transformerList = new List<TransformerList>();
      json['TransformerList'].forEach((v) {
        transformerList.add(new TransformerList.fromJson(v));
      });
    }
    if (json['SpanDirectionList'] != null) {
      spanDirectionList = new List<SpanDirectionList>();
      json['SpanDirectionList'].forEach((v) {
        spanDirectionList.add(new SpanDirectionList.fromJson(v));
      });
    }
    if (json['AnchorList'] != null) {
      anchorList = new List<AnchorList>();
      json['AnchorList'].forEach((v) {
        anchorList.add(new AnchorList.fromJson(v));
      });
    }
    if (json['RiserAndVGRList'] != null) {
      riserAndVGRList = new List<RiserAndVGRList>();
      json['RiserAndVGRList'].forEach((v) {
        riserAndVGRList.add(new RiserAndVGRList.fromJson(v));
      });
    }
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
    if (this.radioAntena != null) {
      data['RadioAntena'] = this.radioAntena.toJson();
    }
    if (this.hOAList != null) {
      data['HOAList'] = this.hOAList.map((v) => v.toJson()).toList();
    }
    if (this.transformerList != null) {
      data['TransformerList'] =
          this.transformerList.map((v) => v.toJson()).toList();
    }
    if (this.spanDirectionList != null) {
      data['SpanDirectionList'] =
          this.spanDirectionList.map((v) => v.toJson()).toList();
    }
    if (this.anchorList != null) {
      data['AnchorList'] = this.anchorList.map((v) => v.toJson()).toList();
    }
    if (this.riserAndVGRList != null) {
      data['RiserAndVGRList'] =
          this.riserAndVGRList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RadioAntena {
  int hOA;

  RadioAntena({this.hOA});

  RadioAntena.fromJson(Map<String, dynamic> json) {
    hOA = json['HOA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HOA'] = this.hOA;
    return data;
  }
}

class HOAList {
  int type;
  int poleLengthInInch;
  double poleLengthInFeet;

  HOAList({this.type, this.poleLengthInInch, this.poleLengthInFeet});

  HOAList.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    poleLengthInInch = json['PoleLengthInInch'];
    poleLengthInFeet = json['PoleLengthInFeet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.type;
    data['PoleLengthInInch'] = this.poleLengthInInch;
    data['PoleLengthInFeet'] = this.poleLengthInFeet;
    return data;
  }
}

class TransformerList {
  double value;
  double hOA;

  TransformerList({this.value, this.hOA});

  TransformerList.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    hOA = json['HOA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['HOA'] = this.hOA;
    return data;
  }
}

class SpanDirectionList {
  int length;
  String lineData;
  String color;

  SpanDirectionList({this.length, this.lineData, this.color});

  SpanDirectionList.fromJson(Map<String, dynamic> json) {
    length = json['Length'];
    lineData = json['LineData'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Length'] = this.length;
    data['LineData'] = this.lineData;
    data['Color'] = this.color;
    return data;
  }
}

class AnchorList {
  int circleX;
  int circleY;
  int textX;
  int textY;
  String text;
  int distance;
  int size;
  int anchorEye;
  bool eyesPict;
  String poleID;
  List<DownGuyList> downGuyList;

  AnchorList(
      {this.circleX,
      this.circleY,
      this.textX,
      this.textY,
      this.text,
      this.distance,
      this.size,
      this.anchorEye,
      this.eyesPict,
      this.poleID,
      this.downGuyList});

  AnchorList.fromJson(Map<String, dynamic> json) {
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
    if (json['DownGuyList'] != null) {
      downGuyList = new List<DownGuyList>();
      json['DownGuyList'].forEach((v) {
        downGuyList.add(new DownGuyList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    if (this.downGuyList != null) {
      data['DownGuyList'] = this.downGuyList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DownGuyList {
  String iD;
  int size;
  int owner;
  bool isInsulated;
  int hOA;
  int type;

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
  int shapeX;
  int shapeY;
  int textX;
  int textY;
  int sequence;
  int value;
  int type;

  RiserAndVGRList(
      {this.shapeX,
      this.shapeY,
      this.textX,
      this.textY,
      this.sequence,
      this.value,
      this.type});

  RiserAndVGRList.fromJson(Map<String, dynamic> json) {
    shapeX = json['ShapeX'];
    shapeY = json['ShapeY'];
    textX = json['TextX'];
    textY = json['TextY'];
    sequence = json['Sequence'];
    value = json['Value'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShapeX'] = this.shapeX;
    data['ShapeY'] = this.shapeY;
    data['TextX'] = this.textX;
    data['TextY'] = this.textY;
    data['Sequence'] = this.sequence;
    data['Value'] = this.value;
    data['Type'] = this.type;
    return data;
  }
}