import 'dart:convert';

import 'package:fielding_app/data/models/detail_fielding/item_line_by_layer_model.dart';
import 'package:fielding_app/data/models/detail_fielding/other_symbol_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/hive_service.dart';
import 'package:flutter/material.dart';

enum SymbolState { initial, loading, empty, success, failed }

class SymbolProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  HiveService _hiveService = HiveService();

  String _message = '';

  SymbolState? _state;

  String get message => _message;

  SymbolState get state => _state!;

  List<OtherSymbolsModel> _otherSymbolsModel = [];
  List<OtherSymbolsModel> get otherSymbolsModel => _otherSymbolsModel;

  void getOtherSymbolModel(
      String token, String layerId, bool isConnected) async {
    _state = SymbolState.loading;

    final dataBox = await _hiveService.openAndGetDataFromHiveBox(
        getHiveOtherSymbol, listOtherSymbol);
    if (isConnected) {
      try {
        var response = await _apiProvider.getOtherSymbol(token, layerId);
        if (response.statusCode == 200) {
          _otherSymbolsModel = OtherSymbolsModel.fromJsonList(response.data)!;
          _hiveService.deleteDataFromBox(getHiveOtherSymbol, listOtherSymbol);
          _hiveService.saveDataToBox(getHiveOtherSymbol, listOtherSymbol,
              json.encode(_otherSymbolsModel));
          if (otherSymbolsModel.isEmpty) {
            _state = SymbolState.empty;
            _message = "This layer no more symbol";
            notifyListeners();
          } else {
            _state = SymbolState.success;
            notifyListeners();
          }
        }
      } catch (e) {
        _state = SymbolState.failed;
        _message = e.toString();
        notifyListeners();
        print(e.toString());
      }
    }
  }

  List<ItemLineByLayerModel> _listItemLineByLayer = [];
  List<ItemLineByLayerModel> get listItemLineByLayer => _listItemLineByLayer;

  void getAllItemLine(String token, String layerId, bool isConnected) async {
    _state = SymbolState.loading;

    final dataBox = await _hiveService.openAndGetDataFromHiveBox(
        getHiveItemLine, listItemLine);
    if (isConnected) {
      try {
        var response = await _apiProvider.getAllItemLine(token, layerId);
        if (response.statusCode == 200) {
          _listItemLineByLayer =
              ItemLineByLayerModel.fromJsonList(response.data)!;
          _hiveService.deleteDataFromBox(getHiveItemLine, listItemLine);
          _hiveService.saveDataToBox(
              getHiveItemLine, listItemLine, json.encode(_listItemLineByLayer));
          if (_listItemLineByLayer.isEmpty) {
            _state = SymbolState.empty;
            _message = "This layer no more symbol";
            notifyListeners();
          } else {
            _state = SymbolState.success;
            notifyListeners();
          }
        }
      } catch (e) {
        _state = SymbolState.failed;
        _message = e.toString();
        notifyListeners();
        print(e.toString());
      }
    }
  }
}
