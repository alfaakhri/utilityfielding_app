import 'dart:convert';
import 'dart:typed_data';

import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/span_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/service/hex_color.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/fielding/span/insert_span_widget.dart';
import 'package:fielding_app/presentation/widgets/circle_painter.dart';
import 'package:fielding_app/presentation/widgets/line_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
        globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    String base64Image = base64Encode(pngBytes);

    print(pngBytes);
    Map<dynamic, dynamic> result =
        await ImageGallerySaver.saveImage(pngBytes, quality: 100, name: "1234");
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
                  Get.to(InsertSpanWidget());
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
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorHelpers.colorGrey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          height: 250,
                        ),
                        Stack(
                          children: data.listSpanData.map(
                            (e) {
                              if (e.lineData != null) {
                                double aX = double.parse(e.lineData
                                    .replaceAll("[", "")
                                    .replaceAll("]", "")
                                    .split(",")[0]);
                                double aY = double.parse(e.lineData
                                    .replaceAll("[]", "")
                                    .replaceAll("]", "")
                                    .split(",")[1]);
                                double bX = double.parse(e.lineData
                                    .replaceAll("[]", "")
                                    .replaceAll("]", "")
                                    .split(",")[2]);
                                double bY = double.parse(e.lineData
                                    .replaceAll("[]", "")
                                    .replaceAll("]", "")
                                    .split(",")[3]);
                                Color color = HexColor.fromHex(e.color);
                                if (e.imageType == 0 || e.imageType == null) {
                                  return Line(
                                    start: {"x": aX, "y": aY},
                                    end: {"x": bX, "y": bY},
                                    color: color,
                                  );
                                } else {
                                  return Line(
                                    start: {"x": aX + 30, "y": aY + 30},
                                    end: {"x": bX + 30, "y": bY + 30},
                                    color: color,
                                  );
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
                        Text("List Size in Feet",
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
                              color = HexColor.fromHex(e.color);
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
                                              Text(e.length.toString() ?? "-"),
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
