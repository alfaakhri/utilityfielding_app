import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:fielding_app/data/models/detail_fielding/detail_fielding.exports.dart';
import 'package:fielding_app/data/models/list_fielding/list_fielding.exports.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/hive_service.dart';
import 'package:flutter/material.dart';

class LocalProvider extends ChangeNotifier {
  HiveService _hiveService = HiveService();
  ApiProvider _apiProvider = ApiProvider();

  List<AllProjectsModel> _allProjectsModel = <AllProjectsModel>[];
  List<AllProjectsModel> get allProjectsModel => _allProjectsModel;
  void setAllProjectsModel(List<AllProjectsModel> allProjectsModel) {
    _allProjectsModel = allProjectsModel;
    notifyListeners();
  }

  AllProjectsModel _projectLocalSelected = AllProjectsModel();
  AllProjectsModel get projectLocalSelected => _projectLocalSelected;
  void setProjectsLocal(AllProjectsModel projectsLocal) {
    _projectLocalSelected = projectsLocal;
    notifyListeners();
  }

  void updateProjectsLocal(String userId) async {
    var dataBox = await _hiveService.openAndGetDataFromHiveBox(
        getHiveFieldingPoles, userId);
    if (dataBox != null) {
      var projects = AllProjectsModel.fromJsonList(jsonDecode(dataBox));
      _projectLocalSelected = projects!
          .firstWhere((element) => element.iD == _projectLocalSelected.iD);
    }
    notifyListeners();
  }

  Future uploadAllWithNotif(String customerId) async {
    Dio _dio = Dio();
    for (var index = 0;
        index < _projectLocalSelected.addPoleModel!.length;
        index++) {
      var response = await _dio.post(
        BASE_URL + "/api/MobileProject/CompletedFieldingNew",
        data: jsonEncode(_projectLocalSelected.addPoleModel![index]),
      );
      if (response.statusCode == 200) {
        showProgressNotification(index,
            _projectLocalSelected.addPoleModel![index].poleSequence!, true);
        _projectLocalSelected.addPoleModel!
            .remove(_projectLocalSelected.addPoleModel![index]);
        _allProjectsModel
            .removeWhere((element) => element.iD == _projectLocalSelected.iD);
        _allProjectsModel.add(_projectLocalSelected);
        await _hiveService.deleteDataFromBox(
          getHiveFieldingPoles,
          customerId,
        );

        if (_allProjectsModel.length != 0) {
          await _hiveService.saveDataToBox(
              getHiveFieldingPoles, customerId, json.encode(_allProjectsModel));
        }
        if (_projectLocalSelected.addPoleModel!.length == 0) {
          break;
        } else {
          uploadAllWithNotif(customerId);
        }
      } else {
        showProgressNotification(index,
            _projectLocalSelected.addPoleModel![index].poleSequence!, true);
      }
    }
  }

  Future<void> showProgressNotification(
      int id, String sequencePole, bool isSuccess) async {
    await Future.delayed(Duration(seconds: 1), () async {
      // if (received > total) {

      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: id,
              channelKey: 'progress_bar',
              title:
                  'Upload pole sequence $sequencePole ${(isSuccess) ? 'finished' : 'failed'}',
              // body: 'filename.txt',
              // payload: {
              //   'file': 'filename.txt',
              //   'path': '-rmdir c://ruwindows/system32/huehuehue'
              // },
              locked: false));
      // } else {
      //   await AwesomeNotifications().createNotification(
      //       content: NotificationContent(
      //           id: id,
      //           channelKey: 'progress_bar',
      //           title:
      //               'Uploading Pole Sequence $sequencePole in progress ($received of $total)',
      //           // body: 'filename.txt',
      //           // payload: {
      //           //   'file': 'filename.txt',
      //           //   'path': '-rmdir c://ruwindows/system32/huehuehue'
      //           // },
      //           notificationLayout: NotificationLayout.ProgressBar,
      //           progress: min((received / total * 100).floor(), 100),
      //           locked: true));
      // }
    });
  }
}
