import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../riser.exports.dart';

class AddRiserButton extends StatelessWidget {
  const AddRiserButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();
    var textDefault =
        TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: Consumer<RiserProvider>(
        builder: (context, data, _) => Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Riser & VGR",
                textAlign: TextAlign.center,
                style: textDefault,
              ),
              UIHelper.verticalSpaceSmall,
              UIHelper.verticalSpaceSmall,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Riser Type",
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
                    items: data.listRiser!.map((value) {
                      return DropdownMenuItem<String>(
                        child: Text(
                            (value.text!.contains("VGR"))
                                ? value.text.toString()
                                : value.text.toString() + " Inch",
                            style: TextStyle(fontSize: 12)),
                        value: value.text.toString(),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      data.setRiserVGRSelected(value);
                    },
                    value: (data.riserVGRSelected.id == null)
                        ? null
                        : data.riserVGRSelected.text.toString(),
                  ),
                  UIHelper.verticalSpaceSmall,
                  Text(
                    "Owner",
                    style: textDefault,
                  ),
                  UIHelper.verticalSpaceSmall,
                  DropdownButtonFormField<String>(
                    isDense: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Please insert owner';
                      } else if (value == "") {
                        return 'Please insert owner';
                      }
                      return null;
                    },
                    decoration: kDecorationDropdown(),
                    items: data.getListDownGuyOwner!.map((value) {
                      return DropdownMenuItem<String>(
                        child: Text(value.text.toString(),
                            style: TextStyle(fontSize: 12)),
                        value: value.text.toString(),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      data.setDownGuySelected(value);
                    },
                    value: (data.downGuySelected.id == null)
                        ? null
                        : data.downGuySelected.text.toString(),
                  ),
                ],
              ),
              UIHelper.verticalSpaceSmall,
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      data.setListActivePoint(data.riserVGRSelected.text!);
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
  }
}
