import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/edit_pole/edit_pole.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/hive_service.dart';
import 'package:meta/meta.dart';

part 'local_event.dart';
part 'local_state.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState> {
  LocalBloc() : super(LocalInitial());
  HiveService _hiveService = HiveService();

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
    }
  }
}
