import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';

class CheckInTriangle extends CustomPainter {
  final Color? color;
  late Paint painter;
  double offset = 4;

  CheckInTriangle({this.color}) {
    painter = Paint()
      ..color = color ?? DefaultThemeColors.mantis
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(3 + offset, 0);
    path.lineTo(size.width - 4, (size.height * 0.5) - 2.8);
    path.quadraticBezierTo(size.width, size.height * 0.5, size.width - 4, (size.height * 0.5) + 2.8);
    path.lineTo(3 + offset, size.height);
    path.quadraticBezierTo(offset, size.height, offset, size.height - 3);
    path.lineTo(offset, 3);
    path.quadraticBezierTo(offset, 0, 3 + offset, 0);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
