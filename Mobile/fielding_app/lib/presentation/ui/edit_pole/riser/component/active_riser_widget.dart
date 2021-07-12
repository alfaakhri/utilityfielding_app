import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ActiveRiserWidget extends StatefulWidget {
  const ActiveRiserWidget({Key? key}) : super(key: key);

  @override
  _ActiveRiserWidgetState createState() => _ActiveRiserWidgetState();
}

class _ActiveRiserWidgetState extends State<ActiveRiserWidget> {
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);
  bool isShowForm = false;

  TextEditingController selectActivePoint = TextEditingController();
  TextEditingController type = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<RiserProvider>(
      builder: (context, data, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Active Point",
              style:
                  TextStyle(fontSize: 14, color: ColorHelpers.colorGrey)),
          UIHelper.verticalSpaceSmall,
          DropdownButtonFormField<String>(
            isDense: true,
            decoration: kDecorationDropdown(),
            items: data.listRiserData.map((value) {
              //Hasil revisi penamaan :) mesti gini
              // var index = data.listRiserData.indexOf(value) + 1;
              var sequence = value.name!.split("-").last;
              var name = value.name!.split("-").first;
              return DropdownMenuItem<String>(
                child: Text(
                    (value.name!.contains("VGR"))
                        ? "${value.generalRVGRSeq}." + name + " $sequence"
                        : "${value.generalRVGRSeq}." + "$sequence-" + "$name in",
                    style: TextStyle(fontSize: 12)),
                value: value.name,
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                this.selectActivePoint.text = value!;
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Type",
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorHelpers.colorGrey)),
                        UIHelper.verticalSpaceSmall,
                        DropdownButtonFormField<String>(
                          isDense: true,
                          decoration: kDecorationDropdown(),
                          items: data.getListDownGuyOwner!.map((value) {
                            return DropdownMenuItem<String>(
                              child: Text(value.text.toString(),
                                  style: TextStyle(fontSize: 12)),
                              value: value.text.toString(),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              data.setDownGuySelected(value);
                              this.type.text = value!;
                            });
                          },
                          value: (data.downGuySelected.id == null)
                              ? null
                              : data.downGuySelected.text.toString(),
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
                                      this.selectActivePoint.text, data);
                                },
                                child: Text(
                                  "DELETE",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ColorHelpers.colorWhite),
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
                                    msg: "Active point have been updated");
                                setState(() {
                                  this.selectActivePoint.clear();
                                });
                              },
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorHelpers.colorWhite),
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
      ),
    );
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
