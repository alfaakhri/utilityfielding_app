import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/download_image_bloc/download_image_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/bloc/picture_bloc/picture_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:permission_handler/permission_handler.dart';

class PreviewImage extends StatefulWidget {
  final String? image;
  final bool? functionDelete;

  const PreviewImage({this.image, this.functionDelete});
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
            (widget.functionDelete!)
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alertDelete();
                          });
                    })
                : IconButton(
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
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
              // Contained = the smallest possible size to fit one dimension of the screen
              minScale: PhotoViewComputedScale.contained * 1,
              // Covered = the smallest possible size to fit the whole screen
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ),
        )));
  }

  Widget alertDelete() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Are you sure delete this picture?',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpaceMedium,
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: ColorHelpers.colorGrey.withOpacity(0.2),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: ColorHelpers.colorBlackText),
                      ),
                    ),
                  ),
                ),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: ColorHelpers.colorRed,
                      onPressed: () {
                        var user = context.read<AuthBloc>();
                        var fielding = context.read<FieldingProvider>();
                        context.read<PictureBloc>().add(DeleteImage(
                            user.userModel!.data!.token!,
                            fielding.polesByLayerSelected.id!,
                            widget.image!));
                        Navigator.pop(context);
                        Get.back();
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
