import 'dart:math' as math;

import 'package:flutter/material.dart';

class GradientArcPainter extends CustomPainter {
  const GradientArcPainter({
    required this.progress,
    required this.startColor,
    this.middleColor,
    required this.endColor,
    this.backgroundColor = Colors.white,
    required this.width,
  })  : assert(progress != null),
        assert(startColor != null),
        assert(endColor != null),
        assert(width != null),
        super();

  final double progress;
  final Color startColor;
  final Color? middleColor;
  final Color endColor;
  final Color backgroundColor;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final gradient = new SweepGradient(
      startAngle: 3 * math.pi / 2,
      endAngle: 7 * math.pi / 2,
      tileMode: TileMode.repeated,
      colors: [
        startColor,
        if (middleColor != null) ...[middleColor!],
        endColor,
      ],
    );

    final backgroundPaint = new Paint()
      ..strokeCap = StrokeCap.butt
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (width / 2);
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius), -math.pi / 2, 2 * math.pi, false, backgroundPaint);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
