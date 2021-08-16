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
  final String layerId;
  final AllProjectsModel allProjectModel;

  SaveFieldingRequest(this.token, this.layerId, this.allProjectModel);
}