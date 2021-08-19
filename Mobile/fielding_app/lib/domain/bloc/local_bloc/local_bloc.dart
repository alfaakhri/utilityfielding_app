import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/detail_fielding/detail_fielding.exports.dart';
import 'package:fielding_app/data/models/edit_pole/edit_pole.exports.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/data/repository/local_repository.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/hive_service.dart';
import 'package:fielding_app/presentation/ui/ui.exports.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

part 'local_event.dart';
part 'local_state.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState> {
  LocalBloc() : super(LocalInitial());
  HiveService _hiveService = HiveService();
  ApiProvider _apiProvider = ApiProvider();
  LocalRepository _localRepo = LocalRepository();

  List<AddPoleLocal>? _listAddPoleLocal = <AddPoleLocal>[];
  List<AddPoleLocal>? get listAddPoleLocal => _listAddPoleLocal;

  List<AllProjectsModel>? _allProjectModel = <AllProjectsModel>[];
  List<AllProjectsModel>? get allProjectModel => _allProjectModel;

  @override
  Stream<LocalState> mapEventToState(
    LocalEvent event,
  ) async* {
    if (event is GetEditPole) {
      yield GetEditPoleLoading();
      final dataBox = await _hiveService.openAndGetDataFromHiveBox(
          getHiveEditPole, listEditPole);
      if (dataBox != null) {
        _listAddPoleLocal = AddPoleLocal.fromJsonList(jsonDecode(dataBox));

        yield GetEditPoleSuccess(_listAddPoleLocal);
      } else {
        yield GetEditPoleEmpty();
      }
    } else if (event is DeletePole) {
      yield DeletePoleLoading();
      _listAddPoleLocal!.remove(event.addPole);
      _hiveService.deleteDataFromBox(getHiveEditPole, listEditPole);
      if (_listAddPoleLocal!.length != 0) {
        _hiveService.saveDataToBox(
            getHiveEditPole, listEditPole, json.encode(_listAddPoleLocal));
      }
      yield DeletePoleSuccess();
    } else if (event is PostEditPole) {
      yield PostEditPoleLoading();
      try {
        event.addPole.addPoleModel!.token = event.token;
        var response =
            await (_apiProvider.addPole(event.addPole.addPoleModel!.toJson()));
        if (response!.statusCode == 200) {
          _listAddPoleLocal!.remove(event.addPole);

          _hiveService.deleteDataFromBox(getHiveEditPole, listEditPole);
          if (_listAddPoleLocal!.length != 0) {
            _hiveService.saveDataToBox(
                getHiveEditPole, listEditPole, json.encode(_listAddPoleLocal));
          }
          yield PostEditPoleSuccess();
        } else if (response.data['Message'] == messageTokenExpired) {
          Get.offAll(LoginPage());
        } else {
          yield PostEditPoleFailed(response.data['Message']);
        }
      } catch (e) {
        yield PostEditPoleFailed(e.toString());
      }
    } else if (event is SaveFieldingRequest) {
      yield SaveFieldingRequestLoading();
      final dataBox = await _hiveService.openAndGetDataFromHiveBox(
          getHiveFieldingPoles, event.userId);

      try {
        var response =
            await _localRepo.getFieldingPoles(event.token, event.layerId);
        if (response!.statusCode == 200) {
          if (dataBox != null) {
            _allProjectModel =
                AllProjectsModel.fromJsonList(json.decode(dataBox));
            _allProjectModel!.removeWhere(
                (element) => element.iD == event.allProjectModel.iD);
          }

          AllProjectsModel temp = event.allProjectModel;
          temp.allPolesByLayer =
              AllPolesByLayerModel.fromJsonList(response.data);
          _allProjectModel!.add(temp);
          _hiveService.saveDataToBox(getHiveFieldingPoles, event.userId,
              json.encode(_allProjectModel));
          yield SaveFieldingRequestSuccess();
        }
      } catch (e) {
        yield SaveFieldingRequestFailed(e.toString());
      }
    } else if (event is GetListFielding) {
      yield GetListFieldingLoading();
      try {
        final dataBox = await _hiveService.openAndGetDataFromHiveBox(
            getHiveFieldingPoles, event.userId);
        if (dataBox != null) {
          if (dataBox != null) {
            _allProjectModel =
                AllProjectsModel.fromJsonList(json.decode(dataBox));
            yield GetListFieldingSuccess();
          } else {
            yield GetListFieldingEmpty();
          }
        } else {
          yield GetListFieldingEmpty();
        }
      } catch (e) {
        yield GetListFieldingFailed(e.toString());
      }
    } else if (event is DeleteFieldingRequest) {
      yield DeleteFieldingRequestLoading();
      try {
        _allProjectModel!.remove(event.allProjectsModel);
        await _hiveService.deleteDataFromBox(getHiveFieldingPoles, event.userId,);
        if (_allProjectModel!.length != 0) {
          await _hiveService.saveDataToBox(
              getHiveFieldingPoles, event.userId, json.encode(_allProjectModel));
        }
        yield DeleteFieldingRequestSuccess();
        add(GetListFielding(event.userId));
      } catch (e) {
        yield DeleteFieldingRequestFailed(e.toString());
      }
    }
  }
}
