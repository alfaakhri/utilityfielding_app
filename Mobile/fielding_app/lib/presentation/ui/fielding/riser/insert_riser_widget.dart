import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/constants.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/fielding/riser/riser_widget.dart';
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
    Fluttertoast.showToast(msg: "Tap on the box layer to add Riser & VGR", toastLength: Toast.LENGTH_LONG);
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
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(15),
                  child: GestureDetector(
                    onTapDown: (detail) {
                      data.setResultDataRiser(detail.localPosition.dx, detail.localPosition.dy);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorHelpers.colorGrey.withOpacity(0.2)),
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
                        (data.activePointName.contains("VGR"))
                            ? GestureDetector(
                                // onHorizontalDragStart: (detail) {
                                //   setState(() {
                                //     this.shapeX = detail.localPosition.dx;
                                //   });
                                // },
                                // onVerticalDragStart: (detail) {
                                //   setState(() {
                                //     this.shapeY = detail.localPosition.dy;
                                //   });
                                // },
                                // onHorizontalDragUpdate: (detail) {
                                //   setState(() {
                                //     this.shapeX = detail.localPosition.dx;
                                //   });
                                // },
                                // onVerticalDragUpdate: (detail) {
                                //   setState(() {
                                //     this.shapeY = detail.localPosition.dy;
                                //   });
                                // },
                                child: TriangleText(
                                  x: data.resultDataRiser.shapeX,
                                  y: data.resultDataRiser.shapeY,
                                  text: data.activePointName +
                                      "-${data.sequenceCurrent}",
                                ),
                              )
                            : GestureDetector(
                                // onHorizontalDragStart: (detail) {
                                //   setState(() {
                                //     this.shapeX = detail.localPosition.dx;
                                //   });
                                // },
                                // onVerticalDragStart: (detail) {
                                //   setState(() {
                                //     this.shapeY = detail.localPosition.dy;
                                //   });
                                // },
                                // onHorizontalDragUpdate: (detail) {
                                //   setState(() {
                                //     this.shapeX = detail.localPosition.dx;
                                //   });
                                // },
                                // onVerticalDragUpdate: (detail) {
                                //   setState(() {
                                //     this.shapeY = detail.localPosition.dy;
                                //   });
                                // },
                                // child: CircleText(
                                //   center: {"x": this.shapeX, "y": this.shapeY},
                                //   radius: 10,
                                //   text: data.activePointName +
                                //       "-${Constants.alphabet[data.sequenceCurrent - 1]}",
                                // ),
                                child: CircleText(
                                  center: {"x": data.resultDataRiser.shapeX, "y": data.resultDataRiser.shapeY},
                                  radius: 10,
                                  text: data.activePointName +
                                      "-${Constants.alphabet[data.sequenceCurrent - 1]}",
                                ),
                              )
                      ],
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
                          // RiserAndVGRList result = RiserAndVGRList(
                          //     shapeX: this.shapeX,
                          //     shapeY: this.shapeY,
                          //     textX: this.shapeX,
                          //     textY: this.shapeY,
                          //     name: (data.activePointName == "VGR")
                          //         ? data.activePointName +
                          //             "-" +
                          //             data.sequenceCurrent.toString()
                          //         : data.activePointName +
                          //             "-" +
                          //             Constants
                          //                 .alphabet[data.sequenceCurrent - 1],
                          //     value: data.riserVGRSelected.id,
                          //     type: data.downGuySelected.id,
                          //     sequence: data.sequenceCurrent,
                          //     imageType: 0);
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
