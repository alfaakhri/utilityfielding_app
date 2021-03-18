import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/constants_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class EditHoaWidget extends StatefulWidget {
  @override
  _EditHoaWidgetState createState() => _EditHoaWidgetState();
}

class _EditHoaWidgetState extends State<EditHoaWidget> {
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);
  bool valueDropdown = false;
  TextEditingController ftController = TextEditingController();
  TextEditingController inchController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  String choiceValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "HOA",
                  style: textDefault,
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<FieldingProvider>().setIsHoa(false);
                  this.choiceValue = null;
                  this.ftController.clear();
                  this.inchController.clear();
                  dialogHoa("HOA Type");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.add,
                      color: ColorHelpers.colorBlueNumber,
                      size: 14,
                    ),
                    UIHelper.horizontalSpaceVerySmall,
                    Text(
                      "Add HOA",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorHelpers.colorBlueNumber,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Consumer<FieldingProvider>(
            builder: (context, data, _) => ListView.builder(
              itemCount: data.hoaList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var list = data.hoaList[index];

                String typeName = data.listAllHoaType
                    .firstWhere((element) => element.id == list.type)
                    .text;
                return Column(
                  children: [
                    UIHelper.verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "HOA ${index + 1}",
                          style: textDefault,
                        ),
                        Text(
                          "$typeName",
                          style: textDefault,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pole Lenght",
                          style: textDefault,
                        ),
                        Text(
                          "${list.poleLengthInFeet} ft, ${list.poleLengthInInch} inch",
                          style: textDefault,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  data.removeHoaList(index);
                                });
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              color: ColorHelpers.colorRed,
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        Expanded(
                          child: Container(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  data.setIsHoa(true);
                                  this.ftController.text =
                                      list.poleLengthInFeet.toString();
                                  this.inchController.text = list.poleLengthInInch.toString();
                                  data.setHoaSelected(typeName);
                                });

                                dialogHoa(
                                  "Hoa Type",
                                );
                              },
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              color: ColorHelpers.colorGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceVerySmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future dialogHoa(String title) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            content: Consumer<FieldingProvider>(
              builder: (context, data, _) => Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: textDefault,
                    ),
                    UIHelper.verticalSpaceSmall,
                    DropdownButtonFormField<String>(
                      isDense: true,
                      decoration: kDecorationDropdown(),
                      items: data.listAllHoaType.map((value) {
                        return DropdownMenuItem<String>(
                          child:
                              Text(value.text, style: TextStyle(fontSize: 12)),
                          value: value.text,
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          choiceValue = value;
                          data.setIsHoa(true);
                          data.setHoaSelected(value);
                        });
                      },
                      value: data.hoaSelected.text == null
                          ? null
                          : data.hoaSelected.text,
                    ),
                    UIHelper.verticalSpaceSmall,
                    (data.isHoa)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pole Lenght",
                                style: textDefault,
                              ),
                              UIHelper.verticalSpaceSmall,
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: ftController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please insert pole lenght';
                                        } else if (value == "") {
                                          return 'Please insert pole lenght';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        suffixText: "ft",
                                        suffixStyle: textDefault,
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorRed)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorGrey
                                                    .withOpacity(0.3))),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorRed)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorGrey
                                                    .withOpacity(0.3))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorGrey
                                                    .withOpacity(0.3))),
                                      ),
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceVerySmall,
                                  Expanded(
                                    child: TextFormField(
                                      controller: inchController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please insert inch';
                                        } else if (value == "") {
                                          return 'Please insert inch';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        suffixText: "inch",
                                        suffixStyle: textDefault,
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorRed)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorGrey
                                                    .withOpacity(0.3))),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorRed)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorGrey
                                                    .withOpacity(0.3))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: ColorHelpers.colorGrey
                                                    .withOpacity(0.3))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              UIHelper.verticalSpaceSmall,
                            ],
                          )
                        : Container(),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        child:
                            Text("Save", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            Provider.of<FieldingProvider>(context,
                                    listen: false)
                                .setIsHoa(false);

                            setState(() {
                              data.addHoaList(HOAList(
                                  type: data.hoaSelected.id,
                                  poleLengthInInch: double.parse(this.inchController.text),
                                  poleLengthInFeet:
                                      double.parse(this.ftController.text)));
                              data.clearHoaSelected();
                              Navigator.pop(context);
                            });
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
}
