import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/add_transformer_model.dart';
import 'package:fielding_app/data/models/all_hoa_type_model.dart';
import 'package:fielding_app/data/models/all_pole_class_model.dart';
import 'package:fielding_app/data/models/all_pole_condition_model.dart';
import 'package:fielding_app/data/models/all_pole_height_model.dart';
import 'package:fielding_app/data/models/all_pole_species_model.dart';
import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/data/models/current_address.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FieldingProvider extends ChangeNotifier {
  AllProjectsModel _allProjectsSelected = AllProjectsModel();
  AllProjectsModel get allProjectsSelected => _allProjectsSelected;
  void setAllProjectsSelected(AllProjectsModel allProjectsSelected) {
    _allProjectsSelected = allProjectsSelected;
    notifyListeners();
  }

  LocationData _currentLocationData;
  LocationData get currentLocationData => _currentLocationData;
  void setCurrentLocationData(LocationData currentLocationData) {
    _currentLocationData = currentLocationData;
    notifyListeners();
  }

  LatLng _currentPosition;
  LatLng get currentPosition => _currentPosition;
  void setCurrentPosition(LatLng currentPosition) {
    _currentPosition = currentPosition;
    notifyListeners();
  }

  CurrentAddress _currentAddress = CurrentAddress();
  CurrentAddress get currentAddress => _currentAddress;
  void setCurrentAddress(CurrentAddress currentAddress) {
    _currentAddress = currentAddress;
    _streetName = _currentAddress.results.first.formattedAddress;
    notifyListeners();
  }

  String _streetName;
  String get streetName => _streetName;
  void setStreetName(String streetName) {
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

  double _latitude;
  double get latitude => _latitude;
  void setLatitude(double latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  double _longitude;
  double get longitude => _longitude;
  void setLongitude(double longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  //--------------------------------------------------------------------------------------------
  List<AllPoleSpeciesModel> _listAllPoleSpecies = List<AllPoleSpeciesModel>();
  List<AllPoleSpeciesModel> get listAllPoleSpecies => _listAllPoleSpecies;
  void setListAllPoleSpecies(List<AllPoleSpeciesModel> listAllPoleSpecies) {
    _listAllPoleSpecies = listAllPoleSpecies;
    notifyListeners();
  }

  AllPoleSpeciesModel _poleSpeciesSelected = AllPoleSpeciesModel();
  AllPoleSpeciesModel get poleSpeciesSelected => _poleSpeciesSelected;
  void setPoleSpeciesSelected(String value) {
    _poleSpeciesSelected = _listAllPoleSpecies
        .firstWhere((element) => element.text.contains(value));
    notifyListeners();
  }

  void setPoleSpeciesAssign(int value) {
    if (value != null) {
      _listAllPoleSpecies.forEach((element) {
        if (element.id == value) {
          _poleSpeciesSelected = element;
        }
      });
    } else {
      _poleSpeciesSelected = AllPoleSpeciesModel();
    }

    notifyListeners();
  }

  void getListAllPoleSpecies() async {
    ApiProvider _repository = ApiProvider();
    try {
      var response = await _repository.getAllPoleSpecies();
      if (response.statusCode == 200) {
        setListAllPoleSpecies(AllPoleSpeciesModel.fromJsonList(response.data));
        print("all pole species: ${response.data}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  //--------------------------------------------------------------------------------------------
  List<AllPoleClassModel> _listAllPoleClass = List<AllPoleClassModel>();
  List<AllPoleClassModel> get listAllPoleClass => _listAllPoleClass;
  void setListAllPoleClass(List<AllPoleClassModel> listAllPoleClass) {
    _listAllPoleClass = listAllPoleClass;
    notifyListeners();
  }

  AllPoleClassModel _poleClassSelected = AllPoleClassModel();
  AllPoleClassModel get poleClassSelected => _poleClassSelected;
  void setPoleClassSelected(String value) {
    _poleClassSelected =
        _listAllPoleClass.firstWhere((element) => element.text.contains(value));
    notifyListeners();
  }

  void setPoleClassAssign(int value) {
    if (value != null) {
      _listAllPoleClass.forEach((element) {
        if (element.id == value) {
          _poleClassSelected = element;
        }
      });
    } else {
      _poleClassSelected = AllPoleClassModel();
    }

    notifyListeners();
  }

  void getListAllPoleClass() async {
    ApiProvider _repository = ApiProvider();
    try {
      var response = await _repository.getAllPoleClass();
      if (response.statusCode == 200) {
        setListAllPoleClass(AllPoleClassModel.fromJsonList(response.data));
        print("all pole class: ${response.data}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

//--------------------------------------------------------------------------------------------
  List<AllPoleHeightModel> _listAllPoleHeight = List<AllPoleHeightModel>();
  List<AllPoleHeightModel> get listAllPoleHeight => _listAllPoleHeight;
  void setListAllPoleHeight(List<AllPoleHeightModel> listAllPoleHeight) {
    _listAllPoleHeight = listAllPoleHeight;
    notifyListeners();
  }

  AllPoleHeightModel _poleHeightSelected = AllPoleHeightModel();
  AllPoleHeightModel get poleHeightSelected => _poleHeightSelected;
  void setPoleHeightSelected(String value) {
    _poleHeightSelected = _listAllPoleHeight
        .firstWhere((element) => element.text == int.parse(value));
    notifyListeners();
  }

  void setPoleHeightAssign(int value) {
    if (value != null) {
      _listAllPoleHeight.forEach((element) {
        if (element.id == value) {
          _poleHeightSelected = element;
        }
      });
    } else {
      _poleHeightSelected = AllPoleHeightModel();
    }

    notifyListeners();
  }

  void getListAllPoleHeight() async {
    ApiProvider _repository = ApiProvider();
    try {
      var response = await _repository.getAllPoleHeight();
      if (response.statusCode == 200) {
        setListAllPoleHeight(AllPoleHeightModel.fromJsonList(response.data));
        print("all pole height: ${response.data}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

//--------------------------------------------------------------------------------------------
  List<AllPoleConditionModel> _listAllPoleCondition =
      List<AllPoleConditionModel>();
  List<AllPoleConditionModel> get listAllPoleCondition => _listAllPoleCondition;
  void setListAllPoleCondition(
      List<AllPoleConditionModel> listAllPoleCondition) {
    _listAllPoleCondition = listAllPoleCondition;
    notifyListeners();
  }

  AllPoleConditionModel _poleConditionSelected = AllPoleConditionModel();
  AllPoleConditionModel get poleConditionSelected => _poleConditionSelected;
  void setPoleConditionSelected(String value) {
    _poleConditionSelected = _listAllPoleCondition
        .firstWhere((element) => element.text.contains(value));
    notifyListeners();
  }

  void setPoleConditionAssign(int value) {
    if (value != null) {
      _listAllPoleCondition.forEach((element) {
        if (element.id == value) {
          _poleConditionSelected = element;
        }
      });
    } else {
      _poleConditionSelected = AllPoleConditionModel();
    }
    notifyListeners();
  }

  void getListAllPoleCondition() async {
    ApiProvider _repository = ApiProvider();
    try {
      var response = await _repository.getAllPoleCondition();
      if (response.statusCode == 200) {
        setListAllPoleCondition(
            AllPoleConditionModel.fromJsonList(response.data));
        print("all pole condition: ${response.data}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

//--------------------------------------------------------------------------------------------
  List<AllHoaTypeModel> _listAllHoaType = List<AllHoaTypeModel>();
  List<AllHoaTypeModel> get listAllHoaType => _listAllHoaType;
  void setListAllHoaType(List<AllHoaTypeModel> listAllHoaType) {
    _listAllHoaType = listAllHoaType;
    notifyListeners();
  }

  void getListAllHoaType() async {
    ApiProvider _repository = ApiProvider();
    try {
      var response = await _repository.getAllHoaType();
      if (response.statusCode == 200) {
        setListAllHoaType(AllHoaTypeModel.fromJsonList(response.data));
        print("all hoa type: ${response.data}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  AllHoaTypeModel _hoaSelected = AllHoaTypeModel();
  AllHoaTypeModel get hoaSelected => _hoaSelected;
  void setHoaSelected(String value) {
    _hoaSelected =
        listAllHoaType.firstWhere((element) => element.text == value);
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

  List<HOAList> _hoaList = List<HOAList>();
  List<HOAList> get hoaList => _hoaList;
  addHoaList(HOAList hoaList) {
    _hoaList.add(hoaList);
    notifyListeners();
  }

  addAllHoaList(List<HOAList> data) {
    _hoaList.clear();
    if (data != null) {
      _hoaList.addAll(data);
    } else {
      _hoaList = List<HOAList>();
    }

    notifyListeners();
  }

  removeHoaList(int index) {
    _hoaList.removeAt(index);
    notifyListeners();
  }

//--------------------------------------------------------------------------------------------
  List<TransformerList> _listTransformer = List<TransformerList>();
  List<TransformerList> get listTransformer => _listTransformer;
  addlistTransformer(TransformerList transformer) {
    _listTransformer.add(transformer);
    notifyListeners();
  }

  addAllListTransformer(List<TransformerList> data) {
    _listTransformer.clear();
    if (data != null) {
      _listTransformer.addAll(data);
    } else {
      _listTransformer = List<TransformerList>();
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
}
