import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';

class AppealRequestCard extends StatelessWidget {
  final String? requestID;
  final String? requestDate;
  final Function? onTap;

  const AppealRequestCard({Key? key, this.requestID, this.requestDate, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        requestID!,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subtitle: Text(
        requestDate!,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
      ),
      onTap: onTap as void Function()?,
    );
  }
}
