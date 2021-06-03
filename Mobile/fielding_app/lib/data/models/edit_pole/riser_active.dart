import 'dart:convert';

class RiserActive {
  final String riserNumber;
  final List<String> listRiserNumber;

  RiserActive(this.riserNumber, this.listRiserNumber);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['riserNumber'] = this.riserNumber;
    data['listRiser'] =
        this.listRiserNumber.map((v) => json.encode(v)).toList();
    return data;
  }
}
