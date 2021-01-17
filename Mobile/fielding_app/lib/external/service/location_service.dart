import 'dart:async';

import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  StreamController<LocationData> _locationStreamController =
      StreamController<LocationData>();
  Stream<LocationData> get locationStream => _locationStreamController.stream;
  bool _isDispose = false;

  LocationService() {
    location.requestPermission().then((value) {
      if (value == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          if (!_isDispose) {
            if (locationData != null) {
              _locationStreamController.add(locationData);
            }
          }
        });
      }
    });
  }

  Future<LocationData> getCurrentLocation() async {
    LocationData locationData = await location.getLocation();
    return locationData;
  }

  void dispose() {
    _isDispose = true;
    _locationStreamController.close();
  }
}