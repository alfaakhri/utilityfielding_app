import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/all_pole_height_model.dart';
import 'package:fielding_app/data/models/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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

  TextEditingController _vapTerminal = TextEditingController();
  TextEditingController _poleNumber = TextEditingController();
  TextEditingController _osmoseNumber = TextEditingController();
  TextEditingController _species = TextEditingController();
  TextEditingController _otherNumber = TextEditingController();
  TextEditingController _poleHeight = TextEditingController();
  TextEditingController _groundLine = TextEditingController();
  TextEditingController _poleClass = TextEditingController();
  TextEditingController _year = TextEditingController();
  TextEditingController _condition = TextEditingController();
  TextEditingController _poleStamp = TextEditingController();

  FieldingBloc fieldingBloc;
  AuthBloc authBloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  bool _isStamp;

  List<String> _listChoice = ["Yes", "No"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fieldingBloc = BlocProvider.of<FieldingBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    if (widget.poles != null) {
      fieldingBloc
          .add(GetPoleById(widget.poles.id, authBloc.userModel.data.token));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          context.read<FieldingProvider>().setLatitude(null);
          context.read<FieldingProvider>().setLongitude(null);
          context.read<FieldingProvider>().setStreetName(null);

          fieldingBloc.add(GetAllPolesByID(
              context.read<UserProvider>().userModel.data.token,
              context.read<FieldingProvider>().allProjectsSelected.iD));
          Get.back();
          return Future.value(false);
        },
        child: BlocListener<FieldingBloc, FieldingState>(
          listener: (context, state) {
            if (state is AddPoleLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is AddPoleFailed) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message);
            } else if (state is AddPoleSuccess) {
              context.read<FieldingProvider>().setLatitude(null);
              context.read<FieldingProvider>().setLongitude(null);
              context.read<FieldingProvider>().setStreetName(null);
              this._vapTerminal.clear();
              this._poleNumber.clear();
              this._osmoseNumber.clear();
              this._otherNumber.clear();
              this._poleHeight.clear();
              this._groundLine.clear();
              this._poleClass.clear();
              this._year.clear();
              this._species.clear();
              this._condition.clear();
              this._poleStamp.clear();
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: "Success");

              fieldingBloc.add(GetAllPolesByID(
                  context.read<UserProvider>().userModel.data.token,
                  context.read<FieldingProvider>().allProjectsSelected.iD));
              Get.back();
            }
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
                  context.read<FieldingProvider>().setLatitude(null);
                  context.read<FieldingProvider>().setLongitude(null);
                  context.read<FieldingProvider>().setStreetName(null);

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
                      var provider = context.read<FieldingProvider>();
                      AddPoleModel data = AddPoleModel(
                        token: authBloc.userModel.data.token,
                        id: (widget.poles == null) ? null : widget.poles.id,
                        layerId: widget.allProjectsModel.iD,
                        street: (provider.streetName == null) ? null : provider.streetName,
                        vAPTerminal: this._vapTerminal.text,
                        poleNumber: this._poleNumber.text,
                        osmose: this._osmoseNumber.text,
                        latitude: (provider.latitude == null) ? null : provider.latitude.toString(),
                        longitude: (provider.longitude == null ) ? null : provider.longitude.toString(),
                        poleHeight: (provider.poleHeightSelected.id == null) ? null : provider.poleHeightSelected.id,
                        groundCircumference: this._groundLine.text,
                        poleClass: (provider.poleClassSelected.id == null) ? null : provider.poleClassSelected.id,
                        poleYear: this._year.text,
                        poleSpecies: (provider.poleSpeciesSelected.id == null) ? null : provider.poleSpeciesSelected.id,
                        poleCondition: (provider.poleConditionSelected.id == null) ? null : provider.poleConditionSelected.id,
                        otherNumber: this._otherNumber.text,
                        poleStamp: _isStamp,
                      );
                      fieldingBloc.add(AddPole(data));
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
            body: BlocConsumer<FieldingBloc, FieldingState>(
              listener: (context, state) {
                if (state is GetPoleByIdSuccess) {
                  var provider = context.read<FieldingProvider>();
                  setState(() {
                    this._poleNumber.text = state.poleByIdModel.poleNumber;
                    this._osmoseNumber.text = state.poleByIdModel.osmose;
                    this._poleHeight.text =
                        state.poleByIdModel.poleHeight.toString();
                    this._groundLine.text =
                        state.poleByIdModel.groundCircumference;
                    this._poleClass.text =
                        state.poleByIdModel.poleClass.toString();
                    this._year.text = state.poleByIdModel.poleYear.toString();
                    this._species.text =
                        state.poleByIdModel.poleSpecies.toString();
                    this._condition.text =
                        state.poleByIdModel.poleCondition.toString();
                    this._otherNumber.text = state.poleByIdModel.otherNumber;
                    this._isStamp = state.poleByIdModel.poleStamp;
                    provider.setPoleClassAssign(state.poleByIdModel.poleClass);
                    provider.setPoleConditionAssign(
                        state.poleByIdModel.poleCondition);
                    provider
                        .setPoleHeightAssign(state.poleByIdModel.poleHeight);
                    provider
                        .setPoleSpeciesAssign(state.poleByIdModel.poleSpecies);
                    provider.setLatitude(
                        double.parse(state.poleByIdModel.latitude));
                    provider.setLongitude(
                        double.parse(state.poleByIdModel.longitude));
                    provider.getCurrentAddress(
                        double.parse(state.poleByIdModel.latitude),
                        double.parse(state.poleByIdModel.longitude));
                  });
                }
              },
              builder: (context, state) {
                if (state is GetPoleByIdLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetPoleByIdFailed) {
                  return _buildBody(context);
                } else if (state is GetPoleByIdSuccess) {
                  return _buildBody(context);
                }
                return _buildBody(context);
              },
            ),
          ),
        ));
  }

  Container _buildBody(BuildContext context) {
    return Container(
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
                      "Pole Sequence",
                      style: TextStyle(
                          color: ColorHelpers.colorBlueNumber, fontSize: 14),
                    ),
                    Text(
                      (widget.poles != null) ? widget.poles.poleSequence.toString() : "-",
                      style: TextStyle(
                          color: ColorHelpers.colorBlackText, fontSize: 14),
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
                            (context.watch<FieldingProvider>().latitude == null)
                                ? ""
                                : "${context.watch<FieldingProvider>().latitude.toStringAsFixed(6)}, ${context.watch<FieldingProvider>().longitude.toStringAsFixed(6)}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: ColorHelpers.colorBlackText,
                                fontSize: 12),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          InkWell(
                            onTap: () {
                              Get.to(EditLatLngPage(
                                polesLayerModel: widget.poles,
                              ));
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
                      UIHelper.horizontalSpaceLarge,
                      (context.watch<FieldingProvider>().streetName != null)
                          ? Expanded(
                              child: Text(
                                (context.watch<FieldingProvider>().streetName !=
                                        null)
                                    ? context
                                        .watch<FieldingProvider>()
                                        .streetName
                                    : "-",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: ColorHelpers.colorBlackText,
                                    fontSize: 12),
                              ),
                            )
                          : Text(
                              "-",
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
                        "FAP / Terminal Address",
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
                                  "FAP / Terminal Address", _vapTerminal);
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
                  _contentEditText(
                      "Pole Number", _poleNumber.text, _poleNumber, false),
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
                  _contentEditText(
                      "Other Number", _otherNumber.text, _otherNumber, false),
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
                  _contentEditText(
                      "Pole Height", _poleHeight.text, _poleHeight, true),
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
                      "Pole Class", _poleClass.text, _poleClass, true),
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
                  _contentEditText("Species", _species.text, _species, true),
                  UIHelper.verticalSpaceSmall,
                  Divider(
                    color: ColorHelpers.colorBlackText,
                  ),
                  UIHelper.verticalSpaceSmall,
                  _contentEditText(
                      "Condition", _condition.text, _condition, true),
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
    );
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
            content: Consumer<FieldingProvider>(
              builder: (context, data, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: textDefault,
                  ),
                  UIHelper.verticalSpaceSmall,
                  (title.toLowerCase() == "pole height")
                      ? DropdownButtonFormField<String>(
                          isDense: true,
                          decoration: decorationDropdown(),
                          items: data.listAllPoleHeight.map((value) {
                            return DropdownMenuItem<String>(
                              child: Text(value.text.toString(),
                                  style: TextStyle(fontSize: 12)),
                              value: value.text.toString(),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {
                              data.setPoleHeightSelected(value);
                              this._poleHeight.text = value;
                            });
                          },
                          value: (this._poleHeight.text == null ||
                                  this._poleHeight.text == "")
                              ? null
                              : this._poleHeight.text,
                        )
                      : (title.toLowerCase() == "pole class")
                          ? DropdownButtonFormField<String>(
                              isDense: true,
                              decoration: decorationDropdown(),
                              items: data.listAllPoleClass.map((value) {
                                return DropdownMenuItem<String>(
                                  child: Text(value.text,
                                      style: TextStyle(fontSize: 12)),
                                  value: value.text,
                                );
                              }).toList(),
                              onChanged: (String value) {
                                setState(() {
                                  data.setPoleClassSelected(value);
                                  this._poleClass.text = value;
                                });
                              },
                              value: (data.poleClassSelected.text == null ||
                                      data.poleClassSelected.text == "")
                                  ? null
                                  : data.poleClassSelected.text,
                            )
                          : (title.toLowerCase() == "species")
                              ? DropdownButtonFormField<String>(
                                  isDense: true,
                                  decoration: decorationDropdown(),
                                  items: data.listAllPoleSpecies.map((value) {
                                    return DropdownMenuItem<String>(
                                      child: Text(value.text,
                                          style: TextStyle(fontSize: 12)),
                                      value: value.text,
                                    );
                                  }).toList(),
                                  onChanged: (String value) {
                                    setState(() {
                                      data.setPoleSpeciesSelected(value);
                                      this._species.text = value;
                                    });
                                  },
                                  value: (data.poleSpeciesSelected.text ==
                                              null ||
                                          data.poleSpeciesSelected.text == "")
                                      ? null
                                      : data.poleSpeciesSelected.text,
                                )
                              : (title.toLowerCase() == "condition")
                                  ? DropdownButtonFormField<String>(
                                      isDense: true,
                                      decoration: decorationDropdown(),
                                      items: data.listAllPoleCondition
                                          .map((value) {
                                        return DropdownMenuItem<String>(
                                          child: Text(value.id.toString(),
                                              style: TextStyle(fontSize: 12)),
                                          value: value.id.toString(),
                                        );
                                      }).toList(),
                                      onChanged: (String value) {
                                        setState(() {
                                          data.setPoleConditionSelected(value);
                                          this._condition.text =
                                              value.toString();
                                        });
                                      },
                                      value: (data.poleConditionSelected.text ==
                                                  null ||
                                              data.poleConditionSelected.text ==
                                                  "")
                                          ? null
                                          : data.poleConditionSelected.text,
                                    )
                                  : DropdownButtonFormField<String>(
                                      isDense: true,
                                      decoration: decorationDropdown(),
                                      items: _listChoice.map((value) {
                                        return DropdownMenuItem<String>(
                                          child: Text(value,
                                              style: TextStyle(fontSize: 12)),
                                          value: value,
                                        );
                                      }).toList(),
                                      onChanged: (String value) {
                                        setState(() {
                                          if (value == "Yes") {
                                            valueDropdown = true;
                                            _isStamp = true;
                                          } else {
                                            valueDropdown = false;
                                            _isStamp = false;
                                          }
                                          controller.text = value;
                                        });
                                      },
                                      value: (controller.text == null ||
                                              controller.text == "")
                                          ? null
                                          : controller.text,
                                    ),
                  UIHelper.verticalSpaceSmall,
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      child:
                          Text("Save", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      color: ColorHelpers.colorButtonDefault,
                    ),
                  ),
                ],
              ),
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
