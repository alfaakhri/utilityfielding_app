import 'package:fielding_app/data/models/add_pole_model.dart';
import 'package:fielding_app/data/models/add_transformer_model.dart';
import 'package:fielding_app/data/models/all_pole_height_model.dart';
import 'package:fielding_app/data/models/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/anchor_provider.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/domain/provider/span_provider.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/fielding/component/edit_transformer_widget.dart';
import 'package:fielding_app/presentation/ui/fielding/riser/riser_widget.dart';
import 'package:fielding_app/presentation/widgets/constants_widget.dart';
import 'package:fielding_app/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'anchor/anchor_widget.dart';
import 'component/edit_hoa_widget.dart';
import 'note/note_widget.dart';
import 'span/view_span_widget.dart';
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
  var textBoldDefault = TextStyle(
      color: ColorHelpers.colorBlackText,
      fontSize: 12,
      fontWeight: FontWeight.bold);

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
  TextEditingController _radioAntena = TextEditingController();
  TextEditingController _notes = TextEditingController();

  TextEditingController kvController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  FieldingBloc fieldingBloc;
  AuthBloc authBloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  bool _isStamp;
  bool _isAntena;

  List<String> _listChoice = ["-", "Yes", "No"];

  void clearFormController() {
    context.read<FieldingProvider>().setLatitude(null);
    context.read<FieldingProvider>().setLongitude(null);
    context.read<FieldingProvider>().setStreetName(null);
    context.read<FieldingProvider>().clearAll();
    context.read<SpanProvider>().clearAll();
    context.read<RiserProvider>().clearAll();
    context.read<AnchorProvider>().clearAll();

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
    this._notes.clear();
  }

  Widget spaceForm() {
    return Column(
      children: [
        UIHelper.verticalSpaceSmall,
        Divider(
          color: ColorHelpers.colorBlackText,
        ),
        UIHelper.verticalSpaceSmall,
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    fieldingBloc = BlocProvider.of<FieldingBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    if (widget.poles != null) {
      fieldingBloc
          .add(GetPoleById(widget.poles.id, authBloc.userModel.data.token));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clearFormController();
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
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is AddPoleFailed) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message);
            } else if (state is AddPoleSuccess) {
              clearFormController();
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
                  clearFormController();

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
                          street: (provider.streetName == null)
                              ? null
                              : provider.streetName,
                          vAPTerminal: this._vapTerminal.text,
                          poleNumber: this._poleNumber.text,
                          osmose: this._osmoseNumber.text,
                          latitude: (provider.latitude == null)
                              ? null
                              : provider.latitude.toString(),
                          longitude: (provider.longitude == null)
                              ? null
                              : provider.longitude.toString(),
                          poleHeight: (provider.poleHeightSelected.id == null)
                              ? null
                              : provider.poleHeightSelected.id,
                          groundCircumference: this._groundLine.text,
                          poleClass: (provider.poleClassSelected.id == null)
                              ? null
                              : provider.poleClassSelected.id,
                          poleYear: this._year.text,
                          poleSpecies: (provider.poleSpeciesSelected.id == null)
                              ? null
                              : provider.poleSpeciesSelected.id,
                          poleCondition:
                              (provider.poleConditionSelected.id == null)
                                  ? null
                                  : provider.poleConditionSelected.id,
                          otherNumber: this._otherNumber.text,
                          poleStamp: (this._poleStamp.text == "-")
                              ? null
                              : this._isStamp,
                          notes: this._notes.text,
                          isRadioAntenna: (this._radioAntena.text == "-")
                              ? null
                              : this._isAntena,
                          hOAList: provider.hoaList,
                          transformerList: provider.listTransformer,
                          spanDirectionList:
                              context.read<SpanProvider>().listSpanData,
                          anchorList:
                              context.read<AnchorProvider>().listAnchorData,
                          riserAndVGRList:
                              context.read<RiserProvider>().listRiserData);
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
                  var span = context.read<SpanProvider>();
                  var anchor = context.read<AnchorProvider>();
                  var riser = context.read<RiserProvider>();
                  setState(() {
                    this._poleNumber.text = state.poleByIdModel.poleNumber;
                    this._vapTerminal.text = state.poleByIdModel.vAPTerminal;

                    this._osmoseNumber.text = state.poleByIdModel.osmose;
                    this._groundLine.text =
                        state.poleByIdModel.groundCircumference;
                    this._year.text = (state.poleByIdModel.poleYear != null)
                        ? state.poleByIdModel.poleYear.toString()
                        : "";
                    this._otherNumber.text = state.poleByIdModel.otherNumber;
                    this._isStamp = state.poleByIdModel.poleStamp;
                    if (this._isStamp == null) {
                      this._poleStamp.text = "-";
                    } else if (this._isStamp) {
                      this._poleStamp.text = "Yes";
                    } else {
                      this._poleStamp.text = "No";
                    }
                    this._isAntena = state.poleByIdModel.isRadioAntenna;
                    if (this._isAntena == null) {
                      this._radioAntena.text = "-";
                    } else if (!this._isAntena) {
                      this._radioAntena.text = "No";
                    } else {
                      this._radioAntena.text = "Yes";
                    }
                    this._notes.text = state.poleByIdModel.note;
                    provider.setPoleClassAssign(state.poleByIdModel.poleClass);
                    this._poleClass.text =
                        provider.poleClassSelected.text ?? "";
                    provider.setPoleConditionAssign(
                        state.poleByIdModel.poleCondition);
                    this._condition.text =
                        provider.poleConditionSelected.text ?? "";
                    provider
                        .setPoleHeightAssign(state.poleByIdModel.poleHeight);
                    this._poleHeight.text =
                        (provider.poleHeightSelected.text != null)
                            ? provider.poleHeightSelected.text.toString()
                            : "";
                    provider
                        .setPoleSpeciesAssign(state.poleByIdModel.poleSpecies);
                    this._species.text =
                        provider.poleSpeciesSelected.text ?? "";

                    provider.setLatitude(
                        double.parse(state.poleByIdModel.latitude));
                    provider.setLongitude(
                        double.parse(state.poleByIdModel.longitude));
                    provider.getCurrentAddress(
                        double.parse(state.poleByIdModel.latitude),
                        double.parse(state.poleByIdModel.longitude));

                    provider.addAllHoaList(state.poleByIdModel.hOAList);
                    provider.addAllListTransformer(
                        state.poleByIdModel.transformerList);
                    span.addAllListSpanData(
                        state.poleByIdModel.spanDirectionList);

                    anchor.setListAnchorData(state.poleByIdModel.anchorList);
                    riser.addAllListRiserData(
                        state.poleByIdModel.riseAndVGRList);
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
                      (widget.poles != null)
                          ? widget.poles.poleSequence.toString()
                          : "-",
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
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(color: ColorHelpers.colorBlueIntro),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GPS",
                          style: textBoldDefault,
                        ),
                        Row(
                          children: [
                            Text(
                              (context.watch<FieldingProvider>().latitude ==
                                      null)
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
                              child: Container(
                                width: 50,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: (context
                                              .watch<FieldingProvider>()
                                              .latitude ==
                                          null)
                                      ? ColorHelpers.colorBlueNumber
                                      : ColorHelpers.colorGreen,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                    (context
                                                .watch<FieldingProvider>()
                                                .latitude ==
                                            null)
                                        ? 'Enter'
                                        : "Edit",
                                    style: TextStyle(
                                        color: ColorHelpers.colorWhite,
                                        fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: ColorHelpers.colorWhite),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Street Name",
                          style: textBoldDefault,
                        ),
                        UIHelper.horizontalSpaceLarge,
                        (context.watch<FieldingProvider>().streetName != null)
                            ? Expanded(
                                child: Text(
                                  (context
                                              .watch<FieldingProvider>()
                                              .streetName !=
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
                  ),
                  _contentFormText("FAP / Terminal Address", _vapTerminal.text,
                      _vapTerminal, false, true),
                  _contentFormText("Pole Number", _poleNumber.text, _poleNumber,
                      false, false),
                  _contentFormText("Osmose Number", _osmoseNumber.text,
                      _osmoseNumber, false, true),
                  _contentFormText("Other Number", _otherNumber.text,
                      _otherNumber, false, false),
                  _contentFormText(
                      "Pole Height", _poleHeight.text, _poleHeight, true, true),
                  _contentFormText("Ground Line Circumference",
                      _groundLine.text, _groundLine, false, false),
                  _contentFormText(
                      "Pole Class", _poleClass.text, _poleClass, true, true),
                  _contentFormText("Year", _year.text, _year, false, false),
                  _contentFormText(
                      "Species", _species.text, _species, true, true),
                  _contentFormText(
                      "Condition", _condition.text, _condition, true, false),
                  _contentFormText(
                      "Pole Stamp", _poleStamp.text, _poleStamp, true, true),
                  _contentFormText("Radio Antena", this._radioAntena.text,
                      this._radioAntena, true, false),
                  EditTransformerWidget(),
                  EditHoaWidget(),
                  _contentFormSpan(
                      "Span Direction and Distance",
                      Provider.of<SpanProvider>(context).listSpanData.length,
                      ViewSpanWidget(),
                      true),
                  _contentFormSpan(
                      "Anchor",
                      Provider.of<AnchorProvider>(context)
                          .listAnchorData
                          .length,
                      AnchorWidget(),
                      false),
                  _contentFormSpan(
                      "Riser and VGR Location",
                      Provider.of<RiserProvider>(context).listRiserData.length,
                      RiserWidget(),
                      true),
                  NoteWidget(
                    title: "Note",
                    controller: _notes,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentFormSpan(
      String title, int lengthValue, Widget classname, bool isBlueColor) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isBlueColor
              ? ColorHelpers.colorBlueIntro
              : ColorHelpers.colorWhite),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: textBoldDefault,
            ),
          ),
          (lengthValue != 0)
              ? Expanded(
                  flex: 2,
                  child: Text(lengthValue.toString(),
                      style: TextStyle(
                          color: ColorHelpers.colorBlackText, fontSize: 14)),
                )
              : Container(),
          InkWell(
            onTap: () {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;

              print("WIDTH : $width, HEIGHT : $height");
              context.read<FieldingProvider>().baseWidth = width;
              context.read<FieldingProvider>().baseHeight = height;
              Get.to(classname);
            },
            child: Container(
              width: 50,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (lengthValue == 0)
                    ? ColorHelpers.colorBlueNumber
                    : ColorHelpers.colorGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text((lengthValue == 0) ? 'Enter' : "Edit",
                  style:
                      TextStyle(color: ColorHelpers.colorWhite, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Container _contentFormText(String title, String value,
      TextEditingController controller, bool isDropdown, bool isBlueColor,
      {bool valueDropdown}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isBlueColor
              ? ColorHelpers.colorBlueIntro
              : ColorHelpers.colorWhite),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: textBoldDefault,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              (controller.text.isEmpty)
                  ? "-"
                  : (title.toLowerCase().contains("pole height"))
                      ? controller.text + " ft"
                      : (title.toLowerCase().contains("ground line"))
                          ? controller.text + " inch"
                          : controller.text,
              style: TextStyle(
                  color: ColorHelpers.colorBlackText,
                  fontSize: 12),
            ),
          ),
          InkWell(
            onTap: () {
              if (isDropdown) {
                dialogAlertDropdown(title, controller, valueDropdown);
              } else {
                dialogAlertDefault(title, controller);
              }
            },
            child: Container(
              width: 50,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (controller.text.isEmpty)
                    ? ColorHelpers.colorBlueNumber
                    : ColorHelpers.colorGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text((controller.text.isEmpty) ? 'Enter' : "Edit",
                  style:
                      TextStyle(color: ColorHelpers.colorWhite, fontSize: 12)),
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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  (controller.text.isEmpty)
                      ? "-"
                      : (title.toLowerCase().contains("pole height"))
                          ? controller.text + " ft"
                          : (title.toLowerCase().contains("ground line"))
                              ? controller.text + " inch"
                              : controller.text,
                  overflow: TextOverflow.ellipsis,
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
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: textDefault,
                  ),
                  UIHelper.verticalSpaceSmall,
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLines: null,
                          controller: controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: "$title...",
                            hintStyle: TextStyle(
                                color: ColorHelpers.colorBlackText
                                    .withOpacity(0.3),
                                fontSize: 12),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: ColorHelpers.colorGrey
                                        .withOpacity(0.3))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: ColorHelpers.colorGrey
                                        .withOpacity(0.3))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: ColorHelpers.colorGrey
                                        .withOpacity(0.3))),
                          ),
                        ),
                      ),
                      (title.toLowerCase().contains("ground line"))
                          ? Padding(
                              padding: EdgeInsets.only(left: 10),
                              child:
                                  Text("Inch", style: TextStyle(fontSize: 12)),
                            )
                          : Container()
                    ],
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
                      ? Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isDense: true,
                                decoration: kDecorationDropdown(),
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
                                value: (data.poleHeightSelected.id == null)
                                    ? null
                                    : data.poleHeightSelected.text.toString(),
                              ),
                            ),
                            UIHelper.horizontalSpaceSmall,
                            Text("Feet", style: TextStyle(fontSize: 12)),
                          ],
                        )
                      : (title.toLowerCase() == "pole class")
                          ? DropdownButtonFormField<String>(
                              isDense: true,
                              decoration: kDecorationDropdown(),
                              items: data.listAllPoleClass.map((value) {
                                return DropdownMenuItem<String>(
                                  child: Text(value.text.toUpperCase(),
                                      style: TextStyle(fontSize: 12)),
                                  value: value.text,
                                );
                              }).toList(),
                              onChanged: (String value) {
                                setState(() {
                                  data.setPoleClassSelected(value);
                                  this._poleClass.text = value.toUpperCase();
                                });
                              },
                              value: (data.poleClassSelected.text == null ||
                                      data.poleClassSelected.text == "")
                                  ? null
                                  : data.poleClassSelected.text.toUpperCase(),
                            )
                          : (title.toLowerCase() == "species")
                              ? DropdownButtonFormField<String>(
                                  isDense: true,
                                  decoration: kDecorationDropdown(),
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
                                      decoration: kDecorationDropdown(),
                                      items: data.listAllPoleCondition
                                          .map((value) {
                                        return DropdownMenuItem<String>(
                                          child: Text(value.text.toString(),
                                              style: TextStyle(fontSize: 12)),
                                          value: value.text.toString(),
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
                                      decoration: kDecorationDropdown(),
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
                                          } else if (value == "No") {
                                            valueDropdown = false;
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
}
