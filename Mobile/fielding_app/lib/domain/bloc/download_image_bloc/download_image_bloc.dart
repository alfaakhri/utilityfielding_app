import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/foundation.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'download_image_event.dart';
part 'download_image_state.dart';

class DownloadImageBloc extends Bloc<DownloadImageEvent, DownloadImageState> {
  DownloadImageBloc() : super(DownloadImageInitial());
  static var httpClient = new HttpClient();

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

        var response = await Dio().get(event.image!,
            options: Options(responseType: ResponseType.bytes));
        // final result = await ImageGallerySaver.saveImage(
        //     Uint8List.fromList(response.data),
        //     quality: 60,
        //     name: "$formattedDate-${rand.nextInt(10000)}");
        // print(result);
        yield SaveImageSuccess();
      } catch (e) {
        yield SaveImageError(e.toString());
      }
    } else if (event is SaveFile) {
      try {
        // for (var list in event.jobNumberAttach!) {
          // File file = File(event.localPath! + baseURLnew + list.filePath!);

          // Response response = await Dio().download(

          //   baseURLnew + list.filePath!,
          //   event.localPath! + list.filePath!.split("/").last,
          //   onReceiveProgress: showDownloadProgress,
          //   //Received data with List<int>
          //   options: Options(
          //       responseType: ResponseType.bytes,
          //       followRedirects: false,
          //       validateStatus: (status) {
          //         return status! < 500;
          //       }),
          // );
          // print(response.headers);
          // File file = File(event.localPath! + list.filePath!.split("/").last);
          // var raf = file.openSync(mode: FileMode.write);
          // // response.data is List<int> type
          // raf.writeFromSync(response.data);
          // await raf.close();

          // var request =
          //     await httpClient.getUrl(Uri.parse(baseURLnew + list.filePath!));
          // var response = await request.close();
          // var bytes = await consolidateHttpClientResponseBytes(response);
          // String dir = (await getExternalStorageDirectory())!.path;
          // File file = new File('$dir/${list.filePath!.split("/").last}');
          // await file.writeAsBytes(bytes);
          // FileUtils.mkdir(["Fielding/"]);
          // await Dio().download(baseURLnew + list.filePath!, "Fielding/" + list.filePath!.split("/").last,
          //     onReceiveProgress: (receivedBytes, totalBytes) {});
          var appDocDir = await getExternalStorageDirectory();
          String savePath = appDocDir!.path + "/${event.jobNumberAttach!.elementAt(1).filePath!.split("/").last}";
          String fileUrl =
              baseURLnew + event.jobNumberAttach!.elementAt(1).filePath!;
          await Dio().download(fileUrl, savePath,
              onReceiveProgress: (count, total) {
            print((count / total * 100).toStringAsFixed(0) + "%");
          });
          // final result = await ImageGallerySaver.saveFile(savePath);
          // print(result);
        // }
      } catch (e) {
        yield SaveFileFailed(e.toString());
      }
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
