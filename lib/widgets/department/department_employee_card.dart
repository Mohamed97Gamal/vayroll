import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/assets/icons.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class DepartmentEmployeeCard extends StatelessWidget {
  final EmployeeAttendance? attendance;

  const DepartmentEmployeeCard({Key? key, this.attendance}) : super(key: key);

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
      padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              attendance?.employee?.photo?.id != null
                  ? AvatarFutureBuilder<BaseResponse<String>>(
                      initFuture: () => ApiRepo().getFile(attendance!.employee!.photo!.id),
                      onSuccess: (context, snapshot) {
                        return SizedBox(
                          height: 46,
                          width: 46,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.transparent,
                            backgroundImage: MemoryImage(base64Decode(snapshot.data!.result!)),
                          ),
                        );
                      })
                  : SizedBox(
                      height: 46,
                      width: 46,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(VPayImages.avatar),
                      ),
                    ),
              Positioned(
                right: 2.0,
                bottom: -2.0,
                child: attendance!.attendance == null
                    ? SvgPicture.asset(VPayIcons.offline)
                    : SvgPicture.asset(VPayIcons.online),
              ),
            ],
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
                      "${attendance?.employee?.firstName} ${attendance?.employee?.familyAcronym}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.w500, color: DefaultThemeColors.prussianBlue),
                    ),
                    Spacer(),
                    if (attendance?.attendance?.differenceWorkingHours != null)
                      Text(
                        _workingHoursDescription(attendance?.attendance?.differenceWorkingHours),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontFamily: Fonts.brandon,
                            color: DefaultThemeColors.nepal),
                      )
                  ],
                ),
                Text(
                  attendance?.employee?.position?.name ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontFamily: Fonts.brandon,
                  ),
                ),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: attendance?.attendance?.checkInTime != null
                                ? timeFormat.format(attendance!.attendance!.checkInTime!)
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
                            text: attendance?.attendance?.checkOutTime != null
                                ? timeFormat.format(attendance!.attendance!.checkOutTime!)
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
                    if (attendance?.attendance?.totalWorkingHours != null)
                      Text(
                        _workingHours(attendance?.attendance?.totalWorkingHours),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: _workingHoursColor(
                                context,
                                attendance?.attendance?.differenceWorkingHours,
                              ),
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
