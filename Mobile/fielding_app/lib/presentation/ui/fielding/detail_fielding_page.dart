import 'package:fielding_app/data/models/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/service/location_service.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/fielding/edit_pole_lat_lng_page.dart';
import 'package:fielding_app/presentation/widgets/error_handling_widget.dart';
import 'package:fielding_app/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'edit_pole_page.dart';

class DetailFieldingPage extends StatefulWidget {
  final AllProjectsModel allProjectsModel;

  const DetailFieldingPage({Key key, this.allProjectsModel}) : super(key: key);
  @override
  _DetailFieldingPageState createState() => _DetailFieldingPageState();
}

class _DetailFieldingPageState extends State<DetailFieldingPage> {
  FieldingBloc fieldingBloc;
  GoogleMapController googleMapController;
  Marker _tempMarkerBlue;
  Marker _tempMarkerSelected;
  Set<Marker> _markers = Set<Marker>();
  double pinPillPosition = -100;
  LocationData currentLocation;
  BitmapDescriptor poleIcon;
  BitmapDescriptor poleSelected;
  BitmapDescriptor poleGreen;
  AllPolesByLayerModel poleModelSelected;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    fieldingBloc = BlocProvider.of<FieldingBloc>(context);
    fieldingBloc.add(GetAllPolesByID(
        context.read<UserProvider>().userModel.data.token,
        widget.allProjectsModel.iD));
    getCurrentLocation();
    setPoleIcons();
  }

  void getCurrentLocation() async {
    LocationService location = LocationService();
    LocationData data = await location.getCurrentLocation();
    setState(() {
      print("latlng: ${data.latitude.toString()} ${data.longitude.toString()}");
      currentLocation = data;
    });
  }

  void setPoleIcons() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_blue.png')
        .then((onValue) {
      poleIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_yellow.png')
        .then((onValue) {
      poleSelected = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_green.png')
        .then((onValue) {
      poleGreen = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        fieldingBloc.add(
            GetAllProjects(context.read<UserProvider>().userModel.data.token));
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.allProjectsModel.layerName,
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
          ),
          leading: IconButton(
            onPressed: () {
              fieldingBloc.add(GetAllProjects(
                  context.read<UserProvider>().userModel.data.token));
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: ColorHelpers.colorBlackText,
            ),
          ),
        ),
        backgroundColor: ColorHelpers.colorBackground,
        body: BlocConsumer<FieldingBloc, FieldingState>(
          listener: (context, state) {
            if (state is StartPolePictureLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is StartPolePictureFailed) {
              fieldingBloc.add(GetAllPolesByID(
                  context.read<UserProvider>().userModel.data.token,
                  widget.allProjectsModel.iD));
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message);
            } else if (state is StartPolePictureSuccess) {
              setState(() {});
              Fluttertoast.showToast(msg: "Additional pole pictures success");

              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              fieldingBloc.add(GetAllPolesByID(
                  context.read<UserProvider>().userModel.data.token,
                  widget.allProjectsModel.iD));
              this.poleModelSelected = AllPolesByLayerModel();
              this._tempMarkerSelected = null;
            } else if (state is CompletePolePictureLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is CompletePolePictureFailed) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message);
              fieldingBloc.add(GetAllPolesByID(
                  context.read<UserProvider>().userModel.data.token,
                  widget.allProjectsModel.iD));
            } else if (state is CompletePolePictureSuccess) {
              setState(() {});
              Fluttertoast.showToast(msg: "Complete pole pictures success");

              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              fieldingBloc.add(GetAllPolesByID(
                  context.read<UserProvider>().userModel.data.token,
                  widget.allProjectsModel.iD));
              this.poleModelSelected = AllPolesByLayerModel();
              this._tempMarkerSelected = null;
            } else if (state is StartFieldingLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is StartFieldingFailed) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message);
              fieldingBloc.add(GetAllPolesByID(
                  context.read<UserProvider>().userModel.data.token,
                  widget.allProjectsModel.iD));
            } else if (state is StartFieldingSuccess) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: "Start fielding success");
              Get.to(EditPolePage(
                poles: poleModelSelected,
                allProjectsModel: widget.allProjectsModel,
              ));
            }
          },
          builder: (context, state) {
            if (state is GetAllPolesByIdLoading) {
              return _loading();
            } else if (state is GetAllPolesByIdFailed) {
              return ErrorHandlingWidget(title: state.message);
            } else if (state is GetAllPolesByIdSuccess) {
              return _content(state.allPolesByLayer);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _content(List<AllPolesByLayerModel> allPoles) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Fielded Request",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: ColorHelpers.colorBlackText),
              ),
              InkWell(
                  onTap: () {
                    Get.to(EditPolePage(
                        allProjectsModel: widget.allProjectsModel,
                        isAddPole: true));
                  },
                  child: Icon(Icons.add, color: ColorHelpers.colorBlackText)),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  tiltGesturesEnabled: false,
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: (allPoles.length == 0)
                        ? LatLng(this.currentLocation.latitude,
                            this.currentLocation.longitude)
                        : LatLng(
                            double.parse(allPoles
                                .firstWhere((element) =>
                                    (element.latitude != null &&
                                        element.latitude.contains(".")))
                                .latitude),
                            double.parse(allPoles
                                .firstWhere((element) =>
                                    (element.longitude != null &&
                                        element.longitude.contains(".")))
                                .longitude)),
                    zoom: 14,
                  ),
                  onTap: (LatLng loc) {
                    print(_markers
                        .where((element) => element.position == loc)
                        .toString());
                    setState(() {
                      this.poleModelSelected = AllPolesByLayerModel();
                      this._tempMarkerSelected = null;
                      // id: null,
                      // latitude: null,
                      // longitude: null,
                      // fieldingBy: null,
                      // fieldingCompletedDate: null,
                      // fieldingStatus: null,
                      // poleSequence: null,
                      // poleNumber: null,
                      // startPolePicture: null);
                      showPinsOnMap(allPoles);
                    });
                  },
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                    showPinsOnMap(allPoles);
                  }),
              (allPoles.length == 0)
                  ? Container()
                  : SlidingUpPanel(
                      minHeight: 175,
                      maxHeight: MediaQuery.of(context).size.height / 1.3,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(25)),
                      panel: (allPoles.length == 0)
                          ? Container()
                          : _buildListAllPoles(allPoles),
                      body: Container(),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListAllPoles(List<AllPolesByLayerModel> allPoles) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: ColorHelpers.colorWhite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(50))),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            height: 2,
            width: 100,
            decoration: BoxDecoration(color: ColorHelpers.colorBorder),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  (_tempMarkerSelected == null)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Card(
                            color: ColorHelpers.colorYellowCard,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Pole Sequences",
                                            style: TextStyle(
                                                color:
                                                    ColorHelpers.colorBlackText,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                          (poleModelSelected.poleSequence ==
                                                  null)
                                              ? "-"
                                              : poleModelSelected.poleSequence
                                                  .toString(),
                                          style: TextStyle(
                                              color: ColorHelpers.colorOrange,
                                              fontSize: 24)),
                                    ],
                                  ),
                                  (poleModelSelected.fieldingStatus == 2)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.to(EditPolePage(
                                                  allProjectsModel:
                                                      widget.allProjectsModel,
                                                  poles: poleModelSelected,
                                                ));
                                              },
                                              child: Container(
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    color: ColorHelpers
                                                        .colorOrange,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  child: Text(
                                                    "Edit Pole Information",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  )),
                                            ),
                                            UIHelper.verticalSpaceSmall,
                                            InkWell(
                                              onTap: () {
                                                if (poleModelSelected
                                                    .startPolePicture) {
                                                  dialogAlert(poleModelSelected,
                                                      "complete pictures");
                                                } else {
                                                  dialogAlert(poleModelSelected,
                                                      "additional pictures");
                                                }
                                              },
                                              child: Container(
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      color: ColorHelpers
                                                          .colorYellowCard,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: ColorHelpers
                                                              .colorOrange)),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  child: Text(
                                                    (poleModelSelected
                                                            .startPolePicture)
                                                        ? "Complete Pictures"
                                                        : "Additional Pictures",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: ColorHelpers
                                                          .colorOrange,
                                                      fontSize: 12,
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        )
                                      : InkWell(
                                          onTap: () {
                                            fieldingBloc.add(StartFielding(
                                                context
                                                    .read<UserProvider>()
                                                    .userModel
                                                    .data
                                                    .token,
                                                poleModelSelected.id,
                                                true));
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorHelpers.colorOrange,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              child: Text(
                                                "Start",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              )),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  UIHelper.verticalSpaceSmall,
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Fielded Poles",
                      style: TextStyle(
                          fontSize: 14,
                          color: ColorHelpers.colorBlackText,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  UIHelper.verticalSpaceSmall,
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: allPoles
                        .map(
                          (data) => (data.fieldingStatus == 2)
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Card(
                                    color: ColorHelpers.colorGreenCard,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Pole Sequences",
                                                    style: TextStyle(
                                                        color: ColorHelpers
                                                            .colorBlackText,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                  (data.poleSequence == null)
                                                      ? "-"
                                                      : data.poleSequence
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: ColorHelpers
                                                          .colorGreen2,
                                                      fontSize: 24)),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(EditPolePage(
                                                    allProjectsModel:
                                                        widget.allProjectsModel,
                                                    poles: data,
                                                  ));
                                                },
                                                child: Container(
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      color: ColorHelpers
                                                          .colorGreen2,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    child: Text(
                                                      "Edit Pole Information",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    )),
                                              ),
                                              UIHelper.verticalSpaceSmall,
                                              InkWell(
                                                onTap: () {
                                                  if (data.startPolePicture) {
                                                    dialogAlert(data,
                                                        "complete pictures");
                                                  } else {
                                                    dialogAlert(data,
                                                        "additional pictures");
                                                  }
                                                },
                                                child: Container(
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        color: ColorHelpers
                                                            .colorGreenCard,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: ColorHelpers
                                                                .colorGreen2)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    child: Text(
                                                      (data.startPolePicture)
                                                          ? "Complete Pictures"
                                                          : "Additional Pictures",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: ColorHelpers
                                                            .colorGreen2,
                                                        fontSize: 12,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPinsOnMap(List<AllPolesByLayerModel> list) {
    if (list.length != 0) {
      list.forEach((data) {
        if (data.latitude != null && data.longitude != null) {
          var fieldingPosition =
              LatLng(double.parse(data.latitude), double.parse(data.longitude));

          // add the initial source location pin
          if (data.fieldingStatus == null ||
              data.fieldingStatus == 0 ||
              data.fieldingStatus == 1) {
            _markers.add(Marker(
                markerId: MarkerId("${data.id}"),
                position: fieldingPosition,
                onTap: () {
                  print("ID " + data.id);
                  selectedMarker(list, data);
                },
                icon: poleIcon));
          } else {
            _markers.add(Marker(
                markerId: MarkerId("${data.id}"),
                position: fieldingPosition,
                onTap: () {
                  print("ID " + data.id);
                  selectedMarker(list, data);
                },
                icon: poleGreen));
          }
        }
      });
      setState(() {});
    }
  }

  void selectedMarker(
      List<AllPolesByLayerModel> list, AllPolesByLayerModel data) {
    setState(() {
      _markers.clear();
      list.map((e) {
        if (e.latitude != null && e.longitude != null) {
          var position =
              LatLng(double.parse(e.latitude), double.parse(e.longitude));
          if (e.id == data.id) {
            _markers.add(Marker(
                markerId: MarkerId("${e.id}"),
                position: position,
                icon: poleSelected,
                onTap: () {
                  print("ID " + data.id);
                  selectedMarker(list, e);
                }));
            _tempMarkerSelected = Marker(
                markerId: MarkerId("${e.id}"),
                position: position,
                icon: poleSelected);
            poleModelSelected = e;
          } else {
            if (e.fieldingStatus == null ||
                e.fieldingStatus == 0 ||
                e.fieldingStatus == 1) {
              _markers.add(Marker(
                  markerId: MarkerId("${e.id}"),
                  position: position,
                  icon: poleIcon,
                  onTap: () {
                    print("ID " + data.id);
                    selectedMarker(list, e);
                  }));
            } else {
              _markers.add(Marker(
                  markerId: MarkerId("${e.id}"),
                  position: position,
                  icon: poleGreen,
                  onTap: () {
                    print("ID " + data.id);
                    selectedMarker(list, e);
                  }));
            }
          }
        }
      }).toList();
    });
  }

  Future dialogAlert(
      AllPolesByLayerModel allPolesByLayerModel, String valueAlert) {
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
                    'Are you sure $valueAlert?',
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
                            color: ColorHelpers.colorGrey.withOpacity(0.2),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style:
                                  TextStyle(color: ColorHelpers.colorBlackText),
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
                              if (allPolesByLayerModel.startPolePicture) {
                                fieldingBloc.add(CompletePolePicture(
                                  context
                                      .read<UserProvider>()
                                      .userModel
                                      .data
                                      .token,
                                  allPolesByLayerModel.id,
                                  widget.allProjectsModel.iD,
                                ));
                              } else {
                                fieldingBloc.add(StartPolePicture(
                                  context
                                      .read<UserProvider>()
                                      .userModel
                                      .data
                                      .token,
                                  allPolesByLayerModel.id,
                                  widget.allProjectsModel.iD,
                                ));
                              }

                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Confirm",
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
