import 'package:fielding_app/external/service/service.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';

class InsertFenceWidget extends StatefulWidget {
  const InsertFenceWidget({Key? key}) : super(key: key);

  @override
  _InsertFenceWidgetState createState() => _InsertFenceWidgetState();
}

class _InsertFenceWidgetState extends State<InsertFenceWidget> {
  double? _aX;
  double? _aY;
  double? _bX;
  double? _bY;
  Color? randomColor = HexColor.fromHex("704022");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        ));
  }
}
