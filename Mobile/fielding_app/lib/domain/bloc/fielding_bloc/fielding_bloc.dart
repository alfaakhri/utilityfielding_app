import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:meta/meta.dart';

part 'fielding_event.dart';
part 'fielding_state.dart';

class FieldingBloc extends Bloc<FieldingEvent, FieldingState> {
  FieldingBloc() : super(FieldingInitial());
  ApiProvider _apiProvider = ApiProvider();

  List<AllProjectsModel> _allProjects = List<AllProjectsModel>();
  List<AllProjectsModel> get allProjects => _allProjects;

  List<AllPolesByLayerModel> _allPolesByLayer = List<AllPolesByLayerModel>();
  List<AllPolesByLayerModel> get allPolesByLayer => _allPolesByLayer;

  AllPolesByLayerModel _responsePolePicture = AllPolesByLayerModel();
  AllPolesByLayerModel get responsePolePicture => _responsePolePicture;


  @override
  Stream<FieldingState> mapEventToState(
    FieldingEvent event,
  ) async* {
    if (event is GetAllProjects) {
      yield GetAllProjectsLoading();
      try {
        var response = await _apiProvider.getAllProject(event.token);
        _allProjects = AllProjectsModel.fromJsonList(response.data);
        if (response.statusCode == 200) {
          if (_allProjects.length == 0) {
            yield GetAllProjectsEmpty();
          } else {
            yield GetAllProjectsSuccess(_allProjects);
          }
        } else
          yield GetAllProjectsFailed(_allProjects.first.message);
      } catch (e) {
        yield GetAllProjectsFailed(e.toString());
      }
    } else if (event is GetAllPolesByID) {
      yield GetAllPolesByIdLoading();
      try {
        var response =
            await _apiProvider.getAllPolesByLayerID(event.token, event.layerId);
        _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
        if (response.statusCode == 200) {
          _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
          yield GetAllPolesByIdSuccess(_allPolesByLayer);
        } else {
          yield GetAllPolesByIdFailed(_allPolesByLayer.first.message);
        }
      } catch (e) {
        yield GetAllPolesByIdFailed(e.toString());
      }
    } else if (event is StartPolePicture) {
      yield StartPolePictureLoading();
      try {
        var response =
            await _apiProvider.startPolePicture(event.token, event.poleId);
        _responsePolePicture = AllPolesByLayerModel.fromJson(response.data);
        if (response.statusCode == 200) {
          var response = await _apiProvider.getAllPolesByLayerID(
              event.token, event.layerId);
          _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
          if (response.statusCode == 200) {
            _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
            yield StartPolePictureSuccess(_allPolesByLayer);
          } else {
            yield StartPolePictureFailed(_allPolesByLayer.first.message);
          }
        } else {
          yield StartPolePictureFailed(_responsePolePicture.message);
        }
      } catch (e) {
        yield StartPolePictureFailed(e.toString());
      }
    } else if (event is CompletePolePicture) {
      yield CompletePolePictureLoading();
      try {
        var response =
            await _apiProvider.completePolePicture(event.token, event.poleId);
        _responsePolePicture = AllPolesByLayerModel.fromJson(response.data);
        if (response.statusCode == 200) {
          var response = await _apiProvider.getAllPolesByLayerID(
              event.token, event.layerId);
          _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
          if (response.statusCode == 200) {
            _allPolesByLayer = AllPolesByLayerModel.fromJsonList(response.data);
            yield CompletePolePictureSuccess(_allPolesByLayer);
          } else {
            yield CompletePolePictureFailed(_allPolesByLayer.first.message);
          }
        } else {
          yield CompletePolePictureFailed(_responsePolePicture.message);
        }
      } catch (e) {
        yield CompletePolePictureFailed(e.toString());
      }
    }
  }
}
