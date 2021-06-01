part of 'fielding_bloc.dart';

@immutable
abstract class FieldingEvent {}

class GetAllProjects extends FieldingEvent {
  final String? token;

  GetAllProjects(this.token);
}

class GetAllPolesByID extends FieldingEvent {
  final String? token;
  final String? layerId;

  GetAllPolesByID(this.token, this.layerId);
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

class UpdateLocation extends FieldingEvent {
  final String? token;
  final String? poleId;
  final String? latitude;
  final String? longitude;

  UpdateLocation(this.token, this.poleId, this.latitude, this.longitude);
}

class AddPole extends FieldingEvent {
  final AddPoleModel addPoleModel;

  AddPole(this.addPoleModel);
}

class GetPoleById extends FieldingEvent {
  final String? id;
  final String? token;

  GetPoleById(this.id, this.token);
}

class GetCurrentAddress extends FieldingEvent {
  final double latitude;
  final double longitude;

  GetCurrentAddress(this.latitude, this.longitude);
}

class StartFielding extends FieldingEvent {
  final String? token;
  final String? poleId;
  final bool isStartAdditional;
  final String? layerId;

  StartFielding(this.token, this.poleId, this.isStartAdditional, this.layerId);
}