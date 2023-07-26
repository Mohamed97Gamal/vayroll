import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/widgets/widgets.dart';
import 'package:vayroll/utils/utils.dart';

class WorkExperinceCard extends StatelessWidget {
  final ExperiencesResponseDTO? experienceInfo;
  final Function? deleteExperince;
  final Function? updateExperince;
  final Function? viewCertificate;

  const WorkExperinceCard({
    Key? key,
    this.experienceInfo,
    this.deleteExperince,
    this.updateExperince,
    this.viewCertificate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String yearsOfExperience = "";
    final DateTime fromDate = DateFormat("yyyy-MM-dd").parse((experienceInfo!.fromDate!.split(" ")[0]));
    final DateTime? toDate = experienceInfo?.toDate?.isNotEmpty == true
        ? DateFormat("yyyy-MM-dd").parse((experienceInfo!.toDate!.split("T")[0]))
        : null;

    final num differenceMonths = Jiffy.parse(toDate.toString()).diff(Jiffy.parse(fromDate.toString()),unit: Unit.month).floor();
    final int differenceYears = Jiffy.parse(toDate.toString()).diff(Jiffy.parse(fromDate.toString()),unit: Unit.year).floor();

    if (differenceMonths < 1)
      yearsOfExperience = "1 Month";
    else if (differenceMonths < 12)
      yearsOfExperience = "$differenceMonths Months";
    else if (differenceMonths == 12)
      yearsOfExperience = "1 Year";
    else if (differenceMonths > 12 && (differenceMonths % 12 == 0))
      yearsOfExperience = "$differenceYears Year";
    else if (differenceMonths > 12 && (differenceMonths % 12 == 1))
      yearsOfExperience = "$differenceYears Year, 1 Month";
    else if (differenceMonths > 12 && (differenceMonths % 12 != 1))
      yearsOfExperience = "$differenceYears Year, ${differenceMonths % 12} Month";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Wrap(
            children: [
              Container(
                child: Text(
                  experienceInfo?.companyName ?? "",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        height: 1.20,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Container(
                      child: Text(
                        experienceInfo?.title ?? "",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: DefaultThemeColors.nepal,
                              height: 1.20,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  children: [
                    Container(
                      child: Text(
                        yearsOfExperience +
                            " " +
                            "(${DateFormat("yyyy").format(fromDate)}" +
                            " - " +
                            ((experienceInfo?.isCurrent ?? false)
                                ? "till present)"
                                : "${DateFormat("yyyy").format(toDate!)})"),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 14,
                              height: 1.20,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
                if (experienceInfo?.description?.isNotEmpty == true ||
                    experienceInfo?.experienceCertificate?.id?.toString().isNotEmpty == true) ...[
                  SizedBox(height: 4),
                  Divider(thickness: 1),
                  SizedBox(height: 4),
                  Wrap(
                    children: [
                      Container(
                        child: Text(
                          experienceInfo?.description ?? "",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14, height: 1.20),
                        ),
                      ),
                    ],
                  ),
                  if (experienceInfo?.experienceCertificate?.id?.toString().isNotEmpty == true) ...[
                    SizedBox(height: 4),
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
                  ]
                ]
              ],
            ),
          ),
          isThreeLine: true,
          contentPadding: EdgeInsets.only(left: 16),
          trailing: experienceInfo!.hasDeleteRequest!
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
                        updateExperince!();
                      else
                        deleteExperince!();
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
