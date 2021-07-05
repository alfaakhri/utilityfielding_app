part of 'picture_bloc.dart';

@immutable
abstract class PictureEvent {}

class UploadImage extends PictureEvent {
  final BuildContext context;
  final String poleId;

  UploadImage(this.context, this.poleId);
}

class GetImageByPole extends PictureEvent {
  final String token;
  final String poleId;

  GetImageByPole(this.token, this.poleId);
}

class DeleteImage extends PictureEvent {
  final String token;
  final String poleId;
  final String filePath;

  DeleteImage(this.token, this.poleId, this.filePath);
}