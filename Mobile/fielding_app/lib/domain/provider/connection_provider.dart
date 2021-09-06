import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:fielding_app/presentation/widgets/alert_dialog_local.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

enum ConnectivityStatus { Online, Offline }

class ConnectionProvider extends ChangeNotifier {
  HiveService _hiveService = HiveService();
  ApiProvider _apiProvider = ApiProvider();

  bool? _isConnected;
  bool get isConnected => _isConnected!;
  void setIsConnected(bool isConnected) async {
    _isConnected = isConnected;
    notifyListeners();
  }

  // Create our public controller
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectionProvider() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t
      connectionStatusController.add(getStatusFromResult(result));
    });
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus getStatusFromResult(ConnectivityResult result) {
    bool _isShow = isShowDialog();
    switch (result) {
      case ConnectivityResult.mobile:
        Fluttertoast.showToast(msg: "Internet available");
        if (_isShow) {
          Get.dialog(AlertDialogLocal(
            titleName:
                "${allProjectsModel.first.projectName} ${allProjectsModel.first.jobNumber}",
            layerName: allProjectsModel.first.layerName,
          ));
        }

        setIsConnected(true);
        return ConnectivityStatus.Online;
      case ConnectivityResult.wifi:
        Fluttertoast.showToast(msg: "Internet available");
        if (_isShow) {
          Get.dialog(AlertDialogLocal(
            titleName:
                "${allProjectsModel.first.projectName} ${allProjectsModel.first.jobNumber}",
            layerName: allProjectsModel.first.layerName,
          ));
        }
        setIsConnected(true);
        return ConnectivityStatus.Online;

      case ConnectivityResult.none:
        Fluttertoast.showToast(msg: "Internet not available");
        setIsConnected(false);
        return ConnectivityStatus.Offline;
      default:
        Fluttertoast.showToast(msg: "Internet not available");
        setIsConnected(false);
        return ConnectivityStatus.Offline;
    }
  }

  List<AllProjectsModel> _allProjectsModel = <AllProjectsModel>[];
  List<AllProjectsModel> get allProjectsModel => _allProjectsModel;
  void setAllProjectsModel(List<AllProjectsModel> allProjectsModel) {
    _allProjectsModel = allProjectsModel;
    notifyListeners();
  }

  void updateForTriggerDialog(String userId) async {
    var dataBox = await _hiveService.openAndGetDataFromHiveBox(
        getHiveFieldingPoles, userId);
    if (dataBox != null) {
      _allProjectsModel = AllProjectsModel.fromJsonList(jsonDecode(dataBox))!;
    }
    notifyListeners();
  }

  bool isShowDialog() {
    if (allProjectsModel.isNotEmpty) {
      if (allProjectsModel.first.addPoleModel!.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
