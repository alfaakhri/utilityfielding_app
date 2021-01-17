import 'package:fielding_app/data/models/all_poles_by_layer_model.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  bool _editLocation = false;
  String _latitude;
  String _longitude;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _latitude = widget.polesLayerModel.latitude;
    _longitude = widget.polesLayerModel.longitude;
    setPoleIcons();
  }

  void setPoleIcons() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(6, 6)), 'assets/pin_yellow.png')
        .then((onValue) {
      poleIcon = onValue;
    });
  }

  void _onAddMarkerButtonPressed(LatLng latlang) {
    setState(() {
      _latitude = latlang.latitude.toString();
      _longitude = latlang.longitude.toString();
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("1"),
        position: latlang,
        draggable: (_editLocation) ? true : false,
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
      body: _content(widget.polesLayerModel),
    );
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
              Text("${allPoles.poleSequence}",
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
                    target: LatLng(double.parse(allPoles.latitude),
                        double.parse(allPoles.longitude)),
                    zoom: 16,
                  ),
                  onTap: (LatLng loc) {
                    if (_editLocation) {
                      if (_markers.length >= 1) {
                        _markers.clear();
                      }

                      _onAddMarkerButtonPressed(loc);
                    }
                  },
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                    showPinsOnMap(allPoles);
                  }),
              SlidingUpPanel(
                minHeight: 175,
                maxHeight: 175,
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
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Latitude",
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        ),
                      ),
                      Container(
                        child: Text(
                          double.parse(_latitude).toStringAsFixed(6),
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        ),
                      ),
                      UIHelper.verticalSpaceSmall,
                      (_editLocation)
                          ? Container()
                          : Container(
                              width: double.infinity,
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    if (!_editLocation) {
                                      _editLocation = true;
                                    }
                                  });
                                },
                                color: ColorHelpers.colorGrey.withOpacity(0.3),
                                child: Text(
                                  "Edit Location",
                                  style: TextStyle(
                                      color: ColorHelpers.colorBlackText),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                UIHelper.horizontalSpaceMedium,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Longitude",
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        ),
                      ),
                      Container(
                        child: Text(
                          double.parse(_longitude).toStringAsFixed(6),
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        ),
                      ),
                      UIHelper.verticalSpaceSmall,
                      (_editLocation)
                          ? Container()
                          : Container(
                              width: double.infinity,
                              child: FlatButton(
                                onPressed: () {},
                                color: ColorHelpers.colorButtonDefault,
                                child: Text(
                                  "Edit Information",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          (_editLocation)
              ? Container(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        if (_editLocation) {
                          _editLocation = false;
                        }
                      });
                    },
                    color: ColorHelpers.colorGreen,
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void showPinsOnMap(AllPolesByLayerModel list) {
    var fieldingPosition =
        LatLng(double.parse(list.latitude), double.parse(list.longitude));

    // add the initial source location pin

    _markers.add(Marker(
        markerId: MarkerId("${list.id}"),
        position: fieldingPosition,
        draggable: (_editLocation) ? true : false,
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
}
