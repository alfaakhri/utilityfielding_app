part of 'fielding_bloc.dart';

@immutable
abstract class FieldingState {}

class FieldingInitial extends FieldingState {}

class GetAllProjectsLoading extends FieldingState {}

class GetAllProjectsFailed extends FieldingState {
  final String message;

  GetAllProjectsFailed(this.message);
}

class GetAllProjectsSuccess extends FieldingState {
  final List<AllProjectsModel> allProjectsModel;

  GetAllProjectsSuccess(this.allProjectsModel);
}

class GetAllProjectsEmpty extends FieldingState {}

class GetAllPolesByIdLoading extends FieldingState {}

class GetAllPolesByIdFailed extends FieldingState {
  final String message;

  GetAllPolesByIdFailed(this.message);
}

class GetAllPolesByIdSuccess extends FieldingState {
  final List<AllPolesByLayerModel> allPolesByLayer;

  GetAllPolesByIdSuccess(this.allPolesByLayer);
}

class StartPolePictureLoading extends FieldingState {}

class StartPolePictureFailed extends FieldingState {
  final String message;

  StartPolePictureFailed(this.message);
}

class StartPolePictureSuccess extends FieldingState {
  final List<AllPolesByLayerModel> allPolesByLayerModel;

  StartPolePictureSuccess(this.allPolesByLayerModel);
}

class CompletePolePictureLoading extends FieldingState {}

class CompletePolePictureFailed extends FieldingState {
  final String message;

  CompletePolePictureFailed(this.message);
}

class CompletePolePictureSuccess extends FieldingState {
  final List<AllPolesByLayerModel> allPolesByLayerModel;

  CompletePolePictureSuccess(this.allPolesByLayerModel);
}
