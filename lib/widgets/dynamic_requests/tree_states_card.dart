import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';

class TreeStatesCardWidget extends StatelessWidget {
  final RequestStateDTOResponse? activeState;
  const TreeStatesCardWidget({Key? key, this.activeState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequestDetialsCardWidget(
      title: activeState?.name ?? "",
      enable: activeState?.details?.isEmpty == true,
      childern: [
        ListView.builder(
          itemCount: activeState?.details?.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return drewCard(
              context,
              "${activeState?.details![index]?.name}",
              Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
              0,
              children: [
                ListView.builder(
                  itemCount: activeState?.details![index].details?.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, i) {
                    return drewCard(
                      context,
                      "${activeState?.details![index].details![i].name ?? ""}: ${activeState?.details![index].details![i]?.node?.position?.name ?? ""} ",
                      Theme.of(context).textTheme.bodyText2,
                      8,
                      children: [
                        ListView.separated(
                          separatorBuilder: (context, index) => ListDivider(),
                          itemCount: activeState!.details![index].details![i].details!.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, q) {
                            return Text(
                              activeState?.details![index].details![i].details![q].name ?? "",
                              style: Theme.of(context).textTheme.bodyText2,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget drewCard(BuildContext context, String title, TextStyle? style, double padding, {List<Widget>? children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ListTileTheme(
            dense: true,
            child: ExpansionTile(
              iconColor: Theme.of(context).primaryColor,
              collapsedIconColor: Theme.of(context).primaryColor,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Text(
                  title ?? "",
                  style: style,
                ),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              children: children ?? [],
            ),
          ),
        ),
      ),
    );
  }
}
