import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/theme/app_themes.dart';

class PersonalInfoListTile extends StatelessWidget {
  final String? leadingIconSvg;
  final Widget? leadingIcon;
  final String? title;
  final String? data;
  final Widget? child;

  const PersonalInfoListTile({Key? key, this.leadingIconSvg, this.leadingIcon, this.title, this.data, this.child})
      : super(key: key);

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
        child: leadingIcon ??
            SvgPicture.asset(
              leadingIconSvg!,
              fit: BoxFit.none,
            ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
          ),
          SizedBox(height: 8),
          child ??
              Text(
                data ?? "",
                style: Theme.of(context).textTheme.bodyText2,
              ),
        ],
      ),
    );
  }
}
