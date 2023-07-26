import 'dart:math' as math;
import 'package:flutter/material.dart';

double getResponsiveWidth(BuildContext context, double width) {
  if (MediaQuery.of(context).size.width < width) {
    return MediaQuery.of(context).size.width;
  } else {
    return math.min(MediaQuery.of(context).size.width, width);
  }
}

Widget responsiveRowColumnLayout({required List<Widget> children}) {
  return OrientationBuilder(
    builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: children,
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: children,
        );
      }
    },
  );
}
