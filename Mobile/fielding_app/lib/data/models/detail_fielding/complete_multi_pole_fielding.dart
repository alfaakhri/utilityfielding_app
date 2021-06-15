class CompleteMultiPoleFielding {
  String? token;
  List<PoleData>? poleData;

  CompleteMultiPoleFielding({this.token, this.poleData});

  CompleteMultiPoleFielding.fromJson(Map<String, dynamic> json) {
    token = json['Token'];
    if (json['PoleData'] != null) {
      poleData = <PoleData>[];
      json['PoleData'].forEach((v) {
        poleData!.add(new PoleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Token'] = this.token;
    if (this.poleData != null) {
      data['PoleData'] = this.poleData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PoleData {
  String? id;
  String? layerId;

  PoleData({this.id, this.layerId});

  PoleData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    layerId = json['LayerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['LayerId'] = this.layerId;
    return data;
  }
}
