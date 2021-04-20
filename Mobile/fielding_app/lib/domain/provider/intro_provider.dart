import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:flutter/material.dart';

class IntroProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();

  var _privacyPolicy;
  get privacyPolicy => _privacyPolicy;

  void setPrivacyPolicy(privacyPolicy) {
    _privacyPolicy = privacyPolicy;
    notifyListeners();
  }

  void getPrivacyPolicy() async {
    try {
      var response = await _apiProvider.getPrivacyPolicy();
      if (response.statusCode == 200) {
        _privacyPolicy = response.data;
      } else {
        print("Failed load privacy policy");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
