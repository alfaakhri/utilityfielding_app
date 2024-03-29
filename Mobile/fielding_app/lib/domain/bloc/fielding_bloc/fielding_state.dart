part of 'fielding_bloc.dart';

@immutable
abstract class FieldingState {}

class FieldingInitial extends FieldingState {}

class GetFieldingRequestLoading extends FieldingState {}
class GetFieldingRequestFailed extends FieldingState {
  final String message;

  GetFieldingRequestFailed(this.message);
}
class GetFieldingRequestEmpty extends FieldingState {}

class GetFieldingRequestSuccess extends FieldingState {
  final List<FieldingRequestByJobModel> fieldingRequest;

  GetFieldingRequestSuccess(this.fieldingRequest);
}

class GetAssignedRequestLoading extends FieldingState {}
class GetAssignedRequestSuccess extends FieldingState {}
class GetAssignedRequestFailed extends FieldingState {}
class GetAssignedRequestEmpty extends FieldingState {}

class GetAllPolesByIdLoading extends FieldingState {}

class GetAllPolesByIdFailed extends FieldingState {
  final String? message;

  GetAllPolesByIdFailed(this.message);
}

class GetAllPolesByIdSuccess extends FieldingState {
  final List<AllPolesByLayerModel>? allPolesByLayer;

  GetAllPolesByIdSuccess(this.allPolesByLayer);
}

class StartPolePictureLoading extends FieldingState {}

class StartPolePictureFailed extends FieldingState {
  final String? message;

  StartPolePictureFailed(this.message);
}

class AddPoleLoading extends FieldingState {}
class AddPoleFailed extends FieldingState {
  final String? message;

  AddPoleFailed(this.message);
}
class AddPoleSuccess extends FieldingState {}

class StartPolePictureSuccess extends FieldingState {
  final List<AllPolesByLayerModel>? allPolesByLayerModel;

  StartPolePictureSuccess(this.allPolesByLayerModel);
}

class CompletePolePictureLoading extends FieldingState {}

class CompletePolePictureFailed extends FieldingState {
  final String? message;

  CompletePolePictureFailed(this.message);
}

class CompletePolePictureSuccess extends FieldingState {
  final List<AllPolesByLayerModel>? allPolesByLayerModel;

  CompletePolePictureSuccess(this.allPolesByLayerModel);
}

class GetPoleByIdLoading extends FieldingState {}
class GetPoleByIdFailed extends FieldingState {
  final String? message;

  GetPoleByIdFailed(this.message);
}
class GetPoleByIdSuccess extends FieldingState {
  final PoleByIdModel poleByIdModel;

  GetPoleByIdSuccess(this.poleByIdModel);
}

class StartFieldingLoading extends FieldingState {}
class StartFieldingFailed extends FieldingState {
  final String? message;

  StartFieldingFailed(this.message);
}

class StartFieldingSuccess extends FieldingState {}

class CompleteMultiPoleLoading extends FieldingState {}
class CompleteMultiPoleSuccess extends FieldingState {}
class CompleteMultiPoleFailed extends FieldingState {
  final String? message;

  CompleteMultiPoleFailed(this.message);
}