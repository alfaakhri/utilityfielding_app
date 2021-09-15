import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/edit_pole/add_pole_model.dart';
import 'package:fielding_app/data/models/detail_fielding/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/list_fielding/all_projects_model.dart';
import 'package:fielding_app/data/models/edit_pole/current_address.dart';
import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
import 'package:fielding_app/data/models/list_fielding/assigned_job_number_model.dart';
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
  List<FieldingRequestByJobModel>? get fieldingRequestByJob => _fieldingRequestByJob;

  List<AssignedJobNumberModel>? _assignedJobNumberModel;
  List<AssignedJobNumberModel>? get assignedJobNumberModel => _assignedJobNumberModel;

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

  DateTime _startTimer = DateTime.now().toUtc();
  DateTime get startTimer => _startTimer;
  void setStartTimer(DateTime data) {
    _startTimer = data;
  }

  DateTime _endTimer = DateTime.now();
  DateTime get endTimer => _endTimer;
  void setEndTimer(DateTime data) {
    _endTimer = data;
  }

  PoleByIdModel assignCompleteFielding(AddPoleModel addPole, StartCompleteModel startComplete, bool isStartComplete,
      AllPolesByLayerModel polesByLayerModel) {
    polesByLayerModel.detailInformation = PoleByIdModel(
      id: polesByLayerModel.detailInformation!.id,
      layerID: polesByLayerModel.detailInformation!.layerID,
      street: (isStartComplete) ? startComplete.street : addPole.street,
      vAPTerminal: (isStartComplete) ? startComplete.vAPTerminal : addPole.vAPTerminal,
      poleNumber: (isStartComplete) ? startComplete.poleNumber : addPole.poleNumber,
      osmose: (isStartComplete) ? startComplete.osmose : addPole.osmose,
      latitude: (isStartComplete) ? startComplete.latitude : addPole.latitude,
      longitude: (isStartComplete) ? startComplete.longitude : addPole.longitude,
      poleHeight: (isStartComplete) ? startComplete.poleHeight : addPole.poleHeight,
      groundCircumference: (isStartComplete) ? startComplete.groundCircumference : addPole.groundCircumference,
      poleClass: (isStartComplete) ? startComplete.poleClass : addPole.poleClass,
      poleYear: (isStartComplete) ? startComplete.poleYear : addPole.poleYear,
      poleSpecies: (isStartComplete) ? startComplete.poleSpecies : addPole.poleSpecies,
      poleCondition: (isStartComplete) ? startComplete.poleCondition : addPole.poleCondition,
      poleType: (isStartComplete) ? startComplete.poleType : addPole.poleType,
      isRadioAntenna: (isStartComplete) ? startComplete.isRadioAntenna : addPole.isRadioAntenna,
      note: (isStartComplete) ? startComplete.notes : addPole.notes,
      otherNumber: (isStartComplete) ? startComplete.otherNumber : addPole.otherNumber,
      poleStamp: (isStartComplete) ? startComplete.poleStamp : addPole.poleStamp,
      fieldingCompletedDate: polesByLayerModel.detailInformation!.fieldingCompletedDate,
      fieldingById: polesByLayerModel.detailInformation!.fieldingById,
      fieldingBy: polesByLayerModel.detailInformation!.fieldingBy,
      fieldingStatus: polesByLayerModel.detailInformation!.fieldingStatus,
      poleSequence: (isStartComplete) ? startComplete.poleSequence : addPole.poleSequence,
      hOAList: (isStartComplete) ? startComplete.hOAList : addPole.hOAList,
      transformerList: (isStartComplete) ? startComplete.transformerList : addPole.transformerList,
      spanDirectionList: (isStartComplete) ? startComplete.spanDirectionList : addPole.spanDirectionList,
      anchorList: (isStartComplete) ? startComplete.anchorList : addPole.anchorList,
      riserAndVGRList: (isStartComplete) ? startComplete.riserAndVGRList : addPole.riserAndVGRList,
      fieldingType: (isStartComplete) ? startComplete.fieldingType : addPole.fieldingType,
      anchorFences: (isStartComplete) ? startComplete.anchorFences : addPole.anchorFences,
      anchorStreets: (isStartComplete) ? startComplete.anchorStreets : addPole.anchorStreets,
      riserFences: (isStartComplete) ? startComplete.riserFences : addPole.riserFences,
      isFAPUnknown: (isStartComplete) ? startComplete.isFAPUnknown : addPole.isFAPUnknown,
      isOsmoseUnknown: (isStartComplete) ? startComplete.isOsmoseUnknown : addPole.isOsmoseUnknown,
      isOtherNumberUnknown: (isStartComplete) ? startComplete.isOtherNumberUnknown : addPole.isOtherNumberUnknown,
      isPoleLengthUnknown: (isStartComplete) ? startComplete.isPoleLengthUnknown : addPole.isPoleLengthUnknown,
      isPoleLengthEstimated: (isStartComplete) ? startComplete.isPoleLengthEstimated : addPole.isPoleLengthEstimated,
      isPoleClassUnknown: (isStartComplete) ? startComplete.isPoleClassUnknown : addPole.isPoleClassUnknown,
      isPoleClassEstimated: (isStartComplete) ? startComplete.isPoleClassEstimated : addPole.isPoleClassEstimated,
      isGroundLineUnknown: (isStartComplete) ? startComplete.isGroundLineUnknown : addPole.isGroundLineUnknown,
      isGroundLineEstimated: (isStartComplete) ? startComplete.isGroundLineEstimated : addPole.isGroundLineEstimated,
      isYearUnknown: (isStartComplete) ? startComplete.isYearUnknown : addPole.isYearUnknown,
      isYearEstimated: (isStartComplete) ? startComplete.isYearEstimated : addPole.isYearEstimated,
      isSpeciesUnknown: (isStartComplete) ? startComplete.isSpeciesUnknown : addPole.isSpeciesUnknown,
      isSpeciesEstimated: (isStartComplete) ? startComplete.isSpeciesEstimated : addPole.isSpeciesEstimated,
      isPoleNumberUnknown: (isStartComplete) ? startComplete.isPoleNumberUnknown : addPole.isPoleNumberUnknown,
    );

    return polesByLayerModel.detailInformation!;
  }

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
            _fieldingRequestByJob = FieldingRequestByJobModel.fromJsonList(response.data);

            if (_fieldingRequestByJob!.length == 0) {
              yield GetFieldingRequestEmpty();
            } else {
              _hiveService.deleteDataFromBox(getHiveFieldingRequest, listFieldingRequest);
              _hiveService.saveDataToBox(
                  getHiveFieldingRequest, listFieldingRequest, json.encode(_fieldingRequestByJob));
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
        // try {
        // var dataBox = await _hiveService.openAndGetDataFromHiveBox(
        //     getHiveFieldingRequest, listFieldingRequest);
        // if (dataBox != null) {
        //   _fieldingRequestByJob =
        //       FieldingRequestByJobModel.fromJsonList(json.decode(dataBox));
        //   yield GetFieldingRequestSuccess(_fieldingRequestByJob!);
        // } else {
        yield GetFieldingRequestFailed("Internet not available");
        //   }
        // } catch (e) {
        //   yield GetFieldingRequestFailed(e.toString());
        // }
      }
    } else if (event is GetAllPolesByID) {
      yield GetAllPolesByIdLoading();
      if (event.isConnected!) {
        try {
          var response = await (_apiProvider.getAllPolesByLayerID(event.token, event.allProjectsModel!.iD));
          if (response!.statusCode == 200) {
            _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
            _hiveService.deleteDataFromBox(getHiveAllPoles, listAllPoles);
            _hiveService.saveDataToBox(getHiveAllPoles, listAllPoles, json.encode(_allPolesByLayer));
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
          final dataBox = await _hiveService.openAndGetDataFromHiveBox(getHiveFieldingPoles, event.userId);
          if (dataBox != null) {
            var project = AllProjectsModel.fromJsonList(json.decode(dataBox));
            _allPolesByLayer =
                project!.firstWhere((element) => element.iD == event.allProjectsModel!.iD).allPolesByLayer;
            yield GetAllPolesByIdSuccess(_allPolesByLayer);
          }
        } catch (e) {
          yield GetAllPolesByIdFailed(e.toString());
        }
      }
    } else if (event is StartPolePicture) {
      yield StartPolePictureLoading();
      try {
        var responseFirst = await (_apiProvider.startPolePicture(event.token, event.poleId, event.layerId));
        if (responseFirst!.statusCode == 200) {
          _responsePolePicture = AllPolesByLayerModel.fromJson(responseFirst.data);
          var response = await (_apiProvider.getAllPolesByLayerID(event.token, event.layerId));

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
        var responseFirst = await (_apiProvider.completePolePicture(event.token, event.poleId));

        if (responseFirst!.statusCode == 200) {
          _responsePolePicture = AllPolesByLayerModel.fromJson(responseFirst.data);
          var response = await (_apiProvider.getAllPolesByLayerID(event.token, event.layerId));

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
      yield AddPoleLoading();

      try {
        if (event.isConnected!) {
          JsonEncoder encoder = new JsonEncoder.withIndent('  ');
          String prettyprint = encoder.convert(event.addPoleModel.toJson());
          debugPrint(prettyprint);
          // yield AddPoleFailed("Test");
          var response = await (_apiProvider.addPole(event.addPoleModel.toJson()));
          if (response!.statusCode == 200) {
            yield AddPoleSuccess();
          } else if (response.data['Message'] == messageTokenExpired) {
            Get.offAll(LoginPage());
          } else {
            yield AddPoleFailed(response.data['Message']);
          }
        } else {
          //Save to local
          List<AllProjectsModel>? _allProjectModel = <AllProjectsModel>[];
          AllPolesByLayerModel _polesByLayerModel = AllPolesByLayerModel();
          AllProjectsModel currentProjects = AllProjectsModel();
          StartCompleteModel _startCompleteModel = StartCompleteModel();
          final dataBox = await _hiveService.openAndGetDataFromHiveBox(getHiveFieldingPoles, event.userId);

          if (dataBox != null) {
            _allProjectModel = AllProjectsModel.fromJsonList(jsonDecode(dataBox));
            //Search projects by id is same
            currentProjects = _allProjectModel!
                .firstWhere((element) => element.iD == event.allProjectsModel.iD, orElse: () => AllProjectsModel());
            //Check is null
            if (currentProjects.iD != null) {
              //Check isStartComplete
              if (event.isStartComplete) {
                _startCompleteModel =
                    StartCompleteModel.fromJson(json.decode(json.encode(event.addPoleModel.toJson())));
                _startCompleteModel.startTimer = _startTimer.toString();
                _startCompleteModel.endTimer = DateTime.now().toUtc().toString();
                _startCompleteModel.isStartAdditional = true;
                if (currentProjects.startCompleteModel != null) {
                  //Remove and then add addPoleModel
                  currentProjects.startCompleteModel!.removeWhere((element) => element.id == event.addPoleModel.id);
                  currentProjects.startCompleteModel!.add(_startCompleteModel);
                } else {
                  currentProjects.startCompleteModel = [_startCompleteModel];
                }
              } else {
                //Check add pole is null
                if (currentProjects.addPoleModel != null) {
                  //Remove and then add addPoleModel
                  currentProjects.addPoleModel!.removeWhere((element) => element.id == event.addPoleModel.id);
                  currentProjects.addPoleModel!.add(event.addPoleModel);
                } else {
                  currentProjects.addPoleModel = [event.addPoleModel];
                }
              }

              //Search poleByLayer by id is same
              _polesByLayerModel = currentProjects.allPolesByLayer!.firstWhere(
                  (element) => element.id == event.allPolesByLayerModel.id,
                  orElse: () => AllPolesByLayerModel());

              if (_polesByLayerModel.id != null) {
                //Assign addPole to update detailInformation
                _polesByLayerModel.detailInformation = assignCompleteFielding(
                    event.addPoleModel, _startCompleteModel, event.isStartComplete, event.allPolesByLayerModel);
                if (event.isStartComplete) {
                  _polesByLayerModel.fieldingCompletedDate = _startCompleteModel.endTimer;
                  _polesByLayerModel.fieldingStatus = 2;
                  _polesByLayerModel.poleNumber = event.addPoleModel.poleNumber;
                }
              }
              //Remove and then add polesBylayer
              currentProjects.allPolesByLayer!.removeWhere((element) => element.id == event.allPolesByLayerModel.id);
              currentProjects.allPolesByLayer!.add(_polesByLayerModel);
              //Remove and then add project
              _allProjectModel.removeWhere((element) => element.iD == event.allProjectsModel.iD);
              _allProjectModel.add(currentProjects);
              //Saving to local
              await _hiveService.saveDataToBox(getHiveFieldingPoles, event.userId, json.encode(_allProjectModel));

              yield AddPoleSuccess();
            } else {
              yield AddPoleFailed("Projects not found");
            }
          } else {
            yield AddPoleFailed("Projects not found");
          }
        }
      } catch (e) {
        yield AddPoleFailed(e.toString());
      }
    } else if (event is GetPoleById) {
      yield GetPoleByIdLoading();
      try {
        if (event.isConnected) {
          var response = await (_apiProvider.getPoleById(event.allPolesByLayerModel!.id, event.token));
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
        } else {
          _poleByIdModel = event.allPolesByLayerModel!.detailInformation!;
          yield GetPoleByIdSuccess(_poleByIdModel);
        }
      } catch (e) {
        yield GetPoleByIdFailed(e.toString());
      }
    } else if (event is StartFielding) {
      if (event.isConnected) {
        yield StartFieldingLoading();
        try {
          var response =
              await (_apiProvider.startFielding(event.token, event.poleId, event.isStartAdditional, event.layerId));
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
      } else {
        yield StartFieldingSuccess();
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
