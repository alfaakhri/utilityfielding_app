import 'dart:convert';

import 'package:fielding_app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  final String USER_MODEL = 'user_model';
  final String FIRST_MODEL = 'first_model';

  void saveUserModel(UserModel userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = json.encode(userModel);
    await prefs.setString(USER_MODEL, userJson);
  }

  Future getUserModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefsValue = prefs.getString(USER_MODEL);
    if (prefsValue == null) {
      return null;
    } else {
      UserModel userModel = UserModel.fromJson(json.decode(prefsValue));
      return userModel;
    }
  }

  void deleteUserModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_MODEL);
    await prefs.clear();
    print("User Model " + prefs.getString(USER_MODEL).toString());
  }

  void saveFirstInstall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = "First";
    await prefs.setString(FIRST_MODEL, userJson);
  }

  Future getFirstInstall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefsValue = prefs.getString(FIRST_MODEL);
    if (prefsValue == null) {
      return null;
    } else {
      return prefsValue;
    }
  }
}
