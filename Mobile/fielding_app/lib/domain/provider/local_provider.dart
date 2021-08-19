import 'dart:convert';

import 'package:fielding_app/data/models/detail_fielding/detail_fielding.exports.dart';
import 'package:fielding_app/data/models/list_fielding/list_fielding.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/hive_service.dart';
import 'package:flutter/material.dart';

class LocalProvider extends ChangeNotifier {
  HiveService _hiveService = HiveService();

  AllProjectsModel _projectLocalSelected = AllProjectsModel();
  AllProjectsModel get projectLocalSelected => _projectLocalSelected;
  void setProjectsLocal(AllProjectsModel projectsLocal) {
    _projectLocalSelected = projectsLocal;
    notifyListeners();
  }

  void updateProjectsLocal(String userId) async {
    var dataBox = await _hiveService.openAndGetDataFromHiveBox(getHiveFieldingPoles, userId);
    if (dataBox != null) {
      var projects = AllProjectsModel.fromJsonList(jsonDecode(dataBox));
      _projectLocalSelected = projects!.firstWhere((element) => element.iD == _projectLocalSelected.iD);
    }
    notifyListeners();
  }
}