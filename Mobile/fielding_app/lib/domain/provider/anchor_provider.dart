import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/all_anchor_eyes_model.dart';
import 'package:fielding_app/data/models/all_anchor_size_model.dart';
import 'package:fielding_app/data/models/broken_down_guy_size_model.dart';
import 'package:fielding_app/data/models/down_guy_size_model.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:flutter/material.dart';

class AnchorProvider extends ChangeNotifier {
  ApiProvider _repository = ApiProvider();

  List<AllAnchorSizeModel> _listAllAnchorSize = List<AllAnchorSizeModel>();
  List<AllAnchorSizeModel> get listAllAnchorSize => _listAllAnchorSize;
  void setListAllAnchorSize(List<AllAnchorSizeModel> listAllAnchorSize) {
    _listAllAnchorSize = listAllAnchorSize;
    notifyListeners();
  }

  AllAnchorSizeModel _anchorSizeSelected = AllAnchorSizeModel();
  AllAnchorSizeModel get anchorSizeSelected => _anchorSizeSelected;
  void setAnchorSizeSelected(String value) {
    _anchorSizeSelected =
        _listAllAnchorSize.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  void getAllAnchorSize() async {
    try {
      var response = await _repository.getAllAnchorSize();
      if (response.statusCode == 200) {
        setListAllAnchorSize(AllAnchorSizeModel.fromJsonList(response.data));
        print("all anchor size : ${response.data}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //-------------------------------------------------------------------------------------------------------

  List<AllAnchorEyesModel> _listAnchorEyesModel = List<AllAnchorEyesModel>();
  List<AllAnchorEyesModel> get listAnchorEyesModel => _listAnchorEyesModel;
  void setListAnchorEyesModel(List<AllAnchorEyesModel> listAnchorEyesModel) {
    _listAnchorEyesModel = listAnchorEyesModel;
    notifyListeners();
  }

  AllAnchorEyesModel _anchorEyesSelected = AllAnchorEyesModel();
  AllAnchorEyesModel get anchorEyesSelected => _anchorEyesSelected;
  void setAnchorEyesSelected(String value) {
    _anchorEyesSelected =
        _listAnchorEyesModel.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  void getAllAnchorEyes() async {
    try {
      var response = await _repository.getAllAnchorEyes();
      if (response.statusCode == 200) {
        setListAnchorEyesModel(AllAnchorEyesModel.fromJsonList(response.data));
        print("all anchor eyes : ${response.data}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //-------------------------------------------------------------------------------------------------------

  List<DownGuySizeModel> _listDownGuySize = List<DownGuySizeModel>();
  List<DownGuySizeModel> get listDownGuySize => _listDownGuySize;
  void setListDownGuySize(List<DownGuySizeModel> listDownGuySize) {
    _listDownGuySize = listDownGuySize;
    notifyListeners();
  }

  DownGuySizeModel _downGuySelected = DownGuySizeModel();
  DownGuySizeModel get downGuySelected => _downGuySelected;
  void setDownGuySelected(String value) {
    _downGuySelected =
        _listDownGuySize.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  void getDownGuySize() async {
    try {
      var response = await _repository.getDownGuySize();
      if (response.statusCode == 200) {
        setListDownGuySize(DownGuySizeModel.fromJsonList(response.data));
        print("down guy size : ${response.data}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //-------------------------------------------------------------------------------------------------------

  List<BrokenDownGuySizeModel> _listBrokenDownGuySize =
      List<BrokenDownGuySizeModel>();
  List<BrokenDownGuySizeModel> get listBrokenDownGuySize =>
      _listBrokenDownGuySize;
  void setListBrokenDownGuySize(
      List<BrokenDownGuySizeModel> listBrokenDownGuySize) {
    _listBrokenDownGuySize = listBrokenDownGuySize;
    notifyListeners();
  }

  BrokenDownGuySizeModel _brokenDownGuySelected = BrokenDownGuySizeModel();
  BrokenDownGuySizeModel get brokendownGuySelected => _brokenDownGuySelected;
  void setBrokenDownGuySelected(String value) {
    _brokenDownGuySelected =
        _listBrokenDownGuySize.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  void getBrokenDownGuySize() async {
    try {
      var response = await _repository.getBrokenDownGuySize();
      if (response.statusCode == 200) {
        setListBrokenDownGuySize(
            BrokenDownGuySizeModel.fromJsonList(response.data));
        print("down guy size : ${response.data}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //-------------------------------------------------------------------------------------------------------

  List<AnchorList> _listAnchorData = List<AnchorList>();
  List<AnchorList> get listAnchorData => _listAnchorData;
  void setListAnchorData(List<AnchorList> listAnchorData) {
    _listAnchorData.clear();
    if (listAnchorData != null) {
      _listAnchorData = listAnchorData;
      _listAnchorData.sort((a, b) => a.text.toLowerCase().compareTo(b.text.toLowerCase()));
    } else {
      _listAnchorData = List<AnchorList>();
    }

    notifyListeners();
  }

  checkListAnchorData(double dx, double dy) {
    if (_listAnchorData.length == 0) {
      addAnchorData(dx, dy + 15, "A1");
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

    _anchorEyesSelected = _listAnchorEyesModel
        .firstWhere((element) => element.id == _anchorActiveSelected.anchorEye);
    _anchorSizeSelected = _listAllAnchorSize
        .firstWhere((element) => element.id == _anchorActiveSelected.size);
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
      {String distance, int size, int eyes, bool isPicture}) {
    _listAnchorData.forEach((element) {
      if (element.text == _anchorActiveSelected.text) {
        element.distance = double.parse(distance);
        element.size = size;
        element.anchorEye = eyes;
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
    _downGuySelected = DownGuySizeModel();
    _brokenDownGuySelected = BrokenDownGuySizeModel();
    notifyListeners();
  }

  String getValueDownGuySize(int id, int type) {
    if (type == 1) {
      return _listBrokenDownGuySize
          .firstWhere((element) => element.id == id)
          .text;
    } else {
      return _listDownGuySize.firstWhere((element) => element.id == id).text;
    }
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
    _downGuySelected = DownGuySizeModel();
    _brokenDownGuySelected = BrokenDownGuySizeModel();
    _anchorEyesSelected = AllAnchorEyesModel();
    _anchorSizeSelected = AllAnchorSizeModel();
    notifyListeners();
  }
}
