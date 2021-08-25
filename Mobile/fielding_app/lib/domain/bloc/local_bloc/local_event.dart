part of 'local_bloc.dart';

@immutable
abstract class LocalEvent {}

class GetEditPole extends LocalEvent {}

class PostEditPole extends LocalEvent {
  final String token;
  final AddPoleLocal addPole;

  PostEditPole(this.token, this.addPole);
}

class DeletePole extends LocalEvent {
  final AddPoleLocal addPole;

  DeletePole(this.addPole);
}

class SaveFieldingRequest extends LocalEvent {
  final String token;
  final String userId;
  final String layerId;
  final AllProjectsModel allProjectModel;

  SaveFieldingRequest(this.token, this.layerId, this.allProjectModel, this.userId);
}

class GetListFielding extends LocalEvent {
  final String userId;

  GetListFielding(this.userId);
}

class DeleteFieldingRequest extends LocalEvent {
  final AllProjectsModel allProjectsModel;
  final String userId;

  DeleteFieldingRequest(this.allProjectsModel, this.userId);
}

class UploadSinglePole extends LocalEvent {
  final AllProjectsModel allProjectsModel;
  final AddPoleModel addPoleModel;
  final String userId;

  UploadSinglePole(this.addPoleModel, this.allProjectsModel, this.userId);
}

class UploadListPole extends LocalEvent {
}