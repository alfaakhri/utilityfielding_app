import 'dart:ui';

import 'package:fielding_app/external/color_helpers.dart';
import 'package:flutter/material.dart';

class Circle extends StatefulWidget {
  final Map<String, double> center;
  final double radius;

  const Circle({Key key, this.center, this.radius}) : super(key: key);

  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle> with SingleTickerProviderStateMixin {
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
      size: Size(MediaQuery.of(context).size.width, 250),
      painter: DrawCircle(center: widget.center, radius: widget.radius),
    );
  }
}

class DrawCircle extends CustomPainter {
  double width;
  Map<String, double> center;
  double radius;
  DrawCircle({this. width, this.center, this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    // Paint brush = new Paint()
    //   ..color = ColorHelpers.colorBlackText
    //   ..strokeWidth = 2.0
    //   ..style = PaintingStyle.stroke;

    // canvas.drawCircle(Offset(center["x"] / 2, center["y"] / 1.75), radius, brush);
    Paint paintCircle = Paint()..color = Colors.white;
    Paint paintBorder = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(center["x"] / 2, center["y"] / 2), radius, paintCircle);
    canvas.drawCircle(
        Offset(center["x"] / 2, center["y"] / 2), radius, paintBorder);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
