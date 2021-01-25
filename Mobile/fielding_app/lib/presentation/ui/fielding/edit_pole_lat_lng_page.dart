import 'package:fielding_app/data/models/all_poles_by_layer_model.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/bloc/location_bloc/location_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/service/location_service.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';

class EditLatLngPage extends StatefulWidget {
  final AllPolesByLayerModel polesLayerModel;

  const EditLatLngPage({Key key, this.polesLayerModel}) : super(key: key);
  @override
  _EditLatLngPageState createState() => _EditLatLngPageState();
}

class _EditLatLngPageState extends State<EditLatLngPage> {
  Set<Marker> _markers = Set<Marker>();
  double pinPillPosition = -100;
  LocationData currentLocation;
  BitmapDescriptor poleIcon;
  GoogleMapController googleMapController;
  // bool _editLocation = false;
  String _latitude;
  String _longitude;
  FieldingBloc fieldingBloc;
  // LocationBloc locationBloc;
  GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Completer<GoogleMapController> _controller = Completer();
  LocationService locationService = LocationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.polesLayerModel != null) {
      _latitude = widget.polesLayerModel.latitude;
      _longitude = widget.polesLayerModel.longitude;
      print("_latitude0" + _latitude.toString());
    } else {
      if (context.read<FieldingProvider>().latitude == null) {
        _latitude = context
            .read<FieldingProvider>()
            .currentPosition
            .latitude
            .toString();
        _longitude = context
            .read<FieldingProvider>()
            .currentPosition
            .longitude
            .toString();
        print("_latitude1" + _latitude.toString());
      } else {
        _latitude = context.read<FieldingProvider>().latitude.toString();
        _longitude = context.read<FieldingProvider>().longitude.toString();
        print("_latitude2" + _latitude.toString());
      }
    }
    fieldingBloc = BlocProvider.of<FieldingBloc>(context);
    // locationBloc = BlocProvider.of<LocationBloc>(context);
    setPoleIcons();
    locationService.locationStream.listen((location) {
      currentLocation = location;
      print("CURRENT LOCATION" + currentLocation.latitude.toString());
    });
  }

  void setPoleIcons() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(6, 6)), 'assets/pin_yellow.png')
        .then((onValue) {
      poleIcon = onValue;
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
        icon: poleIcon,
      ));
    });
    setState(() {});
  }

  void cameraMyLocation() async {
    googleMapController = await _controller.future;
    _onAddMarkerButtonPressed(
        currentLocation.latitude, currentLocation.longitude);
    CameraPosition cPosition = CameraPosition(
      zoom: 16,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
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
            if (state is UpdateLocationLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is UpdateLocationFailed) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message);
            } else if (state is UpdateLocationSuccess) {
              setState(() {
                _latitude = state.allPolesByLayerModel.latitude;
                _longitude = state.allPolesByLayerModel.longitude;
                // _editLocation = false;
              });
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: "Update location success");
              fieldingBloc.add(GetCurrentAddress(
                  double.parse(_latitude), double.parse(_longitude)));
            } else if (state is GetCurrentAddressLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is GetCurrentAddressFailed) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message);
            } else if (state is GetCurrentAddressSuccess) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: "Update location success");

              context
                  .read<FieldingProvider>()
                  .setCurrentAddress(state.currentAddress);
            }
          },
          child: _content(widget.polesLayerModel),
        ));
  }

  Widget _content(AllPolesByLayerModel allPoles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pole Number",
                style:
                    TextStyle(fontSize: 14, color: ColorHelpers.colorBlackText),
              ),
              Text(
                  (widget.polesLayerModel == null)
                      ? "-"
                      : (allPoles != null) ? allPoles.poleSequence.toString() : "-",
                  style: TextStyle(
                      color: ColorHelpers.colorBlueNumber, fontSize: 18)),
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
                        double.parse(_latitude), double.parse(_longitude)),
                    zoom: 16,
                  ),
                  onTap: (LatLng loc) {
                    // if (_editLocation) {
                    if (_markers.length >= 1) {
                      _markers.clear();
                    }

                    _onAddMarkerButtonPressed(loc.latitude, loc.longitude);
                    // }
                  },
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                    _controller.complete(controller);

                    if (widget.polesLayerModel != null) {
                      showPinsOnMap(allPoles);
                    } 
                    else if (context.read<FieldingProvider>().latitude != null) {
                      showPinsOnMapDefault(
                          context.read<FieldingProvider>().latitude,
                          context.read<FieldingProvider>().longitude);
                    }
                  }),
              SlidingUpPanel(
                minHeight: 200,
                maxHeight: 200,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                panel: _buildListAllPoles(allPoles),
                body: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListAllPoles(AllPolesByLayerModel allPoles) {
    // return BlocListener<LocationBloc, LocationState>(
    //   listener: (context, state) {
    //     if (state is GetCurrentAddressLoading) {
    //       LoadingWidget.showLoadingDialog(context, _keyLoader);
    //     } else if (state is GetCurrentAddressFailed) {
    //       Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    //     } else if (state is GetCurrentAddressSuccess) {
    //       Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    //       context
    //           .read<FieldingProvider>()
    //           .setCurrentAddress(state.currentAddress);
    //     }
    //   },
    // child:
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
                                double.parse(_latitude).toStringAsFixed(6) ??
                                    "-",
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
                                double.parse(_longitude).toStringAsFixed(6) ??
                                    "-",
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
        LatLng(double.parse(list.latitude), double.parse(list.longitude));

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
                              if (widget.polesLayerModel == null) {
                                context
                                    .read<FieldingProvider>()
                                    .setLatitude(double.parse(_latitude));
                                context
                                    .read<FieldingProvider>()
                                    .setLongitude(double.parse(_longitude));
                                fieldingBloc.add(GetCurrentAddress(
                                    double.parse(_latitude),
                                    double.parse(_longitude)));
                              } else {
                                context.read<FieldingProvider>().setLatitude(
                                    double.parse(
                                        widget.polesLayerModel.latitude));
                                context.read<FieldingProvider>().setLongitude(
                                    double.parse(
                                        widget.polesLayerModel.longitude));
                                fieldingBloc.add(UpdateLocation(
                                    context
                                        .read<UserProvider>()
                                        .userModel
                                        .data
                                        .token,
                                    widget.polesLayerModel.id,
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
