import 'dart:typed_data';

import 'package:fielding_app/data/models/job_number_location_model.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/bloc/map_bloc/map_bloc.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class MapViewNumberPage extends StatefulWidget {
  @override
  _MapViewNumberPageState createState() => _MapViewNumberPageState();
}

class _MapViewNumberPageState extends State<MapViewNumberPage> {
  MapBloc mapBloc;
  AuthBloc authBloc;
  FieldingBloc fieldingBloc;
  GoogleMapController googleMapController;
  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    mapBloc = BlocProvider.of<MapBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    fieldingBloc = BlocProvider.of<FieldingBloc>(context);
    mapBloc.add(GetJobNumberLoc(authBloc.userModel.data.token));
  }

  Future<Uint8List> getBytesFromCanvas(
      int width, int height, String title) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;
    final Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: title,
      style: TextStyle(fontSize: 16.0, color: ColorHelpers.colorBlackText),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Fielding Request",
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
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetJobNumberLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetJobNumberSuccess) {
            return contentBody(state.jobNumberLocModel);
          } else if (state is GetJobNumberFailed) {
            return Center(
              child: Text(state.message),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget contentBody(List<JobNumberLocModel> listJobNumber) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(
                double.parse(listJobNumber
                    .firstWhere((element) => (element.latitude != null &&
                        element.latitude.contains(".")))
                    .latitude),
                double.parse(listJobNumber
                    .firstWhere((element) => (element.longitude != null &&
                        element.longitude.contains(".")))
                    .longitude)),
            zoom: 10,
          ),
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
            showPinsOnMap(listJobNumber);
          }),
    );
  }

  void showPinsOnMap(List<JobNumberLocModel> list) async {
    if (list.length != 0) {
      for (var data in list) {
        TextSpan longestParagraphTest = TextSpan(
          text: data.jobNumber,
          style: TextStyle(fontSize: 16.0, color: ColorHelpers.colorBlackText),
        );

        TextPainter _textPainter = TextPainter(
            text: longestParagraphTest,
            textDirection: TextDirection.ltr,
            
            maxLines: 1)
          ..layout(minWidth: 0.0, maxWidth: double.infinity);
        double width = _textPainter.width; //This is the width it requires
        double height = _textPainter.height; //This is the height it requires

        final Uint8List markerIcon = await getBytesFromCanvas(
            width.toInt() + 40, 80, data.jobNumber);

        var fieldingPosition =
            LatLng(double.parse(data.latitude), double.parse(data.longitude));
        _markers.add(Marker(
            markerId: MarkerId("${data.jobNumber}"),
            position: fieldingPosition,
            icon: BitmapDescriptor.fromBytes(markerIcon)));
      }

      setState(() {});
    }
  }
}
