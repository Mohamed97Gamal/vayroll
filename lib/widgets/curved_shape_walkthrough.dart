import 'package:flutter/material.dart';

class CurvedShapeWalkthrough extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.511);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.57, size.width * 0.5, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.53, size.width * 1.0, size.height * 0.58);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
