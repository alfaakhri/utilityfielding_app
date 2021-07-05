import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'picture_event.dart';
part 'picture_state.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  PictureBloc() : super(PictureInitial());
  ApiProvider _apiProvider = ApiProvider();

  @override
  Stream<PictureState> mapEventToState(
    PictureEvent event,
  ) async* {
    if (event is UploadImage) {
      File? file =
          await ImagePickerService().dialogImageEditProfil(event.context);
      if (file != null) {
        yield UploadImageLoading();
        try {
          List<int> imageBytes = file.readAsBytesSync();
          String base64Image = base64Encode(imageBytes);

          // var data = {
          //   "file_name": file.path.split('/').last,
          //   "base64url": base64Image,
          //   "imagepath": file.path,
          //   "location": "quotation"
          // };
          var data = {
            "files": file,
          };
          print(json.encode(data).toString());
          print(base64Image);
          print(json.encode(file.path).toString());

          var response =
              await _apiProvider.uploadImageByPole(data, event.poleId);
          if (response.statusCode == 200) {
            // setListFilenameAttachment(response.data['imagepath']);
            List<dynamic> data = [];
            data.add(response.data['imagepath']);
            yield UploadImageSuccess(data);
          } else {
            yield UploadImageFailed("Failed upload image");
          }
        } catch (e) {
          yield UploadImageFailed(e.toString());
        }
      } else {
        yield UploadImageCancel();
      }
    } else if (event is GetImageByPole) {
      yield GetImageByPoleLoading();
      try {
        var response =
            await _apiProvider.getPoleImagesData(event.token, event.poleId);
        if (response.statusCode == 200) {
          print(response.data);
        } else {
          yield GetImageByPoleFailed("Failed load image data");
        }
      } catch (e) {
        yield GetImageByPoleFailed(e.toString());
      }
    } else if (event is DeleteImage) {
      yield DeleteImageLoading();
      try {
        var data = {
          'token': event.token,
          'PoleId': event.poleId,
          'TargetImagePath': event.filePath
        };

        var response = await _apiProvider.deleteImage(data);
        if (response.statusCode == 200) {
          yield DeleteImageSuccess();
        } else {
          yield DeleteImageFailed("Failed delete image");
        }
      } catch (e) {
        yield DeleteImageFailed(e.toString());
      }
    }
  }
}
