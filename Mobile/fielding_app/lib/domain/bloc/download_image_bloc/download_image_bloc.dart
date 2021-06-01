import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'download_image_event.dart';
part 'download_image_state.dart';

class DownloadImageBloc extends Bloc<DownloadImageEvent, DownloadImageState> {
  DownloadImageBloc() : super(DownloadImageInitial());

  @override
  Stream<DownloadImageState> mapEventToState(
    DownloadImageEvent event,
  ) async* {
    if (event is SaveImage) {
      yield SaveImageLoading();

      try {
        var rand = new Random();
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);

        var response = await Dio()
            .get(event.image!, options: Options(responseType: ResponseType.bytes));
        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data),
            quality: 60,
            name: "$formattedDate-${rand.nextInt(10000)}");
        print(result);
        yield SaveImageSuccess();
      } catch (e) {
        yield SaveImageError(e.toString());
      }
    }
  }
}
