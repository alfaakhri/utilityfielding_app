import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddRiserFenceWidget extends StatefulWidget {
  const AddRiserFenceWidget({Key? key}) : super(key: key);

  @override
  _AddRiserFenceWidgetState createState() => _AddRiserFenceWidgetState();
}

class _AddRiserFenceWidgetState extends State<AddRiserFenceWidget> {
  Offset? _shapeA;
  Offset? _shapeB;

  Color? colorBrown = HexColor.fromHex("997950");

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
        msg: "Tap & drag on the box layer to add Riser Fence",
        toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Riser Fence",
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
        body: Consumer<RiserProvider>(
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
                    height: 250,
                    width: 350,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(15),
                    child: CustomPaint(
                      size: Size(350, 250),
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
                              width: 350,
                              height: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/riser.png',
                                    width: 199,
                                    height: 199,
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: data.listRiserData.map((e) {
                                var index = data.listRiserData.indexOf(e) + 1;
                                double newWidth =
                                    MediaQuery.of(context).size.width;
                                double newHeight =
                                    MediaQuery.of(context).size.height;
                                var fielding =
                                    Provider.of<FieldingProvider>(context);
                                double newX = ((newWidth * e.shapeX!) /
                                    fielding.baseWidth);
                                double newY = ((newHeight * e.shapeY!) /
                                    fielding.baseHeight);

                                if (e.value == 4) {
                                  if (e.imageType == 1) {
                                    return TriangleText(
                                      x: newX + 15,
                                      y: newY + 15,
                                      text: "$index.VGR ${e.sequence}",
                                    );
                                  } else {
                                    return TriangleText(
                                      x: newX,
                                      y: newY,
                                      text: "$index.VGR ${e.sequence}",
                                    );
                                  }
                                } else {
                                  var value =
                                      Provider.of<RiserProvider>(context)
                                          .valueType(e.value);
                                  return CircleText(
                                    center: (e.imageType == 1)
                                        ? (newWidth > 360)
                                            ? {"x": newX + 25, "y": newY + 25}
                                            : {"x": newX + 15, "y": newY + 25}
                                        : {"x": newX, "y": newY},
                                    radius: 10,
                                    text:
                                        "$index.${alphabet[e.sequence! - 1]}-R$value in",
                                  );
                                }
                              }).toList(),
                            ),
                            Stack(
                              children: data.listRiserFence.map((e) {
                                var aX =
                                    e.points!.replaceAll("[", "").split(",")[0];

                                double aY =
                                    double.parse(e.points!.split(",")[1]);
                                double bX =
                                    double.parse(e.points!.split(",")[2]);

                                var bY =
                                    e.points!.replaceAll("]", "").split(",")[3];
                                return CustomPaint(
                                  size: Size(350, 250),
                                  painter: DrawLine(
                                      start: {"x": double.parse(aX), "y": aY},
                                      end: {"x": bX, "y": double.parse(bY)},
                                      color: colorBrown),
                                );
                              }).toList(),
                            ),
                            (this._shapeA == null || this._shapeB == null)
                                ? Container()
                                : CustomPaint(
                                    size: Size(350, 250),
                                    painter: DrawLine(start: {
                                      "x": this._shapeA!.dx,
                                      "y": this._shapeA!.dy
                                    }, end: {
                                      "x": this._shapeB!.dx,
                                      "y": this._shapeB!.dy
                                    }, color: colorBrown),
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
                      data.addRiserFence(this._shapeA!, this._shapeB!);

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
