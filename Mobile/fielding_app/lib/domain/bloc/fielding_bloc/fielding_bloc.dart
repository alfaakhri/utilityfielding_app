import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/edit_pole/add_pole_model.dart';
import 'package:fielding_app/data/models/detail_fielding/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/list_fielding/all_projects_model.dart';
import 'package:fielding_app/data/models/edit_pole/current_address.dart';
import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/hive_service.dart';
import 'package:fielding_app/presentation/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'fielding_event.dart';
part 'fielding_state.dart';

class FieldingBloc extends Bloc<FieldingEvent, FieldingState> {
  FieldingBloc() : super(FieldingInitial());
  ApiProvider _apiProvider = ApiProvider();
  HiveService _hiveService = HiveService();

  List<FieldingRequestByJobModel>? _fieldingRequestByJob;
  List<FieldingRequestByJobModel>? get fieldingRequestByJob =>
      _fieldingRequestByJob;

  List<AllProjectsModel>? _allProjects;
  List<AllProjectsModel>? get allProjects => _allProjects;

  List<AllPolesByLayerModel>? _allPolesByLayer;
  List<AllPolesByLayerModel>? get allPolesByLayer => _allPolesByLayer;

  AllPolesByLayerModel _responsePolePicture = AllPolesByLayerModel();
  AllPolesByLayerModel get responsePolePicture => _responsePolePicture;

  PoleByIdModel _poleByIdModel = PoleByIdModel();
  PoleByIdModel get poleByIdModel => _poleByIdModel;
  void setPoleByIdModel(PoleByIdModel data) {
    _poleByIdModel = data;
  }

  CurrentAddress _currentAddress = CurrentAddress();
  CurrentAddress get currentAddress => _currentAddress;

