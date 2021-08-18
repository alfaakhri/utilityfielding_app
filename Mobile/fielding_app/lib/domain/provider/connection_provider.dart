import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    switch (result) {
      case ConnectivityResult.mobile:
        Fluttertoast.showToast(msg: "Internet available");
        setIsConnected(true);
        return ConnectivityStatus.Online;
      case ConnectivityResult.wifi:
        Fluttertoast.showToast(msg: "Internet available");
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
}
