import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/circle_and_text_painter.dart';
import 'package:fielding_app/presentation/widgets/triangle_and_text_painter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class InsertRiserWidget extends StatefulWidget {
  @override
  _InsertRiserWidgetState createState() => _InsertRiserWidgetState();
}

class _InsertRiserWidgetState extends State<InsertRiserWidget> {
  double shapeX = 25;
  double shapeY = 25;

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
        msg: "Tap on the box layer to add Riser & VGR",
        toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<RiserProvider>().removeListActivePoint();
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Edit Position Riser & VGR",
                style: TextStyle(
                    color: ColorHelpers.colorBlackText, fontSize: 14)),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorHelpers.colorBlackText,
              ),
              onPressed: () {
                context.read<RiserProvider>().removeListActivePoint();
                Get.back();
              },
            ),
            backgroundColor: ColorHelpers.colorWhite,
          ),
          backgroundColor: Colors.white,
          body: Consumer<RiserProvider>(
            builder: (context, data, _) => ListView(
              children: [
                Container(
                  height: 250,
                  width: 350,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(15),
                  child: CustomPaint(
                    size: Size(350, 250),
                    child: GestureDetector(
                      onTapDown: (detail) {
                        data.setResultDataRiser(
                            detail.localPosition.dx, detail.localPosition.dy + 15);
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
                                  'assets/riser.png',
                                  width: 199,
                                  height: 199,
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: data.listRiserData.map((e) {
                              double newWidth =
                                  MediaQuery.of(context).size.width;
                              double newHeight =
                                  MediaQuery.of(context).size.height;
                              var fielding =
                                  Provider.of<FieldingProvider>(context);
                              double newX =
                                  ((newWidth * e.shapeX!) / fielding.baseWidth);
                              double newY = ((newHeight * e.shapeY!) /
                                  fielding.baseHeight);

                              if (e.value == 4) {
                                if (e.imageType == 1) {
                                  return TriangleText(
                                    x: newX + 15,
                                    y: newY + 15,
                                    text: "VGR-${e.sequence}",
                                  );
                                } else {
                                  return TriangleText(
                                    x: newX,
                                    y: newY,
                                    text: "VGR-${e.sequence}",
                                  );
                                }
                              } else {
                                var value = Provider.of<RiserProvider>(context)
                                    .valueType(e.value);
                                return CircleText(
                                  center: (e.imageType == 1)
                                      ? (newWidth > 360)
                                          ? {"x": newX + 25, "y": newY + 25}
                                          : {"x": newX + 15, "y": newY + 25}
                                      : {"x": newX, "y": newY},
                                  radius: 10,
                                  text: "R$value-${alphabet[e.sequence! - 1]}",
                                );
                              }
                            }).toList(),
                          ),
                          (data.activePointName!.contains("VGR"))
                              ? TriangleText(
                                x: data.resultDataRiser.shapeX,
                                y: data.resultDataRiser.shapeY,
                                text: data.activePointName! +
                                    "-${data.sequenceCurrent}",
                              )
                              : CircleText(
                                center: {
                                  "x": data.resultDataRiser.shapeX,
                                  "y": data.resultDataRiser.shapeY
                                },
                                radius: 10,
                                text: data.activePointName! +
                                    "-${alphabet[data.sequenceCurrent! - 1]}",
                              )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        padding: EdgeInsets.all(15),
                        onPressed: () {
                          print(data.resultDataRiser.toJson());
                          data.addListRiserData(data.resultDataRiser);
                          data.clearRiserAndtype();

                          Get.back();
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 14, color: ColorHelpers.colorWhite),
                        ),
                        color: ColorHelpers.colorButtonDefault,
                      ),
                    )),
              ],
            ),
          )),
    );
  }
}
