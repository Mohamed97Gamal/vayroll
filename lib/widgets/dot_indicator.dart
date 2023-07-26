import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;
  final double activeDotRadius;
  final double inactiveDotRadius;
  final Color? activeDotColor;
  final Color? inactiveDotColor;
  final double height;
  final double dotSpacing;

  const DotIndicator(
      {Key? key,
      required this.currentIndex,
      required this.pageCount,
      this.activeDotRadius = 10,
      this.inactiveDotRadius = 7,
      this.activeDotColor,
      this.inactiveDotColor,
      this.dotSpacing = 8,
      this.height = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dots = <Widget>[];
    for (int i = 0; i < pageCount; i++) {
      double _radius = i == currentIndex ? activeDotRadius : inactiveDotRadius;
      Color _dotColor =
          i == currentIndex ? activeDotColor ?? Theme.of(context).primaryColor : inactiveDotColor ?? Color(0xFF697E8D);
      dots.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: (dotSpacing ?? 8) / 2),
          width: _radius,
          height: _radius,
          decoration: BoxDecoration(shape: BoxShape.circle, color: _dotColor),
        ),
      );
    }
    return SizedBox(
      height: height ?? 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: dots,
      ),
    );
  }
}
