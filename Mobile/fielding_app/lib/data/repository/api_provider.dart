import 'package:dio/dio.dart';
import 'package:fielding_app/external/constants.dart';

const String BASE_URL = "https://utilityfielding.ultimosolution.com";

class ApiProvider {
  Dio _dio = Dio();
  Response _response;

  Future<Response> checkToken(String token) async {
    var data = {'token': token};
    try {
      _response = await _dio.post(
          BASE_URL + "/api/MobileAuthentication/CheckTokenAuth",
          data: data);
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

  Future<Response> doLogin(String username, String password) async {
    var data = {"username": username, "password": password};
    try {
      _response = await _dio.post(BASE_URL + "/api/MobileAuthentication/Login",
          data: data,
          options: Options(headers: {'Content-Type': 'application/json'}));
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

  Future<Response> getAllProject(String token) async {
    try {
      _response = await _dio.get(
          BASE_URL + "/api/MobileProject/GetAllFieldingRequest?token=$token");
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

  Future<Response> getAllPolesByLayerID(String token, String layerID) async {
    try {
      _response = await _dio.get(BASE_URL +
          "/api/MobileProject/GetAllPolesByLayerId?token=$token&layerId=$layerID");
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

  Future<Response> startPolePicture(String token, String poleId) async {
    var data = {
      "Token": token,
      "PoleID": poleId,
    };
    try {
      _response = await _dio
          .post(BASE_URL + "/api/MobileProject/StartPolePicture", data: data);
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

  Future<Response> completePolePicture(String token, String poleId) async {
    var data = {
      "Token": token,
      "PoleID": poleId,
    };
    try {
      _response = await _dio.post(
          BASE_URL + "/api/MobileProject/CompletePolePicture",
          data: data);
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

  Future<Response> updateLocation(
      String token, String poleId, String latitude, String longitude) async {
    var data = {
      "Token": token,
      "PoleID": poleId,
      "Latitude": latitude,
      "Longitude": longitude
    };

    try {
      _response = await _dio
          .post(BASE_URL + "/api/MobileProject/UpdateLocation", data: data);
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

  Future<Response> addPole(dynamic data) async {
    try {
      _response = await _dio
          .post(BASE_URL + "/api/MobileProject/CompleteFielding", data: data);
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

    Future<Response> getPoleById(String id, String token) async {
    try {
      _response = await _dio
          .get(BASE_URL + "/api/MobileProject/GetPoleById/$id?token=token");
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

  Future<Response> getLocationByLatLng(double lat, double lng) async {
    try {
      var response = await _dio.get(
          "${Constants.baseGoogleApi}/maps/api/geocode/json?key=${Constants.apiKey}&latlng=$lat,$lng");
      return response;
    } catch (e) {
      throw e;
    }
  }
}