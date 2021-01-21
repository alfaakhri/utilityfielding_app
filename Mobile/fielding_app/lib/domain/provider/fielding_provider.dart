import 'package:fielding_app/data/models/all_pole_class_model.dart';
import 'package:fielding_app/data/models/all_pole_condition_model.dart';
import 'package:fielding_app/data/models/all_pole_height_model.dart';
import 'package:fielding_app/data/models/all_pole_species_model.dart';
import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/data/models/current_address.dart';
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
    _poleSpeciesSelected = _listAllPoleSpecies
        .firstWhere((element) => element.id == value);
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
    _poleClassSelected = _listAllPoleClass
        .firstWhere((element) => element.id == value);
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

  List<AllPoleHeightModel> _listAllPoleHeight = List<AllPoleHeightModel>();
  List<AllPoleHeightModel> get listAllPoleHeight => _listAllPoleHeight;
  void setListAllPoleHeight(List<AllPoleHeightModel> listAllPoleHeight) {
    _listAllPoleHeight = listAllPoleHeight;
    notifyListeners();
  }

  AllPoleHeightModel _poleHeightSelected = AllPoleHeightModel();
  AllPoleHeightModel get poleHeightSelected => _poleHeightSelected;
  void setPoleHeightSelected(String value) {
    _poleHeightSelected =
        _listAllPoleHeight.firstWhere((element) => element.text == int.parse(value));
    notifyListeners();
  }

  void setPoleHeightAssign(int value) {
    _poleHeightSelected = _listAllPoleHeight
        .firstWhere((element) => element.id == value);
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

  List<AllPoleConditionModel> _listAllPoleCondition = List<AllPoleConditionModel>();
  List<AllPoleConditionModel> get listAllPoleCondition => _listAllPoleCondition;
  void setListAllPoleCondition(List<AllPoleConditionModel> listAllPoleCondition) {
    _listAllPoleCondition = listAllPoleCondition;
    notifyListeners();
  }

  AllPoleConditionModel _poleConditionSelected = AllPoleConditionModel();
  AllPoleConditionModel get poleConditionSelected => _poleConditionSelected;
  void setPoleConditionSelected(String value) {
    _poleConditionSelected =
        _listAllPoleCondition.firstWhere((element) => element.id.toString().contains(value));
    notifyListeners();
  }

  void setPoleConditionAssign(int value) {
    _poleConditionSelected = _listAllPoleCondition
        .firstWhere((element) => element.id == value);
    notifyListeners();
  }

  void getListAllPoleCondition() async {
    ApiProvider _repository = ApiProvider();
    try {
      var response = await _repository.getAllPoleCondition();
      if (response.statusCode == 200) {
        setListAllPoleCondition(AllPoleConditionModel.fromJsonList(response.data));
        print("all pole condition: ${response.data}");
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }
}
