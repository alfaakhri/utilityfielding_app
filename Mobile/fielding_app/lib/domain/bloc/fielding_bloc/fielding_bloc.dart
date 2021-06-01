import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/data/models/current_address.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/constants.dart';
import 'package:fielding_app/presentation/ui/login_page.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

part 'fielding_event.dart';
part 'fielding_state.dart';

class FieldingBloc extends Bloc<FieldingEvent, FieldingState> {
  FieldingBloc() : super(FieldingInitial());
  ApiProvider _apiProvider = ApiProvider();

  List<AllProjectsModel>? _allProjects;
  List<AllProjectsModel>? get allProjects => _allProjects;

  List<AllPolesByLayerModel>? _allPolesByLayer;
  List<AllPolesByLayerModel>? get allPolesByLayer => _allPolesByLayer;

  AllPolesByLayerModel _responsePolePicture = AllPolesByLayerModel();
  AllPolesByLayerModel get responsePolePicture => _responsePolePicture;

  PoleByIdModel _poleByIdModel = PoleByIdModel();
  PoleByIdModel get poleByIdModel => _poleByIdModel;

  CurrentAddress _currentAddress = CurrentAddress();
  CurrentAddress get currentAddress => _currentAddress;

  @override
  Stream<FieldingState> mapEventToState(
    FieldingEvent event,
  ) async* {
    if (event is GetAllProjects) {
      yield GetAllProjectsLoading();
      try {
        var response = await _apiProvider.getAllProject((event.token));
        if (response!.statusCode == 200) {
          _allProjects = AllProjectsModel.fromJsonList(response.data);

          if (_allProjects!.length == 0) {
            yield GetAllProjectsEmpty();
          } else {
            yield GetAllProjectsSuccess(_allProjects);
          }
        } else if (response.data['Message'] == Constants.messageTokenExpired) {
          Get.offAll(LoginPage());
        } else
          yield GetAllProjectsFailed(response.data['Message']);
      } catch (e) {
        yield GetAllProjectsFailed(e.toString());
      }
    } else if (event is GetAllPolesByID) {
      yield GetAllPolesByIdLoading();
      try {
        var response = await (_apiProvider.getAllPolesByLayerID(
            event.token, event.layerId));
        if (response!.statusCode == 200) {
          _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
          yield GetAllPolesByIdSuccess(_allPolesByLayer);
        } else if (response.data['Message'] == Constants.messageTokenExpired) {
          Get.offAll(LoginPage());
        } else {
          yield GetAllPolesByIdFailed(response.data['Message']);
        }
      } catch (e) {
        yield GetAllPolesByIdFailed(e.toString());
      }
    } else if (event is StartPolePicture) {
      yield StartPolePictureLoading();
      try {
        var responseFirst = await (_apiProvider.startPolePicture(
            event.token, event.poleId, event.layerId));
        if (responseFirst!.statusCode == 200) {
          _responsePolePicture =
              AllPolesByLayerModel.fromJson(responseFirst.data);
          var response = await (_apiProvider.getAllPolesByLayerID(
              event.token, event.layerId));

          if (response!.statusCode == 200) {
            _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
            yield StartPolePictureSuccess(_allPolesByLayer);
          } else if (response.data['Message'] ==
              Constants.messageTokenExpired) {
            Get.offAll(LoginPage());
          } else {
            yield StartPolePictureFailed(response.data['Message']);
          }
        } else {
          yield StartPolePictureFailed(responseFirst.data['Message']);
        }
      } catch (e) {
        yield StartPolePictureFailed(e.toString());
      }
    } else if (event is CompletePolePicture) {
      yield CompletePolePictureLoading();
      try {
        var responseFirst =
            await (_apiProvider.completePolePicture(event.token, event.poleId));

        if (responseFirst!.statusCode == 200) {
          _responsePolePicture =
              AllPolesByLayerModel.fromJson(responseFirst.data);
          var response = await (_apiProvider.getAllPolesByLayerID(
              event.token, event.layerId));

          if (response!.statusCode == 200) {
            _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
            yield CompletePolePictureSuccess(_allPolesByLayer);
          } else if (response.data['Message'] ==
              Constants.messageTokenExpired) {
            Get.offAll(LoginPage());
          } else {
            yield CompletePolePictureFailed(response.data['Message']);
          }
        } else if (responseFirst.data['Message'] ==
            Constants.messageTokenExpired) {
          Get.offAll(LoginPage());
        } else {
          yield CompletePolePictureFailed(responseFirst.data['Message']);
        }
      } catch (e) {
        yield CompletePolePictureFailed(e.toString());
      }
    } else if (event is UpdateLocation) {
      yield UpdateLocationLoading();
      try {
        var response = await (_apiProvider.updateLocation(
            event.token, event.poleId, event.latitude, event.longitude));

        if (response!.statusCode == 200) {
          _responsePolePicture = AllPolesByLayerModel.fromJson(response.data);
          yield UpdateLocationSuccess(_responsePolePicture);
        } else if (response.data['Message'] == Constants.messageTokenExpired) {
          Get.offAll(LoginPage());
        } else {
          yield UpdateLocationFailed(response.data['Message']);
        }
      } catch (e) {
        yield UpdateLocationFailed(e.toString());
      }
    } else if (event is AddPole) {
      yield AddPoleLoading();
      try {
        print(json.encode(event.addPoleModel.toJson()));
        print(json.encode(event.addPoleModel.spanDirectionList!
            .map((e) => e.toJson())
            .toList()));
        print(json.encode(
            event.addPoleModel.anchorList!.map((e) => e.toJson()).toList()));
        print(json.encode(event.addPoleModel.riserAndVGRList!
            .map((e) => e.toJson())
            .toList()));
        // yield AddPoleFailed("Test");
        var response =
            await (_apiProvider.addPole(event.addPoleModel.toJson()));
        if (response!.statusCode == 200) {
          yield AddPoleSuccess();
        } else if (response.data['Message'] == Constants.messageTokenExpired) {
          Get.offAll(LoginPage());
        } else {
          yield AddPoleFailed(response.data['Message']);
        }
      } catch (e) {
        yield AddPoleFailed(e.toString());
      }
    } else if (event is GetPoleById) {
      yield GetPoleByIdLoading();
      try {
        var response = await (_apiProvider.getPoleById(event.id, event.token));
        if (response!.statusCode == 200) {
          if (response.data != null) {
            _poleByIdModel = PoleByIdModel.fromJson(response.data);
            yield GetPoleByIdSuccess(_poleByIdModel);
          } else if (response.data['Message'] ==
              Constants.messageTokenExpired) {
            Get.offAll(LoginPage());
          } else {
            yield GetPoleByIdFailed("Failed load data pole");
          }
        } else {
          yield GetPoleByIdFailed("Failed load data pole");
        }
      } catch (e) {
        yield GetPoleByIdFailed(e.toString());
      }
    } else if (event is GetCurrentAddress) {
      yield GetCurrentAddressLoading();
      try {
        var response = await _apiProvider.getLocationByLatLng(
            event.latitude, event.longitude);
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
    } else if (event is StartFielding) {
      yield StartFieldingLoading();
      try {
        var response = await (_apiProvider.startFielding(
            event.token, event.poleId, event.isStartAdditional, event.layerId));
        if (response!.statusCode == 200) {
          yield StartFieldingSuccess();
        } else if (response.data['Message'] == Constants.messageTokenExpired) {
          Get.offAll(LoginPage());
        } else {
          yield StartFieldingFailed(response.data['Message']);
        }
      } catch (e) {
        yield StartFieldingFailed(e.toString());
      }
    }
  }
}
