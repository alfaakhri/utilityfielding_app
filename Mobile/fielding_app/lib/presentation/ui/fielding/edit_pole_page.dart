import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPolePage extends StatefulWidget {
  @override
  _EditPolePageState createState() => _EditPolePageState();
}

class _EditPolePageState extends State<EditPolePage> {
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);
  TextEditingController _poleNumber = TextEditingController();
  TextEditingController _osmoseNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pole",
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorHelpers.colorBlackText,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              color: ColorHelpers.colorButtonDefault,
            )),
      ),
      body: Container(
        color: ColorHelpers.colorBackground,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location Number",
                        style: TextStyle(
                            color: ColorHelpers.colorBlueNumber, fontSize: 14),
                      ),
                      Text(
                        "1",
                        style: TextStyle(
                            color: ColorHelpers.colorBlackText, fontSize: 14),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/pin_red.png',
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpaceSmall,
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Text(
                      "Pole Information",
                      style: TextStyle(
                          color: ColorHelpers.colorBlackText,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    UIHelper.verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Street Name",
                          style: textDefault,
                        ),
                        Text(
                          "Street name...",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ColorHelpers.colorBlackText,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Pole Number", "XX0001", _poleNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Osmose Number", "S0001CV", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Other Number", "1234", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Picture Number",
                          style: textDefault,
                        ),
                        Text(
                          "123456",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ColorHelpers.colorBlackText,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GPS",
                          style: textDefault,
                        ),
                        Text(
                          "-6.919634, 107.594192",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ColorHelpers.colorBlackText,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Pole Height", "10", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText(
                        "Ground Line Circumference", "10", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Pole Class", "2", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Year", '2018', _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText(
                        "Species", "Western Red Cedar", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Condition", "Good", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Pole Stamp", "Yes", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HOA",
                          style: textDefault,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Telco",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorHelpers.colorBlackText,
                                      fontSize: 12),
                                ),
                                UIHelper.horizontalSpaceSmall,
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ColorHelpers.colorBlackText,
                                  size: 14,
                                ),
                              ],
                            ),
                            UIHelper.verticalSpaceSmall,
                            Row(
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
                          ],
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Transformer", 'Unknown', _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Anchor", "Yes", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Riser", "Yes", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("VGR", "Yes", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText("Notes", "Add Notes", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText(
                        "Poles Picture", "Add Pictures", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _contentEditText(
                        "Other Attachment", "Add Files", _osmoseNumber),
                    UIHelper.verticalSpaceSmall,
                    Divider(
                      color: ColorHelpers.colorBlackText,
                    ),
                    UIHelper.verticalSpaceSmall,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _contentEditText(
      String title, String value, TextEditingController controller) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: textDefault,
                    ),
                    UIHelper.verticalSpaceSmall,
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: "$title...",
                        hintStyle: TextStyle(
                            color: ColorHelpers.colorBlackText.withOpacity(0.3),
                            fontSize: 12),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color:
                                    ColorHelpers.colorGrey.withOpacity(0.3))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color:
                                    ColorHelpers.colorGrey.withOpacity(0.3))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color:
                                    ColorHelpers.colorGrey.withOpacity(0.3))),
                      ),
                    ),
                    UIHelper.verticalSpaceSmall,
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: ColorHelpers.colorGrey.withOpacity(0.2),
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        Expanded(
                          flex: 5,
                          child: FlatButton(
                            child: Text("Save",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: ColorHelpers.colorGreen2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textDefault,
          ),
          Row(
            children: [
              Text(
                (controller.text.isEmpty) ? value : controller.text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorHelpers.colorBlackText,
                    fontSize: 12),
              ),
              UIHelper.horizontalSpaceSmall,
              Icon(
                Icons.arrow_forward_ios,
                color: ColorHelpers.colorBlackText,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
