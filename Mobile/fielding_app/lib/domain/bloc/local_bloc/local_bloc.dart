import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/edit_pole/edit_pole.exports.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
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

  List<AddPoleLocal>? _listAddPoleLocal = <AddPoleLocal>[];
  List<AddPoleLocal>? get listAddPoleLocal => _listAddPoleLocal;

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
    }
  }
}
