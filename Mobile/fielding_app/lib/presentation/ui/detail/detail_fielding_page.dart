import 'package:fielding_app/data/models/detail_fielding/item_line_by_layer_model.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/local_provider.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/domain/provider/symbol_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/widgets/widgets_detail_exports.dart';
import 'package:fielding_app/presentation/ui/edit_pole/edit_pole.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DetailFieldingPage extends StatefulWidget {
  final AllProjectsModel? allProjectsModel;
  final bool? isLocalMenu;

  const DetailFieldingPage({Key? key, this.allProjectsModel, this.isLocalMenu}) : super(key: key);
  @override
  _DetailFieldingPageState createState() => _DetailFieldingPageState();
}

class _DetailFieldingPageState extends State<DetailFieldingPage> {
  late FieldingBloc fieldingBloc;
  GoogleMapController? googleMapController;
  Marker? _tempMarkerSelected;
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> polylines = {};
  // Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];

  double pinPillPosition = -100;
  bool showButtonCompleteMulti = true;
  late LocationData currentLocation;
  late BitmapDescriptor poleIcon;
  late BitmapDescriptor poleIconRed;
  late BitmapDescriptor poleSelected;
  late BitmapDescriptor poleSelectedRed;
  late BitmapDescriptor poleGreen;
  late BitmapDescriptor poleGreenRed;
  late BitmapDescriptor treeIcon;
  late BitmapDescriptor anchorIcon;
  AllPolesByLayerModel? poleModelSelected;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    fieldingBloc = BlocProvider.of<FieldingBloc>(context);
    getAllPoleById();
    getCurrentLocation();
    setPoleIcons();
  }

  void getCurrentLocation() async {
    currentLocation = context.read<FieldingProvider>().currentLocationData!;
  }

  void setPoleIcons() async {
    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)), 'assets/pin_blue.png').then((onValue) {
      poleIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)), 'assets/pin_blue_red.png')
        .then((onValue) {
      poleIconRed = onValue;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)), 'assets/pin_yellow.png')
        .then((onValue) {
      poleSelected = onValue;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)), 'assets/pin_yellow_red.png')
        .then((onValue) {
      poleSelectedRed = onValue;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)), 'assets/pin_green.png').then((onValue) {
      poleGreen = onValue;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)), 'assets/pin_green_red.png')
        .then((onValue) {
      poleGreenRed = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(2, 2)),
      'assets/tree.png',
    ).then((onValue) {
      treeIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)), 'assets/default-anchor.png')
        .then((onValue) {
      anchorIcon = onValue;
    });
  }

  void getAllPoleById() {
    var user = context.read<UserProvider>();

    fieldingBloc.add(GetAllPolesByID(user.userModel.data!.token, widget.allProjectsModel!,
        context.read<ConnectionProvider>().isConnected, user.userModel.data!.user!.iD!));
  }

  void searchPolesByStatus() {
    context
        .read<FieldingProvider>()
        .allPolesByLayer!
        .where((element) => element.poleType != 4)
        .toList()
        .forEach((element) {
      if (element.fieldingStatus != 2) {
        setState(() {
          showButtonCompleteMulti = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.poleModelSelected = AllPolesByLayerModel();
    this._tempMarkerSelected = null;
  }

  void callback() {
    this.poleModelSelected = AllPolesByLayerModel();
    this._tempMarkerSelected = null;
  }

  @override
  Widget build(BuildContext context) {
    var fielding = context.read<FieldingProvider>();
    var connect = context.read<ConnectionProvider>();
    return WillPopScope(
      onWillPop: () {
        fieldingBloc.add(GetFieldingRequest(context.read<UserProvider>().userModel.data!.token, connect.isConnected));
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.allProjectsModel!.layerName!,
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
          ),
          leading: IconButton(
            onPressed: () {
              fieldingBloc
                  .add(GetFieldingRequest(context.read<UserProvider>().userModel.data!.token, connect.isConnected));
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
            if (state is GetAllPolesByIdSuccess) {
              showButtonCompleteMulti = true;
              context.read<LocalProvider>().updateProjectsLocal(context.read<UserProvider>().userModel.data!.user!.iD!);
              connect.updateForTriggerDialog(context.read<UserProvider>().userModel.data!.user!.iD!);
              fielding.setAllPolesByLayer(state.allPolesByLayer);
              fielding.setFieldingTypeAssign(3);
              searchPolesByStatus();
            } else if (state is StartPolePictureLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is StartPolePictureFailed) {
              getAllPoleById();
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              Fluttertoast.showToast(msg: state.message!);
            } else if (state is StartPolePictureSuccess) {
              setState(() {});
              Fluttertoast.showToast(msg: "Additional pole pictures success");

              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              getAllPoleById();
              this.poleModelSelected = AllPolesByLayerModel();
              this._tempMarkerSelected = null;
            } else if (state is CompletePolePictureLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is CompletePolePictureFailed) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              Fluttertoast.showToast(msg: state.message!);
              getAllPoleById();
            } else if (state is CompletePolePictureSuccess) {
              setState(() {});
              Fluttertoast.showToast(msg: "Complete pole pictures success");

              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              getAllPoleById();
              this.poleModelSelected = AllPolesByLayerModel();
              this._tempMarkerSelected = null;
            } else if (state is StartFieldingLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is StartFieldingFailed) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              Fluttertoast.showToast(msg: state.message!, toastLength: Toast.LENGTH_LONG);
              getAllPoleById();
            } else if (state is StartFieldingSuccess) {
              if (connect.isConnected) {
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              }

              Fluttertoast.showToast(msg: "Start fielding success");
              showButtonCompleteMulti = true;
              Get.to(EditPolePage(
                poles: poleModelSelected,
                allProjectsModel: widget.allProjectsModel,
                isStartComplete: true,
              ));
              fieldingBloc.setStartTimer(DateTime.now().toUtc());
              fielding.setPolesByLayerSelected(poleModelSelected!);
              fielding.setLatLng(0, 0);
              callback();
            } else if (state is CompleteMultiPoleLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is CompleteMultiPoleSuccess) {
              setState(() {});
              Fluttertoast.showToast(msg: "Complete Multi pole success");

              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              getAllPoleById();
              this.poleModelSelected = AllPolesByLayerModel();
              this._tempMarkerSelected = null;
            } else if (state is CompleteMultiPoleFailed) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              Fluttertoast.showToast(msg: state.message!, toastLength: Toast.LENGTH_LONG);
              getAllPoleById();
            }
          },
          builder: (context, state) {
            if (state is GetAllPolesByIdLoading) {
              return _loading();
            } else if (state is GetAllPolesByIdFailed) {
              return ErrorHandlingWidget(
                title: state.message,
                subTitle: "Please come back in a moment.",
              );
            } else if (state is GetAllPolesByIdSuccess) {
              // TODO: activated if filter fielding type not hidden
              // List<AllPolesByLayerModel>? allPolesByFilter;
              // if (fielding.fieldingTypeSelected!.id != 3) {
              //   allPolesByFilter = state.allPolesByLayer!
              //       .where((element) =>
              //           element.fieldingType ==
              //           fielding.fieldingTypeSelected!.id)
              //       .toList();
              // } else {
              //   allPolesByFilter = state.allPolesByLayer;
              // }
              if (connect.isConnected) {
                return Consumer<SymbolProvider>(builder: (context, symbol, _) {
                  if (symbol.state == SymbolState.loading) {
                    return _loading();
                  } else if (symbol.state == SymbolState.success) {
                    symbol.otherSymbolsModel.forEach((element) {
                      var fieldingPosition = LatLng(double.parse(element.latitude!), double.parse(element.longitude!));
                      _markers.add(Marker(
                          markerId: MarkerId("${element.iD}"),
                          position: fieldingPosition,
                          icon: (element.poleType == 12) ? anchorIcon : treeIcon));
                    });

                    if (symbol.listItemLineByLayer.isNotEmpty) {
                      getPolyline(symbol.listItemLineByLayer);
                    }

                    return _content(state.allPolesByLayer);
                  } else if (symbol.state == SymbolState.empty) {
                    return _content(state.allPolesByLayer);
                  } else if (symbol.state == SymbolState.failed) {
                    return _content(state.allPolesByLayer);
                  }
                  return Container();
                });
              } else {
                return _content(state.allPolesByLayer);
              }
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

  Widget _content(List<AllPolesByLayerModel>? allPoles) {
    return Column(
      children: [
        TitleMapItem(
          allProjectsModel: widget.allProjectsModel!,
          isLocalMenu: widget.isLocalMenu!,
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
                  target: (allPoles!.length == 0)
                      ? LatLng(this.currentLocation.latitude!, this.currentLocation.longitude!)
                      : (allPoles.first.latitude == null)
                          ? LatLng(this.currentLocation.latitude!, this.currentLocation.longitude!)
                          : LatLng(
                              double.parse(allPoles
                                  .firstWhere(
                                      (element) => (element.latitude != null && element.latitude!.contains(".")))
                                  .latitude!),
                              double.parse(allPoles
                                  .firstWhere(
                                      (element) => (element.longitude != null && element.longitude!.contains(".")))
                                  .longitude!)),
                  zoom: 18,
                ),
                onTap: (LatLng loc) {
                  print(_markers.where((element) => element.position == loc).toString());
                  setState(() {
                    this.poleModelSelected = AllPolesByLayerModel();
                    this._tempMarkerSelected = null;

                    showPinsOnMap(allPoles);
                  });
                },
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                  showPinsOnMap(allPoles);
                  // showSymbolMap();
                },
                // polylines: Set<Polyline>.of(polylines.values),
                polylines: polylines,
              ),
              (allPoles.length == 0)
                  ? Container()
                  : SlidingUpPanel(
                      minHeight: 175,
                      maxHeight: MediaQuery.of(context).size.height / 1.3,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(25)),
                      panel: (allPoles.length == 0) ? Container() : _buildListAllPoles(allPoles),
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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(50))),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  (_tempMarkerSelected == null)
                      ? Container()
                      : PoleSequenceSelectedItem(poleModelSelected: poleModelSelected, callback: callback),
                  UIHelper.verticalSpaceSmall,
                  (showButtonCompleteMulti)
                      ? CompleteMultiPoleButton(
                          token: context.read<UserProvider>().userModel.data!.token,
                          layerId: widget.allProjectsModel!.iD,
                        )
                      : Container(),
                  UIHelper.verticalSpaceSmall,
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Fielded Poles",
                      style: TextStyle(fontSize: 14, color: ColorHelpers.colorBlackText, fontWeight: FontWeight.bold),
                    ),
                  ),
                  UIHelper.verticalSpaceSmall,
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: allPoles
                        .map(
                          (data) =>
                              (data.fieldingStatus == 2) ? PoleSequenceItem(allPolesByLayerModel: data) : Container(),
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

  void getPolyline(List<ItemLineByLayerModel> listItemLine) async {
    var map = context.read<MapProvider>();
    for (var item in listItemLine) {
      polylines.add(await map.getRoutePolyline(
        position: item.position!,
        color: (item.color != null) ? Colors.black : Colors.blue,
        id: item.iD!,
        width: 3,
      ));

      print(polylines);
    }
  }

  void showPinsOnMap(List<AllPolesByLayerModel> list) {
    if (list.length != 0) {
      list.forEach((data) {
        if (data.latitude != null && data.longitude != null) {
          var fieldingPosition = LatLng(double.parse(data.latitude!), double.parse(data.longitude!));

          if (data.fieldingStatus == null || data.fieldingStatus == 0 || data.fieldingStatus == 1) {
            _markers.add(Marker(
                markerId: MarkerId("${data.id}"),
                position: fieldingPosition,
                onTap: () {
                  print("ID " + data.id!);
                  selectedMarker(list, data);
                },
                icon: (data.markerPath == null)
                    ? poleIcon
                    : (data.markerPath == markerPathDefault)
                        ? poleIcon
                        : poleIconRed));
          } else {
            _markers.add(Marker(
                markerId: MarkerId("${data.id}"),
                position: fieldingPosition,
                onTap: () {
                  print("ID " + data.id!);
                  selectedMarker(list, data);
                },
                icon: (data.markerPath == null)
                    ? poleGreen
                    : (data.markerPath == markerPathDefault)
                        ? poleGreen
                        : poleGreenRed));
          }
        }
      });
      setState(() {});
    }
  }

  void selectedMarker(List<AllPolesByLayerModel> list, AllPolesByLayerModel data) {
    setState(() {
      _markers.clear();
      list.map((e) {
        //Check latlong is null
        if (e.latitude != null && e.longitude != null) {
          var position = LatLng(double.parse(e.latitude!), double.parse(e.longitude!));
          //Check ID is the same
          if (e.id == data.id) {
            _markers.add(Marker(
                markerId: MarkerId("${e.id}"),
                position: position,
                icon: (e.markerPath == null)
                    ? poleSelected
                    : (e.markerPath == markerPathDefault)
                        ? poleSelected
                        : poleSelectedRed,
                onTap: () {
                  print("ID " + data.id!);
                  selectedMarker(list, e);
                }));
            _tempMarkerSelected = Marker(
                markerId: MarkerId("${e.id}"),
                position: position,
                icon: (e.markerPath == null)
                    ? poleSelected
                    : (e.markerPath == markerPathDefault)
                        ? poleSelected
                        : poleSelectedRed);
            poleModelSelected = e;
          } else {
            if (e.fieldingStatus == null || e.fieldingStatus == 0 || e.fieldingStatus == 1) {
              _markers.add(Marker(
                  markerId: MarkerId("${e.id}"),
                  position: position,
                  icon: (e.markerPath == null)
                      ? poleIcon
                      : (e.markerPath == markerPathDefault)
                          ? poleIcon
                          : poleIconRed,
                  onTap: () {
                    print("ID " + data.id!);
                    selectedMarker(list, e);
                  }));
            } else {
              _markers.add(Marker(
                  markerId: MarkerId("${e.id}"),
                  position: position,
                  icon: (e.markerPath == null)
                      ? poleGreen
                      : (e.markerPath == markerPathDefault)
                          ? poleGreen
                          : poleGreenRed,
                  onTap: () {
                    print("ID " + data.id!);
                    selectedMarker(list, e);
                  }));
            }
          }
        }
      }).toList();
    });
  }

  Container itemFieldingType(FieldingProvider fielding) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 3.5,
      height: 25.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorHelpers.colorBlue,
      ),
      child: DropdownButton<String>(
        underline: Container(),
        items: fielding.allFieldingType!.map((value) {
          return DropdownMenuItem<String>(
            child: Text(value.text.toString(), style: TextStyle(fontSize: 12)),
            value: value.text.toString(),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            fielding.setFieldingTypeSelected(value);
            _markers.clear();
            List<AllPolesByLayerModel> allPolesByFilter;
            if (context.read<FieldingProvider>().fieldingTypeSelected!.id != 3) {
              allPolesByFilter = fielding.allPolesByLayer!
                  .where((element) => element.fieldingType == context.read<FieldingProvider>().fieldingTypeSelected!.id)
                  .toList();
            } else {
              allPolesByFilter = fielding.allPolesByLayer!;
            }

            showPinsOnMap(allPolesByFilter);
          });
        },
        value: (fielding.fieldingTypeSelected!.id == null) ? null : fielding.fieldingTypeSelected!.text.toString(),
      ),
    );
  }
}
