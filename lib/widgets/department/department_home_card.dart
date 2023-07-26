import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';

import '../single_tap_tooltip.dart';

class DepartmentHomeCard extends StatelessWidget {
  final DepartmentAttendanceResponse? departmentAttendanceResponse;
  final String? department;

  const DepartmentHomeCard({Key? key, this.departmentAttendanceResponse, this.department}) : super(key: key);

  String getNumber(int number) {
    if (number >= 1 && number <= 9)
      return "0${number.toString()}";
    else {
      return "${number.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: DefaultThemeColors.whiteSmoke2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleTapTooltip(
                  message: department,
                  child: Text(
                    department ?? "",
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(getNumber(departmentAttendanceResponse!.present!) ?? "",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: DefaultThemeColors.limeGreen,
                              )),
                      SizedBox(height: 5.0),
                      Text(
                        context.appStrings!.present,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: DefaultThemeColors.nepal,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                    child: SizedBox(
                      height: 10,
                      width: 1,
                      child: Container(
                        color: DefaultThemeColors.nepal,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(getNumber(departmentAttendanceResponse!.leave!) ?? "",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.secondary,
                              )),
                      SizedBox(height: 5.0),
                      Text(
                        context.appStrings!.leave,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: DefaultThemeColors.nepal,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                    child: SizedBox(
                      height: 10,
                      width: 1,
                      child: Container(
                        color: DefaultThemeColors.nepal,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(getNumber(departmentAttendanceResponse!.total!) ?? "",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              )),
                      SizedBox(height: 5.0),
                      Text(context.appStrings!.total,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: DefaultThemeColors.nepal,
                                fontWeight: FontWeight.w500,
                              )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
