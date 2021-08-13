import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:fielding_app/presentation/ui/detail/supporting_docs/supporting_docs_exports.dart';
import 'package:fielding_app/presentation/ui/detail/widgets/widgets_detail_exports.dart';
import 'package:fielding_app/presentation/ui/edit_pole/edit_pole.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DetailFieldingPage extends StatefulWidget {
  final AllProjectsModel? allProjectsModel;

  const DetailFieldingPage({Key? key, this.allProjectsModel}) : super(key: key);
  @override
  _DetailFieldingPageState createState() => _DetailFieldingPageState();
}

class _DetailFieldingPageState extends State<DetailFieldingPage> {
  late FieldingBloc fieldingBloc;
  GoogleMapController? googleMapController;
  Marker? _tempMarkerBlue;
  Marker? _tempMarkerSelected;
  Set<Marker> _markers = Set<Marker>();
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
    // if (context.read<ConnectionProvider>().isConnected) {
    //   LocationService location = LocationService();
    //   LocationData data = await location.getCurrentLocation();
    //   setState(() {
    //     print(
    //         "latlng: ${data.latitude.toString()} ${data.longitude.toString()}");
    //     currentLocation = data;
    //   });
    // } else {
    // setState(() {
    currentLocation = context.read<FieldingProvider>().currentLocationData!;
    // });
    // }
  }

  void setPoleIcons() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_blue.png')
        .then((onValue) {
      poleIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_blue_red.png')
        .then((onValue) {
      poleIconRed = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_yellow.png')
        .then((onValue) {
      poleSelected = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/pin_yellow_red.png')
        .then((onValue) {
      poleSelectedRed = onValue;
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
      ImageConfiguration(size: Size(2, 2)),
      'assets/tree.png',
    ).then((onValue) {
      treeIcon = onValue;
    });
  }

  void getAllPoleById() {
    fieldingBloc.add(GetAllPolesByID(
        context.read<UserProvider>().userModel.data!.token,
        widget.allProjectsModel!.iD,
        context.read<ConnectionProvider>().isConnected));
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
    return WillPopScope(
      onWillPop: () {
        fieldingBloc.add(GetFieldingRequest(
            context.read<UserProvider>().userModel.data!.token,
            context.read<ConnectionProvider>().isConnected));
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
              fieldingBloc.add(GetFieldingRequest(
                  context.read<UserProvider>().userModel.data!.token,
                  context.read<ConnectionProvider>().isConnected));
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
              fielding.setAllPolesByLayer(state.allPolesByLayer);
              fielding.setFieldingTypeAssign(3);
              searchPolesByStatus();
            } else if (state is StartPolePictureLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is StartPolePictureFailed) {
              getAllPoleById();
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message!);
            } else if (state is StartPolePictureSuccess) {
              setState(() {});
              Fluttertoast.showToast(msg: "Additional pole pictures success");

              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              getAllPoleById();
              this.poleModelSelected = AllPolesByLayerModel();
              this._tempMarkerSelected = null;
            } else if (state is CompletePolePictureLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is CompletePolePictureFailed) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(msg: state.message!);
              getAllPoleById();
            } else if (state is CompletePolePictureSuccess) {
              setState(() {});
              Fluttertoast.showToast(msg: "Complete pole pictures success");

              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              getAllPoleById();
              this.poleModelSelected = AllPolesByLayerModel();
              this._tempMarkerSelected = null;
            } else if (state is StartFieldingLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is StartFieldingFailed) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(
                  msg: state.message!, toastLength: Toast.LENGTH_LONG);
              getAllPoleById();
            } else if (state is StartFieldingSuccess) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();

              Fluttertoast.showToast(msg: "Start fielding success");
              showButtonCompleteMulti = true;
              Get.to(EditPolePage(
                poles: poleModelSelected,
                allProjectsModel: widget.allProjectsModel,
              ));
              fielding.setPolesByLayerSelected(poleModelSelected!);
              fielding.setLatLng(0, 0);
              callback();
            } else if (state is CompleteMultiPoleLoading) {
              LoadingWidget.showLoadingDialog(context, _keyLoader);
            } else if (state is CompleteMultiPoleSuccess) {
              setState(() {});
              Fluttertoast.showToast(msg: "Complete Multi pole success");

              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              getAllPoleById();
              this.poleModelSelected = AllPolesByLayerModel();
              this._tempMarkerSelected = null;
            } else if (state is CompleteMultiPoleFailed) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              Fluttertoast.showToast(
                  msg: state.message!, toastLength: Toast.LENGTH_LONG);
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
              List<AllPolesByLayerModel>? allPolesByFilter;
              if (fielding.fieldingTypeSelected!.id != 3) {
                allPolesByFilter = state.allPolesByLayer!
                    .where((element) =>
                        element.fieldingType ==
                        fielding.fieldingTypeSelected!.id)
                    .toList();
              } else {
                allPolesByFilter = state.allPolesByLayer;
              }

              return _content(allPolesByFilter);
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
    double newWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child:
              (newWidth > 480) ? _itemTitleMapLarge() : _itemTitleMapDefault(),
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
                        ? LatLng(this.currentLocation.latitude!,
                            this.currentLocation.longitude!)
                        : (allPoles.first.latitude == null)
                            ? LatLng(this.currentLocation.latitude!,
                                this.currentLocation.longitude!)
                            : LatLng(
                                double.parse(allPoles
                                    .firstWhere((element) =>
                                        (element.latitude != null &&
                                            element.latitude!.contains(".")))
                                    .latitude!),
                                double.parse(allPoles
                                    .firstWhere((element) =>
                                        (element.longitude != null &&
                                            element.longitude!.contains(".")))
                                    .longitude!)),
                    zoom: 18,
                  ),
                  onTap: (LatLng loc) {
                    print(_markers
                        .where((element) => element.position == loc)
                        .toString());
                    setState(() {
                      this.poleModelSelected = AllPolesByLayerModel();
                      this._tempMarkerSelected = null;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  (_tempMarkerSelected == null)
                      ? Container()
                      : PoleSequenceSelectedItem(
                          poleModelSelected: poleModelSelected,
                          callback: callback),
                  UIHelper.verticalSpaceSmall,
                  (showButtonCompleteMulti)
                      ? CompleteMultiPoleButton(
                          token: context
                              .read<UserProvider>()
                              .userModel
                              .data!
                              .token,
                          layerId: widget.allProjectsModel!.iD,
                        )
                      : Container(),
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
                              ? PoleSequenceItem(allPolesByLayerModel: data)
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
          var fieldingPosition = LatLng(
              double.parse(data.latitude!), double.parse(data.longitude!));
          // add the initial source location pin
          //if poleType == 4 then icon tree on maps
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

  void selectedMarker(
      List<AllPolesByLayerModel> list, AllPolesByLayerModel data) {
    setState(() {
      _markers.clear();
      list.map((e) {
        //Check latlong is null
        if (e.latitude != null && e.longitude != null) {
          var position =
              LatLng(double.parse(e.latitude!), double.parse(e.longitude!));
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
            //If poleType 4 then treeIcon
            if (e.poleType == 4) {
              _markers.add(Marker(
                  markerId: MarkerId("${e.id}"),
                  position: position,
                  icon: treeIcon));
            } else if (e.fieldingStatus == null ||
                e.fieldingStatus == 0 ||
                e.fieldingStatus == 1) {
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

  Widget _itemTitleMapDefault() {
    var fielding = context.read<FieldingProvider>();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Fielded Request",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: ColorHelpers.colorBlackText),
              ),
              ButtonAddPole(project: widget.allProjectsModel),
            ],
          ),
          UIHelper.verticalSpaceVerySmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SupportingDocsButton(),
              ButtonAddTreeTrim(project: widget.allProjectsModel),

              // UIHelper.horizontalSpaceSmall,
              // itemFieldingType(fielding), //HIDE DULU
            ],
          ),
        ],
      ),
    );
  }

  Row _itemTitleMapLarge() {
    var fielding = context.read<FieldingProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "Fielded Request",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: ColorHelpers.colorBlackText),
            ),
            UIHelper.horizontalSpaceSmall,
            SupportingDocsButton(),
            // UIHelper.horizontalSpaceSmall,
            // itemFieldingType(fielding), //HIDE DULU
          ],
        ),
        ButtonAddPole(project: widget.allProjectsModel),
      ],
    );
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
            if (context.read<FieldingProvider>().fieldingTypeSelected!.id !=
                3) {
              allPolesByFilter = fielding.allPolesByLayer!
                  .where((element) =>
                      element.fieldingType ==
                      context.read<FieldingProvider>().fieldingTypeSelected!.id)
                  .toList();
            } else {
              allPolesByFilter = fielding.allPolesByLayer!;
            }

            showPinsOnMap(allPolesByFilter);
          });
        },
        value: (fielding.fieldingTypeSelected!.id == null)
            ? null
            : fielding.fieldingTypeSelected!.text.toString(),
      ),
    );
  }
}
