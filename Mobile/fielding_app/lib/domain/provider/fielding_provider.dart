import 'dart:convert';

import 'package:fielding_app/data/models/edit_pole/add_pole_model.dart';
import 'package:fielding_app/data/models/edit_pole/add_transformer_model.dart';
import 'package:fielding_app/data/models/edit_pole/all_fielding_type_model.dart';
import 'package:fielding_app/data/models/edit_pole/all_hoa_type_model.dart';
import 'package:fielding_app/data/models/edit_pole/all_pole_class_model.dart';
import 'package:fielding_app/data/models/edit_pole/all_pole_condition_model.dart';
import 'package:fielding_app/data/models/edit_pole/all_pole_height_model.dart';
import 'package:fielding_app/data/models/edit_pole/all_pole_species_model.dart';
import 'package:fielding_app/data/models/detail_fielding/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/list_fielding/all_projects_model.dart';
import 'package:fielding_app/data/models/edit_pole/current_address.dart';
import 'package:fielding_app/data/models/detail_fielding/job_number_attachment_model.dart';
import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/hive_service.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FieldingProvider extends ChangeNotifier {
  ApiProvider apiProvider = ApiProvider();
  HiveService _hiveService = HiveService();

  void getAllDataFielding(bool? isConnected) {
    if (isConnected != null) {
      getListAllPoleClass(isConnected);
      getListAllPoleCondition(isConnected);
      getListAllPoleHeight(isConnected);
      getListAllPoleSpecies(isConnected);
      getListAllHoaType(isConnected);
      getFieldingType(isConnected);
      getCurrentLocation(isConnected);
    }
  }

  bool? _isEmptyListJob = false;
  bool? get isEmptyListJob => _isEmptyListJob;
  void setEmptyListJob(value) {
    _isEmptyListJob = value;
    notifyListeners();
  }

  bool? _isUnknownCurrent;
  bool? get isUnknownCurrent => _isUnknownCurrent;
  void setUnknownCurrent(value) {
    _isUnknownCurrent = value;
    notifyListeners();
  }

  bool? _isEstimateCurrent;
  bool? get isEstimateCurrent => _isEstimateCurrent;
  void setIsEstimateCurrent(bool? isEstimateCurrent) {
    _isEstimateCurrent = isEstimateCurrent;
    notifyListeners();
  }

  late double baseWidth;
  late double baseHeight;
  setBaseSize(double width, double height) {
    baseWidth = width;
    baseHeight = height;
    notifyListeners();
  }

  List<AllPolesByLayerModel>? _allPolesByLayer = <AllPolesByLayerModel>[];
  List<AllPolesByLayerModel>? get allPolesByLayer => _allPolesByLayer;
  void setAllPolesByLayer(List<AllPolesByLayerModel>? allPolesByLayer) {
    _allPolesByLayer = allPolesByLayer;
    notifyListeners();
  }

  AllProjectsModel _allProjectsSelected = AllProjectsModel();
  AllProjectsModel get allProjectsSelected => _allProjectsSelected;
  void setAllProjectsSelected(AllProjectsModel allProjectsSelected) {
    _allProjectsSelected = allProjectsSelected;
    notifyListeners();
  }

  AllPolesByLayerModel _polesByLayerSelected = AllPolesByLayerModel();
  AllPolesByLayerModel get polesByLayerSelected => _polesByLayerSelected;
  void setPolesByLayerSelected(AllPolesByLayerModel polesByLayerSelected) {
    _polesByLayerSelected = polesByLayerSelected;
    notifyListeners();
  }

  void getCurrentLocation(bool isConnected) async {
    LocationService location = LocationService();
    LocationData data;
    final dataBox = await _hiveService.openAndGetDataFromHiveBox(getHiveCurrentLocation, locationDataLocal);
    if (isConnected) {
      data = await location.getCurrentLocation();
      var mapLocation = {"latitude": data.latitude!, "longitude": data.longitude!};
      print("latlng: ${data.latitude.toString()} ${data.longitude.toString()}");
      _hiveService.deleteDataFromBox(getHiveCurrentLocation, locationDataLocal);
      _hiveService.saveDataToBox(getHiveCurrentLocation, locationDataLocal, mapLocation);
      setCurrentPosition(LatLng(data.latitude!, data.longitude!));
      setCurrentLocationData(data);
    } else {
      if (dataBox != null) {
        var mapLocation = Map<String, double>.from(dataBox);
        data = LocationData.fromMap(mapLocation);
        setCurrentPosition(LatLng(data.latitude!, data.longitude!));
        setCurrentLocationData(data);
      }
    }
    notifyListeners();
  }

  LocationData? _currentLocationData;
  LocationData? get currentLocationData => _currentLocationData;
  void setCurrentLocationData(LocationData currentLocationData) {
    _currentLocationData = currentLocationData;
    notifyListeners();
  }

  LatLng? _currentPosition;
  LatLng? get currentPosition => _currentPosition;
  void setCurrentPosition(LatLng currentPosition) {
    _currentPosition = currentPosition;
    notifyListeners();
  }

  CurrentAddress _currentAddress = CurrentAddress();
  CurrentAddress get currentAddress => _currentAddress;
  void setCurrentAddress(CurrentAddress currentAddress) {
    _currentAddress = currentAddress;
    _streetName = _currentAddress.results!.first.formattedAddress;
    notifyListeners();
  }

  String? _streetName;
  String? get streetName => _streetName;
  void setStreetName(String? streetName) {
    _streetName = streetName;
    notifyListeners();
  }

  void getCurrentAddress(double lat, double long) async {
    ApiProvider _repository = ApiProvider();
    try {
      var response = await _repository.getLocationByLatLng(lat, long);
      if (response.statusCode == 200) {
        setCurrentAddress(CurrentAddress.fromJson(response.data));
        print("status geocode: ${_currentAddress.status.toString()}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  double? _latitude;
  double? get latitude => _latitude;
  double? _longitude;
  double? get longitude => _longitude;

  void setLatLng(double? latitude, double? longitude) {
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
  }

  //--------------------------------------------------------------------------------------------
  List<AllPoleSpeciesModel>? _listAllPoleSpecies = <AllPoleSpeciesModel>[];
  List<AllPoleSpeciesModel>? get listAllPoleSpecies => _listAllPoleSpecies;
  void setListAllPoleSpecies(List<AllPoleSpeciesModel>? listAllPoleSpecies) {
    _listAllPoleSpecies = listAllPoleSpecies;
    notifyListeners();
  }

  AllPoleSpeciesModel _poleSpeciesSelected = AllPoleSpeciesModel();
  AllPoleSpeciesModel get poleSpeciesSelected => _poleSpeciesSelected;
  void setPoleSpeciesSelected(String? value) {
    _poleSpeciesSelected = _listAllPoleSpecies!.firstWhere((element) => element.text!.contains(value!));
    notifyListeners();
  }

  AllPoleSpeciesModel setPoleSpeciesAssign(int? value) {
    if (value != null) {
      _listAllPoleSpecies!.forEach((element) {
        if (element.id == value) {
          _poleSpeciesSelected = element;
        }
      });
    } else {
      _poleSpeciesSelected = AllPoleSpeciesModel();
    }
    return _poleSpeciesSelected;
  }

  void getListAllPoleSpecies(bool isConnected) async {
    final dataBox = await _hiveService.openAndGetDataFromHiveBox(getHivePolesSpecies, listPolesSpecies);
    if (isConnected) {
      try {
        var response = await apiProvider.getAllPoleSpecies();
        if (response.statusCode == 200) {
          setListAllPoleSpecies(AllPoleSpeciesModel.fromJsonList(response.data));
          _hiveService.deleteDataFromBox(getHivePolesSpecies, listPolesSpecies);
          _hiveService.saveDataToBox(getHivePolesSpecies, listPolesSpecies, json.encode(listAllPoleSpecies));
          print("all pole species: ${response.data}");
        } else {}
      } catch (e) {
        print(e.toString());
      }
    } else {
      if (dataBox != null) {
        setListAllPoleSpecies(AllPoleSpeciesModel.fromJsonList(json.decode(dataBox)));
      }
    }
  }

  //--------------------------------------------------------------------------------------------
  List<AllPoleClassModel>? _listAllPoleClass = <AllPoleClassModel>[];
  List<AllPoleClassModel>? get listAllPoleClass => _listAllPoleClass;
  void setListAllPoleClass(List<AllPoleClassModel>? listAllPoleClass) {
    _listAllPoleClass = listAllPoleClass;
    notifyListeners();
  }

  AllPoleClassModel _poleClassSelected = AllPoleClassModel();
  AllPoleClassModel get poleClassSelected => _poleClassSelected;
  void setPoleClassSelected(String? value) {
    _poleClassSelected = _listAllPoleClass!.firstWhere((element) => element.text!.contains(value!));
    notifyListeners();
  }

  AllPoleClassModel setPoleClassAssign(int? value) {
    if (value != null) {
      _listAllPoleClass!.forEach((element) {
        if (element.id == value) {
          _poleClassSelected = element;
        }
      });
    } else {
      _poleClassSelected = AllPoleClassModel();
    }

    return _poleClassSelected;
  }

  void getListAllPoleClass(bool isConnected) async {
    final dataBox = await _hiveService.openAndGetDataFromHiveBox(getHivePolesClass, listPolesClass);
    if (isConnected) {
      try {
        var response = await apiProvider.getAllPoleClass();
        if (response.statusCode == 200) {
          setListAllPoleClass(AllPoleClassModel.fromJsonList(response.data));
          _hiveService.deleteDataFromBox(getHivePolesClass, listPolesClass);
          _hiveService.saveDataToBox(getHivePolesClass, listPolesClass, json.encode(listAllPoleClass));
          print("all pole class: ${response.data}");
        } else {}
      } catch (e) {
        print(e.toString());
      }
    } else {
      if (dataBox != null) {
        setListAllPoleClass(AllPoleClassModel.fromJsonList(json.decode(dataBox)));
      }
    }
  }

//--------------------------------------------------------------------------------------------
  List<AllPoleHeightModel>? _listAllPoleHeight = <AllPoleHeightModel>[];
  List<AllPoleHeightModel>? get listAllPoleHeight => _listAllPoleHeight;
  void setListAllPoleHeight(List<AllPoleHeightModel>? listAllPoleHeight) {
    _listAllPoleHeight = listAllPoleHeight;
    notifyListeners();
  }

  AllPoleHeightModel _poleHeightSelected = AllPoleHeightModel();
  AllPoleHeightModel get poleHeightSelected => _poleHeightSelected;
  void setPoleHeightSelected(String? value) {
    _poleHeightSelected = _listAllPoleHeight!.firstWhere((element) => element.text == value!);
    notifyListeners();
  }

  AllPoleHeightModel setPoleHeightAssign(int? value) {
    if (value != null) {
      _listAllPoleHeight!.forEach((element) {
        if (element.id == value) {
          _poleHeightSelected = element;
        }
      });
    } else {
      _poleHeightSelected = AllPoleHeightModel();
    }
    return _poleHeightSelected;
  }

  void getListAllPoleHeight(bool isConnected) async {
    final dataBox = await _hiveService.openAndGetDataFromHiveBox(getHivePolesHeight, listPolesHeight);
    if (isConnected) {
      try {
        var response = await apiProvider.getAllPoleHeight();
        if (response.statusCode == 200) {
          setListAllPoleHeight(AllPoleHeightModel.fromJsonList(response.data));
          _hiveService.deleteDataFromBox(getHivePolesHeight, listPolesHeight);
          _hiveService.saveDataToBox(getHivePolesHeight, listPolesHeight, json.encode(listAllPoleHeight));
          print("all pole height: ${response.data}");
        } else {}
      } catch (e) {
        print(e.toString());
      }
    } else {
      if (dataBox != null) {
        setListAllPoleHeight(AllPoleHeightModel.fromJsonList(json.decode(dataBox)));
      }
    }
  }

//--------------------------------------------------------------------------------------------
  List<AllPoleConditionModel>? _listAllPoleCondition = <AllPoleConditionModel>[];
  List<AllPoleConditionModel>? get listAllPoleCondition => _listAllPoleCondition;
  void setListAllPoleCondition(List<AllPoleConditionModel>? listAllPoleCondition) {
    _listAllPoleCondition = listAllPoleCondition;
    notifyListeners();
  }

  AllPoleConditionModel _poleConditionSelected = AllPoleConditionModel();
  AllPoleConditionModel get poleConditionSelected => _poleConditionSelected;
  void setPoleConditionSelected(String? value) {
    _poleConditionSelected = _listAllPoleCondition!.firstWhere((element) => element.text!.contains(value!));
    notifyListeners();
  }

  AllPoleConditionModel setPoleConditionAssign(int? value) {
    if (value != null) {
      _listAllPoleCondition!.forEach((element) {
        if (element.id == value) {
          _poleConditionSelected = element;
        }
      });
    } else {
      _poleConditionSelected = AllPoleConditionModel();
    }
    return _poleConditionSelected;
  }

  void getListAllPoleCondition(bool isConnected) async {
    final dataBox = await _hiveService.openAndGetDataFromHiveBox(getHivePolesCondition, listPolesCondition);
    if (isConnected) {
      try {
        var response = await apiProvider.getAllPoleCondition();
        if (response.statusCode == 200) {
          setListAllPoleCondition(AllPoleConditionModel.fromJsonList(response.data));
          _hiveService.deleteDataFromBox(getHivePolesCondition, listPolesCondition);
          _hiveService.saveDataToBox(getHivePolesCondition, listPolesCondition, json.encode(listAllPoleCondition));
          print("all pole condition: ${response.data}");
        } else {}
      } catch (e) {
        print(e.toString());
      }
    } else {
      if (dataBox != null) {
        setListAllPoleCondition(AllPoleConditionModel.fromJsonList(json.decode(dataBox)));
      }
    }
  }

//--------------------------------------------------------------------------------------------
  List<AllHoaTypeModel>? _listAllHoaType = <AllHoaTypeModel>[];
  List<AllHoaTypeModel>? get listAllHoaType => _listAllHoaType;
  void setListAllHoaType(List<AllHoaTypeModel>? listAllHoaType) {
    _listAllHoaType = listAllHoaType;
    notifyListeners();
  }

  void getListAllHoaType(bool isConnected) async {
    final dataBox = await _hiveService.openAndGetDataFromHiveBox(getHiveHoaType, listHoaType);
    if (isConnected) {
      try {
        var response = await apiProvider.getAllHoaType();
        if (response.statusCode == 200) {
          setListAllHoaType(AllHoaTypeModel.fromJsonList(response.data));
          _hiveService.deleteDataFromBox(getHiveHoaType, listHoaType);
          _hiveService.saveDataToBox(getHiveHoaType, listHoaType, json.encode(listAllHoaType));
          print("all hoa type: ${response.data}");
        } else {}
      } catch (e) {
        print(e.toString());
      }
    } else {
      if (dataBox != null) {
        setListAllHoaType(AllHoaTypeModel.fromJsonList(json.decode(dataBox)));
      }
    }
  }

  AllHoaTypeModel _hoaSelected = AllHoaTypeModel();
  AllHoaTypeModel get hoaSelected => _hoaSelected;
  void setHoaSelected(String? value) {
    _hoaSelected = listAllHoaType!.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  void clearHoaSelected() {
    _hoaSelected = AllHoaTypeModel();
    notifyListeners();
  }

  bool _isHoa = false;
  bool get isHoa => _isHoa;
  void setIsHoa(bool isHoa) {
    _isHoa = isHoa;
    notifyListeners();
  }

  List<HOAList> _hoaList = <HOAList>[];
  List<HOAList> get hoaList => _hoaList;
  addHoaList(HOAList hoaList) {
    _hoaList.add(hoaList);
    notifyListeners();
  }

  updateHoaList(HOAList hoa, index) {
    _hoaList.elementAt(index).poleLengthInFeet = hoa.poleLengthInFeet;
    _hoaList.elementAt(index).poleLengthInInch = hoa.poleLengthInInch;
    notifyListeners();
  }

  addAllHoaList(List<HOAList>? data) {
    _hoaList.clear();
    if (data != null) {
      _hoaList.addAll(data);
    } else {
      _hoaList = <HOAList>[];
    }

    notifyListeners();
  }

  removeHoaList(int index) {
    _hoaList.removeAt(index);
    notifyListeners();
  }

//--------------------------------------------------------------------------------------------
  List<TransformerList> _listTransformer = <TransformerList>[];
  List<TransformerList> get listTransformer => _listTransformer;
  addlistTransformer(TransformerList transformer) {
    _listTransformer.add(transformer);
    notifyListeners();
  }

  updateListTransformer(TransformerList transformer, int index) {
    _listTransformer.elementAt(index).hOA = transformer.hOA;
    _listTransformer.elementAt(index).value = transformer.value;
    notifyListeners();
  }

  addAllListTransformer(List<TransformerList>? data) {
    _listTransformer.clear();
    if (data != null) {
      _listTransformer.addAll(data);
    } else {
      _listTransformer = <TransformerList>[];
    }

    notifyListeners();
  }

  removeLisTransformer(int index) {
    _listTransformer.removeAt(index);
    notifyListeners();
  }

  bool _isTransformer = false;
  bool get isTransformer => _isTransformer;
  void setIsTransformer(bool isTransformer) {
    _isTransformer = isTransformer;
    notifyListeners();
  }

  //------------------------------------------------------------------------------
  void clearAll() {
    _hoaList.clear();
    _listTransformer.clear();
    _hoaSelected = AllHoaTypeModel();
    _poleClassSelected = AllPoleClassModel();
    _poleHeightSelected = AllPoleHeightModel();
    _poleSpeciesSelected = AllPoleSpeciesModel();
    _poleConditionSelected = AllPoleConditionModel();
    notifyListeners();
  }

  //------------------------------------------------------------------------------

  List<JobNumberAttachModel>? _jobNumberAttachModel = <JobNumberAttachModel>[];
  List<JobNumberAttachModel>? get jobNumberAttachModel => _jobNumberAttachModel;
  void setJobNumberAttachModel(List<JobNumberAttachModel> jobNumberAttachModel) {
    _jobNumberAttachModel = jobNumberAttachModel;
    notifyListeners();
  }

  void getJobNumberAttachModel(String? layerId, bool isConnected) async {
    if (isConnected) {
      try {
        var response = await apiProvider.getJobNumberAttach(layerId);
        if (response.statusCode == 200) {
          _jobNumberAttachModel = JobNumberAttachModel.fromJsonList(response.data);
        }
      } catch (e) {
        print("JOB NUMBER ATTACH " + e.toString());
      }
    }
  }

  //------------------------------------------------------------------------------

  List<AllFieldingTypeModel>? _allFieldingType;
  List<AllFieldingTypeModel>? get allFieldingType => _allFieldingType;
  void setAllFieldingType(List<AllFieldingTypeModel> allFieldingType) {
    _allFieldingType = allFieldingType;
  }

  AllFieldingTypeModel? _fieldingTypeSelected;
  AllFieldingTypeModel? get fieldingTypeSelected => _fieldingTypeSelected;
  void setFieldingTypeSelected(String? value) {
    _fieldingTypeSelected = _allFieldingType!.firstWhere((element) => element.text == value);
    notifyListeners();
  }

  void setFieldingTypeAssign(int? value) {
    if (value != null) {
      _allFieldingType!.forEach((element) {
        if (element.id == value) {
          _fieldingTypeSelected = element;
        }
      });
    } else {
      _fieldingTypeSelected = AllFieldingTypeModel();
    }

    notifyListeners();
  }

  void getFieldingType(bool isConnected) async {
    final dataBox = await _hiveService.openAndGetDataFromHiveBox(getHiveFieldingType, listFieldingType);
    if (isConnected) {
      try {
        var response = await apiProvider.getFieldingType();
        if (response.statusCode == 200) {
          _allFieldingType = AllFieldingTypeModel.fromJsonList(response.data);
          _hiveService.deleteDataFromBox(getHiveFieldingType, listFieldingType);
          _hiveService.saveDataToBox(getHiveFieldingType, listFieldingType, json.encode(_allFieldingType));
          _allFieldingType!.insertAll(0, [AllFieldingTypeModel(id: 3, text: "Fielding Type")]);

          setFieldingTypeAssign(3);
        }
      } catch (e) {
        print("Fielding Type " + e.toString());
      }
    } else if (dataBox != null) {
      _allFieldingType = AllFieldingTypeModel.fromJsonList(json.decode(dataBox));
      _allFieldingType!.insertAll(0, [AllFieldingTypeModel(id: 3, text: "Fielding Type")]);
      setFieldingTypeAssign(3);
    }
  }

  //------------------------------------------------------------------------------

  int? _layerStatus = 1;
  int get layerStatus => _layerStatus!;
  void setLayerStatus(int layerStatus) {
    _layerStatus = layerStatus;
    notifyListeners();
  }

  //------------------------------------------------------------------------------
  //Return value UNK || controller.text
  String valueTextContent(String title, TextEditingController controller, {bool? isUnk, bool? isEst}) {
    var value;
    if (title.toLowerCase().contains("pole length")) {
      if (isUnk!) {
        value = (controller.text == "-" || controller.text.isEmpty) ? "UNK" : "${controller.text} ft, UNK";
      } else if (isEst!) {
        value = (controller.text == "-" || controller.text.isEmpty) ? "EST" : "${controller.text} ft, EST";
      } else {
        value = (controller.text.isEmpty)
            ? "-"
            : (controller.text == "-")
                ? controller.text
                : "${controller.text} ft";
      }
    } else if (title.toLowerCase().contains("ground line")) {
      if (isUnk!) {
        value = (controller.text == "-" || controller.text.isEmpty) ? "UNK" : "${controller.text} inch, UNK";
      } else if (isEst!) {
        value = (controller.text == "-" || controller.text.isEmpty) ? "EST" : "${controller.text} inch, EST";
      } else {
        value = (controller.text.isEmpty)
            ? "-"
            : (controller.text == "-")
                ? controller.text
                : "${controller.text} inch";
      }
    } else if (isUnk!) {
      value = (controller.text == "-" || controller.text.isEmpty) ? "UNK" : "${controller.text}, UNK";
    } else if (isEst!) {
      value = (controller.text == "-" || controller.text.isEmpty) ? "EST" : "${controller.text}, EST";
    } else {
      value = (controller.text.isEmpty) ? "-" : controller.text;
    }
    return value;
  }

  //------------------------------------------------------------------------------
  //return false if checkbox true, return true if controller "-" || controller empty
  bool validateWithCheckbox(bool? isCheckbox, TextEditingController controller) {
    if (isCheckbox == null) {
      return true;
    } else if (isCheckbox) {
      return false;
    } else if (controller.text == "-" || controller.text.isEmpty)
      return true;
    else
      return false;
  }

  //return false if checkbox true, return true if controller "-" || controller empty
  bool validate(TextEditingController controller, String title) {
    if (controller.text == "-" || controller.text.isEmpty)
      return true;
    else
      return false;
  }

  bool isPoleSequenceAlready(String value) {
    if (value == polesByLayerSelected.poleSequence) {
      return false;
    } else {
      for (var poles in _allPolesByLayer!) {
        if (poles.poleSequence == value) {
          Fluttertoast.showToast(msg: "Pole sequence number already existed", toastLength: Toast.LENGTH_LONG);
          return true;
        }
      }
      return false;
    }
  }
}
