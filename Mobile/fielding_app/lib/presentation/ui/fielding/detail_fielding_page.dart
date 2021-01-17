import 'package:fielding_app/data/models/all_poles_by_layer_model.dart';
import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/service/location_service.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/fielding/edit_pole_lat_lng_page.dart';
import 'package:fielding_app/presentation/widgets/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    // TODO: implement initState
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
            ImageConfiguration(size: Size(12, 12)), 'assets/pin_blue.png')
        .then((onValue) {
      poleIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)), 'assets/pin_yellow.png')
        .then((onValue) {
      poleSelected = onValue;
    });
  }

  void _onSelectedMarker(LatLng latlang, List<AllPolesByLayerModel> list) {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("1"),
        position: latlang,
        icon: poleSelected,
      ));
    });
    setState(() {});
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
            "Project Grid",
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
        body: BlocBuilder<FieldingBloc, FieldingState>(
          builder: (context, state) {
            if (state is GetAllPolesByIdLoading) {
              return _loading();
            } else if (state is GetAllPolesByIdFailed) {
              return ErrorHandlingWidget(title: state.message);
            } else if (state is GetAllPolesByIdSuccess) {
              return _content(state.allPolesByLayer);
            }
            return _loading();
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
              Icon(Icons.add, color: ColorHelpers.colorBlackText),
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
                    target: LatLng(double.parse(allPoles.last.latitude),
                        double.parse(allPoles.last.longitude)),
                    zoom: 10,
                  ),
                  onTap: (LatLng loc) {
                    print(_markers
                        .where((element) => element.position == loc)
                        .toString());
                  },
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                    showPinsOnMap(allPoles);
                  }),
              SlidingUpPanel(
                minHeight: 175,
                maxHeight: MediaQuery.of(context).size.height / 1.3,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                panel: _buildListAllPoles(allPoles),
                body: Container(),
              ),

              // Expanded(
              //   child: GoogleMap(
              //         zoomControlsEnabled: false,
              //         myLocationEnabled: true,
              //         compassEnabled: true,
              //         tiltGesturesEnabled: false,
              //         markers: _markers,
              //         mapType: MapType.normal,
              //         initialCameraPosition: CameraPosition(
              //           target: LatLng(double.parse(allPoles.last.latitude),
              //               double.parse(allPoles.last.longitude)),
              //           zoom: 10,
              //         ),
              //         onTap: (LatLng loc) {
              //           pinPillPosition = -100;
              //         },
              //         onMapCreated: (GoogleMapController controller) {
              //           googleMapController = controller;
              //           showPinsOnMap(allPoles);
              //         }),
              // ),
              // Expanded(
              //   child: SlidingUpPanel(
              //     minHeight: 175,
              //     maxHeight: MediaQuery.of(context).size.height / 1.3,
              //     borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              //     panel: _buildListAllPoles(allPoles),
              //     body: Container(),
              //   ),
              // ),
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
                          (data) => Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Card(
                              color: ColorHelpers.colorBlue,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(EditLatLngPage(
                                            polesLayerModel: data));
                                      },
                                      child: Column(
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
                                                    color: ColorHelpers
                                                        .colorBlackText,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(data.poleSequence ?? "-",
                                              style: TextStyle(
                                                  color: ColorHelpers
                                                      .colorBlueNumber,
                                                  fontSize: 24)),
                                          // Text(
                                          //   "Total Poles",
                                          //   style: TextStyle(
                                          //       fontSize: 12,
                                          //       color:
                                          //           ColorHelpers.colorBlackText),
                                          // ),
                                          // Text(
                                          //   "Finished 3 Poles",
                                          //   style: TextStyle(
                                          //       fontSize: 12,
                                          //       color:
                                          //           ColorHelpers.colorBlackText),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(EditPolePage());
                                          },
                                          child: Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: ColorHelpers
                                                    .colorButtonDefault,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
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
                                            dialogAlert();
                                          },
                                          child: Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: ColorHelpers.colorBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: ColorHelpers
                                                          .colorButtonDefault)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              child: Text(
                                                "Add Pole Pictures",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: ColorHelpers
                                                      .colorButtonDefault,
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
                          ),
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
    list.forEach((data) {
      var fieldingPosition =
          LatLng(double.parse(data.latitude), double.parse(data.longitude));

      // add the initial source location pin

      _markers.add(Marker(
          markerId: MarkerId("${data.id}"),
          position: fieldingPosition,
          onTap: () {
            selectedMarker(list, data);
          },
          icon: poleIcon));
    });
    setState(() {});
  }

  void selectedMarker(
      List<AllPolesByLayerModel> list, AllPolesByLayerModel data) {
    setState(() {
      _markers.clear();
      list.map((e) {
        var position =
            LatLng(double.parse(e.latitude), double.parse(e.longitude));
        if (e.id == data.id) {
          _markers.add(Marker(
              markerId: MarkerId("${e.id}"),
              position: position,
              icon: poleSelected,
              onTap: () {
                selectedMarker(list, e);
              }));
          _tempMarkerSelected = Marker(
              markerId: MarkerId("${e.id}"),
              position: position,
              icon: poleSelected);
        } else {
          _markers.add(Marker(
              markerId: MarkerId("${e.id}"),
              position: position,
              icon: poleIcon,
              onTap: () {
                selectedMarker(list, e);
              }));
        }
      }).toList();
    });
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
                    'Are you sure complete pictures?',
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
                              Navigator.pop(context);
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
