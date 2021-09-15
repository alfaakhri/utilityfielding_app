import 'package:fielding_app/data/models/detail_fielding/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';

import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/bloc/location_bloc/location_bloc.dart';

import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/location_service.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';

class EditLatLngPage extends StatefulWidget {
  final AllPolesByLayerModel? polesLayerModel;
  final AllProjectsModel? allProjectsModel;
  final bool? isAddPole;
  final bool? isAddTreeTrim;

  const EditLatLngPage(
      {Key? key,
      this.polesLayerModel,
      this.allProjectsModel,
      this.isAddPole,
      this.isAddTreeTrim})
      : super(key: key);
  @override
  _EditLatLngPageState createState() => _EditLatLngPageState();
}

class _EditLatLngPageState extends State<EditLatLngPage> {
  Set<Marker> _markers = Set<Marker>();
  double pinPillPosition = -100;
  late LocationData currentLocation;
  late BitmapDescriptor poleIcon;

  late BitmapDescriptor poleGreen;
  late BitmapDescriptor poleGreenRed;

  late BitmapDescriptor poleBlue;
  late BitmapDescriptor poleBlueRed;

  late BitmapDescriptor treeIcon;

  late GoogleMapController googleMapController;
  // bool _editLocation = false;
  String? _latitude;
  String? _longitude;
  // LocationBloc locationBloc;
  GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Completer<GoogleMapController> _controller = Completer();
  LocationService locationService = LocationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var fielding = context.read<FieldingProvider>();
    if (widget.polesLayerModel!.latitude != null) {
      _latitude = fielding.latitude!.toString();
      _longitude = fielding.longitude!.toString();
      print("_latitude0" + _latitude.toString());
    } else {
      if (fielding.allPolesByLayer!.length != 0) {
        _latitude = fielding.allPolesByLayer!.first.latitude;
        _longitude = fielding.allPolesByLayer!.first.longitude;
      } else {
        if (fielding.latitude == null) {
          _latitude = fielding.currentPosition!.latitude.toString();
          _longitude = fielding.currentPosition!.longitude.toString();
          print("_latitude1" + _latitude.toString());
        } else {
          _latitude = fielding.latitude.toString();
          _longitude = fielding.longitude.toString();
          print("_latitude2" + _latitude.toString());
        }
      }
    }

