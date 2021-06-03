import 'package:fielding_app/data/models/edit_pole/add_pole_model.dart';
import 'package:fielding_app/data/models/edit_pole/all_down_guy_owner.dart';
import 'package:fielding_app/data/models/edit_pole/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/anchor_provider.dart';
import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/constants_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditDownguyWidget extends StatefulWidget {
  final bool? type;

  const EditDownguyWidget({this.type});

  @override
  _EditDownguyWidgetState createState() => _EditDownguyWidgetState();
}

class _EditDownguyWidgetState extends State<EditDownguyWidget> {
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);
  TextEditingController sizeDg = TextEditingController();
  TextEditingController hoa = TextEditingController();
  TextEditingController hoaOwner = TextEditingController();
  TextEditingController textInsulated = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  bool? isPictureAnchor;
  bool? isInsulated;

  List<DownGuyList> downGuyList = <DownGuyList>[];
  List<DownGuyList> brokenDownGuyList = <DownGuyList>[];
  List<String> listChoice = ['Yes', 'No'];

  @override
  void initState() {
    super.initState();
    // if (widget.anchorData.text != null) {
    //   if (widget.anchorData.downGuyList.length != 0) {
    //     if (widget.type) {
    //       brokenDownGuyList = widget.anchorData.downGuyList
    //           .where((element) => element.type == 1).toList();
    //     } else {
    //       downGuyList = widget.anchorData.downGuyList
    //           .where((element) => element.type == 0).toList();
    //     }
    //   }
    // }
  }

  _validator(String? value, String textWarning) {
    if (value == null) {
      return 'Please insert $textWarning';
    } else if (value.isEmpty) {
      return 'Please insert $textWarning';
    } else if (value == "0.00") {
      return 'Please insert $textWarning';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  (!widget.type!) ? "DG" : "Broken DG",
                  style: textDefault,
                ),
              ),
              InkWell(
                onTap: () {
                  if (!widget.type!) {
                    dialogDg(0);
                  } else {
                    dialogDg(1);
                  }
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
                      (!widget.type!) ? "Add DG" : "Add Broken DG",
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
          (Provider.of<AnchorProvider>(context)
                      .anchorActiveSelected
                      .downGuyList!
                      .length !=
                  0)
              ? (!widget.type!)
                  ? _listDownGuy(false)
                  : _listDownGuy(true)
              : Container(),
        ],
      ),
    );
  }

  Widget _listDownGuy(bool type) {
    return Consumer<RiserProvider>(
      builder: (context, riser, _) => Consumer<AnchorProvider>(
        builder: (context, anchor, _) => ListView.builder(
          itemCount: (!type)
              ? anchor.anchorActiveSelected.downGuyList!
                  .where((element) => element.type == 0)
                  .toList()
                  .length
              : anchor.anchorActiveSelected.downGuyList!
                  .where((element) => element.type == 1)
                  .toList()
                  .length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            List<DownGuyList> downGuyList;
            List<DownGuyList> brokenDownGuyList;
            DownGuyList dataDownGuy;
            //Filtering untuk menampilkan list type == 0 & type == 1 (broken)
            if (type) {
              dataDownGuy = anchor.anchorActiveSelected.downGuyList!
                  .where((element) => element.type == 1)
                  .toList()[index];
            } else {
              dataDownGuy = anchor.anchorActiveSelected.downGuyList!
                  .where((element) => element.type == 0)
                  .toList()[index];
            }
            //Mengambil text value dari downGuyOwner
            AllDownGuyOwnerModel downGuy =
                riser.getNameDownGuySelected(dataDownGuy.owner);

            return InkWell(
              onTap: () {
                // if (!widget.type) {
                //   dialogDg(0);
                // } else {
                //   dialogDg(1);
                // }
                // setState(() {});
              },
              child: Column(
                children: [
                  UIHelper.verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DG ${index + 1}",
                            style: textDefault,
                          ),
                          Text(
                            "DG Size",
                            style: textDefault,
                          ),
                          Text(
                            "HOA Size",
                            style: textDefault,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${downGuy.text}",
                                style: textDefault,
                              ),
                              Text(
                                "${anchor.getValueDownGuySize(dataDownGuy.size, dataDownGuy.type)}",
                                style: textDefault,
                              ),
                              Text(
                                "${dataDownGuy.hOA} ft",
                                style: textDefault,
                              )
                            ],
                          ),
                          UIHelper.horizontalSpaceSmall,
                          InkWell(
                              onTap: () {
                                setState(() {
                                  anchor.removeDownGuyByAnchor(dataDownGuy);
                                });
                              },
                              child: Image.asset(
                                'assets/delete.png',
                                scale: 4.5,
                              )),
                        ],
                      ),
                    ],
                  ),
                  UIHelper.verticalSpaceVerySmall,
                  Divider(
                    color: ColorHelpers.colorBlackText,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future dialogDg(int type) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            content: Consumer<AnchorProvider>(
              builder: (context, anchor, _) => Consumer<RiserProvider>(
                builder: (context, data, _) => Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("DG Size",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorHelpers.colorGrey)),
                            UIHelper.verticalSpaceSmall,
                            (type == 0)
                                ? DropdownButtonFormField<String>(
                                    isDense: true,
                                    validator: (value) =>
                                        _validator(value, "dg size"),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: kDecorationDropdown(),
                                    items: anchor.listDownGuySize!.map((value) {
                                      return DropdownMenuItem<String>(
                                        child: Text(value.text!,
                                            style: TextStyle(fontSize: 12)),
                                        value: value.text,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        anchor.setDownGuySelected(value);
                                        this.sizeDg.text = value!;
                                      });
                                    },
                                    value: anchor.downGuySelected.text == null
                                        ? null
                                        : anchor.downGuySelected.text,
                                  )
                                : DropdownButtonFormField<String>(
                                    isDense: true,
                                    validator: (value) =>
                                        _validator(value, "dg size"),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: kDecorationDropdown(),
                                    items: anchor.listBrokenDownGuySize!
                                        .map((value) {
                                      return DropdownMenuItem<String>(
                                        child: Text(value.text!,
                                            style: TextStyle(fontSize: 12)),
                                        value: value.text,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        anchor.setBrokenDownGuySelected(value);
                                        this.sizeDg.text = value!;
                                      });
                                    },
                                    value: anchor.brokendownGuySelected.text ==
                                            null
                                        ? null
                                        : anchor.brokendownGuySelected.text,
                                  ),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("HOA Size",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorHelpers.colorGrey)),
                            UIHelper.verticalSpaceSmall,
                            TextFormField(
                              controller: this.hoa,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  _validator(value, "hoa size"),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                suffixText: "ft",
                                suffixStyle: TextStyle(fontSize: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorHelpers.colorGrey
                                          .withOpacity(0.2)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorHelpers.colorGrey
                                          .withOpacity(0.2)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorHelpers.colorRed),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorHelpers.colorRed),
                                ),
                              ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        Text(
                          "DG HOA Owner",
                          style: textDefault,
                        ),
                        UIHelper.verticalSpaceSmall,
                        DropdownButtonFormField<String>(
                          isDense: true,
                          validator: (value) => _validator(value, "hoa owner"),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: kDecorationDropdown(),
                          items: data.listDownGuyOwner!.map((value) {
                            return DropdownMenuItem<String>(
                              child: Text(value.text!,
                                  style: TextStyle(fontSize: 12)),
                              value: value.text,
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              data.setDownGuySelected(value);
                              this.hoaOwner.text = value!;
                            });
                          },
                          value: data.downGuySelected.text == null
                              ? null
                              : data.downGuySelected.text,
                        ),
                        UIHelper.verticalSpaceSmall,
                        Text("Insulated",
                            style: TextStyle(
                                fontSize: 14, color: ColorHelpers.colorGrey)),
                        UIHelper.verticalSpaceSmall,
                        DropdownButtonFormField<String>(
                          isDense: true,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: kDecorationDropdown(),
                          validator: (value) => _validator(value, "insulated"),
                          items: listChoice.map((value) {
                            return DropdownMenuItem<String>(
                              child:
                                  Text(value, style: TextStyle(fontSize: 12)),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              this.textInsulated.text = value!;
                              if (value == "Yes") {
                                this.isInsulated = true;
                              } else {
                                this.isInsulated = false;
                              }
                            });
                          },
                          value: (this.textInsulated.text == null ||
                                  this.textInsulated.text == "")
                              ? null
                              : this.textInsulated.text.toString(),
                        ),
                        UIHelper.verticalSpaceSmall,
                        Container(
                          width: double.infinity,
                          child: FlatButton(
                            child: Text("Save",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                anchor.addDownGuyByAnchor(DownGuyList(
                                    size: widget.type!
                                        ? anchor.brokendownGuySelected.id
                                        : anchor.downGuySelected.id,
                                    owner: data.downGuySelected.id,
                                    isInsulated: this.isInsulated,
                                    hOA: double.parse(this.hoa.text),
                                    type: widget.type! ? 1 : 0));
                                data.clearRiserAndtype();
                                this.sizeDg.clear();
                                this.hoa.clear();
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
              ),
            ),
          );
        });
  }
}
