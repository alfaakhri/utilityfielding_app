part of 'download_image_bloc.dart';

@immutable
abstract class DownloadImageState {}

class DownloadImageInitial extends DownloadImageState {}

class SaveImageLoading extends DownloadImageState {}

class SaveImageSuccess extends DownloadImageState {}

class SaveImageError extends DownloadImageState {
  final String? message;

  SaveImageError(this.message);
}

class SaveFileLoading extends DownloadImageState {}

class SaveFileSuccess extends DownloadImageState {}

class SaveFileFailed extends DownloadImageState {
  final String? message;

  SaveFileFailed(this.message);
}