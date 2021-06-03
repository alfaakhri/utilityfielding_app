class AddTransformerModel {
  double value;
  int hoa;

  AddTransformerModel(this.value, this.hoa);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['HOA'] = this.hoa;
    return data;
  }
}