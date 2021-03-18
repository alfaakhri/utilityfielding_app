import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:flutter/material.dart';

class AnchorProvider extends ChangeNotifier {
  List<AnchorList> _listAnchorData = List<AnchorList>();
  List<AnchorList> get listAnchorData => _listAnchorData;
  void setListAnchorData(List<AnchorList> listAnchorData) {
    _listAnchorData.clear();
    if (listAnchorData != null) {
      _listAnchorData = listAnchorData;
    } else {
      _listAnchorData = List<AnchorList>();
    }

    notifyListeners();
  }

  addListAnchorData(double dx, double dy) {
    if (_listAnchorData.length == 0) {
      _listAnchorData.add(AnchorList(
          circleX: dx,
          circleY: dy,
          textX: dx,
          textY: dy,
          distance: 0,
          size: 0,
          anchorEye: 0,
          text: "1",
          eyesPict: true,
          downGuyList: []));
    } else {
      _listAnchorData.add(AnchorList(
          circleX: dx,
          circleY: dy,
          textX: dx,
          textY: dy,
          distance: 0,
          size: 0,
          anchorEye: 0,
          text: (_listAnchorData.length + 1).toString(),
          eyesPict: true,
          downGuyList: []));
    }
    notifyListeners();
  }

  AnchorList _anchorActiveSelected = AnchorList();
  AnchorList get anchorActiveSelected => _anchorActiveSelected;
  void setAnchorActiveSelected(String text) {
    _anchorActiveSelected =
        _listAnchorData.firstWhere((element) => element.text == text);
    notifyListeners();
  }

  AnchorList getDataAnchorList(String anchorText) {
    AnchorList data =
        _listAnchorData.firstWhere((element) => element.text == anchorText);
    return data;
  }

  void removeDataAnchorList() {
    _listAnchorData.remove(_anchorActiveSelected);
    notifyListeners();
  }

  void updateDataAnchorList(
      {String distance, String size, String eyes, bool isPicture}) {
    _listAnchorData.forEach((element) {
      if (element.text == _anchorActiveSelected.text) {
        element.distance = double.parse(distance);
        element.size = double.parse(size);
        element.anchorEye = double.parse(eyes);
        element.eyesPict = isPicture;
      }
    });
  }

  void addDownGuyByAnchor(DownGuyList downGuyList) {
    for (var list in _listAnchorData) {
      if (list.text == anchorActiveSelected.text) {
        list.downGuyList.add(downGuyList);
        break;
      }
    }
    print(_listAnchorData
        .map((e) => e.downGuyList.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  void removeDownGuyByAnchor(DownGuyList downGuyList) {
    for (var list in _listAnchorData) {
      if (list.text == anchorActiveSelected.text) {
        list.downGuyList.remove(downGuyList);
        break;
      }
    }
    notifyListeners();
  }

  void clearAll() {
    _listAnchorData.clear();
    _anchorActiveSelected = AnchorList();
    notifyListeners();
  }
}