  @override
  Stream<FieldingState> mapEventToState(
    FieldingEvent event,
  ) async* {
    if (event is GetFieldingRequest) {
      yield GetFieldingRequestLoading();
      if (event.isConnected!) {
        try {
          var response = await _apiProvider.getFieldingRequest(event.token);
          if (response!.statusCode == 200) {
            _fieldingRequestByJob =
                FieldingRequestByJobModel.fromJsonList(response.data);

            if (_fieldingRequestByJob!.length == 0) {
              yield GetFieldingRequestEmpty();
            } else {
              _hiveService.deleteDataFromBox(
                  getHiveFieldingRequest, listFieldingRequest);
              _hiveService.saveDataToBox(getHiveFieldingRequest,
                  listFieldingRequest, json.encode(_fieldingRequestByJob));
              yield GetFieldingRequestSuccess(_fieldingRequestByJob!);
            }
          } else if (response.data['Message'] == messageTokenExpired) {
            Get.offAll(LoginPage());
          } else
            yield GetFieldingRequestFailed(response.data['Message']);
        } catch (e) {
          yield GetFieldingRequestFailed(e.toString());
        }
      } else {
        try {
          var dataBox = await _hiveService.openAndGetDataFromHiveBox(
              getHiveFieldingRequest, listFieldingRequest);
          if (dataBox != null) {
            _fieldingRequestByJob = FieldingRequestByJobModel.fromJsonList(json.decode(dataBox));
            yield GetFieldingRequestSuccess(_fieldingRequestByJob!);
          } else {
            yield GetFieldingRequestEmpty();
          }
        } catch (e) {
          yield GetFieldingRequestFailed(e.toString());
        }
      }
    } else if (event is GetAllProjects) {
      yield GetAllProjectsLoading();
      if (event.isConnected!) {
        try {
          var response = await _apiProvider.getAllProject((event.token));
          if (response!.statusCode == 200) {
            _allProjects = AllProjectsModel.fromJsonList(response.data);

            if (_allProjects!.length == 0) {
              yield GetAllProjectsEmpty();
            } else {
              _hiveService.deleteDataFromBox(getHiveAllProject, listAllProject);
              _hiveService.saveDataToBox(
                  getHiveAllProject, listAllProject, json.encode(_allProjects));
              yield GetAllProjectsSuccess(_allProjects);
            }
          } else if (response.data['Message'] == messageTokenExpired) {
            Get.offAll(LoginPage());
          } else
            yield GetAllProjectsFailed(response.data['Message']);
        } catch (e) {
          yield GetAllProjectsFailed(e.toString());
        }
      } else {
        try {
          var dataBox = await _hiveService.openAndGetDataFromHiveBox(
              getHiveAllProject, listAllProject);
          if (dataBox != null) {
            _allProjects = AllProjectsModel.fromJsonList(json.decode(dataBox));
            yield GetAllProjectsSuccess(_allProjects);
          } else {
            yield GetAllProjectsEmpty();
          }
        } catch (e) {
          yield GetAllProjectsFailed(e.toString());
        }
      }
    } else if (event is GetAllPolesByID) {
      yield GetAllPolesByIdLoading();
      if (event.isConnected!) {
        try {
          var response = await (_apiProvider.getAllPolesByLayerID(
              event.token, event.layerId));
          if (response!.statusCode == 200) {
            _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
            _hiveService.deleteDataFromBox(getHiveAllPoles, listAllPoles);
            _hiveService.saveDataToBox(
                getHiveAllPoles, listAllPoles, json.encode(_allPolesByLayer));
            yield GetAllPolesByIdSuccess(_allPolesByLayer);
          } else if (response.data['Message'] == messageTokenExpired) {
            Get.offAll(LoginPage());
          } else {
            yield GetAllPolesByIdFailed(response.data['Message']);
          }
        } catch (e) {
          yield GetAllPolesByIdFailed(e.toString());
        }
      } else {
        try {
          var dataBox = await _hiveService.openAndGetDataFromHiveBox(
              getHiveAllPoles, listAllPoles);
          if (dataBox != null) {
            _allPolesByLayer =
                AllPolesByLayerModel.fromJsonList(json.decode(dataBox));
            yield GetAllPolesByIdSuccess(_allPolesByLayer);
          } else {
            yield GetAllPolesByIdFailed("Failed load data poles");
          }
        } catch (e) {
          yield GetAllPolesByIdFailed(e.toString());
        }
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
          } else if (response.data['Message'] == messageTokenExpired) {
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
          } else if (response.data['Message'] == messageTokenExpired) {
            Get.offAll(LoginPage());
          } else {
            yield CompletePolePictureFailed(response.data['Message']);
          }
        } else if (responseFirst.data['Message'] == messageTokenExpired) {
          Get.offAll(LoginPage());
        } else {
          yield CompletePolePictureFailed(responseFirst.data['Message']);
        }
      } catch (e) {
        yield CompletePolePictureFailed(e.toString());
      }
    } else if (event is AddPole) {
      try {
        if (event.isConnected!) {
          yield AddPoleLoading();

          JsonEncoder encoder = new JsonEncoder.withIndent('  ');
          String prettyprint = encoder.convert(event.addPoleModel.toJson());
          debugPrint(prettyprint);
          // yield AddPoleFailed("Test");
          var response =
              await (_apiProvider.addPole(event.addPoleModel.toJson()));
          if (response!.statusCode == 200) {
            yield AddPoleSuccess();
          } else if (response.data['Message'] == messageTokenExpired) {
            Get.offAll(LoginPage());
          } else {
            yield AddPoleFailed(response.data['Message']);
          }
        } else {
          yield AddPoleLoading();

          //Save to local
          List<AddPoleLocal>? addPoleLocal = <AddPoleLocal>[];
          AddPoleLocal tempAddPole = AddPoleLocal(
              id: Uuid().v1(),
              allProjectsModel: event.allProjectsModel,
              allPolesByLayerModel: event.allPolesByLayerModel,
              addPoleModel: event.addPoleModel);
          final dataBox = await _hiveService.openAndGetDataFromHiveBox(
              getHiveEditPole, listEditPole);
          if (dataBox != null) {
            addPoleLocal = AddPoleLocal.fromJsonList(jsonDecode(dataBox));
            //Check if data is added and doing removal
            addPoleLocal!.removeWhere(
                (element) => element.addPoleModel!.id == event.addPoleModel.id);
            addPoleLocal.add(tempAddPole);
            //Saving to local
            _hiveService.saveDataToBox(
                getHiveEditPole, listEditPole, json.encode(addPoleLocal));
            yield AddPoleSuccess();
          } else {
            addPoleLocal.add(tempAddPole);

            _hiveService.saveDataToBox(
                getHiveEditPole, listEditPole, json.encode(addPoleLocal));
            yield AddPoleSuccess();
          }
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
          } else if (response.data['Message'] == messageTokenExpired) {
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
    } else if (event is StartFielding) {
      yield StartFieldingLoading();
      try {
        var response = await (_apiProvider.startFielding(event.token,
            event.poleId, event.isStartAdditional!, event.layerId));
        if (response!.statusCode == 200) {
          yield StartFieldingSuccess();
        } else if (response.data['Message'] == messageTokenExpired) {
          Get.offAll(LoginPage());
        } else {
          yield StartFieldingFailed(response.data['Message']);
        }
      } catch (e) {
        yield StartFieldingFailed(e.toString());
      }
    } else if (event is CompleteMultiPole) {
      yield CompleteMultiPoleLoading();
      try {
        List<PoleData> list = <PoleData>[];
        List<AllPolesByLayerModel> poles = event.allPolesByLayerModel!;
        poles.map((e) => list.add(PoleData()));
        poles.forEach((v) {
          if (v.fieldingStatus == 2) {
            list.add(PoleData(id: v.id, layerId: event.layerId));
          }
        });
        CompleteMultiPoleFielding data = CompleteMultiPoleFielding(
          token: event.token,
          poleData: list,
        );
        var response = await _apiProvider.completeMultiPole(data);
        if (response.statusCode == 200) {
          yield CompleteMultiPoleSuccess();
        } else {
          yield CompleteMultiPoleFailed(response.data['Message']);
        }
      } catch (e) {
        yield CompleteMultiPoleFailed(e.toString());
      }
    }
  }
}
