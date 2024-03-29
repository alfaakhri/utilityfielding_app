import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/edit_pole/edit_pole.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditPolePage extends StatefulWidget {
  final AllProjectsModel? allProjectsModel;
  final AllPolesByLayerModel? poles;
  final bool isStartComplete;
  final bool isLocalMenu;

  const EditPolePage({Key? key, this.allProjectsModel, this.poles, required this.isStartComplete, required this.isLocalMenu})
      : super(key: key);

  @override
  _EditPolePageState createState() => _EditPolePageState();
}

class _EditPolePageState extends State<EditPolePage> {
  TextEditingController _fieldingType = TextEditingController();
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
  TextEditingController _poleSequence = TextEditingController();

  TextEditingController kvController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  late FieldingBloc fieldingBloc;
  late AuthBloc authBloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  bool? isFillPoleNumber;
  bool? isFillPoleClass;
  bool? isFillPoleLength;
  bool? isFillGLC;
  bool? isFillYear;
  bool? isFillSpecies;
  bool? isFillGPS;
  bool? isAlreadyPoleSequence;
  bool? isFillPoleStamp;
  bool? isFillRadioAntena;

  void clearFormController() {
    var fielding = context.read<FieldingProvider>();
    fielding.setPolesByLayerSelected(AllPolesByLayerModel());
    fielding.setFieldingTypeAssign(3);
    fielding.setLatLng(0, 0);
    fielding.setStreetName("");
    fielding.clearAll();
    context.read<SpanProvider>().clearAll();
    context.read<RiserProvider>().clearAll();
    context.read<AnchorProvider>().clearAll();

    this._fieldingType.clear();
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

  void doneAddPole() {
    var provider = context.read<FieldingProvider>();
    var anchor = context.read<AnchorProvider>();
    var riser = context.read<RiserProvider>();
    var pole = context.read<FieldingBloc>().poleByIdModel;
    AddPoleModel data = AddPoleModel(
        token: authBloc.userModel!.data!.token,
        id: (widget.poles == null) ? null : widget.poles!.id,
        layerId: widget.allProjectsModel!.iD,
        street: (provider.streetName == null) ? null : provider.streetName,
        fieldingType: (provider.fieldingTypeSelected!.id == null) ? null : provider.fieldingTypeSelected!.id,
        vAPTerminal: this._vapTerminal.text,
        poleNumber: this._poleNumber.text,
        osmose: this._osmoseNumber.text,
        latitude: provider.latitude.toString(),
        longitude: provider.longitude.toString(),
        poleHeight: (provider.poleHeightSelected.id == null) ? null : provider.poleHeightSelected.id,
        groundCircumference: this._groundLine.text,
        poleClass: (provider.poleClassSelected.id == null) ? null : provider.poleClassSelected.id,
        poleYear: this._year.text,
        poleSpecies: (provider.poleSpeciesSelected.id == null) ? null : provider.poleSpeciesSelected.id,
        poleCondition: (provider.poleConditionSelected.id == null) ? null : provider.poleConditionSelected.id,
        otherNumber: this._otherNumber.text,
        poleStamp: (this._poleStamp.text == "-" || this._poleStamp.text.isEmpty)
            ? null
            : (this._poleStamp.text == "Yes")
                ? true
                : false,
        notes: this._notes.text,
        isRadioAntenna: (this._radioAntena.text == "-" || this._radioAntena.text.isEmpty)
            ? null
            : (this._radioAntena.text == "Yes")
                ? true
                : false,
        hOAList: provider.hoaList,
        transformerList: provider.listTransformer,
        spanDirectionList: context.read<SpanProvider>().listSpanData,
        anchorList: anchor.listAnchorData,
        riserAndVGRList: riser.listRiserData,
        anchorFences: anchor.listAnchorFences,
        anchorStreets: anchor.listAnchorStreet,
        riserFences: riser.listRiserFence,
        poleSequence: (this._poleSequence.text.isNotEmpty) ? this._poleSequence.text : null,
        isFAPUnknown: pole.isFAPUnknown,
        isOsmoseUnknown: pole.isOsmoseUnknown,
        isOtherNumberUnknown: pole.isOtherNumberUnknown,
        isPoleClassUnknown: pole.isPoleClassUnknown,
        isPoleClassEstimated: pole.isPoleClassEstimated,
        isPoleLengthUnknown: pole.isPoleLengthUnknown,
        isPoleLengthEstimated: pole.isPoleLengthEstimated,
        isGroundLineUnknown: pole.isGroundLineUnknown,
        isGroundLineEstimated: pole.isGroundLineEstimated,
        isYearUnknown: pole.isYearUnknown,
        isYearEstimated: pole.isYearEstimated,
        isSpeciesUnknown: pole.isSpeciesUnknown,
        isSpeciesEstimated: pole.isSpeciesEstimated,
        isPoleNumberUnknown: pole.isPoleNumberUnknown,
        poleType: 0);

    fieldingBloc.add(AddPole(
        data,
        provider.allProjectsSelected,
        provider.polesByLayerSelected,
        context.read<ConnectionProvider>().isConnected,
        context.read<AuthBloc>().userModel!.data!.user!.iD!,
        widget.isStartComplete));
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
    var connect = context.read<ConnectionProvider>();
    var provider = context.read<FieldingProvider>();

    if (widget.poles != null) {
      fieldingBloc.add(GetPoleById(
        widget.poles!,
        authBloc.userModel!.data!.token,
        connect.isConnected,
        context.read<AuthBloc>().userModel!.data!.user!.iD!,
        provider.allProjectsSelected,
      ));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clearFormController();
  }

  void getAllPoles() {
    var user = context.read<UserProvider>();
    fieldingBloc.add(GetAllPolesByID(user.userModel.data!.token, widget.allProjectsModel,
        context.read<ConnectionProvider>().isConnected, user.userModel.data!.user!.iD!, widget.isLocalMenu));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          clearFormController();
          getAllPoles();
          Get.back();
          return Future.value(false);
        },
        child: BlocListener<FieldingBloc, FieldingState>(
          listener: (context, state) {
            if (state is AddPoleLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is AddPoleFailed) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              Fluttertoast.showToast(msg: state.message!);
            } else if (state is AddPoleSuccess) {
              clearFormController();
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              Fluttertoast.showToast(msg: "Success");

              getAllPoles();
              Get.back();
            }
          },
          child: Scaffold(
            key: _keyLoader,
            appBar: AppBar(
              title: Text("Pole", style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14)),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorHelpers.colorBlackText,
                ),
                onPressed: () {
                  clearFormController();

                  getAllPoles();
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
                      var pole = context.read<FieldingBloc>().poleByIdModel;
                      var fielding = context.read<FieldingProvider>();
                      setState(() {
                        isFillPoleLength = fielding.validateWithCheckbox(pole.isPoleLengthUnknown!, _poleHeight);
                        isFillPoleClass = fielding.validateWithCheckbox(pole.isPoleClassUnknown!, _poleClass);
                        isFillGLC = fielding.validateWithCheckbox(pole.isGroundLineUnknown!, _groundLine);
                        isFillYear = fielding.validateWithCheckbox(pole.isYearUnknown!, _year);
                        isFillSpecies = fielding.validateWithCheckbox(pole.isSpeciesUnknown!, _species);
                        isFillPoleNumber = fielding.validateWithCheckbox(pole.isPoleNumberUnknown, _poleNumber);
                        isFillPoleStamp = fielding.validate(_poleStamp, "pole stamp");
                        isFillRadioAntena = fielding.validate(_radioAntena, "radio antena");
                        isAlreadyPoleSequence = fielding.isPoleSequenceAlready(_poleSequence.text);

                        var fieldingProvider = context.read<FieldingProvider>();
                        if (fieldingProvider.latitude!.toInt() == 0 || fieldingProvider.longitude == null)
                          isFillGPS = true;
                        else
                          isFillGPS = false;

                        if (!isFillPoleLength! &&
                            !isFillPoleClass! &&
                            !isFillGLC! &&
                            !isFillYear! &&
                            !isFillGPS! &&
                            !isFillSpecies! &&
                            !isFillPoleNumber! &&
                            !isAlreadyPoleSequence! &&
                            !isFillRadioAntena! &&
                            !isFillPoleStamp!) {
                          if (context.read<ConnectionProvider>().isConnected)
                            doneAddPole();
                          else
                            dialogSaveLocal();
                        }
                      });
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
                    this._poleClass.text =
                        provider.setPoleClassAssign(state.poleByIdModel.poleClass ?? 13).text ?? unknownValue;
                    this._condition.text =
                        provider.setPoleConditionAssign(state.poleByIdModel.poleCondition ?? 0).text ?? unknownValue;
                    this._poleHeight.text = (provider.setPoleHeightAssign(state.poleByIdModel.poleHeight).text == null)
                        ? unknownValue
                        : provider.setPoleHeightAssign(state.poleByIdModel.poleHeight).text.toString();

                    provider.setFieldingTypeAssign(state.poleByIdModel.fieldingType ?? 2);
                    this._species.text =
                        provider.setPoleSpeciesAssign(state.poleByIdModel.poleSpecies).text ?? unknownValue;
                    this._poleNumber.text = state.poleByIdModel.poleNumber ?? unknownValue;
                    this._vapTerminal.text = state.poleByIdModel.vAPTerminal ?? unknownValue;

                    this._osmoseNumber.text =
                        (state.poleByIdModel.osmose == "-") ? unknownValue : state.poleByIdModel.osmose ?? unknownValue;
                    this._groundLine.text = state.poleByIdModel.groundCircumference ?? unknownValue;
                    this._year.text =
                        (state.poleByIdModel.poleYear != null) ? state.poleByIdModel.poleYear.toString() : unknownValue;
                    this._otherNumber.text = (state.poleByIdModel.otherNumber == "-")
                        ? unknownValue
                        : state.poleByIdModel.otherNumber ?? unknownValue;
                    if (state.poleByIdModel.poleStamp == null)
                      this._poleStamp.text = "-";
                    else if (state.poleByIdModel.poleStamp!)
                      this._poleStamp.text = "Yes";
                    else
                      this._poleStamp.text = "No";

                    if (state.poleByIdModel.isRadioAntenna == null)
                      this._radioAntena.text = "-";
                    else if (state.poleByIdModel.isRadioAntenna!)
                      this._radioAntena.text = "Yes";
                    else
                      this._radioAntena.text = "No";

                    this._notes.text = state.poleByIdModel.note ?? unknownValue;

                    this._fieldingType.text =
                        (provider.fieldingTypeSelected!.text != null) ? provider.fieldingTypeSelected!.text! : "";
                    this._poleSequence.text = (state.poleByIdModel.poleSequence != null)
                        ? state.poleByIdModel.poleSequence.toString()
                        : unknownValue;

                    provider.setLatLng(
                        double.parse(state.poleByIdModel.latitude ?? provider.allPolesByLayer!.first.latitude!),
                        double.parse(state.poleByIdModel.longitude ?? provider.allPolesByLayer!.first.longitude!));
                    provider.getCurrentAddress(
                        double.parse(state.poleByIdModel.latitude ?? provider.allPolesByLayer!.first.latitude!),
                        double.parse(state.poleByIdModel.longitude ?? provider.allPolesByLayer!.first.longitude!));

                    provider.addAllHoaList(state.poleByIdModel.hOAList);
                    provider.addAllListTransformer(state.poleByIdModel.transformerList);
                    span.addAllListSpanData(state.poleByIdModel.spanDirectionList);

                    anchor.setListAnchorData(state.poleByIdModel.anchorList);
                    anchor.setAllListAnchorFence(state.poleByIdModel.anchorFences!);
                    anchor.setAllAnchorStreet(state.poleByIdModel.anchorStreets!);
                    riser.setAllRiserFence(state.poleByIdModel.riserFences!);
                    riser.addAllListRiserData(state.poleByIdModel.riserAndVGRList);
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
    var fielding = context.read<FieldingBloc>();
    var pole = context.read<FieldingBloc>().poleByIdModel;
    var providerFielding = context.read<FieldingProvider>();
    var connect = context.read<ConnectionProvider>();
    return Container(
      color: ColorHelpers.colorBackground,
      child: Form(
        key: formKey,
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
                        style: TextStyle(color: ColorHelpers.colorBlueNumber, fontSize: 14),
                      ),
                      Text(
                        (this._poleSequence.text.isNotEmpty) ? this._poleSequence.text : "-",
                        style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
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
                      style: TextStyle(color: ColorHelpers.colorBlackText, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    UIHelper.verticalSpaceSmall,
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: ColorHelpers.colorBlueIntro),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "GPS",
                                  style: ThemeFonts.textBoldDefault,
                                ),
                                (isFillGPS == null)
                                    ? Container()
                                    : (isFillGPS!)
                                        ? Text(
                                            " *need to fill",
                                            style: TextStyle(color: Colors.red, fontSize: 12),
                                          )
                                        : Container()
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              (context.read<FieldingProvider>().latitude!.toInt() == 0)
                                  ? unknownValue
                                  : "${context.watch<FieldingProvider>().latitude!.toStringAsFixed(6)}, ${context.watch<FieldingProvider>().longitude!.toStringAsFixed(6)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, color: ColorHelpers.colorBlackText, fontSize: 12),
                            ),
                          ),
                          (!connect.isConnected)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    Get.to(EditLatLngPage(
                                      polesLayerModel: context.read<FieldingProvider>().polesByLayerSelected,
                                      allProjectsModel: widget.allProjectsModel,
                                      isAddPole: false,
                                      isAddTreeTrim: false,
                                    ));
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: (context.watch<FieldingProvider>().latitude!.toInt() == 0)
                                          ? ColorHelpers.colorBlueNumber
                                          : ColorHelpers.colorGreen,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                        (context.watch<FieldingProvider>().latitude!.toInt() == 0) ? 'Enter' : "Edit",
                                        style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 12)),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    StreetNameItem(),
                    ContentFormTextWidget(
                      title: "Pole Sequence",
                      controller: _poleSequence,
                      isValidation: isAlreadyPoleSequence,
                      isButtonGrey: false,
                      isDropdown: false,
                      isBlueColor: true,
                      needUnk: false,
                      needEst: false,
                      result: () {
                        setState(() {});
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Fielding Type",
                      controller: _fieldingType,
                      isButtonGrey: false,
                      isDropdown: true,
                      isBlueColor: false,
                      needUnk: false,
                      needEst: false,
                      result: () {
                        setState(() {});
                      },
                    ),
                    ContentFormTextWidget(
                      title: "FAP / Terminal Address",
                      controller: _vapTerminal,
                      isButtonGrey: true,
                      isDropdown: false,
                      isBlueColor: true,
                      needUnk: false,
                      needEst: false,
                      result: () {
                        setState(() {});
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Pole Number",
                      controller: _poleNumber,
                      isValidation: isFillPoleNumber,
                      isButtonGrey: false,
                      isDropdown: false,
                      isBlueColor: false,
                      needUnk: true,
                      needEst: false,
                      isUnk: fieldingBloc.poleByIdModel.isPoleNumberUnknown ?? false,
                      result: () {
                        setState(() {
                          pole.isPoleNumberUnknown = providerFielding.isUnknownCurrent;
                        });
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Osmose Number",
                      controller: _osmoseNumber,
                      isDropdown: false,
                      isButtonGrey: true,
                      isBlueColor: true,
                      needUnk: false,
                      needEst: false,
                      result: () {
                        setState(() {});
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Other Number",
                      controller: _otherNumber,
                      isButtonGrey: true,
                      isDropdown: false,
                      isBlueColor: false,
                      needUnk: false,
                      needEst: false,
                      result: () {
                        setState(() {});
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Pole Length",
                      isValidation: isFillPoleLength,
                      isButtonGrey: false,
                      controller: _poleHeight,
                      isDropdown: true,
                      isBlueColor: true,
                      needUnk: true,
                      needEst: true,
                      isUnk: fieldingBloc.poleByIdModel.isPoleLengthUnknown ?? false,
                      isEst: fieldingBloc.poleByIdModel.isPoleLengthEstimated ?? false,
                      result: () {
                        setState(() {
                          pole.isPoleLengthUnknown = providerFielding.isUnknownCurrent;
                          pole.isPoleLengthEstimated = providerFielding.isEstimateCurrent;
                        });
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Pole Class",
                      isValidation: isFillPoleClass,
                      isButtonGrey: false,
                      controller: _poleClass,
                      isDropdown: true,
                      isBlueColor: false,
                      needUnk: true,
                      needEst: true,
                      isUnk: fieldingBloc.poleByIdModel.isPoleClassUnknown ?? false,
                      isEst: fieldingBloc.poleByIdModel.isPoleClassEstimated ?? false,
                      result: () {
                        setState(() {
                          pole.isPoleClassUnknown = providerFielding.isUnknownCurrent;
                          pole.isPoleClassEstimated = providerFielding.isEstimateCurrent;
                        });
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Ground Line Circumference",
                      isValidation: isFillGLC,
                      controller: _groundLine,
                      isDropdown: false,
                      isButtonGrey: false,
                      isBlueColor: true,
                      needUnk: true,
                      needEst: true,
                      isUnk: fieldingBloc.poleByIdModel.isGroundLineUnknown ?? false,
                      isEst: fieldingBloc.poleByIdModel.isGroundLineEstimated ?? false,
                      result: () {
                        setState(() {
                          pole.isGroundLineUnknown = providerFielding.isUnknownCurrent;
                          pole.isGroundLineEstimated = providerFielding.isEstimateCurrent;
                        });
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Year",
                      isValidation: isFillYear,
                      isButtonGrey: false,
                      controller: _year,
                      isDropdown: false,
                      isBlueColor: false,
                      needUnk: true,
                      needEst: true,
                      isUnk: fieldingBloc.poleByIdModel.isYearUnknown ?? false,
                      isEst: fieldingBloc.poleByIdModel.isYearEstimated ?? false,
                      result: () {
                        setState(() {
                          pole.isYearUnknown = providerFielding.isUnknownCurrent;
                          pole.isYearEstimated = providerFielding.isEstimateCurrent;
                        });
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Species",
                      isValidation: isFillSpecies,
                      controller: _species,
                      isDropdown: true,
                      isButtonGrey: false,
                      isBlueColor: true,
                      needUnk: true,
                      needEst: true,
                      isUnk: fieldingBloc.poleByIdModel.isSpeciesUnknown ?? false,
                      isEst: fieldingBloc.poleByIdModel.isSpeciesEstimated ?? false,
                      result: () {
                        setState(() {
                          pole.isSpeciesUnknown = providerFielding.isUnknownCurrent;
                          pole.isSpeciesEstimated = providerFielding.isEstimateCurrent;
                        });
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Condition",
                      controller: _condition,
                      isButtonGrey: false,
                      isDropdown: true,
                      isBlueColor: false,
                      needUnk: false,
                      needEst: false,
                      result: () {
                        setState(() {});
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Pole Stamp Picture",
                      controller: _poleStamp,
                      isValidation: isFillPoleStamp,
                      isButtonGrey: false,
                      isDropdown: true,
                      isBlueColor: true,
                      needUnk: false,
                      needEst: false,
                      result: () {
                        setState(() {});
                      },
                    ),
                    ContentFormTextWidget(
                      title: "Radio Antena",
                      controller: _radioAntena,
                      isValidation: isFillRadioAntena,
                      isButtonGrey: false,
                      isDropdown: true,
                      isBlueColor: false,
                      needUnk: false,
                      needEst: false,
                      result: () {
                        setState(() {});
                      },
                    ),
                    EditTransformerWidget(),
                    EditHoaWidget(),
                    FormDrawingItem(
                      isBlueColor: true,
                      title: "Span Direction and Distance",
                      lengthValue: context.watch<SpanProvider>().listSpanData.length,
                      classname: ViewSpanWidget(),
                    ),
                    FormDrawingItem(
                      isBlueColor: false,
                      title: "Anchor",
                      lengthValue: context.watch<AnchorProvider>().listAnchorData.length,
                      classname: AnchorWidget(),
                    ),
                    FormDrawingItem(
                      isBlueColor: true,
                      title: "Riser and VGR Location",
                      lengthValue: context.watch<RiserProvider>().listRiserData.length,
                      classname: RiserWidget(),
                    ),
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
      ),
    );
  }

  Future dialogSaveLocal() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UIHelper.verticalSpaceMedium,
                Text(
                  'Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorHelpers.colorGrey, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                UIHelper.verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Internet not available, data will be saved and send anytime when internet is available",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ColorHelpers.colorGrey, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                UIHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    setState(() {
                      doneAddPole();
                    });
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorHelpers.colorBlueNumber,
                        border: Border.all(color: ColorHelpers.colorBlueNumber),
                      ),
                      child: Text(
                        "SAVE",
                        style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ),
                UIHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorHelpers.colorRed,
                      ),
                      child: Text(
                        "CANCEL",
                        style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          );
        });
  }
}
