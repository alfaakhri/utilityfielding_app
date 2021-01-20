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

class AddPoleLoading extends FieldingState {}
class AddPoleFailed extends FieldingState {
  final String message;

  AddPoleFailed(this.message);
}
class AddPoleSuccess extends FieldingState {}

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

class UpdateLocationLoading extends FieldingState {}

class UpdateLocationSuccess extends FieldingState {
  final AllPolesByLayerModel allPolesByLayerModel;

  UpdateLocationSuccess(this.allPolesByLayerModel);
}

class UpdateLocationFailed extends FieldingState {
  final String message;
  UpdateLocationFailed(this.message);
}

class GetPoleByIdLoading extends FieldingState {}
class GetPoleByIdFailed extends FieldingState {
  final String message;

  GetPoleByIdFailed(this.message);
}
class GetPoleByIdSuccess extends FieldingState {
  final PoleByIdModel poleByIdModel;

  GetPoleByIdSuccess(this.poleByIdModel);
}

class GetCurrentAddressLoading extends FieldingState {}
class GetCurrentAddressSuccess extends FieldingState {
  final CurrentAddress currentAddress;

  GetCurrentAddressSuccess(this.currentAddress);
}
class GetCurrentAddressFailed extends FieldingState {
  final String message;

  GetCurrentAddressFailed(this.message);
}