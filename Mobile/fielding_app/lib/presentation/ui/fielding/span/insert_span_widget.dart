import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:fielding_app/data/models/pole_by_id_model.dart';
import 'package:fielding_app/domain/provider/span_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/service/hex_color.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/line_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class InsertSpanWidget extends StatefulWidget {
  final SpanDirectionList? spanData;
  final int? index;
  final double? bXCoor;

  const InsertSpanWidget({Key? key, this.spanData, this.index, this.bXCoor})
      : super(key: key);

  @override
  _InsertSpanWidgetState createState() => _InsertSpanWidgetState();
}

class _InsertSpanWidgetState extends State<InsertSpanWidget> {
  double? _aX;
  double? _aY;

  double? _bX;
  double _bY = 250 / 2;
  int? imageType = 0;

  GlobalKey globalKey = GlobalKey();
  final formKey = new GlobalKey<FormState>();

  TextEditingController sizeController = TextEditingController();
  Color? randomColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._bX = widget.bXCoor;
    if (widget.spanData != null) {
      imageType = widget.spanData!.imageType;
      this.randomColor = HexColor.fromHex(widget.spanData!.color!);
      this.sizeController.text = widget.spanData!.length.toString();
      _aX = double.parse(widget.spanData!.lineData!
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[0]);
      _aY = double.parse(widget.spanData!.lineData!
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[1]);
      _bX = double.parse(widget.spanData!.lineData!
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[2]);
      _bY = double.parse(widget.spanData!.lineData!
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[3]);
    } else {
      randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    }
  }

  Future<bool> _onWillPop() async {
    return (await (showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('The data that you have added will not be saved'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        ) as FutureOr<bool>?)) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    this._aX = 350 / 2;
    this._aY = 250 / 2;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              (widget.spanData != null)
                  ? "Edit Span Direction and Distance"
                  : "Add Span Direction and Distance",
              style:
                  TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorHelpers.colorBlackText,
            ),
            onPressed: _onWillPop,
          ),
          backgroundColor: ColorHelpers.colorWhite,
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          child: Padding(
              padding: EdgeInsets.all(15),
              child: RaisedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    List<double?> lineData;

                    lineData = [this._aX, this._aY, this._bX, this._bY];

                    SpanDirectionList data = SpanDirectionList(
                        length: double.parse(this.sizeController.text),
                        lineData: lineData.toString(),
                        imageType: 0,
                        color: randomColor!.generateRandomHexColor());
                    print(json.encode(data));
                    if (widget.spanData != null) {
                      context
                          .read<SpanProvider>()
                          .editListSpanData(data, widget.index!);
                    } else {
                      context.read<SpanProvider>().addListSpanData(data);
                    }

                    this.sizeController.clear();
                    Get.back();
                  }
                },
                child: Text(
                  "Save",
                  style:
                      TextStyle(fontSize: 14, color: ColorHelpers.colorWhite),
                ),
                color: ColorHelpers.colorButtonDefault,
              )),
        ),
        body: Column(
          children: [
            RepaintBoundary(
              key: globalKey,
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.all(15),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorHelpers.colorGrey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 350,
                      height: 250,
                    ),
                    GestureDetector(
                        onHorizontalDragStart: (detail) {
                          setState(() {
                            this._bX = detail.localPosition.dx;
                          });
                        },
                        onVerticalDragStart: (detail) {
                          setState(() {
                            this._bY = detail.localPosition.dy;
                          });
                        },
                        onHorizontalDragUpdate: (detail) {
                          setState(() {
                            this._bX = detail.localPosition.dx;
                          });
                        },
                        onVerticalDragUpdate: (detail) {
                          setState(() {
                            this._bY = detail.localPosition.dy;
                          });
                        },
                        child: Line(
                          start: {"x": this._aX, "y": this._aY},
                          end: {"x": this._bX, "y": this._bY},
                          color: randomColor,
                        )),
                  ],
                ),
              ),
            ),
            Text("Touch & Drag",
                style: TextStyle(fontSize: 14, color: ColorHelpers.colorGrey)),
            UIHelper.verticalSpaceSmall,
            Form(
              key: this.formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Size in Feet",
                        style: TextStyle(
                            fontSize: 14, color: ColorHelpers.colorGrey)),
                    UIHelper.verticalSpaceSmall,
                    TextFormField(
                      controller: this.sizeController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null) {
                          return 'Please insert feet';
                        } else if (value == "") {
                          return 'Please insert feet';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        suffixText: "ft",
                        suffixStyle: TextStyle(fontSize: 14),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorHelpers.colorGrey.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorHelpers.colorGrey.withOpacity(0.2)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorHelpers.colorRed),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorHelpers.colorRed),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
