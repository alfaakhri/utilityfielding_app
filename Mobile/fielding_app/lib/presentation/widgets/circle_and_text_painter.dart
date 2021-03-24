import 'dart:ui';

import 'package:fielding_app/external/color_helpers.dart';
import 'package:flutter/material.dart';

class CircleText extends StatefulWidget {
  final Map<String, double> center;
  final double radius;
  final String text;

  const CircleText({Key key, this.center, this.radius, this.text})
      : super(key: key);

  @override
  _CircleTextState createState() => _CircleTextState();
}

class _CircleTextState extends State<CircleText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(350, 250),
      painter: DrawCircleText(
          center: widget.center, radius: widget.radius, text: widget.text),
    );
  }
}

class DrawCircleText extends CustomPainter {
  Map<String, double> center;
  double radius;
  String text;
  DrawCircleText({this.center, this.radius, this.text});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintCircle = Paint()..color = Colors.white;
    Paint paintBorder = Paint()
      ..color = ColorHelpers.colorRed
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(center["x"], center["y"]), radius, paintCircle);
    canvas.drawCircle(
        Offset(center["x"], center["y"]), radius, paintBorder);
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: ColorHelpers.colorRed, fontSize: 12)
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 30,
    );
    final offset = Offset(center["x"] - 7, center["y"] - 8);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class DrawCircleTextAnchor extends CustomPainter {
  Map<String, double> center;
  double radius;
  String text;
  DrawCircleTextAnchor({this.center, this.radius, this.text});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintCircle = Paint()..color = Colors.white;
    Paint paintBorder = Paint()
      ..color = ColorHelpers.colorRed
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(center["x"], center["y"]), radius, paintCircle);
    canvas.drawCircle(
        Offset(center["x"], center["y"]), radius, paintBorder);
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: ColorHelpers.colorRed, fontSize: 11)
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 20,
    );
    final offset = Offset(center["x"] - 5, center["y"] - 7);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
