import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';

class PositionsChartIndicator extends StatelessWidget {
  final Color color;
  final String gender;
  const PositionsChartIndicator({
    Key? key,
    required this.color,
    required this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Flexible(
          child: Text(
            gender,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.aluminium),
          ),
        )
      ],
    );
  }
}
