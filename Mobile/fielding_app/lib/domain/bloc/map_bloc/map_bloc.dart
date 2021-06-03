import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/list_fielding/job_number_location_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial());
  ApiProvider _apiProvider = ApiProvider();

  List<JobNumberLocModel>? _jobNumberLocModel = <JobNumberLocModel>[];
  List<JobNumberLocModel>? get jobNumberLocModel => _jobNumberLocModel;

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is GetJobNumberLoc) {
      yield GetJobNumberLoading();
      try {
        var response = await _apiProvider.getJobNumberLoc(event.token);
        if (response.statusCode == 200) {
          _jobNumberLocModel = JobNumberLocModel.fromJsonList(response.data);
          yield GetJobNumberSuccess(_jobNumberLocModel);
        } else {
          yield GetJobNumberFailed("Failed load data job number");
        }
      } catch (e) {
        yield GetJobNumberFailed(e.toString());
      }
    }
  }
}
