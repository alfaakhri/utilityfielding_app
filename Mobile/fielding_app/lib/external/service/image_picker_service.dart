import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../external.exports.dart';

class ImagePickerService {
  File? imageFile;
  LostData? _fileLost;
  var resultList;
  ImagePickerService({this.imageFile, this.resultList});

  Future<PickedFile?> retrieveLostData() async {
    final picker = ImagePicker();
    final LostData? response = await picker.getLostData();
    if (response == null) {
      return null;
    }
    if (response.file != null) {
      return response.file;
    } else {
      if (response.exception != null) {
        return null;
      } else {
        print('didn\'t know what happend!');
      }
    }
  }

  _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    PermissionStatus status = await Permission.camera.status;
    if (status.isPermanentlyDenied) return openAppSettings();
    status = await Permission.camera.request();
    if (status.isDenied) return;

    var picture = await picker.getImage(source: ImageSource.gallery);
    // PickedFile lostData = retrieveLostData() as PickedFile;
    // print("LOST DATA " + lostData.path);

    imageFile = File(picture!.path);
    print("SEBELUM KOMPRES " + imageFile!.lengthSync().toString());
    File compressedFile = await FlutterNativeImage.compressImage(
        imageFile!.path,
        quality: 80,
        percentage: 70);
    print("HASIL KOMPRES " + compressedFile.lengthSync().toString());
    if (imageFile != null) {
      Navigator.of(context).pop(compressedFile);
    } else {
      Navigator.of(context).pop(null);
    }
  }

  _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    PermissionStatus status = await Permission.camera.status;
    if (status.isPermanentlyDenied) return openAppSettings();
    status = await Permission.camera.request();
    if (status.isDenied) return;

    var picture = await picker.getImage(source: ImageSource.camera);
    // PickedFile lostData = retrieveLostData() as PickedFile;
    // print("LOST DATA " + lostData.path);
    imageFile = File(picture!.path);
    File compressedFile = await FlutterNativeImage.compressImage(
        imageFile!.path,
        quality: 80,
        percentage: 70);
    print("HASIL KOMPRES " + compressedFile.lengthSync().toString());
    if (imageFile != null) {
      Navigator.of(context).pop(compressedFile);
    } else {
      Navigator.of(context).pop(null);
    }
  }

  Future dialogImageEditProfil(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UIHelper.verticalSpaceMedium,
                Text(
                  'Take Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorHelpers.colorGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                UIHelper.verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Please choose to use Gallery or Camera',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorHelpers.colorGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                UIHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () {
                    _openGallery(context);
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorHelpers.colorButtonDefault,
                      ),
                      child: Text(
                        "GALLERY",
                        style: TextStyle(
                            color: ColorHelpers.colorWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                UIHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () {
                    _openCamera(context);
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorHelpers.colorBlue,
                        border: Border.all(color: ColorHelpers.colorBlue),
                      ),
                      child: Text(
                        "CAMERA",
                        style: TextStyle(
                            color: ColorHelpers.colorBlackText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          );
        });
  }
}
