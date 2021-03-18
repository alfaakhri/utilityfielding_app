import 'dart:convert';
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
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_color/random_color.dart';
import 'package:provider/provider.dart';

class InsertSpanWidget extends StatefulWidget {
  final SpanDirectionList spanData;
  final int index;

  const InsertSpanWidget({Key key, this.spanData, this.index})
      : super(key: key);

  @override
  _InsertSpanWidgetState createState() => _InsertSpanWidgetState();
}

class _InsertSpanWidgetState extends State<InsertSpanWidget> {
  double _aX;
  double _aY;

  double _bX = 300;
  double _bY = 250 / 1.75;

  GlobalKey globalKey = GlobalKey();
  final formKey = new GlobalKey<FormState>();

  TextEditingController sizeController = TextEditingController();
  Color randomColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RandomColor _randomColor = RandomColor();
    if (widget.spanData != null) {
      this.randomColor = HexColor.fromHex(widget.spanData.color);
      this.sizeController.text = widget.spanData.length.toString();
      _aX = double.parse(widget.spanData.lineData
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")[0]);
      _aY = double.parse(widget.spanData.lineData
          .replaceAll("[]", "")
          .replaceAll("]", "")
          .split(",")[1]);
      _bX = double.parse(widget.spanData.lineData
          .replaceAll("[]", "")
          .replaceAll("]", "")
          .split(",")[2]);
      _bY = double.parse(widget.spanData.lineData
          .replaceAll("[]", "")
          .replaceAll("]", "")
          .split(",")[3]);
    } else {
      randomColor = _randomColor.randomColor(
          colorHue: ColorHue.multiple(colorHues: [
        ColorHue.red,
        ColorHue.blue,
        ColorHue.green,
        ColorHue.orange,
        ColorHue.purple
      ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    this._aX = MediaQuery.of(context).size.width / 2;
    this._aY = MediaQuery.of(context).size.height / 5.25;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            (widget.spanData != null)
                ? "Edit Span Direction and Distance"
                : "Add Span Direction and Distance",
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
        backgroundColor: ColorHelpers.colorWhite,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: RaisedButton(
              onPressed: () {
                if (formKey.currentState.validate()) {
                  List<double> lineData = [
                    this._aX,
                    this._aY,
                    this._bX,
                    this._bY
                  ];
                  SpanDirectionList data = SpanDirectionList(
                      length: double.parse(this.sizeController.text),
                      lineData: lineData.toString(),
                      color: randomColor.toHex());
                  print(json.encode(data));
                  if (widget.spanData != null) {
                    context
                        .read<SpanProvider>()
                        .editListSpanData(data, widget.index);
                  } else {
                    context.read<SpanProvider>().addListSpanData(data);
                  }

                  this.sizeController.clear();
                  Get.back();
                }
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 14, color: ColorHelpers.colorWhite),
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
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorHelpers.colorGrey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    height: 250,
                  ),
                  GestureDetector(
                      onHorizontalDragStart: (detail) {
                        setState(() {
                          this._bX = detail.globalPosition.dx;
                        });
                      },
                      onVerticalDragStart: (detail) {
                        setState(() {
                          this._bY = detail.globalPosition.dy;
                        });
                      },
                      onHorizontalDragUpdate: (detail) {
                        setState(() {
                          this._bX = detail.globalPosition.dx;
                        });
                      },
                      onVerticalDragUpdate: (detail) {
                        setState(() {
                          this._bY = detail.globalPosition.dy;
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
          UIHelper.verticalSpaceMedium,
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
    );
  }
}
