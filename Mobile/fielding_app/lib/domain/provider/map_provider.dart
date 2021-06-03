import 'package:fielding_app/data/models/list_fielding/job_number_location_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:flutter/material.dart';

class MapProvider extends ChangeNotifier {
  ApiProvider apiProvider = ApiProvider();

  JobNumberLocModel _jobNumberLocModel = JobNumberLocModel();
  JobNumberLocModel get jobNumberLocModel => _jobNumberLocModel;
  void setJobNumberLocModel(JobNumberLocModel jobNumberLocModel) {
    _jobNumberLocModel = jobNumberLocModel;
    notifyListeners();
  }
}