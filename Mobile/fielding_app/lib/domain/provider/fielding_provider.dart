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
      } else {
      }
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
}

