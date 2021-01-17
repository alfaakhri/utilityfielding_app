class UserModel {
  Data data;
  bool status;
  String message;

  UserModel({this.data, this.status, this.message});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = this.status;
    data['Message'] = this.message;
    return data;
  }
}

class Data {
  User user;
  String token;
  String expiredTime;

  Data({this.user, this.token, this.expiredTime});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    token = json['Token'];
    expiredTime = json['ExpiredTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    data['Token'] = this.token;
    data['ExpiredTime'] = this.expiredTime;
    return data;
  }
}

class User {
  String iD;
  String companyID;
  String companyName;
  String email;

  User({this.iD, this.companyID, this.companyName, this.email});

  User.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    companyID = json['CompanyID'];
    companyName = json['CompanyName'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CompanyID'] = this.companyID;
    data['CompanyName'] = this.companyName;
    data['Email'] = this.email;
    return data;
  }
}
