import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/constants_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTransformerWidget extends StatefulWidget {
  @override
  _EditTransformerWidgetState createState() => _EditTransformerWidgetState();
}

class _EditTransformerWidgetState extends State<EditTransformerWidget> {
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);
  var textBoldDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12, fontWeight: FontWeight.bold);
  List<String> _listChoice = ["Yes", "No"];
  bool valueDropdown = false;
  TextEditingController kvController = TextEditingController();
  TextEditingController ftController = TextEditingController();

  final formKey = new GlobalKey<FormState>();
  String? choiceValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: ColorHelpers.colorBlueIntro),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Transformer",
                  style: textBoldDefault,
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<FieldingProvider>().setIsTransformer(false);
                  this.choiceValue = null;
                  this.kvController.clear();
                  dialogTransformer("Transformer");
                },
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorHelpers.colorBlueNumber,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("Add", style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 12)),
                ),
              ),
            ],
          ),
          Consumer<FieldingProvider>(
            builder: (context, data, _) => ListView.builder(
              itemCount: data.listTransformer.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var list = data.listTransformer[index];
                return Column(
                  children: [
                    UIHelper.verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Transformer ${index + 1}",
                              style: textDefault,
                            ),
                            Text(
                              "${list.value} kV",
                              style: textDefault,
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              data.setIsTransformer(true);
                              this.choiceValue = "Yes";
                              this.kvController.text = list.value.toString();
                              this.ftController.text = list.hOA.toString();
                            });

                            dialogTransformer("Transformer", index: index);
                          },
                          child: Container(
                            width: 50,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ColorHelpers.colorGreen,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("Edit", style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 12)),
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

  Future dialogTransformer(String title, {int? index}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
                      items: _listChoice.map((value) {
                        return DropdownMenuItem<String>(
                          child: Text(value, style: TextStyle(fontSize: 12)),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          choiceValue = value;
                          if (value!.toLowerCase() == "yes") {
                            data.setIsTransformer(true);
                          } else {
                            data.setIsTransformer(false);
                          }
                        });
                      },
                      value: choiceValue == null ? null : choiceValue,
                    ),
                    UIHelper.verticalSpaceSmall,
                    (data.isTransformer)
                        ? Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: kvController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    suffixText: "kV",
                                    suffixStyle: textDefault,
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(color: ColorHelpers.colorRed)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(color: ColorHelpers.colorGrey.withOpacity(0.3))),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(color: ColorHelpers.colorRed)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(color: ColorHelpers.colorGrey.withOpacity(0.3))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(color: ColorHelpers.colorGrey.withOpacity(0.3))),
                                  ),
                                ),
                              ),
                              //TO-DO HIDE for temporary
                              // UIHelper.horizontalSpaceVerySmall,
                              // Expanded(
                              //   child: TextFormField(
                              //     controller: ftController,
                              //     keyboardType: TextInputType.number,
                              //     validator: (value) {
                              //       if (value == null) {
                              //         return 'Please insert ft value';
                              //       } else if (value == "") {
                              //         return 'Please insert ft value';
                              //       }
                              //       return null;
                              //     },
                              //     decoration: InputDecoration(
                              //       border: InputBorder.none,
                              //       isDense: true,
                              //       suffixText: "ft",
                              //       suffixStyle: textDefault,
                              //       focusedErrorBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide(
                              //               color: ColorHelpers.colorRed)),
                              //       disabledBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide(
                              //               color: ColorHelpers.colorGrey
                              //                   .withOpacity(0.3))),
                              //       errorBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide(
                              //               color: ColorHelpers.colorRed)),
                              //       enabledBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide(
                              //               color: ColorHelpers.colorGrey
                              //                   .withOpacity(0.3))),
                              //       focusedBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(5),
                              //           borderSide: BorderSide(
                              //               color: ColorHelpers.colorGrey
                              //                   .withOpacity(0.3))),
                              //     ),
                              //   ),
                              // ),
                            ],
                          )
                        : Container(),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        child: Text("Save", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              if (!data.isTransformer) {
                                data.removeLisTransformer(index!);
                              } else {
                                if (index != null) {
                                  data.updateListTransformer(
                                      TransformerList(
                                          value: (kvController.text.isEmpty) ? 0 : double.parse(this.kvController.text.replaceAll(",", ".")),
                                          hOA: 0),
                                      index);
                                } else {
                                  data.addlistTransformer(TransformerList(
                                      value: (kvController.text.isEmpty) ? 0 : double.parse(this.kvController.text.replaceAll(",", ".")), hOA: 0));
                                }
                              }

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
