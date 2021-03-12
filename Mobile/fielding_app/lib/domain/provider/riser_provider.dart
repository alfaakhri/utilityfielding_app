import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/all_down_guy_owner.dart';
import 'package:fielding_app/data/models/riser_and_vgr_type_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:flutter/material.dart';

class RiserProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();

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

  List<RiserAndVGRTypeModel> _listRiserType = List<RiserAndVGRTypeModel>();
  List<RiserAndVGRTypeModel> get listRiser => _listRiserType;
  void setListRiser(List<RiserAndVGRTypeModel> data) {
    _listRiserType = data;
    notifyListeners();
  }

  void getRiserAndVGR() async {
    try {
      var response = await _apiProvider.getRiserAndVGR();
      if (response.statusCode == 200) {
        setListRiser(RiserAndVGRTypeModel.fromJsonList(response.data));
        print("riser and vgr: ${response.data}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  List<RiserAndVGRList> _listRiserData = List<RiserAndVGRList>();
  List<RiserAndVGRList> get listRiserData => _listRiserData;

  void addListRiserData(RiserAndVGRList data) {
    _listRiserData.add(data);
    notifyListeners();
  }

  void editListRiserData(RiserAndVGRList data, int index) {
    _listRiserData.removeAt(index);
    _listRiserData.add(data);
    notifyListeners();
  }

  void removeListRiserData(int index) {
    _listRiserData.removeAt(index);
    notifyListeners();
  }
}
