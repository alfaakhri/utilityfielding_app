import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/ui.exports.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial());
  ApiProvider _apiProvider = ApiProvider();

  CurrentAddress _currentAddress = CurrentAddress();
  CurrentAddress get currentAddress => _currentAddress;

  AllPolesByLayerModel _responsePolePicture = AllPolesByLayerModel();
  AllPolesByLayerModel get responsePolePicture => _responsePolePicture;

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is GetCurrentAddress) {
      yield GetCurrentAddressLoading();
      try {
        var response = await _apiProvider.getLocationByLatLng(
            event.latitude!, event.longitude!);
        if (response.statusCode == 200) {
          _currentAddress = CurrentAddress.fromJson(response.data);
          print("status geocode: ${_currentAddress.status.toString()}");
          yield GetCurrentAddressSuccess(_currentAddress);
        } else {
          yield GetCurrentAddressFailed("Failed get street location");
        }
      } catch (e) {
        yield GetCurrentAddressFailed(e.toString());
      }
    } else if (event is UpdateLocation) {
      yield UpdateLocationLoading();
      try {
        var response = await (_apiProvider.updateLocation(
            event.token, event.poleId, event.latitude, event.longitude));

        if (response!.statusCode == 200) {
          _responsePolePicture = AllPolesByLayerModel.fromJson(response.data);
          yield UpdateLocationSuccess(_responsePolePicture);
        
        } else if (response.data['Message'] == messageTokenExpired) {
          Get.offAll(LoginPage());
        } else {
          yield UpdateLocationFailed(response.data['Message']);
        }
      } catch (e) {
        yield UpdateLocationFailed(e.toString());
      }
    }
  }
}
