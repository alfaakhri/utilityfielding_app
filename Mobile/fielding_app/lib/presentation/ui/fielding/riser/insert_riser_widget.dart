import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/fielding/riser/riser_widget.dart';
import 'package:fielding_app/presentation/widgets/circle_and_text_painter.dart';
import 'package:fielding_app/presentation/widgets/triangle_and_text_painter.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Position Riser & VGR",
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
        body: Consumer<RiserProvider>(
          builder: (context, data, _) => ListView(
            children: [
              Container(
                height: 250,
                margin: EdgeInsets.all(15),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorHelpers.colorGrey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      height: 250,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/riser.png',
                              scale: 2,
                            ),
                            UIHelper.verticalSpaceSmall,
                            Text("Curb Face / Street Side",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                    ),
                    (data.activePointName.contains("VGR"))
                        ? GestureDetector(
                            onHorizontalDragStart: (detail) {
                              setState(() {
                                this.shapeX = detail.globalPosition.dx;
                              });
                            },
                            onVerticalDragStart: (detail) {
                              setState(() {
                                this.shapeY = detail.globalPosition.dy;
                              });
                            },
                            onHorizontalDragUpdate: (detail) {
                              setState(() {
                                this.shapeX = detail.globalPosition.dx;
                              });
                            },
                            onVerticalDragUpdate: (detail) {
                              setState(() {
                                this.shapeY = detail.globalPosition.dy;
                              });
                            },
                            child: TriangleText(
                                x: this.shapeX,
                                y: this.shapeY,
                                text: data.activePointName),
                          )
                        : GestureDetector(
                            onHorizontalDragStart: (detail) {
                              setState(() {
                                this.shapeX = detail.globalPosition.dx;
                              });
                            },
                            onVerticalDragStart: (detail) {
                              setState(() {
                                this.shapeY = detail.globalPosition.dy;
                              });
                            },
                            onHorizontalDragUpdate: (detail) {
                              setState(() {
                                this.shapeX = detail.globalPosition.dx;
                              });
                            },
                            onVerticalDragUpdate: (detail) {
                              setState(() {
                                this.shapeY = detail.globalPosition.dy;
                              });
                            },
                            child: CircleText(
                              center: {"x": this.shapeX, "y": this.shapeY},
                              radius: 15,
                              text: data.activePointName,
                            ),
                          )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.all(15),
                      onPressed: () {
                        RiserAndVGRList result = RiserAndVGRList(
                            shapeX: this.shapeX,
                            shapeY: this.shapeY,
                            textX: this.shapeX,
                            textY: this.shapeY,
                            name: data.activePointName,
                            value: data.riserVGRSelected.id,
                            type: data.downGuySelected.id);
                        print(result.toJson());
                        data.addListRiserData(result);
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
        ));
  }
}
