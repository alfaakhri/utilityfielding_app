import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/constants.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/circle_and_text_painter.dart';
import 'package:fielding_app/presentation/widgets/circle_painter.dart';
import 'package:fielding_app/presentation/widgets/constants_widget.dart';
import 'package:fielding_app/presentation/widgets/triangle_and_text_painter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'insert_riser_widget.dart';

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
  // TextEditingController sizeRiser = TextEditingController();
  TextEditingController type = TextEditingController();
  final formKey = new GlobalKey<FormState>();

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
                dialogAlertDropdown();
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
                      //             Constants.alphabet[data.sequenceCurrent - 1],
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
                            double newWidth = MediaQuery.of(context).size.width;
                            double newHeight =
                                MediaQuery.of(context).size.height;
                            var fielding =
                                Provider.of<FieldingProvider>(context);
                            double newX =
                                ((newWidth * e.shapeX) / fielding.baseWidth);
                            double newY =
                                ((newHeight * e.shapeY) / fielding.baseHeight);

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
                                text:
                                    "R$value-${Constants.alphabet[e.sequence - 1]}",
                              );
                            }
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
                          Text("Select Active Point",
                              style: TextStyle(
                                  fontSize: 14, color: ColorHelpers.colorGrey)),
                          UIHelper.verticalSpaceSmall,
                          DropdownButtonFormField<String>(
                            isDense: true,
                            decoration: kDecorationDropdown(),
                            items: data.listRiserData.map((value) {
                              return DropdownMenuItem<String>(
                                child: Text(value.name,
                                    style: TextStyle(fontSize: 12)),
                                value: value.name,
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                this.selectActivePoint.text = value;
                                data.searchTypeByPointName(value);
                              });
                            },
                            value: (this.selectActivePoint.text == null ||
                                    this.selectActivePoint.text == "")
                                ? null
                                : this.selectActivePoint.text.toString(),
                          ),
                          (this.selectActivePoint.text == null ||
                                  this.selectActivePoint.text == "")
                              ? Container()
                              : Column(
                                  children: [
                                    UIHelper.verticalSpaceSmall,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Type",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: ColorHelpers.colorGrey)),
                                        UIHelper.verticalSpaceSmall,
                                        DropdownButtonFormField<String>(
                                          isDense: true,
                                          decoration: kDecorationDropdown(),
                                          items: data.listDownGuyOwner
                                              .map((value) {
                                            return DropdownMenuItem<String>(
                                              child: Text(value.text.toString(),
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              value: value.text.toString(),
                                            );
                                          }).toList(),
                                          onChanged: (String value) {
                                            setState(() {
                                              data.setDownGuySelected(value);
                                              this.type.text = value;
                                            });
                                          },
                                          value:
                                              (data.downGuySelected.id == null)
                                                  ? null
                                                  : data.downGuySelected.text
                                                      .toString(),
                                        )
                                      ],
                                    ),
                                    UIHelper.verticalSpaceSmall,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            child: RaisedButton(
                                                padding: EdgeInsets.all(10),
                                                onPressed: () {
                                                  dialogDelete(
                                                      this
                                                          .selectActivePoint
                                                          .text,
                                                      data);
                                                },
                                                child: Text(
                                                  "DELETE",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: ColorHelpers
                                                          .colorWhite),
                                                ),
                                                color: ColorHelpers.colorRed),
                                          ),
                                        ),
                                        UIHelper.horizontalSpaceSmall,
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            child: RaisedButton(
                                              padding: EdgeInsets.all(10),
                                              onPressed: () {
                                                data.editListRiserData(
                                                    this.selectActivePoint.text,
                                                    data.downGuySelected.id);
                                                data.clearRiserAndtype();
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Active point have been updated");
                                                setState(() {
                                                  this
                                                      .selectActivePoint
                                                      .clear();
                                                });
                                              },
                                              child: Text(
                                                "SAVE",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: ColorHelpers
                                                        .colorWhite),
                                              ),
                                              color: ColorHelpers.colorGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                        ],
                      ))
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

  Future dialogAlertDropdown() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            content: Consumer<RiserProvider>(
              builder: (context, data, _) => Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Riser And VGR Location",
                      style: textDefault,
                    ),
                    UIHelper.verticalSpaceSmall,
                    DropdownButtonFormField<String>(
                      isDense: true,
                      validator: (value) {
                        if (value == null) {
                          return 'Please choose one';
                        } else if (value == "") {
                          return 'Please choose one';
                        }
                        return null;
                      },
                      decoration: kDecorationDropdown(),
                      items: data.listRiser.map((value) {
                        return DropdownMenuItem<String>(
                          child: Text(value.text.toString(),
                              style: TextStyle(fontSize: 12)),
                          value: value.text.toString(),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          data.setRiserVGRSelected(value);
                        });
                      },
                      value: (data.riserVGRSelected.id == null)
                          ? null
                          : data.riserVGRSelected.text.toString(),
                    ),
                    UIHelper.verticalSpaceSmall,
                    Text(
                      "Type",
                      style: textDefault,
                    ),
                    UIHelper.verticalSpaceSmall,
                    DropdownButtonFormField<String>(
                      isDense: true,
                      validator: (value) {
                        if (value == null) {
                          return 'Please insert type';
                        } else if (value == "") {
                          return 'Please insert type';
                        }
                        return null;
                      },
                      decoration: kDecorationDropdown(),
                      items: data.listDownGuyOwner.map((value) {
                        return DropdownMenuItem<String>(
                          child: Text(value.text.toString(),
                              style: TextStyle(fontSize: 12)),
                          value: value.text.toString(),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          data.setDownGuySelected(value);
                        });
                      },
                      value: (data.downGuySelected.id == null)
                          ? null
                          : data.downGuySelected.text.toString(),
                    ),
                    UIHelper.verticalSpaceSmall,
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        child:
                            Text("Save", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            data.setListActivePoint(data.riserVGRSelected.text);
                            Navigator.of(context).pop();
                            // Fluttertoast.showToast(msg: "Please tap Riser/VGR in canvas");
                            Get.to(InsertRiserWidget());
                          }
                        },
                        color: ColorHelpers.colorButtonDefault,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future dialogDelete(String pointName, RiserProvider data) {
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
                    'Are you sure delete this active point?',
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
                              Navigator.pop(context);
                            },
                            child: Text(
                              "No",
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
                              Fluttertoast.showToast(
                                  msg: "Active point have been deleted");
                              data.removeDataActivePoint(pointName);
                              data.clearRiserAndtype();
                              setState(() {
                                this.selectActivePoint.clear();
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Yes",
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
