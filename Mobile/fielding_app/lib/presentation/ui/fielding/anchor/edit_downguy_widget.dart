import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/all_down_guy_owner.dart';
import 'package:fielding_app/domain/provider/anchor_provider.dart';
import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/constants_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditDownguyWidget extends StatefulWidget {
  final bool type;

  const EditDownguyWidget({this.type});

  @override
  _EditDownguyWidgetState createState() => _EditDownguyWidgetState();
}

class _EditDownguyWidgetState extends State<EditDownguyWidget> {
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);
  TextEditingController sizeDg = TextEditingController();
  TextEditingController hoaOwner = TextEditingController();
  TextEditingController textInsulated = TextEditingController();

  bool isPictureAnchor;
  bool isInsulated;

  List<DownGuyList> downGuyList = List<DownGuyList>();
  List<DownGuyList> brokenDownGuyList = List<DownGuyList>();
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
                  (!widget.type) ? "DG" : "Broken DG",
                  style: textDefault,
                ),
              ),
              InkWell(
                onTap: () {
                  if (!widget.type) {
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
                      (!widget.type) ? "Add DG" : "Add Broken DG",
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
                      .downGuyList
                      .length !=
                  0)
              ? (!widget.type)
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
              ? anchor.anchorActiveSelected.downGuyList
                  .where((element) => element.type == 0)
                  .toList()
                  .length
              : anchor.anchorActiveSelected.downGuyList
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
              dataDownGuy = anchor.anchorActiveSelected.downGuyList
                  .where((element) => element.type == 1)
                  .toList()[index];
            } else {
              dataDownGuy = anchor.anchorActiveSelected.downGuyList
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
                            "Size",
                            style: textDefault,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${downGuy.text}",
                                style: textDefault,
                              ),
                              Text(
                                "${dataDownGuy.size} ft",
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
                builder: (context, data, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("DG Size",
                            style: TextStyle(
                                fontSize: 14, color: ColorHelpers.colorGrey)),
                        UIHelper.verticalSpaceSmall,
                        TextFormField(
                          controller: this.sizeDg,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null) {
                              return 'Please insert size';
                            } else if (value == "") {
                              return 'Please insert size';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            suffixText: "ft",
                            suffixStyle: TextStyle(fontSize: 14),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      ColorHelpers.colorGrey.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      ColorHelpers.colorGrey.withOpacity(0.2)),
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
                      validator: (value) {
                        if (value == null) {
                          return 'Please insert hoa owner';
                        } else if (value == "") {
                          return 'Please insert hoa owner';
                        }
                        return null;
                      },
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: kDecorationDropdown(),
                      items: data.listDownGuyOwner.map((value) {
                        return DropdownMenuItem<String>(
                          child:
                              Text(value.text, style: TextStyle(fontSize: 12)),
                          value: value.text,
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          data.setDownGuySelected(value);
                          this.hoaOwner.text = value;
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
                      validator: (value) {
                        if (value == null) {
                          return 'Please insert insulated';
                        } else if (value == "") {
                          return 'Please insert insulated';
                        }
                        return null;
                      },
                      items: listChoice.map((value) {
                        return DropdownMenuItem<String>(
                          child: Text(value, style: TextStyle(fontSize: 12)),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          this.textInsulated.text = value;
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
                        child:
                            Text("Save", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          anchor.addDownGuyByAnchor(DownGuyList(
                              size: int.parse(this.sizeDg.text),
                              owner: data.downGuySelected.id,
                              isInsulated: this.isInsulated,
                              hOA: 0,
                              type: (widget.type) ? 1 : 0));
                          data.clearRiserAndtype();
                          this.sizeDg.clear();
                          Navigator.pop(context);
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
