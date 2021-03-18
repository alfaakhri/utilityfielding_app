import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/anchor_provider.dart';
import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/fielding/anchor/edit_downguy_widget.dart';
import 'package:fielding_app/presentation/widgets/circle_and_text_painter.dart';
import 'package:fielding_app/presentation/widgets/circle_painter.dart';
import 'package:fielding_app/presentation/widgets/constants_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AnchorWidget extends StatefulWidget {
  @override
  _AnchorWidgetState createState() => _AnchorWidgetState();
}

class _AnchorWidgetState extends State<AnchorWidget> {
  double shapeX = 25;
  double shapeY = 25;
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);

  TextEditingController activeAnchor = TextEditingController();
  TextEditingController distance = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController eyes = TextEditingController();
  TextEditingController textPictureAnchorEye = TextEditingController();

  bool isPictureAnchor;

  List<DownGuyList> downGuyList = List<DownGuyList>();
  List<DownGuyList> brokenDownGuyList = List<DownGuyList>();
  List<String> listChoice = ['Yes', 'No'];

  void assignValueForm(AnchorList data) {
    setState(() {
      this.distance.text = data.distance.toString();
      this.size.text = data.size.toString();
      this.eyes.text = data.anchorEye.toString();
      if (data.eyesPict) {
        this.textPictureAnchorEye.text = "Yes";
        isPictureAnchor = true;
      } else {
        this.textPictureAnchorEye.text = "No";
        isPictureAnchor = false;
      }
      data.downGuyList.forEach((element) {
        if (element.type == 0) {
          downGuyList.add(element);
        } else {
          brokenDownGuyList.add(element);
        }
      });
    });
  }

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
                  margin: EdgeInsets.all(15),
                  child: GestureDetector(
                    onTapDown: (detail) {
                      if (data.listAnchorData.length > 2) {
                        Fluttertoast.showToast(msg: "Anchor max 3");
                      } else {
                        data.addListAnchorData(
                            detail.globalPosition.dx, detail.globalPosition.dy);
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorHelpers.colorGrey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: CustomPaint(
                            size: Size(MediaQuery.of(context).size.width, 250),
                            painter: DrawCircle(center: {
                              "x": MediaQuery.of(context).size.width - 30,
                              "y": 225
                            }, radius: 15),
                          ),
                        ),
                        Stack(
                          children: data.listAnchorData.map((e) {
                            return CustomPaint(
                              size:
                                  Size(MediaQuery.of(context).size.width, 250),
                              painter: DrawCircleTextAnchor(center: {
                                "x": e.circleX - 10,
                                "y": e.circleY - 100
                                //Dari web
                                // "x": e.circleX ,
                                // "y": e.circleY + 30
                              }, radius: 15, text: e.text),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(
                      children: [
                        Text("Select Active Anchor",
                            style: TextStyle(
                                fontSize: 14, color: ColorHelpers.colorGrey)),
                        UIHelper.verticalSpaceSmall,
                        DropdownButtonFormField<String>(
                          isDense: true,
                          decoration: kDecorationDropdown(),
                          items: data.listAnchorData.map((value) {
                            return DropdownMenuItem<String>(
                              child: Text(value.text,
                                  style: TextStyle(fontSize: 12)),
                              value: value.text,
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {
                              this.activeAnchor.text = value;
                              AnchorList _anchor =
                                  data.getDataAnchorList(value);
                              assignValueForm(_anchor);
                              data.setAnchorActiveSelected(value);
                            });
                          },
                          value: (this.activeAnchor.text == null ||
                                  this.activeAnchor.text == "")
                              ? null
                              : this.activeAnchor.text.toString(),
                        ),
                        (this.activeAnchor.text != "")
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UIHelper.verticalSpaceSmall,
                                  _textFormWidget(
                                      this.distance, "Distance from Pole"),
                                  UIHelper.verticalSpaceSmall,
                                  _textFormWidget(this.size, "Anchor Size"),
                                  UIHelper.verticalSpaceSmall,
                                  _textFormWidget(this.eyes, "Anchor Eyes"),
                                  UIHelper.verticalSpaceSmall,
                                  Text("Picture of anchor eyes",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorHelpers.colorGrey)),
                                  UIHelper.verticalSpaceSmall,
                                  DropdownButtonFormField<String>(
                                    isDense: true,
                                    decoration: kDecorationDropdown(),
                                    items: listChoice.map((value) {
                                      return DropdownMenuItem<String>(
                                        child: Text(value,
                                            style: TextStyle(fontSize: 12)),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String value) {
                                      setState(() {
                                        this.textPictureAnchorEye.text = value;
                                        if (value == "Yes") {
                                          this.isPictureAnchor = true;
                                        } else {
                                          this.isPictureAnchor = false;
                                        }
                                      });
                                    },
                                    value: (this.textPictureAnchorEye.text ==
                                                null ||
                                            this.textPictureAnchorEye.text ==
                                                "")
                                        ? null
                                        : this
                                            .textPictureAnchorEye
                                            .text
                                            .toString(),
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  EditDownguyWidget(
                                    type: false,
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  EditDownguyWidget(
                                    type: true,
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
                                                dialogDelete(data);
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
                                              data.updateDataAnchorList(
                                                  distance: this.distance.text,
                                                  size: this.size.text,
                                                  eyes: this.eyes.text,
                                                  isPicture:
                                                      this.isPictureAnchor);
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Anchor have been updated");
                                              setState(() {
                                                this.activeAnchor.clear();
                                              });
                                            },
                                            child: Text(
                                              "SAVE",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      ColorHelpers.colorWhite),
                                            ),
                                            color: ColorHelpers.colorGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        UIHelper.verticalSpaceMedium,
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                              padding: EdgeInsets.all(10),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                "DONE",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorHelpers.colorWhite),
                              ),
                              color: ColorHelpers.colorButtonDefault),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  Widget _textFormWidget(TextEditingController controller, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 14, color: ColorHelpers.colorGrey)),
        UIHelper.verticalSpaceSmall,
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null) {
              return 'Please insert ${title.toLowerCase()}';
            } else if (value == "") {
              return 'Please insert ${title.toLowerCase()}';
            }
            return null;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            suffixText: "ft",
            suffixStyle: TextStyle(fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorHelpers.colorGrey.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorHelpers.colorGrey.withOpacity(0.2)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorHelpers.colorRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorHelpers.colorRed),
            ),
          ),
        ),
      ],
    );
  }

  Future dialogDelete(AnchorProvider data) {
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
                    'Are you sure delete this active anchor?',
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
                              setState(() {
                                data.removeDataAnchorList();
                                this.activeAnchor.clear();
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
