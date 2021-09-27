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
    var dataBox = await _hiveService.openAndGetDataFromHiveBox(getHiveFieldingPoles, userId);
    if (dataBox != null) {
      _allProjectsModel = AllProjectsModel.fromJsonList(jsonDecode(dataBox))!;
      _projectLocalSelected = _allProjectsModel.firstWhere((element) => element.iD == _projectLocalSelected.iD,
          orElse: () => AllProjectsModel());
    }
    notifyListeners();
  }

  Future uploadAllWithNotif(String customerId) async {
    Dio _dio = Dio();

    if (_projectLocalSelected.addPoleModel!.isNotEmpty) {
      for (var index = 0; index < _projectLocalSelected.addPoleModel!.length; index++) {
        var response = await _dio.post(
          BASE_URL + "/api/MobileProject/CompletedFieldingNew",
          data: jsonEncode(_projectLocalSelected.addPoleModel![index]),
        );
        if (response.statusCode == 200) {
          showProgressNotification(
              index, _projectLocalSelected.addPoleModel![index].poleSequence!, true, _projectLocalSelected);
          _projectLocalSelected.addPoleModel!.remove(_projectLocalSelected.addPoleModel![index]);
          _allProjectsModel.removeWhere((element) => element.iD == _projectLocalSelected.iD);
          _allProjectsModel.add(_projectLocalSelected);
          await _hiveService.deleteDataFromBox(
            getHiveFieldingPoles,
            customerId,
          );

          if (_allProjectsModel.length != 0) {
            await _hiveService.saveDataToBox(getHiveFieldingPoles, customerId, json.encode(_allProjectsModel));
          }
          if (_projectLocalSelected.addPoleModel!.length == 0) {
            if (_projectLocalSelected.startCompleteModel!.isNotEmpty) {
              await uploadAllStartComplete(customerId, false);
            } else {
              updateProjectsLocal(customerId);
            }
            break;
          } else {
            uploadAllWithNotif(customerId);
          }
        } else {
          showProgressNotification(
              index, _projectLocalSelected.addPoleModel![index].poleSequence!, false, _projectLocalSelected);
        }
      }
    } else if (_projectLocalSelected.startCompleteModel!.isNotEmpty) {
      await uploadAllStartComplete(customerId, false);
    }
  }

  Future uploadAllStartComplete(String customerId, bool fromAlert) async {
    Dio _dio = Dio();
    AllProjectsModel projects = (fromAlert) ? _allProjectsModel.first : _projectLocalSelected;
    for (var index = 0; index < projects.startCompleteModel!.length; index++) {
      var response = await _dio.post(
        BASE_URL + "/api/MobileProject/StartAndCompleteFielding",
        data: jsonEncode(projects.startCompleteModel![index]),
      );
      if (response.statusCode == 200) {
        showProgressNotification(index, projects.startCompleteModel![index].poleSequence!, true, projects);
        projects.startCompleteModel!.remove(projects.startCompleteModel![index]);
        _allProjectsModel.removeWhere((element) => element.iD == projects.iD);
        _allProjectsModel.add(projects);
        await _hiveService.deleteDataFromBox(
          getHiveFieldingPoles,
          customerId,
        );

        if (_allProjectsModel.length != 0) {
          await _hiveService.saveDataToBox(getHiveFieldingPoles, customerId, json.encode(_allProjectsModel));
        }
        if (projects.startCompleteModel!.length == 0) {
          updateProjectsLocal(customerId);
          break;
        } else {
          uploadAllStartComplete(customerId, fromAlert);
        }
      } else {
        showProgressNotification(index, projects.startCompleteModel![index].poleSequence!, false, projects);
      }
    }
  }

  void uploadFirstWithAlert(String customerId, int indexElement) async {
    Dio _dio = Dio();
    
    if (_allProjectsModel[indexElement].addPoleModel!.isNotEmpty) {
      for (var index = 0; index < _allProjectsModel[indexElement].addPoleModel!.length; index++) {
        var response = await _dio.post(
          BASE_URL + "/api/MobileProject/CompletedFieldingNew",
          data: jsonEncode(_allProjectsModel[indexElement].addPoleModel![index]),
        );
        if (response.statusCode == 200) {
          showProgressNotification(
              index, _allProjectsModel[indexElement].addPoleModel![index].poleSequence!, true, _allProjectsModel[indexElement]);
          _allProjectsModel[indexElement].addPoleModel!.remove(_allProjectsModel[indexElement].addPoleModel![index]);
          // _allProjectsModel.removeWhere((element) => element.iD == _allProjectsModel.first.iD);
          // _allProjectsModel.add(_allProjectsModel.first);
          await _hiveService.deleteDataFromBox(
            getHiveFieldingPoles,
            customerId,
          );

          if (_allProjectsModel.length != 0) {
            await _hiveService.saveDataToBox(getHiveFieldingPoles, customerId, json.encode(_allProjectsModel));
          }
          if (_allProjectsModel[indexElement].addPoleModel!.length == 0) {
            if (_allProjectsModel[indexElement].startCompleteModel!.isNotEmpty) {
              await uploadAllStartComplete(customerId, true);
            } else {
              updateProjectsLocal(customerId);
            }
            break;
          } else {
            uploadFirstWithAlert(customerId, indexElement);
          }
        } else {
          showProgressNotification(
              index, _allProjectsModel[indexElement].addPoleModel![index].poleSequence!, false, _allProjectsModel[indexElement]);
        }
      }
    } else if (_allProjectsModel[indexElement].startCompleteModel!.isNotEmpty) {
      await uploadAllStartComplete(customerId, true);
    }
  }

  Future<void> showProgressNotification(
      int id, String sequencePole, bool isSuccess, AllProjectsModel allProjectsModel) async {
    await Future.delayed(Duration(seconds: 1), () async {
      print("Upload pole sequence $sequencePole ${(isSuccess) ? 'finished' : 'failed'}");
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: id,
              channelKey: 'grouped',
              title: 'Upload pole sequence $sequencePole ${(isSuccess) ? 'finished' : 'failed'}',
              body: "${allProjectsModel.projectName} - ${allProjectsModel.jobNumber}\n${allProjectsModel.layerName}",
              locked: false));
    });
  }
}
