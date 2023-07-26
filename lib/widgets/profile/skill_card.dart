import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class SkillCard extends StatelessWidget {
  final SkillsResponseDTO? skillInfo;
  final Function? deleteSkill;
  final Function? updateSkill;

  const SkillCard({Key? key, this.skillInfo, this.deleteSkill, this.updateSkill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 16),
          title: Wrap(
            children: [
              Text(
                skillInfo?.skillName ?? "",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      height: 1.20,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                constraints: BoxConstraints(maxHeight: 40, minHeight: 20),
                child: Text(
                  skillInfo!.proficiency!,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: DefaultThemeColors.nepal,
                        height: 1.20,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
          trailing: skillInfo!.hasDeleteRequest!
              ? SizedBox()
              : Container(
                  height: 20,
                  child: PopupMenuButton(
                    color: Theme.of(context).primaryColor,
                    iconSize: 30,
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).primaryColor,
                    ),
                    offset: Offset(-5, 15),
                    padding: EdgeInsets.zero,
                    shape: TooltipShape(),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(context.appStrings!.edit,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                          value: "Edit"),
                      PopupMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(context.appStrings!.delete,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                          value: "Delete"),
                    ],
                    onSelected: (dynamic value) {
                      if (value == "Edit")
                        updateSkill!();
                      else
                        deleteSkill!();
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
