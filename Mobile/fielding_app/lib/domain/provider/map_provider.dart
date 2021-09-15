import 'package:fielding_app/data/models/list_fielding/job_number_location_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  ApiProvider apiProvider = ApiProvider();

  JobNumberLocModel _jobNumberLocModel = JobNumberLocModel();
  JobNumberLocModel get jobNumberLocModel => _jobNumberLocModel;
  void setJobNumberLocModel(JobNumberLocModel jobNumberLocModel) {
    _jobNumberLocModel = jobNumberLocModel;
    notifyListeners();
  }

  Future<Polyline> getRoutePolyline(
      {required String position,
      required Color color,
      required String id,
      int width = 6}) async {
    // Generates every polyline between start and finish
    final polylinePoints = PolylinePoints();
    // Holds each polyline coordinate as Lat and Lng pairs
    final List<LatLng> polylineCoordinates = [];

    List<PointLatLng> result = polylinePoints.decodePolyline(position);

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    final polyline = Polyline(
      polylineId: PolylineId(id),
      color: color,
      points: polylineCoordinates,
      width: width,
    );
    return polyline;
  }
}
