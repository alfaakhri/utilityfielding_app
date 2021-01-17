import 'package:dio/dio.dart';

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
      _response = await _dio.post(BASE_URL +
          "/api/MobileProject/CompletePolePicture", data: data);
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }
}
