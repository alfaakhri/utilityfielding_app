import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
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
  var textBoldDefault = TextStyle(
      color: ColorHelpers.colorBlackText,
      fontSize: 12,
      fontWeight: FontWeight.bold);
  bool valueDropdown = false;
  TextEditingController ftController = TextEditingController();
  TextEditingController inchController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  String? choiceValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: ColorHelpers.colorWhite),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "HOA",
                  style: textBoldDefault,
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<FieldingProvider>().setIsHoa(false);
                  this.choiceValue = null;
                  this.ftController.clear();
                  this.inchController.clear();
                  dialogHoa("HOA Type", false);
                },
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorHelpers.colorBlueNumber,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("Add",
                      style: TextStyle(
                          color: ColorHelpers.colorWhite, fontSize: 12)),
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

                String? typeName = data.listAllHoaType!
                    .firstWhere((element) => element.id == list.type)
                    .text;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelper.verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "HOA ${index + 1}",
                                style: textDefault,
                              ),
                              Text(
                                "$typeName",
                                style: textDefault,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                width:
                                    (MediaQuery.of(context).size.width - 52) /
                                        2,
                                height: 1,
                                color: ColorHelpers.colorBlackLine
                              ),
                              Text(
                                "Hight Of Attachment",
                                style: textDefault,
                              ),
                              Text(
                                "${list.poleLengthInFeet} ft, ${list.poleLengthInInch} inch",
                                style: textDefault,
                              ),
                            ],
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        Row(
                          children: [
                            Container(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    data.removeHoaList(index);
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: ColorHelpers.colorRed,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text("Delete",
                                      style: TextStyle(
                                          color: ColorHelpers.colorWhite,
                                          fontSize: 12)),
                                ),
                              ),
                            ),
                            UIHelper.horizontalSpaceSmall,
                            Container(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    data.setIsHoa(true);
                                    this.ftController.text =
                                        list.poleLengthInFeet.toString();
                                    this.inchController.text =
                                        list.poleLengthInInch.toString();
                                    data.setHoaSelected(typeName);
                                  });

                                  dialogHoa("Hoa Type", true, index: index);
                                },
                                child: Container(
                                  width: 50,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: ColorHelpers.colorGreen,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text("Edit",
                                      style: TextStyle(
                                          color: ColorHelpers.colorWhite,
                                          fontSize: 12)),
                                ),
                              ),
                            ),
                          ],
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

  Future dialogHoa(String title, bool isEdit, {int? index}) {
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
                      items: data.listAllHoaType!.map((value) {
                        return DropdownMenuItem<String>(
                          child:
                              Text(value.text!, style: TextStyle(fontSize: 12)),
                          value: value.text,
                        );
                      }).toList(),
                      onChanged: (String? value) {
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
                                "Hight Of Attachment",
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
                                          return 'Please insert hight of attachment';
                                        } else if (value == "") {
                                          return 'Please insert hight of attachment';
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
                          if (formKey.currentState!.validate()) {
                            Provider.of<FieldingProvider>(context,
                                    listen: false)
                                .setIsHoa(false);

                            if (isEdit) {
                              setState(() {
                                data.updateHoaList(
                                    HOAList(
                                        type: data.hoaSelected.id,
                                        poleLengthInInch: double.parse(
                                            this.inchController.text),
                                        poleLengthInFeet: double.parse(
                                            this.ftController.text)),
                                    index);
                              });
                            } else {
                              setState(() {
                                data.addHoaList(HOAList(
                                    type: data.hoaSelected.id,
                                    poleLengthInInch:
                                        double.parse(this.inchController.text),
                                    poleLengthInFeet:
                                        double.parse(this.ftController.text)));
                              });
                            }
                            data.clearHoaSelected();

                            Navigator.pop(context);
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
