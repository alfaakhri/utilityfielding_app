import 'dart:io';
import 'dart:ui';

import 'package:fielding_app/domain/bloc/download_image_bloc/download_image_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:isolate';

const debug = true;

class SupportingDocsWidget extends StatefulWidget {
  @override
  _SupportingDocsWidgetState createState() => _SupportingDocsWidgetState();
}

class _SupportingDocsWidgetState extends State<SupportingDocsWidget> {
  late String _localPath;
  late bool _permissionReady;
  ReceivePort _port = ReceivePort();

  Future<bool> _checkPermission() async {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }  

    return false;
  }

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _permissionReady = false;
    _prepareSaveDir();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      // String? id = data[0];
      // DownloadTaskStatus? status = data[1];
      // int? progress = data[2];

      // if (_tasks != null && _tasks!.isNotEmpty) {
      //   final task = _tasks!.firstWhere((task) => task.taskId == id);
      //   setState(() {
      //     task.status = status;
      //     task.progress = progress;
      //   });
      // }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (true) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<void> _prepareSaveDir() async {
    _permissionReady = await _checkPermission();
    if (_permissionReady) {
      _localPath =
          (await _findLocalPath())! + Platform.pathSeparator + 'Download';

      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
    }
  }

  Future<String?> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    final pathDirectory = Directory("${directory!.path}/UtilityFielding");
    if ((await pathDirectory.exists())) {
      print("exist");
    } else {
      print("not exist");
      pathDirectory.create();
    }
    return pathDirectory.path;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Supporting Documents",
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
          ),
          UIHelper.verticalSpaceMedium,
          // InkWell(
          //     onTap: () async {
                // context.read<DownloadImageBloc>().add(SaveFile(
                //     context.read<FieldingProvider>().jobNumberAttachModel!,
                //     _localPath));
          //       await FlutterDownloader.enqueue(
          //           url: baseURLnew +
          //               context
          //                   .read<FieldingProvider>()
          //                   .jobNumberAttachModel!.elementAt(0).filePath!
          //                   ,
          //           savedDir: _localPath,
          //           showNotification: true,
          //           openFileFromNotification: true);
          //     },
          //     child: Container(
          //       width: 100,
          //       decoration: BoxDecoration(
          //         color: ColorHelpers.colorGreen2,
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //       child: Text(
          //         "Download All",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //         ),
          //       ),
          //     )),
          // UIHelper.verticalSpaceSmall,
          Expanded(
            child: ListView(
              children: context
                  .watch<FieldingProvider>()
                  .jobNumberAttachModel!
                  .map((e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: ColorHelpers.colorGrey2,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.fileName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: ColorHelpers.colorBlackText,
                                        fontSize: 12),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    String format = e.fileName!.split(".").last;
                                    if (format.toLowerCase() == "jpg" ||
                                        format.toLowerCase() == "jpeg" ||
                                        format.toLowerCase() == "png") {
                                      Navigator.pop(context);
                                      Get.to(PreviewImage(
                                        image: baseURL + e.filePath!,
                                      ));
                                    } else {
                                      String url = baseURL + e.filePath!;
                                      if (await canLaunch(url)) {
                                        Navigator.pop(context);
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Open",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: ColorHelpers.colorBlueNumber),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
