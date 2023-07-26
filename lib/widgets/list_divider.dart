import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 10,
      thickness: 1,
      indent: 20,
      color: DefaultThemeColors.whiteSmoke1,
    );
  }
}
