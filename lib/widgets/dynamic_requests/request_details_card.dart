import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/theme/app_themes.dart';

class RequestDetialsCardWidget extends StatelessWidget {
  final String? title;
  final List<Widget>? childern;
  final bool enable;

  const RequestDetialsCardWidget({Key? key, this.title, this.childern, this.enable = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: enable,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent, colorScheme: Theme.of(context).colorScheme),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                trailing: enable ? SizedBox() : null,
                iconColor: Theme.of(context).primaryColor,
                collapsedIconColor: Theme.of(context).primaryColor,
                title: Text(
                  title ?? "",
                  style: Theme.of(context).textTheme.headline6,
                ),
                backgroundColor: DefaultThemeColors.whiteSmoke2,
                collapsedBackgroundColor: Colors.white,
                children: childern!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
