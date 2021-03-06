import 'package:fielding_app/presentation/widgets/circle_painter.dart';
import 'package:flutter/material.dart';

class Line extends StatefulWidget {
  final Map<String, double?>? start;
  final Map<String, double?>? end;
  final Color? color;

  const Line({Key? key, this.start, this.end, this.color}) : super(key: key);

  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("WIDTH LINE : $width");
    return CustomPaint(
      size: Size(350, 250),
      painter:
          DrawLine(start: widget.start, end: widget.end, color: widget.color),
      foregroundPainter: DrawCircle(
          width: width,
          center: {"x": 350, "y": 250},
          radius: 15),
    );
  }
}

class DrawLine extends CustomPainter {
  Map<String, double?>? start;
  Map<String, double?>? end;
  Color? color;
  DrawLine({this.start, this.end, this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = color!
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.drawLine(
        Offset(start!["x"]!, start!["y"]!), Offset(end!["x"]!, end!["y"]!), line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
