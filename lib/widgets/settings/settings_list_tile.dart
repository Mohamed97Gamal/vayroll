import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/theme/app_themes.dart';

class SettingsListTile extends StatelessWidget {
  final String? leadingIconSvg;
  final String? title;
  final Function? onTap;

  const SettingsListTile({Key? key, this.leadingIconSvg, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            new BoxShadow(
              blurRadius: 6,
              color: DefaultThemeColors.gainsboro,
              offset: new Offset(0, 3),
            )
          ],
        ),
        child: SvgPicture.asset(
          leadingIconSvg!,
          fit: BoxFit.none,
        ),
      ),
      title: Text(
        title!,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: onTap as void Function()?,
    );
  }
}
