import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/detail_fielding/detail_fielding.exports.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'picture_event.dart';
part 'picture_state.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  PictureBloc() : super(PictureInitial());
  ApiProvider _apiProvider = ApiProvider();

  List<ImageByPoleModel>? _imageByPoleModel = <ImageByPoleModel>[];
  List<ImageByPoleModel> get imageByPoleModel => _imageByPoleModel!;

  Future<String> uploadImage(dynamic data) async {
    try {
      ApiProvider _apiProvider = ApiProvider();

      var response = await _apiProvider.uploadImage(data);

      return response.data['imagepath'];
    } catch (e) {
      throw e;
    }
  }

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

          var dataImage = {
            "file_name": file.path.split('/').last,
            "base64url": base64Image,
            "imagepath": file.path,
            "location": "quotation"
          };

          print(json.encode(dataImage).toString());
          print(base64Image);
          print(json.encode(file.path).toString());

          String path = await uploadImage(dataImage);
          
          var dataAttachPole = {
            "files": [
              {
                "FileName": file.path.split('/').last,
                "FilePath": path,
              }
            ],
            "poleId": event.poleId
          };

          print(dataAttachPole);

          var response = await _apiProvider.uploadImageByPole(json.encode(dataAttachPole));
          if (response.statusCode == 200) {
            print(response.data);
            yield UploadImageSuccess();
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
          _imageByPoleModel = ImageByPoleModel.fromJsonList(response.data);
          yield GetImageByPoleSuccess(imageByPoleModel);
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
          'TargetImagePath': "${event.filePath}",
          "AttachmentId": event.attachmentId
        };

        print("Delete " + json.encode(data));

        var response = await _apiProvider.deleteImage(data);
        if (response.statusCode == 200) {
          yield DeleteImageSuccess();
        } else {
          yield DeleteImageFailed(response.data["message"]);
        }
      } catch (e) {
        yield DeleteImageFailed(e.toString());
      }
    }
  }
}
