import 'package:fielding_app/external/color_helpers.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:image/image.dart' as IMG;

class TriangleText extends StatefulWidget {
  final double x;
  final double y;
  final String text;

  const TriangleText({Key key, this.x, this.y, this.text}) : super(key: key);

  @override
  _TriangleTextState createState() => _TriangleTextState();
}

class _TriangleTextState extends State<TriangleText> {
  ui.Image image;
  bool isImageloaded = false;
  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    final ByteData data = await rootBundle.load('assets/triangle.png');
    image = await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final IMG.Image image = IMG.decodeImage(img);
    final IMG.Image resized = IMG.copyResize(image, width: 100);
    final List<int> resizedBytes = IMG.encodePng(resized);
    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(
        resizedBytes, (ui.Image img) => completer.complete(img));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return CustomPaint(
      size: Size(350, 250),
      painter: DrawTriangle(
          x: (width > 360) ? (widget.x + 10) : widget.x, y: widget.y, text: widget.text),
    );
  }
}

class DrawTriangle extends CustomPainter {
  double x;
  double y;
  String text;

  DrawTriangle({this.x, this.y, this.text});
  @override
  void paint(Canvas canvas, Size size) {
    // Paint imagePaint = Paint();

    final textSpan = TextSpan(
        text: text,
        style: TextStyle(color: ColorHelpers.colorRed, fontSize: 12));
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 50,
    );
    final offset = Offset(x + 10, y + 5);
    textPainter.paint(canvas, offset);
    Paint paintTriangle = Paint()..color = Colors.white;
    Paint paintBorder = Paint()
      ..color = ColorHelpers.colorRed
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    var path = Path();
    path.moveTo(x, y);
    path.lineTo(x - 10, y + 20);
    path.lineTo(x + 10, y + 20);
    path.close();
    canvas.drawPath(path, paintTriangle);
    canvas.drawPath(path, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
