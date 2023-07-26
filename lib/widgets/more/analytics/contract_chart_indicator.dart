import 'package:flutter/material.dart';
import 'package:vayroll/assets/fonts.dart';

class ContractChartIndicator extends StatelessWidget {
  final Color color;
  final String? text;
  final FontWeight fontWeight;

  const ContractChartIndicator({
    Key? key,
    required this.color,
    required this.text,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: 16),
        Container(
          width: 8,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Flexible(
          child: Text(
            text!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: fontWeight,
              fontFamily: Fonts.brandon,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
