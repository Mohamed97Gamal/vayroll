import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:vayroll/assets/fonts.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/theme/app_themes.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AttendanceHomeWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? employeeId;
  final Function? onTap;

  const AttendanceHomeWidget({Key? key, this.startDate, this.endDate, this.employeeId, this.onTap}) : super(key: key);

  String _workingHours(double? workHours) {
    if (workHours == null || workHours == 0)
      return '0:00';
    else {
      var hours = workHours.truncate();
      var minutes = ((workHours - hours) * 60).floor();
      return '${hours.toString()}:${minutes.toString().padLeft(2, '0')}';
    }
  }

  List<CalendarAttendance> _getWeekAttendance(List<CalendarAttendance>? attendance, DateTime first) {
    var start = DateTime.utc(first.year, first.month, first.day);
    List<CalendarAttendance> weekAttendance = [];
    for (int i = 0; i < 7; i++) {
      var day = attendance?.firstWhereOrNull((dayAttendance) => dayAttendance.date == start.add(Duration(days: i))) ??
          CalendarAttendance(
            date: start.add(Duration(days: i)),
            totalWorkingHours: 0,
          );
      weekAttendance.add(day);
    }
    return weekAttendance;
  }

  List<Widget> _getWeekAttendanceWidgets(BuildContext context, List<CalendarAttendance> weekAttendance) {
    List<Widget> weekAttendanceWidgets = [];
    for (CalendarAttendance dayAttendance in weekAttendance) {
      weekAttendanceWidgets.add(
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              SizedBox(
                width: 35,
                child: Column(
                  children: [
                    Text(
                      _workingHours(dayAttendance.totalWorkingHours),
                      style: _getTextStyle(context, dayAttendance),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              height: 66,
                              width: 6,
                            ),
                            if (dayAttendance.totalWorkingHours != 0)
                              Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0xFFB3B23D), Color(0xFF013C68)],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                height: (dayAttendance.differenceWorkingHours! >= 0)
                                    ? 66
                                    : dayAttendance.totalWorkingHours! / dayAttendance.scheduleWorkingHours! * 66,
                                width: 6,
                              ),
                          ],
                        ),
                        if ((dayAttendance?.differenceWorkingHours ?? -1) > 0) ...[
                          const SizedBox(width: 4),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  'Overtime',
                                  style: TextStyle(
                                      height: 0.8,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: Fonts.brandon,
                                      color: Theme.of(context).colorScheme.secondary),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                height: 17,
                                width: 6,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dayOfWeek.format(dayAttendance.date!),
                      style: _getTextStyle(context, dayAttendance),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    }
    return weekAttendanceWidgets;
  }

  TextStyle _getTextStyle(BuildContext context, CalendarAttendance dayAttendance) {
    var textStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      fontFamily: Fonts.brandon,
      color: Theme.of(context).primaryColor,
    );
    if (dayAttendance.differenceWorkingHours == null)
      return textStyle.copyWith(color: DefaultThemeColors.nepal);
    else if (dayAttendance.differenceWorkingHours! > 0)
      return textStyle.copyWith(color: Theme.of(context).colorScheme.secondary);
    else
      return textStyle;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 120,
        child: CustomFutureBuilder<BaseResponse<List<CalendarAttendance>>>(
          initFuture: () => ApiRepo().getCalendarAttendance(
            employeeId,
            DateTime(startDate!.year, startDate!.month, startDate!.day),
           DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59),
          ),
          onSuccess: (context, snapshot) {
            var attendance = snapshot.data!.result;
            var weekAttendance = _getWeekAttendance(attendance, startDate!);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _getWeekAttendanceWidgets(context, weekAttendance),
            );
          },
        ),
      ),
    );
  }
}
