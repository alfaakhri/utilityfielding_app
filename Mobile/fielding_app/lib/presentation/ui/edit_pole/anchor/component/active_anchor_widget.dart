import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../anchor.exports.dart';

class ActiveAnchorWidget extends StatefulWidget {
  const ActiveAnchorWidget({Key? key}) : super(key: key);

  @override
  _ActiveAnchorWidgetState createState() => _ActiveAnchorWidgetState();
}

class _ActiveAnchorWidgetState extends State<ActiveAnchorWidget> {
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);
  List<String> listChoice = ['Yes', 'No'];

  TextEditingController activeAnchor = TextEditingController();
  TextEditingController distance = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController eyes = TextEditingController();
  TextEditingController textPictureAnchorEye = TextEditingController();
  TextEditingController anchorCondition = TextEditingController();

  bool? isPictureAnchor;

  List<DownGuyList> downGuyList = <DownGuyList>[];
  List<DownGuyList> brokenDownGuyList = <DownGuyList>[];

  @override
  void initState() {
    super.initState();
    var anchor = context.read<AnchorProvider>();
    if (anchor.listAnchorData.length != 0) {
      this.activeAnchor.text = anchor.listAnchorData.first.text!;
      AnchorList _anchor = anchor.getDataAnchorList(this.activeAnchor.text);
      assignValueForm(_anchor);
      anchor.setAnchorActiveSelected(this.activeAnchor.text);
    }
  }

  void assignValueForm(AnchorList data) {
    setState(() {
      this.distance.text = data.distance.toString();

      if (data.eyesPict!) {
        this.textPictureAnchorEye.text = "Yes";
        isPictureAnchor = true;
      } else {
        this.textPictureAnchorEye.text = "No";
        isPictureAnchor = false;
      }
      data.downGuyList!.forEach((element) {
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
    var data = context.read<AnchorProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Select Active Anchor",
          style: TextStyle(fontSize: 14, color: ColorHelpers.colorGrey)),
      UIHelper.verticalSpaceSmall,
      DropdownButtonFormField<String>(
        isDense: true,
        decoration: kDecorationDropdown(),
        items: data.listAnchorData.map((value) {
          return DropdownMenuItem<String>(
            child: Text(value.text!, style: TextStyle(fontSize: 12)),
            value: value.text,
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            this.activeAnchor.text = value!;
            AnchorList _anchor = data.getDataAnchorList(value);
            assignValueForm(_anchor);
            data.setAnchorActiveSelected(value);
          });
        },
        value: (this.activeAnchor.text.isEmpty)
            ? null
            : this.activeAnchor.text.toString(),
      ),
      (this.activeAnchor.text.isNotEmpty)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpaceSmall,
                _textFormWidget(this.distance, "Distance from Pole"),
                UIHelper.verticalSpaceSmall,
                Text("Anchor Size",
                    style:
                        TextStyle(fontSize: 14, color: ColorHelpers.colorGrey)),
                UIHelper.verticalSpaceSmall,
                DropdownButtonFormField<String>(
                  isDense: true,
                  decoration: kDecorationDropdown(),
                  items: data.listAllAnchorSize!.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.text!, style: TextStyle(fontSize: 12)),
                      value: value.text,
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      this.size.text = value!;

                      data.setAnchorSizeSelected(value);
                    });
                  },
                  value: (data.anchorSizeSelected.text == null)
                      ? null
                      : data.anchorSizeSelected.text,
                ),
                UIHelper.verticalSpaceSmall,
                Text("Anchor Eyes",
                    style:
                        TextStyle(fontSize: 14, color: ColorHelpers.colorGrey)),
                UIHelper.verticalSpaceSmall,
                DropdownButtonFormField<String>(
                  isDense: true,
                  decoration: kDecorationDropdown(),
                  items: data.listAnchorEyesModel!.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.text!, style: TextStyle(fontSize: 12)),
                      value: value.text,
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      this.eyes.text = value!;

                      data.setAnchorEyesSelected(value);
                    });
                  },
                  value: (data.anchorEyesSelected.text == null)
                      ? null
                      : data.anchorEyesSelected.text,
                ),
                UIHelper.verticalSpaceSmall,
                Text("Picture of anchor eyes",
                    style:
                        TextStyle(fontSize: 14, color: ColorHelpers.colorGrey)),
                UIHelper.verticalSpaceSmall,
                DropdownButtonFormField<String>(
                  isDense: true,
                  decoration: kDecorationDropdown(),
                  items: listChoice.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value, style: TextStyle(fontSize: 12)),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      this.textPictureAnchorEye.text = value!;
                      if (value == "Yes") {
                        this.isPictureAnchor = true;
                      } else {
                        this.isPictureAnchor = false;
                      }
                    });
                  },
                  value: (this.textPictureAnchorEye.text.isEmpty)
                      ? null
                      : this.textPictureAnchorEye.text.toString(),
                ),
                UIHelper.verticalSpaceSmall,
                Text("Condition",
                    style:
                        TextStyle(fontSize: 14, color: ColorHelpers.colorGrey)),
                UIHelper.verticalSpaceSmall,
                DropdownButtonFormField<String>(
                  isDense: true,
                  decoration: kDecorationDropdown(),
                  items: data.listAnchorCondition.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.text!, style: TextStyle(fontSize: 12)),
                      value: value.text,
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      this.anchorCondition.text = value!;
                      data.setAnchorConditionSelected(value);
                    });
                  },
                  value: (data.anchorConditionSelected!.text == null)
                      ? null
                      : data.anchorConditionSelected!.text.toString(),
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
                                  fontSize: 14, color: ColorHelpers.colorWhite),
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
                                size: data.anchorSizeSelected.id,
                                eyes: data.anchorEyesSelected.id,
                                isPicture: this.isPictureAnchor,
                                anchorCondition:
                                    data.anchorConditionSelected!.id);
                            Fluttertoast.showToast(
                                msg: "Anchor have been updated");
                            setState(() {
                              this.activeAnchor.clear();
                            });
                          },
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontSize: 14, color: ColorHelpers.colorWhite),
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
              style: TextStyle(fontSize: 14, color: ColorHelpers.colorWhite),
            ),
            color: ColorHelpers.colorButtonDefault),
      ),
    ]);
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
