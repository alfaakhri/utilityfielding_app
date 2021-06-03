import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:fielding_app/presentation/widgets/line_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../edit_pole.exports.dart';

class ViewSpanWidget extends StatefulWidget {
  @override
  _ViewSpanWidgetState createState() => _ViewSpanWidgetState();
}

class _ViewSpanWidgetState extends State<ViewSpanWidget> {
  GlobalKey globalKey = GlobalKey();
  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData>);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    String base64Image = base64Encode(pngBytes);

    print(pngBytes);
    Map<dynamic, dynamic> result =
        await (ImageGallerySaver.saveImage(pngBytes, quality: 100, name: "1234") as FutureOr<Map<dynamic, dynamic>>);
    print(result);
    context.read<SpanProvider>().uploadImage(
        Uuid().v1() + ".png", base64Image, result["filePath"], "span");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _capturePng();
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Span Direction and Distance",
                style: TextStyle(
                    color: ColorHelpers.colorBlackText, fontSize: 14)),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorHelpers.colorBlackText,
              ),
              onPressed: () {
                _capturePng();
                Get.back();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: ColorHelpers.colorBlackText),
                onPressed: () {
                  Get.to(InsertSpanWidget(
                    bXCoor: 350 / 1.5,
                  ));
                },
              )
            ],
            backgroundColor: ColorHelpers.colorWhite,
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton(
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                    _capturePng();
                    Get.back();
                  },
                  child: Text(
                    "DONE",
                    style:
                        TextStyle(fontSize: 14, color: ColorHelpers.colorWhite),
                  ),
                  color: ColorHelpers.colorButtonDefault),
            ),
          ),
          backgroundColor: Colors.white,
          body: Consumer<SpanProvider>(
            builder: (context, data, _) => ListView(
              children: [
                RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    height: 250,
                    margin: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorHelpers.colorGrey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 350,
                          height: 250,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: data.listSpanData.map(
                            (e) {
                              if (e.lineData != null) {
                                double newWidth =
                                    MediaQuery.of(context).size.width;
                                double newHeight =
                                    MediaQuery.of(context).size.height;

                                if (e.lineData != "null") {
                                  double aX = double.parse(e.lineData!
                                      .replaceAll("[", "")
                                      .replaceAll("]", "")
                                      .split(",")[0]);
                                  double aY = double.parse(e.lineData!
                                      .replaceAll("[]", "")
                                      .replaceAll("]", "")
                                      .split(",")[1]);
                                  double bX = double.parse(e.lineData!
                                      .replaceAll("[]", "")
                                      .replaceAll("]", "")
                                      .split(",")[2]);
                                  double bY = double.parse(e.lineData!
                                      .replaceAll("[]", "")
                                      .replaceAll("]", "")
                                      .split(",")[3]);
                                  Color color = HexColor.fromHex(e.color!);
                                  var fielding =
                                      Provider.of<FieldingProvider>(context);
                                  double newAX =
                                      ((newWidth * aX) / fielding.baseWidth);
                                  double newAY =
                                      ((newHeight * aY) / fielding.baseHeight);
                                  double newBX =
                                      ((newWidth * bX) / fielding.baseWidth);
                                  double newBY =
                                      ((newHeight * bY) / fielding.baseHeight);

                                  if (e.imageType == 0 || e.imageType == null) {
                                    return Line(
                                      start: {"x": newAX, "y": newAY},
                                      end: {"x": newBX, "y": newBY},
                                      color: color,
                                    );
                                  } else {
                                    return Line(
                                      start: {"x": newAX + 25, "y": newAY + 25},
                                      end: {"x": newBX + 25, "y": newBY + 25},
                                      color: color,
                                    );
                                  }
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Span length",
                            style: TextStyle(
                                fontSize: 14, color: ColorHelpers.colorGrey)),
                        UIHelper.verticalSpaceSmall,
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.listSpanData.length,
                          itemBuilder: (context, index) {
                            Color color;
                            var e = data.listSpanData[index];
                            if (e.color != null) {
                              color = HexColor.fromHex(e.color!);
                            } else {
                              color = ColorHelpers.colorBlackText;
                            }

                            return InkWell(
                              onTap: () {
                                dialogAlert(e, index);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: color),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 10,
                                                width: 10,
                                                color: color,
                                              ),
                                              UIHelper.horizontalSpaceVerySmall,
                                              Text(e.length.toString() ),
                                            ],
                                          ),
                                          Text("ft"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  Future dialogAlert(SpanDirectionList spanData, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                    'Do yo want to Edit or Delete?',
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
                            color: ColorHelpers.colorRed,
                            onPressed: () {
                              context
                                  .read<SpanProvider>()
                                  .removeListSpanData(index);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: FlatButton(
                            color: ColorHelpers.colorGreen,
                            onPressed: () {
                              Navigator.pop(context);
                              Get.to(InsertSpanWidget(
                                spanData: spanData,
                                index: index,
                                bXCoor: MediaQuery.of(context).size.width / 1.5,
                              ));
                            },
                            child: Text(
                              "Edit",
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
        });
  }
}
