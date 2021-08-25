import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/edit_pole/edit_pole.exports.dart';
import 'package:fielding_app/presentation/ui/edit_pole/riser/component/active_riser_widget.dart';
import 'package:fielding_app/presentation/widgets/circle_and_text_painter.dart';
import 'package:fielding_app/presentation/widgets/triangle_and_text_painter.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


class RiserWidget extends StatefulWidget {
  @override
  _RiserWidgetState createState() => _RiserWidgetState();
}

class _RiserWidgetState extends State<RiserWidget> {
  GlobalKey globalKey = GlobalKey();
  double shapeX = 25;
  double shapeY = 25;
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);
  bool isShowForm = false;

  TextEditingController selectActivePoint = TextEditingController();
  TextEditingController type = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
        msg: "Tap + to add Riser & VGR", toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Riser & VGR",
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
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: ColorHelpers.colorBlackText),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AddRiserButton();
                    });
              },
            )
          ],
          backgroundColor: ColorHelpers.colorWhite,
        ),
        backgroundColor: Colors.white,
        body: Consumer<RiserProvider>(builder: (context, data, _) {
          return ListView(
            children: [
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  height: 250,
                  margin: EdgeInsets.all(15),
                  child: GestureDetector(
                    onTapDown: (detail) {
                      // RiserAndVGRList result = RiserAndVGRList(
                      //     shapeX: detail.localPosition.dx,
                      //     shapeY: detail.localPosition.dy,
                      //     textX: detail.localPosition.dx,
                      //     textY: detail.localPosition.dy,
                      //     name: (data.activePointName == "VGR")
                      //         ? data.activePointName +
                      //             "-" +
                      //             data.sequenceCurrent.toString()
                      //         : data.activePointName +
                      //             "-" +
                      //             alphabet[data.sequenceCurrent - 1],
                      //     value: data.riserVGRSelected.id,
                      //     type: data.downGuySelected.id,
                      //     sequence: data.sequenceCurrent,
                      //     imageType: 0);
                      // print(result.toJson());
                      // data.addListRiserData(result);
                      // data.clearRiserAndtype();
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
                        Stack(
                          alignment: Alignment.center,
                          children: data.listRiserData.map((e) {
                            var index = data.listRiserData.indexOf(e) + 1;
                            double newWidth = MediaQuery.of(context).size.width;
                            double newHeight =
                                MediaQuery.of(context).size.height;
                            var fielding =
                                Provider.of<FieldingProvider>(context);
                            double newX =
                                ((newWidth * e.shapeX!) / fielding.baseWidth);
                            double newY =
                                ((newHeight * e.shapeY!) / fielding.baseHeight);

                            if (e.value == 4) {
                              if (e.imageType == 1) {
                                return TriangleText(
                                  x: newX + 15,
                                  y: newY + 15,
                                  text: "${e.generalRVGRSeq}.VGR ${e.sequence}",
                                );
                              } else {
                                return TriangleText(
                                  x: newX,
                                  y: newY,
                                  text: "${e.generalRVGRSeq}.VGR ${e.sequence}",
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
                                text:
                                    "${e.generalRVGRSeq}.${alphabet[e.sequence! - 1]}-R$value in",
                              );
                            }
                          }).toList(),
                        ),
                        Stack(
                          children: data.listRiserFence.map((e) {
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
                      ],
                    ),
                  ),
                ),
              ),
              (data.listRiserData.length != 0)
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RiserFenceButton(
                            onItemClick: (bool) {
                              setState(() {
                                Get.to(AddRiserFenceWidget());
                              });
                            },
                          ),
                          UIHelper.verticalSpaceSmall,
                          ActiveRiserWidget(),
                        ],
                      ),
                    )
                  : Container(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "DONE",
                      style: TextStyle(
                          fontSize: 14, color: ColorHelpers.colorWhite),
                    ),
                    color: ColorHelpers.colorButtonDefault),
              ),
            ],
          );
        }));
  }
}
