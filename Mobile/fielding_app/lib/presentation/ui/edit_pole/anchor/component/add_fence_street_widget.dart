import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddFenceStreetWidget extends StatefulWidget {
  final String? title;
  final bool? isFence;

  const AddFenceStreetWidget({Key? key, this.title, this.isFence})
      : super(key: key);

  @override
  _AddFenceStreetWidgetState createState() => _AddFenceStreetWidgetState();
}

class _AddFenceStreetWidgetState extends State<AddFenceStreetWidget> {
  Offset? _shapeA;
  Offset? _shapeB;

  Color? colorBrown = HexColor.fromHex("997950");

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
        msg: "Tap & drag on the box layer to add ${widget.title}",
        toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = 300;
    double heightSize = 200;
    return Scaffold(
        appBar: AppBar(
          title: Text("Add ${widget.title}",
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
          backgroundColor: ColorHelpers.colorWhite,
        ),
        backgroundColor: Colors.white,
        body: Consumer<AnchorProvider>(
          builder: (context, data, _) => Column(
            children: [
              RepaintBoundary(
                child: GestureDetector(
                  onPanStart: (detail) {
                    setState(() {
                      this._shapeA = detail.localPosition;
                    });
                  },
                  onPanUpdate: (detail) {
                    setState(() {
                      this._shapeB = detail.localPosition;
                    });
                  },
                  child: Container(
                    height: heightSize,
                    width: widthSize,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(15),
                    child: CustomPaint(
                      size: Size(widthSize, heightSize),
                      child: GestureDetector(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorHelpers.colorGrey
                                        .withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: widthSize,
                              height: heightSize,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/anchor.png',
                                    width: 99,
                                    height: 99,
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              children: data.listAnchorData.map((e) {
                                double newWidth =
                                    MediaQuery.of(context).size.width;
                                double newHeight =
                                    MediaQuery.of(context).size.height;
                                var fielding =
                                    Provider.of<FieldingProvider>(context);
                                double newX = ((newWidth * e.circleX!) /
                                    fielding.baseWidth);
                                double newY = ((newHeight * e.circleY!) /
                                    fielding.baseHeight);

                                return CustomPaint(
                                  size: Size(widthSize, heightSize),
                                  painter: DrawCircleTextAnchor(
                                      center: (e.imageType == 1)
                                          ? {"x": newX + 30, "y": newY + 30}
                                          : {"x": newX, "y": newY},
                                      radius: 10,
                                      text: e.text),
                                );
                              }).toList(),
                            ),
                            Stack(
                              children: data.listAnchorFences.map((e) {
                                var aX =
                                    e.points!.replaceAll("[", "").split(",")[0];

                                double aY =
                                    double.parse(e.points!.split(",")[1]);
                                double bX =
                                    double.parse(e.points!.split(",")[2]);

                                var bY =
                                    e.points!.replaceAll("]", "").split(",")[3];
                                return CustomPaint(
                                  size: Size(widthSize, heightSize),
                                  painter: DrawLine(
                                      start: {"x": double.parse(aX), "y": aY},
                                      end: {"x": bX, "y": double.parse(bY)},
                                      color: colorBrown),
                                );
                              }).toList(),
                            ),
                            Stack(
                              children: data.listAnchorStreet.map((e) {
                                var aX =
                                    e.points!.replaceAll("[", "").split(",")[0];

                                double aY =
                                    double.parse(e.points!.split(",")[1]);
                                double bX =
                                    double.parse(e.points!.split(",")[2]);

                                var bY =
                                    e.points!.replaceAll("]", "").split(",")[3];
                                return CustomPaint(
                                  size: Size(widthSize, heightSize),
                                  painter: DrawLine(
                                      start: {"x": double.parse(aX), "y": aY},
                                      end: {"x": bX, "y": double.parse(bY)},
                                      color: Colors.black),
                                );
                              }).toList(),
                            ),
                            (this._shapeA == null || this._shapeB == null)
                                ? Container()
                                : CustomPaint(
                                    size: Size(widthSize, heightSize),
                                    painter: DrawLine(
                                        start: {
                                          "x": this._shapeA!.dx,
                                          "y": this._shapeA!.dy
                                        },
                                        end: {
                                          "x": this._shapeB!.dx,
                                          "y": this._shapeB!.dy
                                        },
                                        color: (widget.isFence!)
                                            ? colorBrown
                                            : Colors.black),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  child: FlatButton(
                    color: ColorHelpers.colorButtonDefault,
                    onPressed: () {
                      if (widget.isFence!) {
                        data.addAnchorFences(this._shapeA!, this._shapeB!);
                      } else {
                        data.addAnchorStreet(this._shapeA!, this._shapeB!);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
