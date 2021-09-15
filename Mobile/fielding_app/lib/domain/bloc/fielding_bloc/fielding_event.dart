part of 'fielding_bloc.dart';

@immutable
abstract class FieldingEvent {}

class GetFieldingRequest extends FieldingEvent {
  final String? token;
  final bool? isConnected;

  GetFieldingRequest(this.token, this.isConnected);
}

class GetAssignedRequest extends FieldingEvent {
  final String? token;
  final String? jobNumberId;

  GetAssignedRequest(this.token, this.jobNumberId);
}

class GetAllPolesByID extends FieldingEvent {
  final String? token;
  final AllProjectsModel? allProjectsModel;
  final bool? isConnected;
  final String userId;

  GetAllPolesByID(this.token, this.allProjectsModel, this.isConnected, this.userId);
}

class StartPolePicture extends FieldingEvent {
  final String? token;
  final String? poleId;
  final String? layerId;

  StartPolePicture(this.token, this.poleId, this.layerId);
}

class CompletePolePicture extends FieldingEvent {
  final String? token;
  final String? poleId;
  final String? layerId;

  CompletePolePicture(this.token, this.poleId, this.layerId);
}

class AddPole extends FieldingEvent {
  final String userId;
  final AddPoleModel addPoleModel;
  final AllProjectsModel allProjectsModel;
  final AllPolesByLayerModel allPolesByLayerModel;
  final bool? isConnected;
  final bool isStartComplete;

  AddPole(this.addPoleModel, this.allProjectsModel, this.allPolesByLayerModel,
      this.isConnected, this.userId, this.isStartComplete);
}

class GetPoleById extends FieldingEvent {
  final AllPolesByLayerModel? allPolesByLayerModel;
  final String? token;
  final bool isConnected;

  GetPoleById(this.allPolesByLayerModel, this.token, this.isConnected);
}

class StartFielding extends FieldingEvent {
  final String token;
  final String poleId;
  final bool isStartAdditional;
  final String layerId;
  final bool isConnected;

  StartFielding(
      {required this.token, required this.poleId, required this.isStartAdditional, required this.layerId, required this.isConnected});
}

class CompleteMultiPole extends FieldingEvent {
  final String? token;
  final String? layerId;
  final List<AllPolesByLayerModel>? allPolesByLayerModel;

  CompleteMultiPole(this.token, this.layerId, this.allPolesByLayerModel);
}
