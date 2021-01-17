import 'package:fielding_app/data/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;
  void setUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }
}