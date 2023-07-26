import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';

import 'check_in_triangle.dart';

class CheckInButton extends StatelessWidget {
  final Color? triangleColor;
  final Color? circleColor;
  final Function? onPressed;
  final double size;
  const CheckInButton({Key? key, this.triangleColor, this.circleColor, this.size = 44, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: size,
      onPressed: onPressed as void Function()?,
      icon: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: new Border.all(color: circleColor ?? DefaultThemeColors.lynch),
        ),
        child: Center(
          child: Container(
            height: 18,
            width: 22,
            child: CustomPaint(
              painter: CheckInTriangle(color: triangleColor),
            ),
          ),
        ),
      ),
    );
  }
}
