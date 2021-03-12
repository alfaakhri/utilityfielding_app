import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:flutter/material.dart';

class SpanProvider extends ChangeNotifier {
  List<SpanDirectionList> _listSpanData = List<SpanDirectionList>();
  List<SpanDirectionList> get listSpanData => _listSpanData;
  void addListSpanData(SpanDirectionList spanData) {
    _listSpanData.add(spanData);
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
}
