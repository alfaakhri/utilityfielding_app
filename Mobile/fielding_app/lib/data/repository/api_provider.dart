import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fielding_app/external/constants.dart';

const String BASE_URL = "http://utilityfielding.com/";

class ApiProvider {
  Dio _dio = Dio();
  Response _response;

  Future<Response> getPrivacyPolicy() async {
    try {
      _response = await _dio.get(
          BASE_URL + "/home/privacypolicy",
          );
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

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
    print(token);
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

  Future<Response> startPolePicture(String token, String poleId, String layerId) async {
    var data = {
      "Token": token,
      "PoleID": poleId,
      "LayerID": layerId,
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
    print(json.encode(data));

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
      _response = await _dio.post(
          BASE_URL + "/api/MobileProject/CompletedFieldingNew",
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

  Future<Response> getPoleById(String id, String token) async {
    try {
      _response = await _dio
          .get(BASE_URL + "/api/MobileProject/GetPoleByIdNew/$id?token=$token");
      return _response;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return e.response;
      } else {
        throw e;
      }
    }
  }

  Future<Response> startFielding(
      String token, String poleId, bool isStartAdditional, String layerId) async {
    var data = {
      'Token': token,
      'PoleID': poleId,
      'LayerID': layerId,
      'isStartAdditional': isStartAdditional
    };
    print(json.encode(data));
    try {
      _response = await _dio.post(BASE_URL + "/api/MobileProject/StartFielding",
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

  Future<Response> getLocationByLatLng(double lat, double lng) async {
    try {
      var response = await _dio.get(
          "${Constants.baseGoogleApi}/maps/api/geocode/json?key=${Constants.apiKey}&latlng=$lat,$lng");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getAllPoleSpecies() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetAllPoleSpecies");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getAllPoleCondition() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetAllPoleCondition");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getRiserAndVGR() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetRiserAndVGRType");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getAllDownGuyOwner() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetAllDownGuyOwner");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getAllHoaType() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetAllHOAType");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getAllPoleClass() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetAllPoleClass");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getAllPoleHeight() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetAllPoleHeight");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> uploadImage(dynamic data) async {
    try {
      var response = await _dio
          .post(BASE_URL + "/api/MobileProject/UploadImage", data: data);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getAllAnchorSize() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetAllAnchorSize");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getAllAnchorEyes() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetAllAnchorEyes");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getDownGuySize() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetDownGuySize");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getBrokenDownGuySize() async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/MobileProject/GetBrokenDownGuySize");
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> getJobNumberAttach(String layerId) async {
    try {
      var response =
          await _dio.get(BASE_URL + "/api/Layer/GetJobnumberAttachments?assignedLayerId=$layerId");
      return response;
    } catch (e) {
      throw e;
    }
  }
}
