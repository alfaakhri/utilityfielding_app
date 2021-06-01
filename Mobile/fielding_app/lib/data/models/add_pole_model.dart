import 'package:fielding_app/data/models/pole_by_id_model.dart';

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
      this.fieldingType});

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
    notes = json['Notes'];
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

    return data;
  }
}
