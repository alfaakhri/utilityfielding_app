import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
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

  int? _indexElement;
  int? get indexElement => _indexElement;

  // Create our public controller
  StreamController<ConnectivityStatus> connectionStatusController = StreamController<ConnectivityStatus>();

  ConnectionProvider() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      // Use Connectivity() here to gather more info if you need t
      connectionStatusController.add(await getStatusFromResult(result));
    });
  }

  // Convert from the third part enum to our own enum
  Future<ConnectivityStatus> getStatusFromResult(ConnectivityResult result) async {
    bool _isShow = await isShowDialog();
    switch (result) {
      case ConnectivityResult.mobile:
        Fluttertoast.showToast(msg: "Internet available");
        if (_isShow) {
          Get.dialog(AlertDialogLocal(
            titleName: "${allProjectsModel[indexElement!].projectName} ${allProjectsModel[indexElement!].jobNumber}",
            layerName: allProjectsModel[indexElement!].layerName,
            indexElement: indexElement,
          ));
        }

        setIsConnected(true);
        return ConnectivityStatus.Online;
      case ConnectivityResult.wifi:
        Fluttertoast.showToast(msg: "Internet available");
        if (_isShow) {
           Get.dialog(AlertDialogLocal(
            titleName: "${allProjectsModel[indexElement!].projectName} ${allProjectsModel[indexElement!].jobNumber}",
            layerName: allProjectsModel[indexElement!].layerName,
            indexElement: indexElement,
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

  String? _userId;
  String? get userId => _userId;

  void updateForTriggerDialog(String data) async {
    _userId = data;
    var dataBox = await _hiveService.openAndGetDataFromHiveBox(getHiveFieldingPoles, _userId!);
    if (dataBox != null) {
      _allProjectsModel = AllProjectsModel.fromJsonList(jsonDecode(dataBox))!;
    }
    notifyListeners();
  }

  Future<bool> isShowDialog() async {
    if (_userId != null) {
      var dataBox = await _hiveService.openAndGetDataFromHiveBox(getHiveFieldingPoles, _userId!);
      if (dataBox != null) {
        _allProjectsModel = AllProjectsModel.fromJsonList(jsonDecode(dataBox))!;
      }
    }

    if (_allProjectsModel.isNotEmpty) {
      for (int index = 0; index < _allProjectsModel.length; index++) {
        if (_allProjectsModel[index].addPoleModel == null && _allProjectsModel[index].startCompleteModel == null) {
          return false;
        } else if (_allProjectsModel[index].addPoleModel!.isNotEmpty ||
            _allProjectsModel[index].startCompleteModel!.isNotEmpty) {
          _indexElement = index;
          notifyListeners();
          return true;
        }
      }
    }
    return false;
  }
}
