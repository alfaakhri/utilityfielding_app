import 'package:fielding_app/data/models/edit_pole/add_pole_model.dart';
import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/anchor_provider.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/edit_pole/anchor/anchor.exports.dart';
import 'package:fielding_app/presentation/ui/edit_pole/anchor/component/active_anchor_widget.dart';
import 'package:fielding_app/presentation/widgets/circle_and_text_painter.dart';
import 'package:fielding_app/presentation/widgets/circle_painter.dart';
import 'package:fielding_app/presentation/widgets/constants_widget.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AnchorWidget extends StatefulWidget {
  @override
  _AnchorWidgetState createState() => _AnchorWidgetState();
}

class _AnchorWidgetState extends State<AnchorWidget> {
  GlobalKey globalKey = GlobalKey();

  bool isAddAnchor = false;
  bool isShowActiveAnchor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Anchor",
              style:
                  TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorHelpers.colorBlackText,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: ColorHelpers.colorWhite,
        ),
        backgroundColor: Colors.white,
        body: Consumer<AnchorProvider>(
          builder: (context, data, _) => Column(
            children: [
              RepaintBoundary(
                child: Container(
                  height: 250,
                  width: 350,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(15),
                  child: CustomPaint(
                    size: Size(350, 250),
                    child: GestureDetector(
                      onTapDown: (detail) {
                        // if (data.listAnchorData.length > 2) {
                        //   Fluttertoast.showToast(msg: "Anchor max 3");
                        // } else {
                        if (isAddAnchor) {
                          data.checkListAnchorData(
                              detail.localPosition.dx, detail.localPosition.dy);
                          // }
                          setState(() {
                            isAddAnchor = false;
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      ColorHelpers.colorGrey.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 350,
                            height: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/anchor.png',
                                  width: 99,
                                  height: 99,
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: data.listAnchorData.map((e) {
                              double newWidth =
                                  MediaQuery.of(context).size.width;
                              double newHeight =
                                  MediaQuery.of(context).size.height;
                              var fielding =
                                  Provider.of<FieldingProvider>(context);
                              double newX = ((newWidth * e.circleX!) /
                                  fielding.baseWidth);
                              double newY = ((newHeight * e.circleY!) /
                                  fielding.baseHeight);

                              return CustomPaint(
                                size: Size(350, 250),
                                painter: DrawCircleTextAnchor(
                                    center: (e.imageType == 1)
                                        ? {"x": newX + 30, "y": newY + 30}
                                        : {"x": newX, "y": newY},
                                    radius: 10,
                                    text: e.text),
                              );
                            }).toList(),
                          ),
                          Stack(
                            children: data.listAnchorFences.map((e) {
                              var aX =
                                  e.points!.replaceAll("[", "").split(",")[0];

                              double aY = double.parse(e.points!.split(",")[1]);
                              double bX = double.parse(e.points!.split(",")[2]);

                              var bY =
                                  e.points!.replaceAll("]", "").split(",")[3];
                              return CustomPaint(
                                size: Size(350, 250),
                                painter: DrawLine(
                                    start: {"x": double.parse(aX), "y": aY},
                                    end: {"x": bX, "y": double.parse(bY)},
                                    color: ColorHelpers.colorBrown),
                              );
                            }).toList(),
                          ),
                          Stack(
                            children: data.listAnchorStreet.map((e) {
                              var aX =
                                  e.points!.replaceAll("[", "").split(",")[0];

                              double aY = double.parse(e.points!.split(",")[1]);
                              double bX = double.parse(e.points!.split(",")[2]);

                              var bY =
                                  e.points!.replaceAll("]", "").split(",")[3];
                              return CustomPaint(
                                size: Size(350, 250),
                                painter: DrawLine(
                                    start: {"x": double.parse(aX), "y": aY},
                                    end: {"x": bX, "y": double.parse(bY)},
                                    color: Colors.black),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnchorButton(onItemClick: (bool) {
                              setState(() {
                                isAddAnchor = true;
                                isShowActiveAnchor = true;
                                Fluttertoast.showToast(
                                    msg: "Tap on the box layer to add Anchor",
                                    toastLength: Toast.LENGTH_LONG);
                              });
                            }),
                            Row(children: [
                              FenceButton(
                                onItemClick: (bool) {
                                  setState(() {
                                    Get.to(AddFenceStreetWidget(
                                      title: "Fence",
                                      isFence: true,
                                    ));
                                    isShowActiveAnchor = true;
                                  });
                                },
                              ),
                              UIHelper.horizontalSpaceSmall,
                              StreetButton(
                                onItemClick: (bool) {
                                  setState(() {
                                    Get.to(AddFenceStreetWidget(
                                      title: "Street",
                                      isFence: false,
                                    ));
                                    isShowActiveAnchor = true;
                                  });
                                },
                              ),
                            ]),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        (!isShowActiveAnchor)
                            ? Container()
                            : ActiveAnchorWidget(),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
