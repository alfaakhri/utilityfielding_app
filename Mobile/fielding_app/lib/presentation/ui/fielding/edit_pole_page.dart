import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'edit_pole_lat_lng_page.dart';

class EditPolePage extends StatefulWidget {
  final AllProjectsModel allProjectsModel;
  final AllPolesByLayerModel poles;
  final bool isAddPole;

  const EditPolePage(
      {Key key, this.allProjectsModel, this.poles, this.isAddPole})
      : super(key: key);

  @override
  _EditPolePageState createState() => _EditPolePageState();
}

class _EditPolePageState extends State<EditPolePage> {
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);
  TextEditingController _street = TextEditingController();
  TextEditingController _vapTerminal = TextEditingController();
  TextEditingController _poleNumber = TextEditingController();
  TextEditingController _osmoseNumber = TextEditingController();
  TextEditingController _otherNumber = TextEditingController();
  TextEditingController _poleHeight = TextEditingController();
  TextEditingController _groundLine = TextEditingController();
  TextEditingController _poleClass = TextEditingController();
  TextEditingController _year = TextEditingController();
  TextEditingController _condition = TextEditingController();
  TextEditingController _poleStamp = TextEditingController();

  FieldingBloc fieldingBloc;
  AuthBloc authBloc;

  bool _isStamp;

  List<String> _listChoice = ["Yes", "No"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fieldingBloc = BlocProvider.of<FieldingBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          fieldingBloc.add(GetAllPolesByID(
              context.read<UserProvider>().userModel.data.token,
              context.read<FieldingProvider>().allProjectsSelected.iD));
          Get.back();
          return Future.value(false);
        },
        child: BlocListener<FieldingBloc, FieldingState>(
          listener: (context, state) {
            if (state is AddPoleLoading) {
            } else if (state is AddPoleFailed) {
            } else if (state is AddPoleSuccess) {}
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("Pole",
                  style: TextStyle(
                      color: ColorHelpers.colorBlackText, fontSize: 14)),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorHelpers.colorBlackText,
                ),
                onPressed: () {
                  fieldingBloc.add(GetAllPolesByID(
                      context.read<UserProvider>().userModel.data.token,
                      context.read<FieldingProvider>().allProjectsSelected.iD));
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
                    onPressed: () {
                      AddPoleModel data = AddPoleModel(
                        token: authBloc.userModel.data.token,
                        id: null,
                        layerId: widget.allProjectsModel.iD,
                        street: "",
                        poleNumber: this._poleNumber.text,
                        osmose: this._osmoseNumber.text,
                        latitude: "",
                        longitude: "",
                        poleHeight: int.parse(this._poleHeight.text),
                        groundCircumference: this._groundLine.text,
                        poleClass: int.parse(this._poleClass.text),
                        poleYear: this._year.text,
                        poleSpecies: 0,
                        poleCondition: int.parse(this._condition.text),
                        otherNumber: this._otherNumber.text,
                        poleStamp: _isStamp,
                      );
                    },
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
                                  color: ColorHelpers.colorBlueNumber,
                                  fontSize: 14),
                            ),
                            Text(
                              "-",
                              style: TextStyle(
                                  color: ColorHelpers.colorBlackText,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/pin_blue.png',
                          scale: 4.5,
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
                                "GPS",
                                style: textDefault,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "-6.919634, 107.594192",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorHelpers.colorBlackText,
                                        fontSize: 12),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  InkWell(
                                    onTap: () {
                                      Get.to(EditLatLngPage());
                                    },
                                    child: Text('Edit Location',
                                        style: TextStyle(
                                            color: ColorHelpers.colorBlueNumber,
                                            fontSize: 12)),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Street Name",
                                style: textDefault,
                              ),
                              Text(
                                _street.text,
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
                                "VAP / Terminal",
                                style: textDefault,
                              ),
                              Row(
                                children: [
                                  Text(
                                    _vapTerminal.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ColorHelpers.colorBlackText,
                                        fontSize: 12),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  InkWell(
                                    onTap: () {
                                      dialogAlertDefault(
                                          "VAP / Terminal", _vapTerminal);
                                    },
                                    child: Text('Edit',
                                        style: TextStyle(
                                            color: ColorHelpers.colorBlueNumber,
                                            fontSize: 12)),
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
                          _contentEditText("Pole Number", _poleNumber.text,
                              _poleNumber, false),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          _contentEditText("Osmose Number", _osmoseNumber.text,
                              _osmoseNumber, false),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          _contentEditText("Other Number", _otherNumber.text,
                              _otherNumber, false),
                          // UIHelper.verticalSpaceSmall,
                          // Divider(
                          //   color: ColorHelpers.colorBlackText,
                          // ),
                          // UIHelper.verticalSpaceSmall,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       "Picture Number",
                          //       style: textDefault,
                          //     ),
                          //     Text(
                          //       "123456",
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.w600,
                          //           color: ColorHelpers.colorBlackText,
                          //           fontSize: 12),
                          //     ),
                          //   ],
                          // ),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          _contentEditText("Pole Height", _poleHeight.text,
                              _poleHeight, false),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          _contentEditText("Ground Line Circumference",
                              _groundLine.text, _groundLine, false),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          _contentEditText(
                              "Pole Class", _poleClass.text, _poleClass, false),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          _contentEditText("Year", _year.text, _year, false),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          _contentEditText("Species", "Western Red Cedar",
                              _osmoseNumber, false),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          _contentEditText(
                              "Condition", _condition.text, _condition, false),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          _contentEditText(
                              "Pole Stamp", _poleStamp.text, _poleStamp, true),
                          UIHelper.verticalSpaceSmall,
                          Divider(
                            color: ColorHelpers.colorBlackText,
                          ),
                          UIHelper.verticalSpaceSmall,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       "HOA",
                          //       style: textDefault,
                          //     ),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.end,
                          //       children: [
                          //         Row(
                          //           children: [
                          //             Text(
                          //               "Telco",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w600,
                          //                   color: ColorHelpers.colorBlackText,
                          //                   fontSize: 12),
                          //             ),
                          //             UIHelper.horizontalSpaceSmall,
                          //             Icon(
                          //               Icons.arrow_forward_ios,
                          //               color: ColorHelpers.colorBlackText,
                          //               size: 14,
                          //             ),
                          //           ],
                          //         ),
                          //         UIHelper.verticalSpaceSmall,
                          //         Row(
                          //           children: [
                          //             Icon(
                          //               Icons.add,
                          //               color: ColorHelpers.colorBlueNumber,
                          //               size: 14,
                          //             ),
                          //             UIHelper.horizontalSpaceVerySmall,
                          //             Text(
                          //               "Add HOA",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w600,
                          //                   color: ColorHelpers.colorBlueNumber,
                          //                   fontSize: 12),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          // UIHelper.verticalSpaceSmall,
                          // Divider(
                          //   color: ColorHelpers.colorBlackText,
                          // ),
                          // UIHelper.verticalSpaceSmall,
                          // _contentEditText("Transformer", 'Unknown', _osmoseNumber),
                          // UIHelper.verticalSpaceSmall,
                          // Divider(
                          //   color: ColorHelpers.colorBlackText,
                          // ),
                          // UIHelper.verticalSpaceSmall,
                          // _contentEditText("Anchor", "Yes", _osmoseNumber),
                          // UIHelper.verticalSpaceSmall,
                          // Divider(
                          //   color: ColorHelpers.colorBlackText,
                          // ),
                          // UIHelper.verticalSpaceSmall,
                          // _contentEditText("Riser", "Yes", _osmoseNumber),
                          // UIHelper.verticalSpaceSmall,
                          // Divider(
                          //   color: ColorHelpers.colorBlackText,
                          // ),
                          // UIHelper.verticalSpaceSmall,
                          // _contentEditText("VGR", "Yes", _osmoseNumber),
                          // UIHelper.verticalSpaceSmall,
                          // Divider(
                          //   color: ColorHelpers.colorBlackText,
                          // ),
                          // UIHelper.verticalSpaceSmall,
                          // _contentEditText("Notes", "Add Notes", _osmoseNumber),
                          // UIHelper.verticalSpaceSmall,
                          // Divider(
                          //   color: ColorHelpers.colorBlackText,
                          // ),
                          // UIHelper.verticalSpaceSmall,
                          // _contentEditText(
                          //     "Poles Picture", "Add Pictures", _osmoseNumber),
                          // UIHelper.verticalSpaceSmall,
                          // Divider(
                          //   color: ColorHelpers.colorBlackText,
                          // ),
                          // UIHelper.verticalSpaceSmall,
                          // _contentEditText(
                          //     "Other Attachment", "Add Files", _osmoseNumber),
                          // UIHelper.verticalSpaceSmall,
                          // Divider(
                          //   color: ColorHelpers.colorBlackText,
                          // ),
                          // UIHelper.verticalSpaceSmall,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  InkWell _contentEditText(String title, String value,
      TextEditingController controller, bool isDropdown,
      {bool valueDropdown}) {
    return InkWell(
      onTap: () {
        if (isDropdown) {
          dialogAlertDropdown(title, controller, valueDropdown);
        } else {
          dialogAlertDefault(title, controller);
        }
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

  Future dialogAlertDefault(String title, TextEditingController controller) {
    return showDialog(
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
                            color: ColorHelpers.colorGrey.withOpacity(0.3))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: ColorHelpers.colorGrey.withOpacity(0.3))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: ColorHelpers.colorGrey.withOpacity(0.3))),
                  ),
                ),
                UIHelper.verticalSpaceSmall,
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    color: ColorHelpers.colorButtonDefault,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future dialogAlertDropdown(
      String title, TextEditingController controller, bool valueDropdown) {
    return showDialog(
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
                DropdownButtonFormField<String>(
                  isDense: true,
                  decoration: decorationDropdown(),
                  validator: (value) {
                    if (value == null) {
                      return 'Harap mengisi ${title.toLowerCase()}';
                    }
                    return null;
                  },
                  items: _listChoice.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value, style: TextStyle(fontSize: 12)),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() {
                      if (value == "Yes") {
                        valueDropdown = true;
                      } else {
                        valueDropdown = false;
                      }
                      controller.text = value;
                    });
                  },
                  value: (controller.text == null || controller.text == "")
                      ? null
                      : controller.text,
                ),
                UIHelper.verticalSpaceSmall,
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    color: ColorHelpers.colorButtonDefault,
                  ),
                ),
              ],
            ),
          );
        });
  }

  InputDecoration decorationDropdown() {
    return InputDecoration(
      filled: true,
      fillColor: ColorHelpers.colorBackground,
      labelStyle: TextStyle(color: Colors.black),
      isDense: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
        color: ColorHelpers.colorBackground,
      )),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorHelpers.colorBackground,
        ),
      ),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    );
  }
}
