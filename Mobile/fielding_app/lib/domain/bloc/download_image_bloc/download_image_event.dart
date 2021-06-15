part of 'download_image_bloc.dart';

@immutable
abstract class DownloadImageEvent {}

class SaveImage extends DownloadImageEvent {
  final String? image;

  SaveImage(this.image);
}

class SaveFile extends DownloadImageEvent {
  final List<JobNumberAttachModel>? jobNumberAttach;
  final String? localPath;

  SaveFile(this.jobNumberAttach, this.localPath);
}