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

  checkListAnchorData(double dx, double dy) {
    if (_listAnchorData.length == 0) {
       addAnchorData(
            dx, dy + 15, "A1");
    } else {
      int length = _listAnchorData.length;
      List<int> missing = [];
      List<int> sequence = [];

      _listAnchorData.forEach((element) {
        sequence.add(int.parse(element.text.replaceAll("A", "")));
      });
      sequence.sort();

      for (int i = 1; i <= length; i++) {
        if (!sequence.contains(i)) {
          missing.add(i);
        }
      }

      print(missing);
      if (missing.isEmpty) {
        addAnchorData(
            dx, dy + 15, "A" + (_listAnchorData.length + 1).toString());
      } else {
        addAnchorData(dx, dy + 15, "A" + (missing.first).toString());
      }
    }
    notifyListeners();
  }

  addAnchorData(double dx, double dy, String text) {
    _listAnchorData.add(AnchorList(
        circleX: dx,
        circleY: dy - 25,
        textX: dx,
        textY: dy - 25,
        distance: 0,
        size: 0,
        anchorEye: 0,
        text: text,
        eyesPict: true,
        imageType: 0,
        downGuyList: []));

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
