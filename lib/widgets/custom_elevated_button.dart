import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    required this.text,
    required this.onPressed,
    this.style,
    this.textStyle,
    this.textAlign,
  });

  final String? text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: style,
            onPressed: onPressed,
            child: Text(
              text?.toUpperCase() ?? "",
              textAlign: textAlign,
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