    setPoleIcons();
    // locationService.locationStream.listen((location) {
    currentLocation = fielding.currentLocationData!;
    //   print("CURRENT LOCATION" + currentLocation.latitude.toString());
    // });
  }

  void setPoleIcons() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(6, 6)), 'assets/pin_yellow.png')
        .then((onValue) {
      poleIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_blue.png')
        .then((onValue) {
      poleBlue = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_blue_red.png')
        .then((onValue) {
      poleBlueRed = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_green.png')
        .then((onValue) {
      poleGreen = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_green_red.png')
        .then((onValue) {
      poleGreenRed = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/tree.png')
        .then((onValue) {
      treeIcon = onValue;
    });
  }

  void _onAddMarkerButtonPressed(double latitude, double longitude) {
    setState(() {
      _latitude = latitude.toString();
      _longitude = longitude.toString();
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("1"),
        position: LatLng(latitude, longitude),
        draggable:
            // (_editLocation) ?
            true,
        // : false,
        onDragEnd: ((newPosition) {
          setState(() {
            _latitude = newPosition.latitude.toString();
            _longitude = newPosition.longitude.toString();
          });
        }),
        icon: (widget.isAddTreeTrim!) ? treeIcon : poleIcon,
      ));
    });
    setState(() {});
  }

  void cameraMyLocation() async {
    googleMapController = await _controller.future;
    _onAddMarkerButtonPressed(
        currentLocation.latitude!, currentLocation.longitude!);
    CameraPosition cPosition = CameraPosition(
      zoom: 16,
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
    );
    setState(() {
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cPosition));
    });
  }

  @override
  void dispose() {
    locationService.dispose();
    _controller.isCompleted;

    super.dispose();
  }

  void doneAddPole() {
    var provider = context.read<FieldingProvider>();

    AddPoleModel data = AddPoleModel(
      token: context.read<AuthBloc>().userModel!.data!.token,
      id: null,
      layerId: widget.allProjectsModel!.iD,
      street: (provider.streetName == null) ? null : provider.streetName,
      latitude: provider.latitude.toString(),
      longitude: provider.longitude.toString(),
      poleType: (widget.isAddTreeTrim!) ? 4 : 0,
    );

    context.read<FieldingBloc>().add(AddPole(
          data,
          provider.allProjectsSelected,
          provider.polesByLayerSelected,
          context.read<ConnectionProvider>().isConnected,
          context.read<AuthBloc>().userModel!.data!.user!.iD!,
          false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pole",
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
          backgroundColor: Colors.white,
        ),
        body: BlocListener<FieldingBloc, FieldingState>(
          listener: (context, state) {
            if (state is AddPoleLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is AddPoleFailed) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message!);
            } else if (state is AddPoleSuccess) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: "Success");
              var fielding = context.read<FieldingProvider>();
              fielding.setPolesByLayerSelected(AllPolesByLayerModel());
              fielding.setFieldingTypeAssign(3);
              fielding.setLatLng(0, 0);
              fielding.setStreetName("");
              fielding.clearAll();
              
              var user = context.read<UserProvider>();
              context.read<FieldingBloc>().add(GetAllPolesByID(
                  user.userModel.data!.token,
                  widget.allProjectsModel,
                  context.read<ConnectionProvider>().isConnected,
                  user.userModel.data!.user!.iD!));
              Get.back();
            }
          },
          child: BlocListener<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state is UpdateLocationLoading) {
                LoadingWidget.showLoadingDialog(context, _keyLoader);
              } else if (state is UpdateLocationFailed) {
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                    .pop();
                Fluttertoast.showToast(msg: state.message!);
              } else if (state is UpdateLocationSuccess) {
                setState(() {
                  _latitude = state.allPolesByLayerModel.latitude;
                  _longitude = state.allPolesByLayerModel.longitude;
                  // _editLocation = false;
                });
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                    .pop();
                Fluttertoast.showToast(msg: "Update location success");
                context.read<LocationBloc>().add(GetCurrentAddress(
                    double.parse(_latitude!), double.parse(_longitude!)));
              } else if (state is GetCurrentAddressLoading) {
                LoadingWidget.showLoadingDialog(context, _keyLoader);
              } else if (state is GetCurrentAddressFailed) {
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                    .pop();
                Fluttertoast.showToast(msg: state.message);
              } else if (state is GetCurrentAddressSuccess) {
                var fielding = context.read<FieldingProvider>();
                AllPolesByLayerModel poles = fielding.polesByLayerSelected;
                poles.latitude = _latitude!.toString();
                poles.longitude = _longitude!.toString();
                fielding.setPolesByLayerSelected(poles);
                fielding.setLatLng(
                    double.parse(_latitude!), double.parse(_longitude!));
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                    .pop();
                Fluttertoast.showToast(msg: "Update location success");
                context
                    .read<FieldingProvider>()
                    .setCurrentAddress(state.currentAddress);
                if (widget.isAddPole! || widget.isAddTreeTrim!) {
                  doneAddPole();
                } else {
                  Get.back();
                }
              }
            },
            child: _content(),
          ),
        ));
  }

  Widget _content() {
    var fielding = context.read<FieldingProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: (widget.isAddPole!)
              ? Text("Add Pole")
              : (widget.isAddTreeTrim!)
                  ? Text("Add Tree Trim")
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pole Number",
                          style: TextStyle(
                              fontSize: 14, color: ColorHelpers.colorBlackText),
                        ),
                        Text(
                            (widget.polesLayerModel!.id == null)
                                ? "-"
                                : widget.polesLayerModel!.poleSequence
                                    .toString(),
                            style: TextStyle(
                                color: ColorHelpers.colorBlueNumber,
                                fontSize: 18)),
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
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    new Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        double.parse(fielding.allPolesByLayer!.first.latitude!),
                        double.parse(
                            fielding.allPolesByLayer!.first.longitude!)),
                    zoom: 18,
                  ),
                  onTap: (LatLng loc) {
                    // if (_editLocation) {
                    if (_markers.length >= 1) {
                      _markers.clear();
                    }

                    _onAddMarkerButtonPressed(loc.latitude, loc.longitude);
                    // }
                    if (context
                            .read<FieldingProvider>()
                            .allPolesByLayer!
                            .length !=
                        0) {
                      showPinsOnMapAllPoles(fielding.allPolesByLayer!);
                    }
                  },
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                    _controller.complete(controller);

                    if (widget.polesLayerModel!.latitude != null) {
                      showPinsOnMap(widget.polesLayerModel!);
                    } else if (fielding.latitude != null) {
                      showPinsOnMapDefault(
                          fielding.latitude!, fielding.longitude!);
                    }

                    if (fielding.allPolesByLayer!.length != 0) {
                      showPinsOnMapAllPoles(fielding.allPolesByLayer!);
                    }
                    Fluttertoast.showToast(
                        msg: "Tap & drag to add pole in map",
                        toastLength: Toast.LENGTH_LONG);
                  }),
              SlidingUpPanel(
                minHeight: 200,
                maxHeight: 200,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(25)),
                panel: _bottomPanel(),
                body: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomPanel() {
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
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Latitude",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorHelpers.colorBlackText),
                              ),
                            ),
                            Container(
                              child: Text(
                                double.parse(_latitude!).toStringAsFixed(6),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorHelpers.colorBlackText),
                              ),
                            ),
                            UIHelper.verticalSpaceSmall,
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Longitude",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorHelpers.colorBlackText),
                              ),
                            ),
                            Container(
                              child: Text(
                                double.parse(_longitude!).toStringAsFixed(6),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorHelpers.colorBlackText),
                              ),
                            ),
                            UIHelper.verticalSpaceSmall,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // (_editLocation)
                // ? Container() :
                InkWell(
                  onTap: () {
                    cameraMyLocation();
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: ColorHelpers.colorButtonDefault),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.my_location,
                            color: ColorHelpers.colorButtonDefault),
                        UIHelper.horizontalSpaceSmall,
                        Text(
                          "Move Pole to My Location",
                          style:
                              TextStyle(color: ColorHelpers.colorButtonDefault),
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelper.verticalSpaceVerySmall,
                // (_editLocation) ?
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      dialogAlert();
                    },
                    color: ColorHelpers.colorButtonDefault,
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // : Container(),
              ],
            ),
          ),
        ],
      ),
      // ),
    );
  }

  void showPinsOnMap(AllPolesByLayerModel list) {
    var fieldingPosition =
        LatLng(double.parse(list.latitude!), double.parse(list.longitude!));

    // add the initial source location pin

    _markers.add(Marker(
        markerId: MarkerId("${list.id}"),
        position: fieldingPosition,
        draggable:
            // (_editLocation) ?
            true,
        // : false,
        onDragEnd: ((newPosition) {
          setState(() {
            _latitude = newPosition.latitude.toString();
            _longitude = newPosition.longitude.toString();
          });
        }),
        onTap: () {
          setState(() {
            pinPillPosition = 0;
          });
        },
        icon: poleIcon));
    setState(() {});
  }

  void showPinsOnMapDefault(double latitude, double longitude) {
    var fieldingPosition = LatLng(latitude, longitude);

    // add the initial source location pin

    _markers.add(Marker(
        markerId: MarkerId("123"),
        position: fieldingPosition,
        draggable:
            // (_editLocation) ?
            true,
        // : false,
        onDragEnd: ((newPosition) {
          setState(() {
            _latitude = newPosition.latitude.toString();
            _longitude = newPosition.longitude.toString();
          });
        }),
        onTap: () {
          setState(() {
            pinPillPosition = 0;
          });
        },
        icon: poleIcon));
    setState(() {});
  }

  void showPinsOnMapAllPoles(List<AllPolesByLayerModel> list) {
    if (list.length != 0) {
      list.forEach((data) {
        if (data.latitude != null && data.longitude != null) {
          var fieldingPosition = LatLng(
              double.parse(data.latitude!), double.parse(data.longitude!));
          if (widget.polesLayerModel != null) {
            if (widget.polesLayerModel!.id != data.id) {
              // add the initial source location pin
              if (data.poleType == 4) {
                _markers.add(Marker(
                    markerId: MarkerId("${data.id}"),
                    position: fieldingPosition,
                    icon: treeIcon));
              } else if (data.fieldingStatus == null ||
                  data.fieldingStatus == 0 ||
                  data.fieldingStatus == 1) {
                _markers.add(Marker(
                    markerId: MarkerId("${data.id}"),
                    position: fieldingPosition,
                    icon: (data.markerPath == null)
                        ? poleBlue
                        : (data.markerPath == markerPathDefault)
                            ? poleBlue
                            : poleBlueRed));
              } else {
                _markers.add(Marker(
                    markerId: MarkerId("${data.id}"),
                    position: fieldingPosition,
                    icon: (data.markerPath == null)
                        ? poleGreen
                        : (data.markerPath == markerPathDefault)
                            ? poleGreen
                            : poleGreenRed));
              }
            }
          } else {
            if (data.poleType == 4) {
              _markers.add(Marker(
                  markerId: MarkerId("${data.id}"),
                  position: fieldingPosition,
                  icon: treeIcon));
            }
            if (data.fieldingStatus == null ||
                data.fieldingStatus == 0 ||
                data.fieldingStatus == 1) {
              _markers.add(Marker(
                  markerId: MarkerId("${data.id}"),
                  position: fieldingPosition,
                  icon: (data.markerPath == null)
                      ? poleBlue
                      : (data.markerPath == markerPathDefault)
                          ? poleBlue
                          : poleBlueRed));
            } else {
              _markers.add(Marker(
                  markerId: MarkerId("${data.id}"),
                  position: fieldingPosition,
                  icon: (data.markerPath == null)
                      ? poleGreen
                      : (data.markerPath == markerPathDefault)
                          ? poleGreen
                          : poleGreenRed));
            }
          }
        }
      });
      setState(() {});
    }
  }

  Future dialogAlert() {
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
                    'Are you sure move Pole Location?',
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
                              if (widget.polesLayerModel!.id == null) {
                                context.read<LocationBloc>().add(
                                    GetCurrentAddress(double.parse(_latitude!),
                                        double.parse(_longitude!)));
                              } else {
                                context.read<LocationBloc>().add(UpdateLocation(
                                    context
                                        .read<UserProvider>()
                                        .userModel
                                        .data!
                                        .token,
                                    widget.polesLayerModel!.id,
                                    _latitude,
                                    _longitude));
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
