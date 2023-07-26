import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class EducationCard extends StatelessWidget {
  final EducationResponseDTO? educationInfo;
  final Function? deleteEducation;
  final Function? updateEducation;
  final Function? viewCertificate;

  const EducationCard({
    Key? key,
    this.educationInfo,
    this.deleteEducation,
    this.updateEducation,
    this.viewCertificate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime? fromDate = educationInfo?.fromDate?.isNotEmpty == true
        ? DateFormat("yyyy").parse(educationInfo!.fromDate!.split(" ")[0])
        : null;
    final DateTime? toDate = educationInfo?.toDate?.isNotEmpty == true
        ? DateFormat("yyyy").parse(educationInfo!.toDate!.split("T")[0])
        : null;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 16),
          title: Wrap(
            children: [
              Container(
                child: Text(
                  educationInfo?.college ?? "",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        height: 1.20,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              if (educationInfo?.grade?.isNotEmpty == true)
                Wrap(
                  children: [
                    Container(
                      child: Text(
                        "${educationInfo?.grade}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: DefaultThemeColors.nepal, height: 1.20),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 8),
              if (educationInfo?.fromDate?.isNotEmpty == true && educationInfo?.toDate?.isNotEmpty == true)
                Wrap(
                  children: [
                    Container(
                      child: Text(
                        "${educationInfo?.degree} (${DateFormat("yyyy")?.format(fromDate!)} - ${DateFormat("yyyy")?.format(toDate!)})",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: DefaultThemeColors.nepal, height: 1.20),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 8),
              if (educationInfo?.certificateFile?.id?.toString().isNotEmpty == true)
                InkWell(
                  onTap: viewCertificate as void Function()?,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 40, minHeight: 20),
                    child: Text(
                      context.appStrings!.viewCertificate,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.secondary,
                            height: 1.20,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ),
            ],
          ),
          trailing: educationInfo!.hasDeleteRequest!
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
                        updateEducation!();
                      else
                        deleteEducation!();
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
