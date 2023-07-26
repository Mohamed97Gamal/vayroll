import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CurvedShapeDashboard extends CustomPainter {
  double heightRatio;
  CurvedShapeDashboard({this.heightRatio = 0.7});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.shader = ui.Gradient.linear(
      Offset(0, (size.height * heightRatio) - 50),
      Offset(size.width + 44, 60),
      [
        Color(0xFF0C4875),
        Color(0xFF082337),
      ],
    );
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.lineTo(0, (size.height * heightRatio) - 50);
    path.quadraticBezierTo(size.width * 0.5, size.height * heightRatio, size.width, (size.height * heightRatio) - 50);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
