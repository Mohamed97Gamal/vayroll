import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/icons.dart';

class CustomBackButton extends StatelessWidget {
  final Function? onPressed;
  const CustomBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed != null ? onPressed as void Function()? : () => Navigator.of(context).pop(),
      icon: SvgPicture.asset(
        VPayIcons.left_arrow,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
