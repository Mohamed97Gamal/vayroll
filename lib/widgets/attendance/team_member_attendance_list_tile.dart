import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class TeamMemberAttendanceListTile extends StatelessWidget {
  final EmployeeAttendance? employeeAttendance;

  const TeamMemberAttendanceListTile({Key? key, this.employeeAttendance}) : super(key: key);

  String _workingHours(double? workHours) {
    if (workHours == null || workHours == 0)
      return '00:00 hrs';
    else {
      var hours = workHours.truncate();
      var minutes = ((workHours - hours) * 60).floor();
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} hrs';
    }
  }

  String _workingHoursDescription(double? difference) {
    if (difference == 0)
      return 'Full Day';
    else if (difference! > 0)
      return '(Overtime) Full Day';
    else if (difference < 0)
      return 'Incomplete Day';
    else
      return '';
  }

  Color _workingHoursColor(BuildContext context, double? difference) {
    if (difference == 0)
      return DefaultThemeColors.prussianBlue;
    else if (difference! > 0)
      return DefaultThemeColors.mantis;
    else
      return Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          employeeAttendance?.employee?.photo?.id != null
              ? AvatarFutureBuilder<BaseResponse<String>>(
                  initFuture: () => ApiRepo().getFile(employeeAttendance!.employee!.photo!.id),
                  onSuccess: (context, snapshot) {
                    return CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.transparent,
                      backgroundImage: MemoryImage(base64Decode(snapshot.data!.result!)),
                    );
                  })
              : CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(VPayImages.avatar),
                ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "${employeeAttendance?.employee?.firstName} ${employeeAttendance?.employee?.familyAcronym}" ??
                          "",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    if (employeeAttendance?.attendance != null)
                      Text(
                        _workingHoursDescription(employeeAttendance!.attendance!.differenceWorkingHours),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontFamily: Fonts.brandon,
                            color: DefaultThemeColors.nepal),
                      )
                  ],
                ),
                if (employeeAttendance?.employee?.position?.name != null)
                  Text(
                    employeeAttendance!.employee!.position!.name!,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                if (employeeAttendance?.employee?.department?.name != null)
                  Text(
                    employeeAttendance!.employee!.department!.name!,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: DefaultThemeColors.nepal),
                  ),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: employeeAttendance?.attendance?.checkInTime != null
                                ? timeFormat.format(employeeAttendance!.attendance!.checkInTime!)
                                : '00:00 AM',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontWeight: FontWeight.w500, color: DefaultThemeColors.prussianBlue),
                          ),
                          TextSpan(
                            text: '   |   ',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor.withAlpha(120)),
                          ),
                          TextSpan(
                            text: employeeAttendance?.attendance?.checkOutTime != null
                                ? timeFormat.format(employeeAttendance!.attendance!.checkOutTime!)
                                : '00:00 PM',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontWeight: FontWeight.w500, color: DefaultThemeColors.prussianBlue),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    if (employeeAttendance?.attendance?.totalWorkingHours != null)
                      Text(
                        _workingHours(employeeAttendance!.attendance!.totalWorkingHours),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: _workingHoursColor(context, employeeAttendance!.attendance!.differenceWorkingHours),
                            ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
