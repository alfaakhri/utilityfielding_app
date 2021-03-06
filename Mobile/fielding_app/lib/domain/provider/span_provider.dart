import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:flutter/material.dart';

class SpanProvider extends ChangeNotifier {
  List<SpanDirectionList> _listSpanData = <SpanDirectionList>[];
  List<SpanDirectionList> get listSpanData => _listSpanData;
  void addListSpanData(SpanDirectionList spanData) {
    _listSpanData.add(spanData);
    notifyListeners();
  }

  addAllListSpanData(List<SpanDirectionList>? data) {
    _listSpanData.clear();
    if (data != null) {
      _listSpanData.addAll(data);
    } else {
      _listSpanData = <SpanDirectionList>[];
    }

    notifyListeners();
  }

  void editListSpanData(SpanDirectionList spanData, int index) {
    _listSpanData.removeAt(index);
    _listSpanData.add(spanData);
    notifyListeners();
  }

  void removeListSpanData(int index) {
    _listSpanData.removeAt(index);
    notifyListeners();
  }

  void uploadImage(
      String filename, String base64, String? imagePath, String location) async {
    try {
      ApiProvider _apiProvider = ApiProvider();

      var data = {
        "file_name": filename,
        "base64url": base64,
        "imagepath": imagePath,
        "location": location
      };
      var response = await _apiProvider.uploadImage(data);
      if (response.statusCode == 200) {
        print(response.data['imagepath']);
        _listSpanData.forEach((element) {
          element.image = response.data['imagepath'];
          // element.
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void clearAll() {
    _listSpanData.clear();
    notifyListeners();
  }

  int? _imageType;
  int? get imageType => _imageType;
  void setImageType(int imageType) {
    _imageType = imageType;
    notifyListeners();
  }
}
