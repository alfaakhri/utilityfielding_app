import 'package:fielding_app/domain/bloc/download_image_bloc/download_image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:permission_handler/permission_handler.dart';

class PreviewImage extends StatefulWidget {
  final String? image;

  const PreviewImage({this.image});
  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  late DownloadImageBloc downloadBloc;

  @override
  void initState() {
    super.initState();
    downloadBloc = BlocProvider.of<DownloadImageBloc>(context);
        _requestPermission();

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadImageBloc, DownloadImageState>(
        listener: (context, state) {
          if (state is SaveImageSuccess) {
            Fluttertoast.showToast(
                msg: "Download image success. Check your directory.");
          } else if (state is SaveImageLoading) {
          } else if (state is SaveImageError) {
            Fluttertoast.showToast(msg: "Please try again");
          }
        },
        child: _buildScaffold());
  }

  Scaffold _buildScaffold() {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Colors.white,
                ),
                onPressed: () {
                  downloadBloc.add(SaveImage(widget.image!));
                })
          ],
        ),
        body: Center(
            // Dynamically set a fixed size for the child widget,
            // so that it takes up the most possible screen space
            // while adhering to the defined aspect ratio
            child: AspectRatio(
          aspectRatio: 9 / 9,
          // Puts a "mask" on the child, so that it will keep its original, unzoomed size
          // even while it's being zoomed in
          child: ClipRect(
            child: PhotoView(
              imageProvider: NetworkImage(
                widget.image!,
              ),
              // Contained = the smallest possible size to fit one dimension of the screen
              minScale: PhotoViewComputedScale.contained * 1,
              // Covered = the smallest possible size to fit the whole screen
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ),
        )));
  }
}
