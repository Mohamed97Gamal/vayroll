import 'package:flutter/material.dart';
import 'package:vayroll/assets/fonts.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String? text;
  final String? percentage;
  final bool isSquare;
  final double size;
  final Color textColor;
  final Function? ontap;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.percentage,
    required this.isSquare,
    this.ontap,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
          child: Center(
            child: Text(
              "$percentage%",
              style: TextStyle(
                fontSize: 14,
                fontFamily: Fonts.brandon,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(maxWidth: 200, maxHeight: 40),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontFamily: Fonts.brandon, color: Theme.of(context).primaryColor, height: 1),
          ),
        ),
      ],
    );
  }
}
