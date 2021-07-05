import 'dart:convert';

import 'package:fielding_app/data/models/edit_pole/add_pole_model.dart';
import 'package:fielding_app/data/models/edit_pole/all_down_guy_owner.dart';
import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
import 'package:fielding_app/data/models/edit_pole/riser_active.dart';
import 'package:fielding_app/data/models/edit_pole/riser_and_vgr_type_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RiserProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  HiveService _hiveService = HiveService();

  //-----------------------------------------------------------------------------------------
  List<AllDownGuyOwnerModel>? _listDownGuyOwner = <AllDownGuyOwnerModel>[];
  List<AllDownGuyOwnerModel>? get getListDownGuyOwner => _listDownGuyOwner;
  void setListDownGuyOwner(List<AllDownGuyOwnerModel>? listDownGuyOwner) {
    _listDownGuyOwner = listDownGuyOwner;
    notifyListeners();
  }

  AllDownGuyOwnerModel _downGuySelected = AllDownGuyOwnerModel();
  AllDownGuyOwnerModel get downGuySelected => _downGuySelected;
  void setDownGuySelected(String? value) {
    _downGuySelected =
        _listDownGuyOwner!.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  AllDownGuyOwnerModel getNameDownGuySelected(int? index) {
    AllDownGuyOwnerModel data =
        _listDownGuyOwner!.firstWhere((element) => element.id == index);
    return data;
  }

  void setDownGuySelectedByEnum(int? index) {
    _downGuySelected =
        _listDownGuyOwner!.firstWhere((element) => element.id == index);
    notifyListeners();
  }

  void getAllDownGuyOwner() async {
    final dataBox = await _hiveService.openAndGetDataFromHiveBox(
        getHiveDownGuyOwner, listDownGuyOwner);
    if (dataBox != null) {
      setListDownGuyOwner(
          AllDownGuyOwnerModel.fromJsonList(json.decode(dataBox)));
    } else {
      try {
        var response = await _apiProvider.getAllDownGuyOwner();
        if (response.statusCode == 200) {
          setListDownGuyOwner(AllDownGuyOwnerModel.fromJsonList(response.data));
          _hiveService.deleteDataFromBox(getHiveDownGuyOwner, listDownGuyOwner);
          _hiveService.saveDataToBox(getHiveDownGuyOwner, listDownGuyOwner,
              json.encode(getListDownGuyOwner));
          print("all down guy: ${response.data}");
        } else {}
      } catch (e) {
        print(e.toString());
      }
    }
  }

  //-----------------------------------------------------------------------------------------
  List<RiserAndVGRTypeModel>? _listRiserType = <RiserAndVGRTypeModel>[];
  List<RiserAndVGRTypeModel>? get listRiser => _listRiserType;
  void setListTypeRiser(List<RiserAndVGRTypeModel>? data) {
    _listRiserType = data;
    notifyListeners();
  }

  RiserAndVGRTypeModel _riserVGRSelected = RiserAndVGRTypeModel();
  RiserAndVGRTypeModel get riserVGRSelected => _riserVGRSelected;
  void setRiserVGRSelected(String? value) {
    _riserVGRSelected =
        _listRiserType!.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  void getRiserAndVGR() async {
    final dataBox = await _hiveService.openAndGetDataFromHiveBox(
        getHiveRiserVGR, listRiserVGR);
    if (dataBox != null) {
      setListTypeRiser(RiserAndVGRTypeModel.fromJsonList(json.decode(dataBox)));
    } else {
      try {
        var response = await _apiProvider.getRiserAndVGR();
        if (response.statusCode == 200) {
          setListTypeRiser(RiserAndVGRTypeModel.fromJsonList(response.data));
          _hiveService.deleteDataFromBox(getHiveRiserVGR, listRiserVGR);
          _hiveService.saveDataToBox(
              getHiveRiserVGR, listRiserVGR, json.encode(listRiser));
          print("riser and vgr: ${response.data}");
        } else {}
      } catch (e) {
        print(e.toString());
      }
    }
  }

  //-----------------------------------------------------------------------------------------
  void clearRiserAndtype() {
    _downGuySelected = AllDownGuyOwnerModel();
    _riserVGRSelected = RiserAndVGRTypeModel();
    _resultDataRiser = RiserAndVGRList();
    notifyListeners();
  }

  //-----------------------------------------------------------------------------------------
  List<String?> _listVGRActive = <String?>[];
  List<String?> get listVGRActive => _listVGRActive;

  void addListVGRActive() {
    if (_listVGRActive.length == 0) {
      String data = "VGR-1";
      _listVGRActive.add(data);
      _activePointName = "VGR";
      _sequenceCurrent = 1;
    } else {
      String last = _listVGRActive.last!;
      int lastValue = int.parse(last.split("-")[1]);
      String data = "VGR-${lastValue + 1}";
      _sequenceCurrent = lastValue + 1;
      _listVGRActive.add(data);
      _activePointName = "VGR";
    }
    print(json.encode(_listVGRActive).toString());
    assignActivePoint();
    notifyListeners();
  }

  void removeOneListVGRActive(String value) {
    _listVGRActive.remove(value);
    notifyListeners();
  }

  //-----------------------------------------------------------------------------------------
  List<String?> _listRiserActive = <String?>[];
  List<String?> get listRiserActive => _listRiserActive;
  void addListRiserActive(String value) {
    if (_listRiserActive.length == 0) {
      String data = "R" + value + "-A";
      _listRiserActive.add(data);
      _activePointName = "R" + value;
      _sequenceCurrent = 1;
    } else {
      bool isRiserNotFound = false;
      late String tempNumberRiser;
      late int tempSequenceEqualNumber;
      //Looping untuk mengecek apakah riser number telah ada atau tidak
      //Jika ada maka menambahkan increment berdasarkan riser number
      _listRiserActive.forEach((element) {
        String numberRiser = element!.replaceAll("R", "");
        numberRiser = numberRiser.split("-")[0];
        int sequence = alphabet
                .indexWhere((note) => note.startsWith(element.split("-")[1])) +
            1;
        if (numberRiser.contains(value)) {
          tempNumberRiser = numberRiser;
          tempSequenceEqualNumber = sequence;

          isRiserNotFound = true;
        }
      });

      if (!isRiserNotFound) {
        String data = "R" + value + "-A";
        _listRiserActive.add(data);
        _activePointName = "R" + value;
        _sequenceCurrent = 1;
      } else {
        String data = "R$tempNumberRiser-${alphabet[tempSequenceEqualNumber]}";
        _activePointName = "R" + tempNumberRiser;
        _listRiserActive.add(data);
        _sequenceCurrent = tempSequenceEqualNumber + 1;
      }
    }
    print(json.encode(_listRiserActive));
    assignActivePoint();
    notifyListeners();
  }

  void removeOneListRiserActive(String value) {
    _listRiserActive.remove(value);
    notifyListeners();
  }

  //-----------------------------------------------------------------------------------------
  String? _activePointName;
  String? get activePointName => _activePointName;
  void setActivePointName(value) {
    _activePointName = value;
    notifyListeners();
  }

  int? _sequenceCurrent;
  int? get sequenceCurrent => _sequenceCurrent;
  void setSequenceCurrent(int sequenceCurrent) {
    _sequenceCurrent = sequenceCurrent;
    notifyListeners();
  }

  RiserAndVGRList _resultDataRiser = RiserAndVGRList();
  RiserAndVGRList get resultDataRiser => _resultDataRiser;
  setResultDataRiser(double shapeX, double shapeY) {
    _resultDataRiser = RiserAndVGRList(
        shapeX: shapeX,
        shapeY: shapeY - 25,
        textX: shapeX,
        textY: shapeY - 25,
        name: (activePointName == "VGR")
            ? activePointName! + "-" + sequenceCurrent.toString()
            : activePointName! + "-" + alphabet[sequenceCurrent! - 1],
        value: riserVGRSelected.id,
        type: downGuySelected.id,
        sequence: sequenceCurrent,
        imageType: 0);
    notifyListeners();
  }

  List<String?> _listActivePoint = <String?>[];
  List<String?> get listActivePoint => _listActivePoint;
  void setListActivePoint(String value) {
    _sequenceCurrent = null;
    if (value.contains("VGR")) {
      addListVGRActive();
    } else {
      addListRiserActive(value);
    }
  }

  void removeListActivePoint() {
    if (activePointName!.contains("VGR")) {
      removeOneListVGRActive(activePointName! + "-$sequenceCurrent");
    } else {
      removeOneListRiserActive(
          activePointName! + "-${alphabet[sequenceCurrent! - 1]}");
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
  List<RiserAndVGRList> _listRiserData = <RiserAndVGRList>[];
  List<RiserAndVGRList> get listRiserData => _listRiserData;
  void addListRiserData(RiserAndVGRList data) {
    _listRiserData.add(data);
    _listRiserData
        .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

    print(json.encode(_listRiserData.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  void addAllListRiserData(List<RiserAndVGRList>? data) {
    _listRiserData.clear();
    _listActivePoint.clear();
    _listRiserActive.clear();
    _listVGRActive.clear();
    if (data != null) {
      _listRiserData.addAll(data);
      _listRiserData.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      print(_listRiserData.toList());
      for (var riser in _listRiserData) {
        if (riser.name != null) {
          if (riser.name!.contains("VGR")) {
            _listVGRActive.add(riser.name);
          } else {
            _listRiserActive.add(riser.name);
          }
        }
      }
      assignActivePoint();
    } else {
      _listRiserData = <RiserAndVGRList>[];
      _listVGRActive = <String?>[];
      _listRiserActive = <String?>[];
      _listActivePoint = <String?>[];
    }

    notifyListeners();
  }

  void searchTypeByPointName(String? value) {
    int? index =
        _listRiserData.firstWhere((element) => element.name == value).type;
    setDownGuySelectedByEnum(index);
    notifyListeners();
  }

  void editListRiserData(String name, int? indexType) {
    RiserAndVGRList data =
        _listRiserData.firstWhere((element) => element.name == name);
    _listRiserData.remove(data);
    data.type = indexType;
    _listRiserData.add(data);
    notifyListeners();
  }

  //-----------------------------------------------------------------------------------------

  List<AnchorFences> _listRiserFence = <AnchorFences>[];
  List<AnchorFences> get listRiserFence => _listRiserFence;
  setAllRiserFence(List<AnchorFences> listRiserFence) {
    _listRiserFence = listRiserFence;
    notifyListeners();
  }

  addRiserFence(Offset a, Offset b) {
    List<double> points = [a.dx, a.dy, b.dx, b.dy];
    _listRiserFence.add(AnchorFences(
      points: points.toString(),
      stroke: "brown",
      data: "fence",
    ));
    notifyListeners();
  }

  void removeLastRiserFence() {
    _listRiserFence.removeLast();
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
    _listRiserFence.clear();
    notifyListeners();
  }

  //-----------------------------------------------------------------------------------------

  String? valueType(int? data) {
    String? value =
        _listRiserType!.firstWhere((element) => element.id == data).text;
    return value;
  }
}
