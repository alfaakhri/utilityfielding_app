import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:flutter/material.dart';

class ConnectionProvider extends ChangeNotifier {
  HiveService _hiveService = HiveService();
  ApiProvider _apiProvider = ApiProvider();

  bool? _isConnected;
  bool get isConnected => _isConnected!;
  void setIsConnected(bool isConnected) async {
    _isConnected = isConnected;
    notifyListeners();
  }
}