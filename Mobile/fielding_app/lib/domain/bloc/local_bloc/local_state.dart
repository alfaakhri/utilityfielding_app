part of 'local_bloc.dart';

@immutable
abstract class LocalState {}

class LocalInitial extends LocalState {}

class GetEditPoleLoading extends LocalState {}

class GetEditPoleSuccess extends LocalState {
  final List<AddPoleLocal>? listAddPoleLocal;

  GetEditPoleSuccess(this.listAddPoleLocal);
}

class GetEditPoleFailed extends LocalState {
  final String? message;

  GetEditPoleFailed(this.message);
}

class GetEditPoleEmpty extends LocalState {}

class PostEditPoleLoading extends LocalState {}

class PostEditPoleSuccess extends LocalState {}

class PostEditPoleFailed extends LocalState {
  final String? message;

  PostEditPoleFailed(this.message);
}

class DeletePoleLoading extends LocalState {}

class DeletePoleFailed extends LocalState {
  final String? message;

  DeletePoleFailed(this.message);
}

class DeletePoleSuccess extends LocalState {}

class SaveFieldingRequestLoading extends LocalState {}

class SaveFieldingRequestFailed extends LocalState {
  final String? message;

  SaveFieldingRequestFailed(this.message);
}

class SaveFieldingRequestSuccess extends LocalState {}

class GetListFieldingLoading extends LocalState {}
class GetListFieldingSuccess extends LocalState {
  final List<AllProjectsModel> allProjectsModel;

  GetListFieldingSuccess(this.allProjectsModel);
}
class GetListFieldingEmpty extends LocalState {}
class GetListFieldingFailed extends LocalState {
  final String? message;

  GetListFieldingFailed(this.message);
}

class DeleteFieldingRequestLoading extends LocalState {}
class DeleteFieldingRequestSuccess extends LocalState {}
class DeleteFieldingRequestFailed extends LocalState {
  final String? message;

  DeleteFieldingRequestFailed(this.message);
}

class UploadListPoleLoading extends LocalState {}
class UploadListPoleSuccess extends LocalState {}
class UploadListPoleFailed extends LocalState {
  final String? message;

  UploadListPoleFailed(this.message);
}

class UploadSinglePoleLoading extends LocalState {}
class UploadSinglePoleSuccess extends LocalState {}
class UploadSinglePoleFailed extends LocalState {
  final String? message;

  UploadSinglePoleFailed(this.message);
}

class StartLocalFieldingLoading extends  LocalState {}
class StartLocalFieldingSuccess extends  LocalState {}
class StartLocalFieldingFailed extends  LocalState {
  final String? message;

  StartLocalFieldingFailed(this.message);
}

class UploadStartCompleteLoading extends LocalState {}
class UploadStartCompleteSuccess extends LocalState {}
class UploadStartCompleteFailed extends LocalState {
  final String? message;

  UploadStartCompleteFailed(this.message);
}