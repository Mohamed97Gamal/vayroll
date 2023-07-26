import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';

class CheckOutButton extends StatelessWidget {
  final Color? squareColor;
  final Color? circleColor;
  final Function? onPressed;
  final double size;
  const CheckOutButton({Key? key, this.squareColor, this.circleColor, this.size = 44, this.onPressed}) : super(key: key);

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
            width: 18,
            decoration: new BoxDecoration(
              color: squareColor ?? DefaultThemeColors.red,
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
          ),
        ),
      ),
    );
  }
}
