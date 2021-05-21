part of 'download_image_bloc.dart';

@immutable
abstract class DownloadImageEvent {}

class SaveImage extends DownloadImageEvent {
  final String image;

  SaveImage(this.image);
}
