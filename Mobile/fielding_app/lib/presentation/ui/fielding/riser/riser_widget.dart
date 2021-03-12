import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/constants_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RiserWidget extends StatefulWidget {
  @override
  _RiserWidgetState createState() => _RiserWidgetState();
}

class _RiserWidgetState extends State<RiserWidget> {
  GlobalKey globalKey = GlobalKey();

  TextEditingController selectActivePoint = TextEditingController();
  TextEditingController sizeRiser = TextEditingController();
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
              onPressed: () {},
            )
          ],
          backgroundColor: ColorHelpers.colorWhite,
        ),
        backgroundColor: Colors.white,
        body: Consumer<RiserProvider>(
          builder: (context, data, _) => ListView(
            children: [
              RepaintBoundary(
                key: globalKey,
                child: Stack(
                  children: [
                    Container(
                      height: 250,
                      color: Colors.white,
                      child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorHelpers.colorGrey.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        height: 250,
                        child: Image.asset(
                          'assets/riser.png',
                          scale: 2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Form(
                key: this.formKey,
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Size of Riser",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorHelpers.colorGrey)),
                            UIHelper.verticalSpaceSmall,
                            TextFormField(
                              controller: this.sizeRiser,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please insert riser';
                                } else if (value == "") {
                                  return 'Please insert riser';
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
                                  this.type.text = value;
                                });
                              },
                              value: (data.downGuySelected.id == null)
                                  ? null
                                  : data.downGuySelected.text.toString(),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
