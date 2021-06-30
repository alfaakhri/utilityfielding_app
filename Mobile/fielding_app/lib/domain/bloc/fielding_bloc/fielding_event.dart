part of 'fielding_bloc.dart';

@immutable
abstract class FieldingEvent {}

class GetAllProjects extends FieldingEvent {
  final String? token;
  final bool? isConnected;

  GetAllProjects(this.token, this.isConnected);
}

class GetAllPolesByID extends FieldingEvent {
  final String? token;
  final String? layerId;
  final bool? isConnected;

  GetAllPolesByID(this.token, this.layerId, this.isConnected);
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
  final AddPoleModel addPoleModel;
  final AllProjectsModel allProjectsModel;
  final AllPolesByLayerModel allPolesByLayerModel;
  final bool? isConnected;

  AddPole(this.addPoleModel, this.allProjectsModel, this.allPolesByLayerModel, this.isConnected);

}

class GetPoleById extends FieldingEvent {
  final String? id;
  final String? token;

  GetPoleById(this.id, this.token);
}

class StartFielding extends FieldingEvent {
  final String? token;
  final String? poleId;
  final bool? isStartAdditional;
  final String? layerId;

  StartFielding({this.token, this.poleId, this.isStartAdditional, this.layerId});
}

class CompleteMultiPole extends FieldingEvent {
  final String? token;
  final String? layerId;
  final List<AllPolesByLayerModel>? allPolesByLayerModel;

  CompleteMultiPole(this.token, this.layerId, this.allPolesByLayerModel);
}