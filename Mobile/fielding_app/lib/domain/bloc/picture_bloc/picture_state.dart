part of 'picture_bloc.dart';

@immutable
abstract class PictureState {}

class PictureInitial extends PictureState {}

class UploadImageLoading extends PictureState {}

class UploadImageFailed extends PictureState {
  final String? message;

  UploadImageFailed(this.message);
}

class UploadImageSuccess extends PictureState {}

class UploadImageCancel extends PictureState {}

class GetImageByPoleLoading extends PictureState {}

class GetImageByPoleSuccess extends PictureState {
  final List<ImageByPoleModel> imageByPole;

  GetImageByPoleSuccess(this.imageByPole);
}

class GetImageByPoleFailed extends PictureState {
  final String message;

  GetImageByPoleFailed(this.message);
}

class GetImageByPoleEmpty extends PictureState {}

class DeleteImageLoading extends PictureState {}

class DeleteImageFailed extends PictureState {
  final String message;

  DeleteImageFailed(this.message);
}

class DeleteImageSuccess extends PictureState {}
