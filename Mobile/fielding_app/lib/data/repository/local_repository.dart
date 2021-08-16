import 'package:dio/dio.dart';

import 'api_provider.dart';

class LocalRepository {
  Dio _dio = Dio();
  Response? _response;

  Future<Response?> getFieldingPoles(String token, String layerId) async {
    try {
      _response = await _dio.get(
          BASE_URL + "/api/MobileProject/GetPolesWithDetailsByLayerId?token=$token&layerId=$layerId",
          );
      return _response;
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }
}