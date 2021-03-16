import 'dart:convert';

import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/all_down_guy_owner.dart';
import 'package:fielding_app/data/models/riser_active.dart';
import 'package:fielding_app/data/models/riser_and_vgr_type_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:flutter/material.dart';

class RiserProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  //-----------------------------------------------------------------------------------------
  List<AllDownGuyOwnerModel> _listDownGuyOwner = List<AllDownGuyOwnerModel>();
  List<AllDownGuyOwnerModel> get listDownGuyOwner => _listDownGuyOwner;
  void setListDownGuyOwner(List<AllDownGuyOwnerModel> listDownGuyOwner) {
    _listDownGuyOwner = listDownGuyOwner;
    notifyListeners();
  }

  AllDownGuyOwnerModel _downGuySelected = AllDownGuyOwnerModel();
  AllDownGuyOwnerModel get downGuySelected => _downGuySelected;
  void setDownGuySelected(String value) {
    _downGuySelected =
        _listDownGuyOwner.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  AllDownGuyOwnerModel getNameDownGuySelected(int index) {
    AllDownGuyOwnerModel data = _listDownGuyOwner.firstWhere((element) => element.id == index);
    return data;
  }

  void setDownGuySelectedByEnum(int index) {
    _downGuySelected =
        _listDownGuyOwner.firstWhere((element) => element.id == index);
    notifyListeners();
  }

  void getAllDownGuyOwner() async {
    try {
      var response = await _apiProvider.getAllDownGuyOwner();
      if (response.statusCode == 200) {
        setListDownGuyOwner(AllDownGuyOwnerModel.fromJsonList(response.data));
        print("all down guy: ${response.data}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  //-----------------------------------------------------------------------------------------
  List<RiserAndVGRTypeModel> _listRiserType = List<RiserAndVGRTypeModel>();
  List<RiserAndVGRTypeModel> get listRiser => _listRiserType;
  void setListTypeRiser(List<RiserAndVGRTypeModel> data) {
    _listRiserType = data;
    notifyListeners();
  }

  RiserAndVGRTypeModel _riserVGRSelected = RiserAndVGRTypeModel();
  RiserAndVGRTypeModel get riserVGRSelected => _riserVGRSelected;
  void setRiserVGRSelected(String value) {
    _riserVGRSelected =
        _listRiserType.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  void getRiserAndVGR() async {
    try {
      var response = await _apiProvider.getRiserAndVGR();
      if (response.statusCode == 200) {
        setListTypeRiser(RiserAndVGRTypeModel.fromJsonList(response.data));
        print("riser and vgr: ${response.data}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  //-----------------------------------------------------------------------------------------
  void clearRiserAndtype() {
    _downGuySelected = AllDownGuyOwnerModel();
    _riserVGRSelected = RiserAndVGRTypeModel();
    notifyListeners();
  }

  //-----------------------------------------------------------------------------------------
  List<String> _listVGRActive = List<String>();
  List<String> get listVGRActive => _listVGRActive;
  void addListVGRActive() {
    if (_listVGRActive.length == 0) {
      String data = "VGR 1";
      _listVGRActive.add(data);
      _activePointName = data;
    } else {
      String data = "VGR ${_listVGRActive.length + 1}";
      _listVGRActive.add(data);
      _activePointName = data;
    }
    print(json.encode(_listVGRActive).toString());
    assignActivePoint();
    notifyListeners();
  }

  //-----------------------------------------------------------------------------------------
  List<String> _listRiserActive = List<String>();
  List<String> get listRiserActive => _listRiserActive;
  void addListRiserActive(String value) {
    if (_listRiserActive.length == 0) {
      String data = "R" + value + "-1";
      _listRiserActive.add(data);
      _activePointName = data;
    } else {
      bool isRiserNotFound = false;
      bool isEqualNumber = false;
      String tempNumberRiser;
      int tempSequenceEqualNumber;
      //Looping untuk mengecek apakah riser number telah ada atau tidak
      //Jika ada maka menambahkan increment berdasarkan riser number
      _listRiserActive.forEach((element) {
        String numberRiser = element.replaceAll("R", "");
        numberRiser = numberRiser.split("-")[0];
        int sequence = int.parse(element.split("-")[1]);
        if (numberRiser.contains(value)) {
          tempNumberRiser = numberRiser;
          tempSequenceEqualNumber = sequence;

          isRiserNotFound = true;
        }
      });

      if (!isRiserNotFound) {
        String data = "R" + value + "-1";
        _listRiserActive.add(data);
        _activePointName = data;
      } else {
        String data = "R$tempNumberRiser-${tempSequenceEqualNumber + 1}";
        _activePointName = data;
        _listRiserActive.add(data);
      }
    }
    print(json.encode(_listRiserActive));
    assignActivePoint();
    notifyListeners();
  }

  //-----------------------------------------------------------------------------------------
  String _activePointName;
  String get activePointName => _activePointName;
  void setActivePointName(value) {
    _activePointName = value;
    notifyListeners();
  }

  List<String> _listActivePoint = List<String>();
  List<String> get listActivePoint => _listActivePoint;
  void setListActivePoint(String value) {
    if (value.contains("VGR")) {
      addListVGRActive();
    } else {
      addListRiserActive(value);
    }
  }

  void assignActivePoint() {
    _listActivePoint.clear();
    if (_listRiserActive.length != 0) {
      _listRiserActive.forEach((element) {
        _listActivePoint.add(element);
      });
    }
    if (_listVGRActive.length != 0) {
      _listVGRActive.forEach((element) {
        _listActivePoint.add(element);
      });
    }
    print(json.encode(_listActivePoint));
  }

  void removeDataActivePoint(String pointName) {
    if (pointName.contains("VGR")) {
      _listVGRActive.remove(pointName);
    } else {
      _listRiserActive.remove(pointName);
    }
    _listActivePoint.remove(pointName);
    _listRiserData.removeWhere((element) => element.name == pointName);
    notifyListeners();
  }

  //-----------------------------------------------------------------------------------------
  List<RiserAndVGRList> _listRiserData = List<RiserAndVGRList>();
  List<RiserAndVGRList> get listRiserData => _listRiserData;
  void addListRiserData(RiserAndVGRList data) {
    _listRiserData.add(data);
    print(json.encode(_listRiserData.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  void searchTypeByPointName(String value) {
    int index =
        _listRiserData.firstWhere((element) => element.name == value).type;
    setDownGuySelectedByEnum(index);
    notifyListeners();
  }

  void editListRiserData(String name, int indexType) {
    RiserAndVGRList data =
        _listRiserData.firstWhere((element) => element.name == name);
    _listRiserData.remove(data);
    data.type = indexType;
    _listRiserData.add(data);
    notifyListeners();
  }
  //-----------------------------------------------------------------------------------------
  void clearAll() {
    _listRiserData.clear();
    _listActivePoint.clear();
    _listRiserActive.clear();
    _listVGRActive.clear();
    _riserVGRSelected = RiserAndVGRTypeModel();
    _downGuySelected = AllDownGuyOwnerModel();
    notifyListeners();
  }
}
